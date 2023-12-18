from trex_stl_lib.api import *
import argparse


# 1 clients MAC override the LSB of destination
class STLS1(object):

    def __init__ (self):
        self.fsize  =1024; # the size of the packet 
        self.burst_size = 10000


    def create_stream (self):

        # Create base packet and pad it to size
        size = self.fsize - 4; # HW will add 4 bytes ethernet FCS
        base_pkt =  Ether()/IP(src="10.101.8.108",dst="10.101.1.101")/UDP(dport=12,sport=1025)
        base_pkt1 =  Ether()/IP(src="10.101.8.108",dst="10.101.2.102")/UDP(dport=12,sport=1025)
        base_pkt2 =  Ether()/IP(src="10.101.8.108",dst="10.101.5.105")/UDP(dport=12,sport=1025)
        base_pkt3 =  Ether()/IP(src="10.101.8.108",dst="10.101.9.109")/UDP(dport=12,sport=1025)
        pad = max(0, size - len(base_pkt)) * 'x'

        for l in self: 
            return STLProfile( [ STLStream( isg = 10.0, # start in delay 
                                            name    ='S0',
                                            packet = STLPktBuilder(pkt = base_pkt/pad),
                                            mode = STLTXSingleBurst( pps = 3000, total_pkts = self.burst_size),
                                            next = 'S1'), # point to next stream 

                                STLStream( self_start = False,  # Stream is disabled. Will run because it is pointed from S0
                                            name    ='S1',
                                            packet  = STLPktBuilder(pkt = base_pkt1/pad),
                                            mode    = STLTXSingleBurst( pps = 2000, total_pkts = self.burst_size),
                                            next    = 'S2' ),

                                STLStream( self_start = False, # Stream is disabled. Will run because it is pointed from S1
                                            name   ='S2',
                                            packet = STLPktBuilder(pkt = base_pkt2/pad),
                                            mode = STLTXSingleBurst( pps = 5000, total_pkts = self.burst_size ),
                                            next    = 'S3' ),
                                            
                                STLStream(  self_start = False, # Stream is disabled. Will run because it is pointed from S2
                                            name   ='S3',
                                            packet = STLPktBuilder(pkt = base_pkt3/pad),
                                            mode = STLTXSingleBurst( pps = 8000, total_pkts = self.burst_size )
                                            )
                                ]).get_streams()
        return l


    def get_streams (self, tunables, **kwargs):
        parser = argparse.ArgumentParser(description='Argparser for {}'.format(os.path.basename(__file__)), 
                                         formatter_class=argparse.ArgumentDefaultsHelpFormatter)
        args = parser.parse_args(tunables)
        # create 1 stream 
        return self.create_stream()


# dynamic load - used for trex console or simulator
def register():
    return STLS1()