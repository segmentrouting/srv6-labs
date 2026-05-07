#!/bin/bash
# Push config_db.json and frr.conf to SONiC nodes for the 4-plane 8x16 lab
# (topology.clab.yaml). Generate configs first: python3 generate_fabric.py
# Usage: ./config.sh [gen|all|leaf|spine|<node_name>]
#
# Container names are usually clab-<topology>-<node> (see name: in topology.clab.yaml)
# or the short node name when your Containerlab build uses short names.

set +e

SCOPE="${1:-all}"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
CONFIGS_DIR="$SCRIPT_DIR/config"

TOPOLOGY_NAME="$(grep -m1 '^name:' "$SCRIPT_DIR/topology.clab.yaml" 2>/dev/null | awk '{print $2}' | tr -d '\r')"
TOPOLOGY_NAME="${TOPOLOGY_NAME:-sonic-docker-4p-8x16}"

NUM_PLANES=4
NUM_SPINES=8
NUM_LEAVES=16

LEAF_NODES=""
for p in $(seq 0 $((NUM_PLANES - 1))); do
    for i in $(seq 0 $((NUM_LEAVES - 1))); do
        LEAF_NODES+="p${p}-leaf$(printf '%02d' "$i") "
    done
done
LEAF_NODES="${LEAF_NODES%% }"

SPINE_NODES=""
for p in $(seq 0 $((NUM_PLANES - 1))); do
    for i in $(seq 0 $((NUM_SPINES - 1))); do
        SPINE_NODES+="p${p}-spine$(printf '%02d' "$i") "
    done
done
SPINE_NODES="${SPINE_NODES%% }"

ALL_NODES="$LEAF_NODES $SPINE_NODES"

# This lab has no BGP, but stock SONiC may still ship a default BGP instance.
# Strip any common defaults so vtysh -f loads the file cleanly.
BGP_ASNS_TO_CLEAR="65000 65001 65100"

resolve_container() {
    local NODE_ID="$1"
    local LONG_NAME="clab-${TOPOLOGY_NAME}-${NODE_ID}"

    if docker inspect "$NODE_ID" &>/dev/null; then
        echo "$NODE_ID"
        return 0
    fi
    if docker inspect "$LONG_NAME" &>/dev/null; then
        echo "$LONG_NAME"
        return 0
    fi
    echo ""
    return 1
}

