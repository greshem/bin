#!/usr/bin/perl 
#use strict;
#use warnings;
#192.168.3.0  rich 的研发部的网段.

@netmask=qw(192.168.1.0 
172.16.10.0
172.16.30.0
);

$netmask=undef;
$ip=undef;
do("/root/develop_perl/ipaddr_netmask_ioctl.pl");
if(-d "/sys/class/net/br0/")
{
    $netmask=get_ip_netmask("br0");
    $ipaddr =   get_ip_address("br0");
}
else
{

    $netmask=get_ip_netmask("br0");
    $ipaddr =   get_ip_address("br0");
}

sub usage()
{
    my $ipaddr= get_ip_address("br0");
    print "Usage: \n";
    print "\t$0:  from_ipaddr  to_ipaddr\n\n";

    print "Example: \n";
    print "\t$0 192.168.1.10  $ipaddr\n";
    print "\t$0 $ipaddr 192.168.1.10\n";
    die("\n");
}

# $from_ipaddr=shift;
# $to_ipaddr= shift;
# if(! defined($to_ipaddr) || ! defined($from_ipaddr))
# {
#     usage();
# }
    

sub change_ip($$)
{
	(my $from_ipaddr, $to_ipaddr)=@_;
	$from_ipaddr=~s/\.\d+$//g;
	$to_ipaddr=~s/\.\d+$//g;

	print "#====================================================         \n";
	print "sed 's/$from_ipaddr/$to_ipaddr/g'  /etc/dhcp/dhcpd.conf    -i \n";
	print "sed 's/$from_ipaddr/$to_ipaddr/g'  /etc/dhcpd.conf         -i \n";
	print "sed 's/$from_ipaddr/$to_ipaddr/g'  /etc/resolv.conf        -i \n";
	print "sed 's/$from_ipaddr/$to_ipaddr/g'  /etc/hosts              -i \n";
	print "sed 's/$from_ipaddr/$to_ipaddr/g'  /var/lib/dhcpd/dhcpd.leases             -i \n";
	print "sed 's/$from_ipaddr/$to_ipaddr/g'  /usr/share/rtiosrv/option.ini             -i \n";
	print "sed 's/$from_ipaddr/$to_ipaddr/g'  /usr/share/rtiosrv/wks.ini             -i \n";
	print "sed 's/$from_ipaddr/$to_ipaddr/g'  /usr/share/diskplat/option.ini             -i \n";
	print "sed 's/$from_ipaddr/$to_ipaddr/g'  /usr/share/diskplat/wks.ini             -i \n";

	print "scp /etc/hosts   rtiosrv:/etc/ \n";
	print "scp /etc/dhcpd.conf rtiosrv:/etc/ \n";
	print "scp /etc/dhcp/dhcpd.conf   rtiosrv:/etc/dhcp/ \n";


	@lines=` find /tmp3/img_app/ |grep dhcp |grep conf\$`;
	for(@lines)
	{
		chomp();
		print  "sed  's/$from_ipaddr/$to_ipaddr/g'  $_  -i \n";
	}
	

}

#print "kvm virtual machine\n";
#
#
$ipaddr =   get_ip_address("br0");
change_ip("172.16.10.10", $ipaddr);	#transoft dev netmask
change_ip("192.168.5.10", $ipaddr); #qianlong test 
change_ip("192.168.1.10", $ipaddr);
change_ip("192.168.99.209", $ipaddr);  	#hotel in wenzhou
change_ip("20.3.198.110", $ipaddr);		#wenzhou back
change_ip("172.16.30.10", $ipaddr);
change_ip("172.26.30.10", $ipaddr); 	#vrv
change_ip("172.30.53.10", $ipaddr);  	#bgp
change_ip("172.16.8.200", $ipaddr);
change_ip("192.168.0.100", $ipaddr);	#in home
