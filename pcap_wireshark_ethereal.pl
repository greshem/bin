#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__
wireshark-filter
wireshark
tshark
editcap
tcpdump
pcap
dumpcap
text2pcap
rawshark 
pcapdiff

Net::Pcap
arpwatch
arptools

