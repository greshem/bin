#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__

nmap　-sP　192.168.7.0/24	#ICMP echo , TCP ACK 
nmap  -sP -PT80 			#port, without ICMP 
nmap  -St 192.168.1.1  	    #three hand , 三次握手.
nmap  -sS 192.168.1.1 		#tcp SYN 
nmap  -sF  192.168.1.1      #tcp FIN 
nmap  -sU  192.168.1.1      #udp 

nmap -A    172.30.53.111   #os,system, windows 
nmap -sS  -O 192.168.1.1   #os fingerprint 
nmap -v scanme.nmap.org

#identd
nmap -sT -p 90 -I -O 192.168.21.175 #
nmap -PO  192.16.1.1 		#tcp scan without icmp

nmap -p1-65535     192.168.1.1 # range  port 


# ssh online discovery 
diskplat/trunk/tools_third_part/auto_discovery_diskplat/nmap_autopasswd_ssh_diskplat.pl  #ssh 

fping  							#icmp 
tcping -t 3 192.168.1.1 80		#tcp port scan 



 nmap -sV -O -v gsx  		# 服务器版本   version 
