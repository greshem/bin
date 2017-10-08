#!/usr/bin/perl
# USAGE
#       EDIT THE SCRIPT TO SPECIFY Your IPs
#	perl rh-eth0-bulk-ipconfig-1.2.pl
# SEE ALSO
#
#   perldoc rh-eth0-bulk-ipconfig-1.2.pl

#Configure your IP Class and Network attributes
$path = "/etc/sysconfig/network-scripts/ifcfg-eth0:";
$class = "192.168.1";
$broadcast = "192.168.1.255";
$netmask = "255.255.255.0";
$network = "192.168.1.0";
#End user config

for($i=6;$i<=9;$i++)
{
   open(DAT,">$path".$i);
   print DAT "DEVICE=eth0:".$i."\n";
   print DAT "BOOTPROTO=static\n";
   print DAT "BROADCAST=$broadcast\n";
   print DAT "IPADDR=$class.$i\n";
   print DAT "NETMASK=$netmask\n";
   print DAT "NETWORK=$network\n";
   print DAT "ONBOOT=yes";
   close(DAT);
}

__END__

=head1 NAME

rh-eth0-bulk-ipconfig-1.2.pl - Get open ports informatio in xml format

=head1 SCRIPT CATEGORIES

Networking

=head1 README

This script is used to hard config the bulk IPs in Red-Hat style linux operating systems.


=head1 OSNAMES

RedHat, Centos, Fedora

=head1 PREREQUISITES

=head1 COREQUISITES

=head1 SYNOPSIS

=head1 AUTHOR

Jamshaid Faisal

 { 
   domain   => "gmail", 
   tld      => "com", 
   username => "j.faisal" 
 }

=cut
