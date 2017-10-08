#!/usr/bin/perl
foreach (<DATA>)
{
	print $_;
}
__DATA__
#stop all 
#ps -elf |grep python  |grep -v manage |awk '{print $4}'  |xargs kill -9 
 
cd /opt/stack/logs/
/usr/bin/python /usr/bin/glance-registry --config-file=/etc/glance/glance-registry.conf &> glance-registry.log &
/usr/bin/python /usr//bin/glance-api --config-file=/etc/glance/glance-api.conf &> glance-api.log &
/usr/bin/python /usr/bin/nova-conductor &> nova-conductor.log &
/usr/bin/python /usr/bin/nova-compute --config-file /etc/nova/nova.conf &> nova-compute.log &
/usr/bin/python /usr/bin/nova-cert &> nova-cert.log &
/usr/bin/python /usr/bin/nova-network --config-file /etc/nova/nova.conf &> nova-network.log &
/usr/bin/python /usr/bin/nova-scheduler --config-file /etc/nova/nova.conf &> nova-scheduler.log &
/usr/bin/python /usr/bin/nova-novncproxy --config-file /etc/nova/nova.conf --web /opt/stack/noVNC &> nova-novncproxy.log &
/usr/bin/python /usr/bin/nova-xvpvncproxy --config-file /etc/nova/nova.conf &> nova-xvpvncproxy.log &
/usr/bin/python /usr/bin/nova-consoleauth &> nova-consoleauth.log &
/usr/bin/python /usr/bin/nova-objectstore &> nova-objectstore.log &
/usr/bin/python /usr/bin/cinder-api --config-file /etc/cinder/cinder.conf &> cinder-api.log &
/usr/bin/python /usr/bin/cinder-scheduler --config-file /etc/cinder/cinder.conf &> cinder-scheduler.log &
/usr/bin/python /usr/bin/cinder-volume --config-file /etc/cinder/cinder.conf &> cinder-volume.log &
/usr/bin/python /usr/bin/nova-api &> nova-api.log &
/usr/bin/python /opt/stack/keystone/bin/keystone-all --config-file /etc/keystone/keystone.conf --log-config /etc/keystone/logging.conf -d --debug &> keystone-all.log &

