from trex_stl_lib.api import *
from scapy.contrib.mpls import * # import from contrib folder of scapy 
import argparse

class STLS1(object):

    def __init__ (self):
        pass;

    def create_stream (self):
        # 2 MPLS label the internal with  s=1 (last one)
        #pkt =  Ether()/MPLS(label=100003,cos=1,s=0,ttl=255)/MPLS(label=100010,cos=1,s=1,ttl=12)\
        #    /IP(src="10.101.1.2",dst="10.101.9.1")/UDP(dport=12,sport=1025)/('x'*20)

        pkt =  Ether()/IPv6(src="fc00:0:101:1::3",dst="fc00:0:3:10:e009::")\
            /IP(src="10.101.1.2",dst="10.101.9.1")/UDP(dport=12,sport=1025)/('x'*20)
        
        # burst of 17 packets
        return STLStream(packet = STLPktBuilder(pkt = pkt ,vm = []),
                         mode = STLTXSingleBurst( pps = 1, total_pkts = 17) )

    def get_streams (self, tunables, **kwargs):
        parser = argparse.ArgumentParser(description='Argparser for {}'.format(os.path.basename(__file__)), 
                                         formatter_class=argparse.ArgumentDefaultsHelpFormatter)

        args = parser.parse_args(tunables)
        # create 1 stream 
        return [ self.create_stream() ]

def register():
    return STLS1()