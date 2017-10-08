#!/usr/bin/perl
foreach (<DATA>)
{
	print $_;
}
__DATA__
#==========================================================================
git clone ssh://root@mail.emotibot.com.cn:6787/home/git_syscloud_2015_09/horizon

#==========================================================================
##7.1.1503
wget http://vault.centos.org/7.1.1503/cloud/Source/openstack-liberty/python-django-horizon-8.0.0-1.el7.src.rpm

##==========================================================================
## 7.2.1511 

wget http://vault.centos.org/7.2.1511/cloud/Source/openstack-kilo/python-django-horizon-2015.1.2-1.el7.src.rpm
wget http://vault.centos.org/7.2.1511/cloud/Source/openstack-liberty/python-django-horizon-8.0.1-2.el7.src.rpm
wget http://vault.centos.org/7.2.1511/cloud/Source/openstack-mitaka/python-django-horizon-9.0.1-1.el7.src.rpm
wget http://vault.centos.org/7.2.1511/cloud/Source/openstack-newton/python-django-horizon-10.0.0-1.el7.src.rpm
