#!/usr/bin/perl
foreach (<DATA>)
{
	print $_;
}
__DATA__

cp /root/CI/django_openstack_auth/openstack_auth/views_billing.py       /usr/lib/python2.7/site-packages/openstack_auth/views.py 
cp /root/CI/django_openstack_auth/openstack_auth/views_raw_version.py   /usr/lib/python2.7/site-packages/openstack_auth/views.py 

