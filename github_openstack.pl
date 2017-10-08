#!/usr/bin/perl
foreach (<DATA>)
{
	print $_;
}
__DATA__

git clone  https://github.com/openstack/nova
git clone  https://github.com/openstack/glance
git clone  https://github.com/openstack/cinder


git clone git://git.openstack.org/openstack/nova                #计算
git clone git://git.openstack.org/openstack/horizon          #web界面
git clone git://git.openstack.org/openstack/glance      #镜像
git clone git://git.openstack.org/openstack/cinder            #块存储
git clone git://git.openstack.org/openstack/swift                #对象存储
git clone git://git.openstack.org/openstack/keystone      #身份认证
git clone git://git.openstack.org/openstack/neutron     #网络
git clone git://git.openstack.org/openstack/ceilometer  #统计
git clone git://git.openstack.org/openstack/django_openstack_auth  #身份认证
git clone git://git.openstack.org/openstack/heat   #

git clone git://git.openstack.org/openstack/tempest
git clone git://git.openstack.org/openstack/trove
git clone git://git.openstack.org/openstack/pbr
git clone git://git.openstack.org/openstack/oslo.config
git clone git://git.openstack.org/openstack/oslo.messaging
git clone git://git.openstack.org/openstack/python-ceilometerclient
git clone git://git.openstack.org/openstack/python-cinderclient
git clone git://git.openstack.org/openstack/python-glanceclient
git clone git://git.openstack.org/openstack/python-heatclient
git clone git://git.openstack.org/openstack/python-keystoneclient
git clone git://git.openstack.org/openstack/python-neutronclient
git clone git://git.openstack.org/openstack/python-novaclient
git clone git://git.openstack.org/openstack/python-openstackclient
git clone git://git.openstack.org/openstack/python-swiftclient
git clone git://git.openstack.org/openstack/python-troveclient
git clone git://git.openstack.org/openstack/requirements
