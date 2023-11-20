from trex_stl_lib.api import *

class STLS1(object):
    def __init__ (self):
        self.fsize  =64; # the size of the packet 

    def create_stream (self):

        # Create base packet and pad it to size
        size = self.fsize - 4; # HW will add 4 bytes ethernet FCS
        base_pkt =  Ether()/IP(src="10.101.1.2",dst="10.0.0.9")/UDP(dport=12,sport=1025)
        pad = max(0, size - len(base_pkt)) * 'x'

        return STLProfile( [ STLStream( isg = 1.0, # start in delay in usec 
                                        packet = STLPktBuilder(pkt = base_pkt/pad),
                                        mode = STLTXSingleBurst( pps = 1000),
                                        )
                            ]).get_streams()
    def get_streams (self, direction = 0, **kwargs):
        # create 1 stream 
        return self.create_stream() 
# dynamic load - used for trex console or simulator
def register():
    return STLS1()