from trex_stl_lib.api import *

class STLS1(object):

    def __init__ (self):
        pass;

    def create_stream (self):
        # 2 MPLS label the internal with  s=1 (last one)

        pkt =  Ether()/IPv6(src="fc00:0:101:1::3",dst="fc00:0:3:10:e007::")\
	    /IP(src="10.101.1.2",dst="10.101.9.1")/ICMP()
            #/IP(src="10.101.1.2",dst="10.101.9.1")/UDP(dport=12,sport=1025)/('x'*20)

        # burst of 17 packets
        return STLStream(packet = STLPktBuilder(pkt = pkt ,vm = []),
                         mode = STLTXSingleBurst( pps = 100, total_pkts = 1000) )


    def get_streams (self, direction = 0, **kwargs):
        # create 1 stream 
        return [ self.create_stream() ]

def register():
    return STLS1()