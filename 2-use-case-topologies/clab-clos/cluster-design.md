## Fat Tree Cluster

### Base node: 
32-port 51.2T router
16x1.6T intra-Brick
64x400G between layers - T0 to Brick, Brick to Spine, etc.

### Brick:
96 16x16 Bricks
Brick = 16*64x400G up to spine (16*64*96)
Total 400G ports up to spine = 98304
Total 400G ports down to ToR = 98304
ToR = avg 8x400G uplinks, 98304/8 = 12288

### Spine
64 columns 16 deep = 1024 spine nodes
Spine node = 96x400G down to Bricks, 32x400G up to Inter-Cluster Core
96x1024 = 98304

### Totals:
Total ToR 12288
Total Brick nodes 3072
Total Spine nodes 1024
Total Routers 16384
Theoretical server count of 20 per ToR = 245760

#### Cluster x 4 = AZ/Region

#### SRv6 steering domain fc00:1::

### DC 1
Each DC fabric is a /36, example: fc00:1:a000::/36

#### ToRs - each ToR (and attached hosts) is /64
fc00:1:9fff::/64 - fc00:1:9fff:3fff::/64 - summarize as /50, 16384 /64s

#### Spine
fc00:1:a000:: - fc00:1:a3ff::

#### Brick 0 - 32 nodes
fc00:1:a400:: - fc00:1:a41f::

#### Brick 0 ToRs
fc00:1:9fff::/64 - fc00:1:9fff:7f:/64

#### Brick 1
fc00:1:a420:: - fc00:1:a43f::

#### Brick 1 ToRs
fc00:1:9fff:80:/64 - fc00:1:9fff:ff:/64

#### Brick 2
fc00:1:a440:: - fc00:1:a45f::

#### Brick 2 ToRs
fc00:1:9fff:100:/64 - fc00:1:9fff:17f:/64

#### Brick 3
fc00:1:a460:: - fc00:1:a47f::

#### Brick 3 ToRs
fc00:1:9fff:180:/64 - fc00:1:9fff:1ff:/64

#### Brick 4 - 95
fc00:1:a480:: - fc00:1:afff::

#### Brick 4 - 95 ToRs
fc00:1:9fff:200::/64- fc00:1:9fff:3fff::/64

### DC 2
#### Fabric
fc00:1:b000:: - fc00:1:bfff::

#### ToRs
fc00:1:9fff:4000::/64 - fc00:1:9fff:7fff::/64

### DC 3
#### Fabric
fc00:1:c000:: - fc00:1:cfff::

####  ToRs
fc00:1:9fff:8000::/64 - fc00:1:9fff:bfff::/64

### DC 4
#### Fabric
fc00:1:d000:: - fc00:1:dfff::

#### ToRs
fc00:1:9fff:c000::/64 - fc00:1:9fff:ffff::/64

### Summary routes AZ/Region 1

#### Fabric prefixes
fc00:1:a000::/36
fc00:1:b000::/36
fc00:1:c000::/36
fc00:1:d000::/36

#### ToR prefixes
fc00:1:9fff::/48





