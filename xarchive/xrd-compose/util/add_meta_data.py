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
print(r"r01: ", r01)
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

r02 = sr.get('2_0_0_0000.0000.0002')
src = (r02['ls_sr_capabilities'])
srctlv = (src['sr_capability_subtlv'])
sid = [ sub['sid'] for sub in srctlv ]

pat = (r02['prefix_attr_tlvs'])
lps = (pat['ls_prefix_sid'])
idx = [ sub['prefix_sid'] for sub in lps ]

prefix_sid02 = sid[0] + idx[0]
print("xrd02 prefix sid: ", prefix_sid02)
r02['prefix_sid'] = prefix_sid02
r02['location_id'] = 'BML001'
r02['country_code'] = 'DEU'
r02['address'] = "Albrechtstraße 110, 12103 Berlin, Germany"
sr.update(r02)

r03 = sr.get('2_0_0_0000.0000.0003')
src = (r03['ls_sr_capabilities'])
srctlv = (src['sr_capability_subtlv'])
sid = [ sub['sid'] for sub in srctlv ]

pat = (r03['prefix_attr_tlvs'])
lps = (pat['ls_prefix_sid'])
idx = [ sub['prefix_sid'] for sub in lps ]

prefix_sid03 = sid[0] + idx[0]
print("xrd03 prefix sid: ", prefix_sid03)
r03['prefix_sid'] = prefix_sid03
r03['location_id'] = 'IEV001'
r03['country_code'] = 'UKR'
r03['address'] = "O.Gonchara str, Kyiv,Ukraine"
sr.update(r03)

r04 = sr.get('2_0_0_0000.0000.0004')
src = (r04['ls_sr_capabilities'])
srctlv = (src['sr_capability_subtlv'])
sid = [ sub['sid'] for sub in srctlv ]

pat = (r04['prefix_attr_tlvs'])
lps = (pat['ls_prefix_sid'])
idx = [ sub['prefix_sid'] for sub in lps ]

prefix_sid04 = sid[0] + idx[0]
print("xrd04 prefix sid: ", prefix_sid04)
r04['prefix_sid'] = prefix_sid04
r04['location_id'] = 'IST001'
r04['country_code'] = 'TUR'
r04['address'] = "Büyükdere Cd No:121Şişli, Turkey, 34394"
sr.update(r04)

r05 = sr.get('2_0_0_0000.0000.0005')
src = (r05['ls_sr_capabilities'])
srctlv = (src['sr_capability_subtlv'])
sid = [ sub['sid'] for sub in srctlv ]

pat = (r05['prefix_attr_tlvs'])
lps = (pat['ls_prefix_sid'])
idx = [ sub['prefix_sid'] for sub in lps ]

prefix_sid05 = sid[0] + idx[0]
print("xrd05 prefix sid: ", prefix_sid05)
r05['prefix_sid'] = prefix_sid05
r05['location_id'] = 'LHR001'
r05['country_code'] = 'GBR'
r05['address'] = "Second Floor, Trinity Ct, Trinity St, Peterborough PE1 1DA, United Kingdom"
sr.update(r05)

r06 = sr.get('2_0_0_0000.0000.0006')
src = (r06['ls_sr_capabilities'])
srctlv = (src['sr_capability_subtlv'])
sid = [ sub['sid'] for sub in srctlv ]

pat = (r06['prefix_attr_tlvs'])
lps = (pat['ls_prefix_sid'])
idx = [ sub['prefix_sid'] for sub in lps ]

prefix_sid06 = sid[0] + idx[0]
print("xrd06 prefix sid: ", prefix_sid06)
r06['prefix_sid'] = prefix_sid06
r06['location_id'] = 'CDG001'
r06['country_code'] = 'FRA'
r06['address'] = "18 Rue la Boétie, 75008 Paris, France"
sr.update(r06)

r07 = sr.get('2_0_0_0000.0000.0007')
src = (r07['ls_sr_capabilities'])
srctlv = (src['sr_capability_subtlv'])
sid = [ sub['sid'] for sub in srctlv ]

pat = (r07['prefix_attr_tlvs'])
lps = (pat['ls_prefix_sid'])
idx = [ sub['prefix_sid'] for sub in lps ]

prefix_sid07 = sid[0] + idx[0]
print("xrd07 prefix sid: ", prefix_sid07)
r07['prefix_sid'] = prefix_sid07
r07['location_id'] = 'FCO001'
r07['country_code'] = 'ITA'
r07['address'] = "Via dei Tizii, 2C, 00185 Roma Italy"
sr.update(r07)

# Outbound path (left to right on diagram)

print("adding location, country codes, latency, and link utilization data")

srt0102 = srt.get("2_0_0_0_0000.0000.0001_10.1.1.0_0000.0000.0002_10.1.1.1")
srt0102['prefix_sid'] = prefix_sid02
srt0102['latency'] = 10
srt0102['percent_util_out'] = 35
srt0102['country_codes'] = ['NLD', 'DEU']
srt.update(srt0102)

srt0105 = srt.get("2_0_0_0_0000.0000.0001_10.1.1.8_0000.0000.0005_10.1.1.9")
srt0105['prefix_sid'] = prefix_sid05
srt0105['latency'] = 5
srt0105['percent_util_out'] = 55
srt0105['country_codes'] = ['NLD', 'GBR']
srt.update(srt0105)

srt0203 = srt.get("2_0_0_0_0000.0000.0002_10.1.1.2_0000.0000.0003_10.1.1.3")
srt0203['prefix_sid'] = prefix_sid03
srt0203['latency'] = 30
srt0203['percent_util_out'] = 25
srt0203['country_codes'] = ['DEU', 'POL', 'UKR']
srt.update(srt0203)

