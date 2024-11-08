# Script writes site and link meta data into the Arango graphDB
# python3 add_meta_data.py

from arango import ArangoClient

user = "root"
pw = "jalapeno"
dbname = "jalapeno"

client = ArangoClient(hosts='http://10.200.99.27:32748')
db = client.db(dbname, username=user, password=pw)

if db.has_collection('sr_node'):
    sr = db.collection('sr_node')

if db.has_collection('peer'):
    pr = db.collection('peer')

if db.has_collection('sr_topology'):
    srt = db.collection('sr_topology')

sr.properties()
srt.properties()

print("calculating prefix SIDs")

r01 = sr.get('2_0_0_0000.0000.0001')
print("r01: ", r01)
src = (r01['ls_sr_capabilities'])
srctlv = (src['sr_capability_subtlv'])
sid = [ sub['sid'] for sub in srctlv ]

pat = (r01['prefix_attr_tlvs'])
lps = (pat['ls_prefix_sid'])
idx = [ sub['prefix_sid'] for sub in lps ]

prefix_sid01 = sid[0] + idx[0]
print("xrd01 prefix sid: ", prefix_sid01)
r01['prefix_sid'] = prefix_sid01
r01['location_id'] = 'AMS001'
r01['country_code'] = 'NLD'
r01['address'] = "Frederiksplein 42, 1017 XN Amsterdam, Netherlands"
sr.update(r01)