# Script writes site and link meta data into the Arango graphDB
# requires https://pypi.org/project/python-arango/
# python3 add_meta_data.py

from arango import ArangoClient
import json

user = "root"
pw = "jalapeno"
dbname = "jalapeno"

client = ArangoClient(hosts='http://198.18.133.104:30852')
db = client.db(dbname, username=user, password=pw)

if db.has_collection('igp_node'):
    igp = db.collection('igp_node')

if db.has_collection('bgp_node'):
    bgp = db.collection('bgp_node')

if db.has_collection('peer'):
    peer = db.collection('peer')

if db.has_collection('ipv4_graph'):
    ipv4graph = db.collection('ipv4_graph')

if db.has_collection('ipv6_graph'):
    ipv6graph = db.collection('ipv6_graph')

igp.properties()
bgp.properties()
peer.properties()
ipv4graph.properties()
ipv6graph.properties()

def insert_peer_data(db, peer_file_path):
    """
    Insert peer data from sonic-peer.json into the jalapeno database
    Args:
        db: ArangoDB database connection
        peer_file_path: Path to the sonic-peer.json file
    """
    try:
        # Read the peer data from JSON file
        with open(peer_file_path, 'r') as f:
            peer_data = json.load(f)
        
        # Create peer collection if it doesn't exist
        if not db.has_collection('peer'):
            db.create_collection('peer')
        
        peer_collection = db.collection('peer')
        
        # AQL query to insert/update peer data
        aql = """
        FOR peer in @peers
            UPSERT { _key: peer._key }
            INSERT peer
            REPLACE peer
            IN peer
            RETURN NEW
        """
        
        # Execute AQL query
        db.aql.execute(aql, bind_vars={'peers': peer_data})
        print(f"Successfully inserted/updated {len(peer_data)} peer records")
        
    except Exception as e:
        print(f"Error inserting peer data: {str(e)}")

# Add this at the end of your file to test the function
if __name__ == "__main__":
    # Your existing code runs first
    print("\nInserting peer data...")
    insert_peer_data(db, "sonic-peer.json")