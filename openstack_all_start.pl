#!/usr/bin/perl
foreach (<DATA>)
{
	print $_;
}
__DATA__

systemctl start rabbitmq-server
systemctl start mariadb
#systemctl start openstack-keystone
systemctl start openstack-glance-registry openstack-glance-api
systemctl start openstack-nova-api openstack-nova-scheduler openstack-nova-conductor openstack-nova-cert openstack-nova-consoleauth openstack-nova-novncproxy
#systemctl start neutron-server
systemctl start openstack-cinder-scheduler openstack-cinder-api openstack-cinder-volume
systemctl start httpd
