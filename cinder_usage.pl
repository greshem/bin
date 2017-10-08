#!/usr/bin/perl
foreach (<DATA>)
{
	print $_;
}
__DATA__

systemctl  restart openstack-cinder-api
systemctl  restart openstack-cinder-backup
systemctl  restart openstack-cinder-volume
systemctl  restart openstack-cinder-scheduler
