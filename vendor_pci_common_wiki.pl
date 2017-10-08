#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__

1022 	#amd
1025	#acer , ali
104B	#BusLogic
105b	#foxconn
1274  	#Ensoniq
15AD	#VMware
168c	#Atheros Communications Inc
1af4  	#Red Hat, Inc
1b36  	#Red Hat, Inc.
1e4e 	#Broadcom Inc
6900  	#Red Hat, Inc.
8086 	#intel
feda  	#Broadcom Inc
fffd  	#XenSource, Inc.
1028	#dell
1000	#lsi
102b	#Matrox Graphics,
10ec	#Realtek
