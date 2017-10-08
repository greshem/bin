#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__

hexinject -s -i eth0

hexinject -s -i eth0 -r

#ftp sniffer 
 hexinject -s -i eth0 -r | strings

#http sniffer
hexinject -s -i eth0 -r | strings | grep 'Host:'


#dns sniffer
hexinject -s -i eth0 -f 'udp dstport=53' -r -c 10 | tr
'\001-\015' '.' | strings --bytes=8 | grep -o -E '[a-zA-Z0-9_-]+[a-zA-Z0-9\._-]
+'


hexinject -s -i eth0 -f 'arp' -c 1


echo "01 02 03 04" | hexinject -p -i eth0
echo 'Yum... pizza!' | hexinject -p -i eth0 -r
hexinject -s -i eth0 -c 1 -f 'arp' | replace '06 04 00 01' '06 04 00 02' | hexinject -p -i eth0


hexinject -s -i eth0 -c 1 -f 'src host 192.168.1.9' | hexinject -p -i eth1


hexinject -s -i eth1 -c 1 -f 'dst host 192.168.1.9' |hexinject -p -i eth0



#It's even possible to emulate NAT opportunely replacing the IP:
hexinject -s -i eth0 -c 1 -f 'src host 192.168.1.9' |replace 'C0 A8 01 09' 'C0 A8 01 04' | hexinject -p -i eth1

hexinject -s -i eth1 -c 1 -f 'dst host 192.168.1.9' |
replace 'C0 A8 01 04' 'C0 A8 01 09' | hexinject -p -i eth0

#==========================================================================
#dhcp 
#you ip      |next server ip 
#C0 A8 15 B1 C0 A8 15 A5
#把 192.168.21.165  next-server  替换成  192.168.21.162
#会出现 死循环: 
hexinject -s -i eth  -f 'udp and port 67 ' |   replace  'C0 A8 15 B1 C0 A8 15 A5' 'C0 A8 15 B1 C0 A8 15 A2' | hexinject -p -i eth0



