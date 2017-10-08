#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__
#==========================================================================
struct ethernet{
char mac[6]
char mac[6]
short  proto
}
#==========================================================================
struct iphdr {
        __u8    ihl:4,							ip[0]
                version:4;
        __u8    tos; 		//server type tos   ip[1]
        __u16   tot_len; 	//total len 		ip[2..3];
        __u16   id;		 	//id				ip[4..5]
        __u16   frag_off; 	//16 bit flag		ip[6..7]
        __u8    ttl;		//ttl 				ip[8]
        __u8    protocol;	//protocol			ip[9]
        __u16   check;		//check 			ip[10..11]
        __u32   saddr;		//src				ip[12..15]
        __u32   daddr;		//dest				ip[16..19]
};
#==========================================================================
struct tcphdr {
        __u16   source; //source port	   #	tcp[0..1]	
        __u16   dest;	//destination port #	tcp[2..3] 		#tcpdump tcp dst port  
        __u32   seq;	//sequence number  #	tcp[4..7]
        __u32   ack_seq;//acknowledge nubmer#tcp[8..11]

        __u16   res1:4, //reverse		  #		tcp[12..13];
                doff:4, //data offset
                fin:1, syn:1, rst:1, psh:1, 
				ack:1, urg:1, ece:1, cwr:1;

        __u16   window;	 //windows size		#	tcp[14..15]
        __u16   checksum;//checksum			#	tcp[16..17]
        __u16   urg_ptr; //uregen pointer	#	tcp[18..19]
};

