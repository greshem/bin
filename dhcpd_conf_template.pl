#!/usr/bin/perl
use strict;
do("net_info.pl");

my $eth="eno1";
my $local_ip= get_ip_address($eth);
my $netmask = get_ip_netmask($eth);

my @tmp=split(/\./, $local_ip);
my $net_range= $tmp[0].".".$tmp[1].".".$tmp[2];

if( -f "/etc/dhcpd.conf")
{
	die("Error: /etc/dhcpd.conf exist! Pleaes delete /etc/dhcpd.conf, first. \n");
	#die("Error: /etc/dhcpd.conf 文件存在 退出, 请备份/etc/dhcpd.conf, 再删除, 再执行 本程序 \n");
}
open(FILE, "> /etc/dhcpd.conf" ) or die(" create /etc/dhcpd.conf error\n");
print FILE <<EOF
option space PXE;
option PXE.mtftp-ip               code 1 = ip-address;  
option PXE.mtftp-cport            code 2 = unsigned integer 16;
option PXE.mtftp-sport            code 3 = unsigned integer 16;
option PXE.mtftp-tmout            code 4 = unsigned integer 8;
option PXE.mtftp-delay            code 5 = unsigned integer 8;
option PXE.discovery-control      code 6 = unsigned integer 8;
option PXE.discovery-mcast-addr   code 7 = ip-address;

allow unknown-clients;
allow bootp;
allow booting;
option subnet-mask $netmask;
option broadcast-address $net_range.255;
option domain-name "diskplat";
option routers $net_range.2;
option vendor-class-identifier "PXEClient";
vendor-option-space PXE; 
option PXE.mtftp-ip 0.0.0.0;
	
ddns-update-style none;
	
subnet $net_range.0 netmask $netmask {
	      	range dynamic-bootp $net_range.77 $net_range.177;
default-lease-time 160000;
max-lease-time 3200;
next-server $local_ip;
filename "pxelinux.0";
	
}
EOF
;


eval {
	require 'Hash::Diff';
};

if ($@)
{
warn $@ ;
die("Hash::Diff not exists \n");
}

########################################################################
#支持 dhpcd.lease 和wks.ini 的 merge  放到 /etc/dhcpd.conf 中去.
if( -f "hash_to_dhcpd_conf_new.pl")
{
	print "perl hash_to_dhcpd_conf_new.pl \n";
	system("perl hash_to_dhcpd_conf_new.pl ");
}
elsif( -f   "/usr/share/diskplat/sync_dhcpd_wks/hash_to_dhcpd_conf_new.pl")
{
	print "perl /usr/share/diskplat/sync_dhcpd_wks/hash_to_dhcpd_conf_new.pl \n";
	system("perl  /usr/share/diskplat/sync_dhcpd_wks/hash_to_dhcpd_conf_new.pl ");
}



__DATA__
#示例的inode 的例子.
#vmware linux
host node1 {
    hardware ethernet 00:0c:29:f1:15:cd;
    fixed-address 192.168.7.82;
	filename "aoe.0";
	option root-path "aoe:e1.1";
}
#vwmare winxp. 
host node2 {
    hardware ethernet 00:0c:29:5a:67:b3;
    fixed-address 192.168.7.86;
	filename "aoe.0";
	option root-path "aoe:e1.1";
}
host node3 {
    hardware ethernet 48:5b:39:cb:7c:ce;
    fixed-address 192.168.1.81;
	filename "aoe.0";
	option root-path "aoe:e1.1";
}
#给 aoe用的dhcpd 的标记.
group {
host Clinet1{ hardware ethernet 00:00:e8:43:15:4a; fixed-address 172.16.8.200;option root-path "aoe:e1.1";}
host Clinet2{ hardware ethernet 00:0c:29:27:a1:c5; fixed-address 172.16.8.199;option root-path "aoe:e1.1";}
}

