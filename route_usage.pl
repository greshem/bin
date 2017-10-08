#!/usr/bin/perl
foreach (<DATA>)
{
	print $_;
}
__DATA__
#==========================================================================
route del   -net  192.168.1.1 netmask 255.255.255.255 
route add default gw 192.168.1.1 

route delete default
route add default gw 192.168.2.2 netmask 255.255.0.0

route add -net 58.0.0.0 netmask 255.0.0.0   eth0
route add -net 59.0.0.0 netmask 255.0.0.0   eth0
route add -net 60.0.0.0 netmask 255.0.0.0   eth0
route add -net 61.0.0.0 netmask 255.0.0.0   eth0

route add -net 172.16.6.0 netmask 255.255.255.0 gw 172.16.2.254 dev eth0 /* 增加一条网络172.16.6.0/24 经过172.16.2.254 eth0 */
route del gw 172.16.2.254 /* 删除默认网关172.16.2.254 */

route del -net 172.16.86.0/24 /* 删除默认网络172.16.86.0 *

ifconfig eth0 192.168.7.82/16
route add default gw 192.168.2.2 netmask 255.255.0.0 dev eth0

route del -net  172.30.53.0/24

route add -net 192.168.168.0 netmask 255.255.255.0 dev ppp0 # vpn route 
route add 192.168.2.0 mask 255.255.255.0 192.168.2.1 		# windows   ip mask   gw_ip
route add -net default dev ppp0								#

route add  -net  192.168.0.0/24   gw 192.168.1.55			# tyd  

