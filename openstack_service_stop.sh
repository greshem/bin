#!/bin/bash
set -x 

for nova in {openstack-nova-api.service,openstack-nova-cert.service,openstack-nova-compute.service,openstack-nova-conductor.service,openstack-nova-consoleauth.service,openstack-nova-novncproxy.service,openstack-nova-scheduler.service};do
systemctl stop $nova &>/dev/null && echo "$nova stop ok" || echo "$nova stop failed"
done

for glance in {openstack-glance-api.service,openstack-glance-registry.service};do
systemctl stop $glance &>/dev/null && echo "$glance stop ok" || echo "$glance stop failed"
done

for cinder in {openstack-cinder-api.service,openstack-cinder-backup.service,openstack-cinder-scheduler.service,openstack-cinder-volume.service,openstack-losetup.service};do
systemctl stop $cinder &>/dev/null && echo "$cinder stop ok" || echo "$cinder stop failed"
done

for neutron in {neutron-dhcp-agent.service,neutron-lbaas-agent.service,neutron-metadata-agent.service,neutron-metering-agent.service,neutron-openvswitch-agent.service,neutron-server.service,neutron-vpn-agent.service};do
systemctl stop $neutron &>/dev/null && echo "$neutron stop ok" || echo "$neutron stop failed"
done

for ceilometer in {openstack-ceilometer-central.service,openstack-ceilometer-collector.service,openstack-ceilometer-compute.service,openstack-ceilometer-notification.service};do
systemctl stop $ceilometer &>/dev/null && echo "$ceilometer stop ok" || echo "$ceilometer stop failed"
done

for gnocchi in {openstack-gnocchi-metricd.service,openstack-gnocchi-statsd.service};do
 systemctl stop $gnocchhi &>/dev/null && echo "$gnocchhi stop ok" || echo "$gnocchhi stop failed"
done

for aodh in {openstack-aodh-evaluator.service,openstack-aodh-listener.service,openstack-aodh-notifier.service};do
systemctl stop $aodh &>/dev/null && echo "$aodh stop ok" || echo "$aodh stop failed"
done

for trove in {openstack-trove-api.service,openstack-trove-conductor.service,openstack-trove-taskmanager.service};do
systemctl stop $trove &>/dev/null && echo "$trove stop ok" || echo "$trove stop failed"
done

for sahara in {openstack-sahara-api.service,openstack-sahara-engine.service};do
systemctl stop $sahara &>/dev/null && echo "$sahara stop ok" || echo "$sahara stop failed"
done


for each in $(systemctl -a |grep openstack)
do
systemctl stop $each
done


for each in $(systemctl -a |grep neutron)
do
systemctl stop $each
done


#rabbit 
#epmd 

#mysql  mariadb 

#service httpd 
