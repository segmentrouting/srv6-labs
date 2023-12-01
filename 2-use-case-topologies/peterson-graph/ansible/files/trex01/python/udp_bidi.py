class STLS1(object):

    def create_stream (self):
        return STLStream(
            packet =
                    STLPktBuilder(
                        pkt = Ether()/IP(src="10.101.1.2",dst="10.101.2.2")/
                                UDP(dport=12,sport=1025)/(10*'x')
                    ),
             mode = STLTXCont())

    def get_streams (self, direction = 0, **kwargs):
        # create 1 stream
        if direction == 0:
            src_ip = "10.101.1.2"
            dst_ip="10.101.2.2"
        else:
            src_ip="10.101.2.2"
            dst_ip="10.101.1.2"

        pkt   = STLPktBuilder(
                              pkt = Ether()/IP(src=src_ip,dst=dst_ip)/
                              UDP(dport=12,sport=1025)/(10*'x') )

        return [ STLStream( packet = pkt,mode = STLTXCont()) ]
    
def register():
    return STLS1()