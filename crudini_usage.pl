#!/usr/bin/perl
foreach (<DATA>)
{
	print $_;
}
__DATA__

#-----------------------------------------------------------------------------------
crudini --set /etc/keystone/keystone.conf DEFAULT admin_token tgbygv
crudini --set /etc/keystone/keystone.conf DEFAULT debug   True
crudini --set /etc/keystone/keystone.conf DEFAULT verbose True

#-----------------------------------------------------------------------------------
crudini --set /etc/yum.repos.d/rdo-release.repo    openstack-kilo-customized  enabled  1
