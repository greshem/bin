#!/usr/bin/perl
get_ovs_bridge();
sub get_ovs_bridge()
{
	my @br;
	for (glob("/sys/class/net/br*"))
	{
		print $_."\n";
	}
	
}
__DATA__
ovs-vsctl add-br br100			#Ìí¼Ó br100µÄÇÅ.
ovs-vsctl add-port br100 em3 	#Õâ¸ö¸ù¾Ý BGP µÄÍøÂç»·¾³À´µÄ, ×Ô¼ºµ±³¡ÐèÒªÈ·¶¨ºÃµÄ.

ip tuntap add tap0 mode tap
ip tuntap add tap1 mode tap
ip tuntap add tap2 mode tap

#ovs-vsctl add-port br100 tap0	#Ìí¼Ó tap0 ÉÏÈ¥, ÕâÒ»²½·Ç±ØÒª, Ä¬ÈÏqemuÆô¶¯µÄÊ±ºòÄ¬ÈÏ, ÉèÖÃºÃÍøÂçÁË, ÔÚ /etc/qemu-ifup ÖÐ.
ovs-vsctl get bridge br100
ovs-vsctl list br
ovs-vsctl list port


tunctl

ovs-vsctl del-port ${switch} $1
ovs-vsctl add-port  ${switch} $1
ovs-vsctl set port $1 tag=351

