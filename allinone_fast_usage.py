#!/usr/bin/python
DATA="""

cd /tmp3/images/
wget  http://192.168.131.75:1888/allinone/newton.qcow2.newton56-14.template


cd /root/bin/mybridge_common_usage/&& bash  14_start_net.sh 
cd /root/bin/gen_vms_libvirt/

python  instance_class.py  --name=newton   --start_net=12 --count=1  --image=/tmp3/image3/newton.qcow2.newton56-14.template

mv output   /tmp3/allinone_newton 

cd  /tmp3/allinone_newton/  && bash start.sh  


"""
print DATA;
