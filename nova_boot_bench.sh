#!/usr/bin/perl

#nova-manage network create br100 192.168.201.0/24 1 256 --bridge=br100
#netoword_id 为空 则 用上面的方式产生. 

network_id=$(nova network-list   |awk -F\|  '{print $2}'  |grep -v ID  |grep -)
id=$( echo $network_id |sed 's/ //g' ) 

for each in $(seq 1 10)
do
echo nova boot --flavor  1G_40G   --image centos7bbb  --nic  net-id=$id   newnew$each
done


