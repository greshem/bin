#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__
# /root/develop_network/app_img/app_rtiosrv/
# mac 01
host rt_as4_8      { hardware ethernet dc:0e:bb:bb:01:01; fixed-address 172.16.10.101;}
host rt_as6_2      { hardware ethernet dc:0e:bb:bb:01:02; fixed-address 172.16.10.102;}
host rt_f8         { hardware ethernet dc:0e:bb:bb:01:03; fixed-address 172.16.10.103;}
host rtiosrv       { hardware ethernet dc:0e:bb:bb:01:04; fixed-address 172.16.10.104;}
host rt_as5_8      { hardware ethernet dc:0e:bb:bb:01:05; fixed-address 172.16.10.105;}
host rt_f13		   { hardware ethernet dc:0e:bb:bb:01:06; fixed-address 172.16.10.106;}
host rt_winxp      { hardware ethernet dc:0e:bb:bb:01:07; fixed-address 172.16.10.107;}
host rt_win2000      { hardware ethernet dc:0e:bb:bb:01:08; fixed-address 172.16.10.108;}

host dlxp0      { hardware ethernet dc:0e:bb:bb:01:A0; fixed-address 172.16.10.150;}
host dlxp1      { hardware ethernet dc:0e:bb:bb:01:A1; fixed-address 172.16.10.151;}

host vmware_dlxp2     { hardware ethernet dc:0e:bb:bb:01:A2; fixed-address 172.16.10.152;}
host vmware_dlxp3     { hardware ethernet dc:0e:bb:bb:01:A3; fixed-address 172.16.10.154;}
nost vmware_dlxp4     { hardware ethernet dc:0e:bb:bb:01:A4; fixed-address 172.16.10.153;}

#snapshot
# mac 02
host gentoo_2012      { hardware ethernet dc:0e:bb:bb:02:01 ; fixed-address 172.16.10.152;}


