#!/usr/bin/perl

for(<DATA>)
{
chomp;
$name=$_;
$name=~s/\.git$//g;
print <<EOF
git clone git://git.openstack.org/openstack/$_ $name 
git clone git://teresa/git/$name $name 

EOF
;

}

print "162.211.181.182 teresa  \n";


__DATA__
ceilometer.git
cinder.git
glance.git
heat.git
horizon.git
ironic.git
keystone.git
neutron.git
neutron-fwaas.git
neutron-lbaas.git
neutron-vpnaas.git
nova.git
sahara.git
swift.git
trove.git
requirements.git
tempest.git
tempest-lib.git
python-ceilometerclient.git
python-cinderclient.git
python-glanceclient.git
python-heatclient.git
python-ironicclient.git
python-keystoneclient.git
python-neutronclient.git
python-novaclient.git
python-saharaclient.git
python-swiftclient.git
python-troveclient.git
python-openstackclient.git
cliff.git
debtcollector.git
oslo.concurrency.git
oslo.config.git
oslo.context.git
oslo.db.git
oslo.i18n.git
oslo.log.git
oslo.messaging.git
oslo.middleware.git
oslo.policy.git
oslo.rootwrap.git
oslo.serialization.git
oslo.utils.git
oslo.versionedobjects.git
oslo.vmware.git
pycadf.git
stevedore.git
taskflow.git
tooz.git
pbr.git
glance_store.git
heat-cfntools.git
heat-templates.git
django_openstack_auth.git
keystonemiddleware.git
swift3.git
ceilometermiddleware.git
dib-utils.git
os-apply-config.git
os-collect-config.git
os-refresh-config.git
ironic-python-agent.git
noVNC.git
spice-html5.git