srt0206 = srt.get("2_0_0_0_0000.0000.0002_10.1.1.10_0000.0000.0006_10.1.1.11")
srt0206['prefix_sid'] = prefix_sid06
srt0206['latency'] = 20
srt0206['percent_util_out'] = 40
srt0206['country_codes'] = ['DEU', 'POL', 'UKR']
srt.update(srt0206)

srt0304 = srt.get("2_0_0_0_0000.0000.0003_10.1.1.4_0000.0000.0004_10.1.1.5")
srt0304['prefix_sid'] = prefix_sid04
srt0304['latency'] = 40
srt0304['percent_util_out'] = 20
srt0304['country_codes'] = ['UKR', 'MDA', 'BGR', 'TUR']
srt.update(srt0304)

srt0504 = srt.get("2_0_0_0_0000.0000.0005_10.1.1.12_0000.0000.0004_10.1.1.13")
srt0504['prefix_sid'] = prefix_sid04
srt0504['latency'] = 60
srt0504['percent_util_out'] = 25
srt0504['country_codes'] = ['GBR', 'BEL', 'DEU', 'AUT', 'HUN', 'SRB', 'BGR', 'TUR']
srt.update(srt0504)

srt0407 = srt.get("2_0_0_0_0000.0000.0004_10.1.1.6_0000.0000.0007_10.1.1.7")
srt0407['prefix_sid'] = prefix_sid07
srt0407['latency'] = 30
srt0407['percent_util_out'] = 20
srt0407['country_codes'] = ['TUR', 'GRC', 'ITA']
srt.update(srt0407)

srt0506 = srt.get("2_0_0_0_0000.0000.0005_10.1.1.14_0000.0000.0006_10.1.1.15")
srt0506['prefix_sid'] = prefix_sid06
srt0506['latency'] = 5
srt0506['percent_util_out'] = 55
srt0506['country_codes'] = ['GBR', 'FRA']
srt.update(srt0506)

srt0607 = srt.get("2_0_0_0_0000.0000.0006_10.1.1.16_0000.0000.0007_10.1.1.17")
srt0607['prefix_sid'] = prefix_sid07
srt0607['latency'] = 30
srt0607['percent_util_out'] = 35
srt0607['country_codes'] = ['FRA', 'ITA']
srt.update(srt0607)

# Return path

srt0201 = srt.get("2_0_0_0_0000.0000.0002_10.1.1.1_0000.0000.0001_10.1.1.0")
srt0201['prefix_sid'] = prefix_sid01
srt0201['latency'] = 10
srt0201['percent_util_out'] = 30
srt0201['country_codes'] = ['NLD', 'DEU']
srt.update(srt0201)

srt0501 = srt.get("2_0_0_0_0000.0000.0005_10.1.1.9_0000.0000.0001_10.1.1.8")
srt0501['prefix_sid'] = prefix_sid01
srt0501['latency'] = 5
srt0501['percent_util_out'] = 50
srt0501['country_codes'] = ['NLD', 'GBR']
srt.update(srt0501)

srt0302 = srt.get("2_0_0_0_0000.0000.0003_10.1.1.3_0000.0000.0002_10.1.1.2")
srt0302['prefix_sid'] = prefix_sid02
srt0302['latency'] = 30
srt0302['percent_util_out'] = 25
srt0302['country_codes'] = ['DEU', 'POL', 'UKR']
srt.update(srt0302)

srt0602 = srt.get("2_0_0_0_0000.0000.0006_10.1.1.11_0000.0000.0002_10.1.1.10")
srt0602['prefix_sid'] = prefix_sid02
srt0602['latency'] = 20
srt0602['percent_util_out'] = 25
srt0602['country_codes'] = ['DEU', 'POL', 'UKR']
srt.update(srt0602)

srt0403 = srt.get("2_0_0_0_0000.0000.0004_10.1.1.5_0000.0000.0003_10.1.1.4")
srt0403['prefix_sid'] = prefix_sid03
srt0403['latency'] = 40
srt0403['percent_util_out'] = 30
srt0403['country_codes'] = ['UKR', 'MDA', 'BGR', 'TUR']
srt.update(srt0403)

srt0405 = srt.get("2_0_0_0_0000.0000.0004_10.1.1.13_0000.0000.0005_10.1.1.12")
srt0405['prefix_sid'] = prefix_sid05
srt0405['latency'] = 60
srt0405['percent_util_out'] = 25
srt0405['country_codes'] = ['GBR', 'BEL', 'DEU', 'AUT', 'HUN', 'SRB', 'BGR', 'TUR']
srt.update(srt0405)

srt0704 = srt.get("2_0_0_0_0000.0000.0007_10.1.1.7_0000.0000.0004_10.1.1.6")
srt0704['prefix_sid'] = prefix_sid04
srt0704['latency'] = 30
srt0704['percent_util_out'] = 30
srt0704['country_codes'] = ['TUR', 'GRC', 'ITA']
srt.update(srt0704)

srt0605 = srt.get("2_0_0_0_0000.0000.0006_10.1.1.15_0000.0000.0005_10.1.1.14")
srt0605['prefix_sid'] = prefix_sid05
srt0605['latency'] = 5
srt0605['percent_util_out'] = 60
srt0605['country_codes'] = ['GBR', 'FRA']
srt.update(srt0605)

srt0706 = srt.get("2_0_0_0_0000.0000.0007_10.1.1.17_0000.0000.0006_10.1.1.16")
srt0706['prefix_sid'] = prefix_sid06
srt0706['latency'] = 30
srt0706['percent_util_out'] = 25
srt0706['country_codes'] = ['FRA', 'ITA']
srt.update(srt0706)

print("meta data added")