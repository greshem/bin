#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__
Eucalyptus
openstack
OpenNebula
openQRM
ovirt

Enomalism 
abiCloud

aeolus
