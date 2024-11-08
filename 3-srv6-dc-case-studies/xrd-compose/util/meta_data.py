# Script writes site and link meta data into the Arango graphDB
# python3 meta_data.py

import json
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

f = open("meta_data.json")
md = json.load(f)
for x in md["nodes"]:

    node = sr.get(x['key'])
    print(x['key'])

    src = (node['ls_sr_capabilities'])
    srctlv = (src['sr_capability_subtlv'])
    sid = [ sub['sid'] for sub in srctlv ]

    pat = (node['prefix_attr_tlvs'])
    lps = (pat['ls_prefix_sid'])
    idx = [ sub['prefix_sid'] for sub in lps ]

    prefix_sid = sid[0] + idx[0]
    print("node prefix sid: ", prefix_sid)
    node['prefix_sid'] = prefix_sid
    node['location_id'] = x['location_id']
    node['country_code'] = x['country_code']
    #node['address'] = x["address"]
    sr.update(node)

for y in md["links"]:

    print("adding location, country codes, latency, and link utilization data")

    link = srt.get(y['key'])
    print(y['key'])
    print(link)
    #latency = y['latency']
    #link['prefix_sid'] = prefix_sid
    link['latency'] = y['latency']
    link['percent_util_out'] = y['percent_util_out']
    link['country_codes'] = y['country_codes']
    srt.update(link)