#!/usr/bin/perl
#tcpdump_cur_srv();
print "#========================================================================== \n";
common_usage();

#==========================================================================
sub tcpdump_cur_srv()
{
	#获取所有的 TCP listem  的socket 
	#httpd      1118    root    4u  IPv6  14134      0t0  TCP *:http (LISTEN)
	my %port_hash;

	open(CMD, " lsof -iTCP -sTCP:LISTEN |") or die("open lsof 失败 $!\n");
	for(<CMD>)
	{
		if($_=~/.*:(\S+)\s+\(.*/)
		{
			$port=$1;
			if(!defined($port_hash{$port}))
			{
			print  "tcpdump  port  $port -s 0 -i eth0 -w $port.pcap  # $port  servers\n";
			$port_hash{$port}=0;

			}
			else
			{
				$port_hash{$port}++;
			}
		}	
	}


}

#==========================================================================
sub common_usage()
{
	use Encode;
	$lang= $ENV{"LANG"};
	foreach (<DATA>)
	{
		#print $_;
		if($lang=~/utf8/i)
		{
			$to=encode("utf-8", decode("gb2312", $_));  
			print $to;
		}
		else
		{
			print $_;
		}

	}
}
__DATA__
tcpdump  -s 54  -w ether_ip_tcp_header.pcap  #指定大小, 抓取

tcpdump  snmp -s 0 -i eth0 -w snmpd.pcap #指定网卡 
tcpdump  snmp -s 0 -i eth0 -w snmpd.pcap
tcpdump  port  161  -s 0 -i eth0 -w snmpd.pcap  
tcpdump  port  67 -s 0 -i eth0 -w dhcpd.pcap # dhcpd  包, 指定.
tcpdump -s 1518 -lenx port bootps or port bootpc | dhcpdump  #抓取dhcp包并供解析. 
tcpdump port 2049 -s 0  -i lo  -w nfs_proto_copy_file.pcap    #NFS 协议包。 
tcpdump ip and port not 22 -s 0    -i lo -w http.pcap #排除ssh 的影响. 
tcpdump ip and port 80  -s 0    -i eth0  -w http.pcap #httpd 包. 
tcpdump ip and port not 22 -s 0    -i lo -w http.pcap #not 否定. 

#==========================================================================
tcpdump -i br0 tcp[13] == 2 #tcp syn  SYN
tcpdump 'tcp port 80 and (((ip[2:2] - ((ip[0]&0xf)<<2)) - ((tcp[12]&0xf0)>>2)) != 0)' #  ACK-only packets.
tcpdump ' ip[2:2] > 576' #length 
tcpdump 'ether[0] & 1 = 0 and ip[16] >= 224' #ethernet broadcast 
tcpdump 'icmp[icmptype] != icmp-echo and icmp[icmptype] != icmp-echoreply' # icmp not ping packets
#==========================================================================
#这里 -s 0 就可以把 nfs 的包都抓下来了. 
tcpdump port 2049 -s 0  -i lo  -w nfs_proto_copy_file.pcap   # -s  完整的包 截断  ,  ftruncate
#这里只能抓 取一点点的数据. 
tcpdump port 2049  -i lo  -w nfs_proto_copy_file.pcap  
tcpdump ipx -s 0 -i eth0 -w ipx.pcap #ipx包
tcpdump -w greshem.pcap -s  0 host 192.168.0.234 #host 指定 ip 的机子.  
tcpdump -w greshem_port.pcap -s  0 host 192.168.0.234 and port 3333  # 某台机器的某个端口
tcpdump 'gateway 192.168.0.1  and (port ftp or ftp-data)' # 网关 gateway  ftp 数据. 
tcpdump ip and port not 22 and port not 8080  and port not 2049  -s 0 #抓非 ssh 非 https 非nfs 的端口, hmc 的流量, 多条件.
tcpdump  port  7495 -s 0 -i eth0 -w rich_disk.pcap   # rich 7495 锐起磁盘服务.
tcpdump -i tap34 -i  tap35 -i  tap36 -i  tap37 -i  tap38 #tunctl tap  eth0 br0 br100 
tcpdump -i br100  -p 		#如果我们关心的只是我们本地主机的通信情况，一种方法是使用 -p 参数禁止promiscuous模式
tcpdump -i eth0  host 61.55.138.133 and udp #only  this ip udp packet

tcpdump ether dst 50:43:A5:AE:69:55	#destination eth dst dest 
tcpdump dst net 192.168.3.0			#destination net range
tcpdump src net 192.168.3.0 mask 255.255.255.240  	#
tcpdump src net 192.168.3.0/28 						#
tcpdump dst port 23				# dst source src
tcpdump src port 80				#
tcpdump  vlan and ip 		# in vlan  env.
tcpdump  -vvve vlan -i em2   		# 就可以获取vlan    这个网卡的vlan的id了. decode,verbose,解码
tcpdump -x -s 2048 ether[14]=0xfc and ether[15]=0xfc  #all rpld packet


tcpdump -vvve udp port tftp 		#diskplat tftp debug
tcpdump -vvve udp port 67		#diskplat dhcp bootps debug

tcpdump   -i any  				# all netcard 

tcpdump   tcp and \( port ftp or ftp-data \)  -i any -w output_ftp_login.pcap  -s 0   #or   brace   parenthesis
tcpdump   tcp and port smtp -i any -w  smtp_output.pcap -s 0 
tcpdump   tcp and port pop3 -i any -w  pop3_output.pcap -s 0 
tcpdump   tcp and port imap -i any -w  imap_output.pcap -s 0 

tcpdump  tcp src port 3333 -c 10000  #count 