deploy_node() {
    local NODE_ID="$1"
    local CONTAINER
    CONTAINER="$(resolve_container "$NODE_ID")"

    echo "  Deploying $NODE_ID -> ${CONTAINER:-<not found>}"

    if [ -z "$CONTAINER" ]; then
        echo "    SKIP: no docker container for $NODE_ID (tried $NODE_ID, clab-${TOPOLOGY_NAME}-${NODE_ID})"
        return 1
    fi

    # Create Loopback0 if missing
    docker exec "$CONTAINER" bash -c "ip link show Loopback0 &>/dev/null || { ip link add Loopback0 type dummy && ip link set Loopback0 up; }" 2>/dev/null || true

    # Copy config_db.json
    if [ -f "$CONFIGS_DIR/$NODE_ID/config_db.json" ]; then
        docker cp "$CONFIGS_DIR/$NODE_ID/config_db.json" "$CONTAINER:/etc/sonic/config_db.json"
        echo "    config_db.json copied"
    else
        echo "    WARN: no config_db.json found for $NODE_ID"
    fi

    # Reload SONiC config
    docker exec "$CONTAINER" bash -c "sonic-cfggen -j /etc/sonic/config_db.json --write-to-db" 2>/dev/null || true
    docker exec "$CONTAINER" bash -c "supervisorctl restart all" 2>/dev/null || true
    echo "    config reloaded"

    # Setup VRF default and sysctl
    docker exec "$CONTAINER" ip link add vrfdefault type vrf table main 2>/dev/null || true
    docker exec "$CONTAINER" ip link set vrfdefault up 2>/dev/null || true
    docker exec "$CONTAINER" sysctl -w net.vrf.strict_mode=1 2>/dev/null || true
    docker exec "$CONTAINER" sysctl -w net.ipv4.conf.vrfdefault.rp_filter=0 2>/dev/null || true
    docker exec "$CONTAINER" ip link add sr0 type dummy 2>/dev/null || true
    docker exec "$CONTAINER" ip link set sr0 up 2>/dev/null || true
    docker exec "$CONTAINER" sysctl -w net.ipv6.conf.all.forwarding=1 2>/dev/null || true
    echo "    vrfdefault, sr0, and sysctl configured"

    # Enable ports (admin up) - SONiC default may have them down
    docker exec "$CONTAINER" bash -c 'for port in $(sonic-cfggen -d --var-json PORT | python3 -c "import sys,json; print(\" \".join(json.load(sys.stdin).keys()))"); do config interface startup $port 2>/dev/null; done' 2>/dev/null || true

    # Wait for FRR to be ready
    for i in $(seq 1 30); do
        if docker exec "$CONTAINER" vtysh -c "show version" &>/dev/null; then
            break
        fi
        sleep 2
    done

    # Copy and load FRR config
    if [ -f "$CONFIGS_DIR/$NODE_ID/frr.conf" ]; then
        local FRR_DIR=""
        if docker exec "$CONTAINER" test -d /etc/sonic/frr 2>/dev/null; then
            FRR_DIR="/etc/sonic/frr"
        elif docker exec "$CONTAINER" test -d /etc/frr 2>/dev/null; then
            FRR_DIR="/etc/frr"
        else
            FRR_DIR="/etc/sonic/frr"
            docker exec "$CONTAINER" mkdir -p "$FRR_DIR" 2>/dev/null || true
        fi

        docker cp "$CONFIGS_DIR/$NODE_ID/frr.conf" "$CONTAINER:$FRR_DIR/frr.conf"
        echo "    frr.conf copied to $FRR_DIR/frr.conf"

        docker exec "$CONTAINER" supervisorctl stop bgpd zebra staticd 2>/dev/null || true
        sleep 2
        docker exec "$CONTAINER" supervisorctl start bgpd zebra staticd 2>/dev/null || true
        sleep 3
        # Strip any default BGP instance(s) so vtysh -f applies cleanly.
        for asn in $BGP_ASNS_TO_CLEAR; do
            docker exec "$CONTAINER" vtysh -c "configure terminal" -c "no router bgp $asn" -c "exit" 2>/dev/null || true
        done
        docker exec "$CONTAINER" vtysh -f "$FRR_DIR/frr.conf" 2>/dev/null || true
        echo "    frr.conf loaded"
    else
        echo "    WARN: no frr.conf found for $NODE_ID"
    fi

    echo "    OK: $NODE_ID deployed"
}

deploy_group() {
    local NODES="$1"
    local GROUP_NAME="$2"
    echo "=== Deploying $GROUP_NAME (parallel) ==="
    for node in $NODES; do
        deploy_node "$node" &
    done
    wait
    echo "=== $GROUP_NAME done ==="
    echo ""
}

case "$SCOPE" in
    gen)
        exec python3 "$SCRIPT_DIR/generate_fabric.py"
        ;;
    all)
        deploy_group "$LEAF_NODES" "leaf tier"
        deploy_group "$SPINE_NODES" "spine tier"
        ;;
    leaf)  deploy_group "$LEAF_NODES" "leaf tier" ;;
    spine) deploy_group "$SPINE_NODES" "spine tier" ;;
    *)
        if echo "$ALL_NODES" | grep -qw "$SCOPE"; then
            deploy_node "$SCOPE"
        else
            echo "Unknown scope: $SCOPE"
            echo "Valid: gen, all, leaf, spine, or node name (see topology.clab.yaml)"
            exit 1
        fi
        ;;
esac

echo ""
echo "============================================================"
echo "  $TOPOLOGY_NAME — 4 planes x (8 spine x 16 leaf) SRv6 CLOS"
echo "============================================================"
echo "  Topology:     $TOPOLOGY_NAME (from topology.clab.yaml)"
echo "  Config dir:   $CONFIGS_DIR"
echo "  Routing:      Controller-driven (no BGP, no IGP)"
echo "  Tenants:      green (uDT d000 -> Vrf-green on every leaf)"
echo "                yellow (host-based; uDT d001 seg6local on hosts)"
echo "============================================================"
echo ""
echo "Deploy complete!"
