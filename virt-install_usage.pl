#!/usr/bin/perl
foreach (<DATA>)
{
	print $_;
}
__DATA__


qemu-img create -f qcow2   /vmstorage/Centos7.img  80G 

virt-install -n Centos7 -r 2048     -cpus=2  -f /vmstorage/Centos7.img


virt-install --name=centos7a --ram=1024 --vcpus=1 --cdrom /vmstorage/CentOS-7-x86_64-DVD-1503-01.iso  \
    --disk path=/vmstorage/centos7a.img,size=70 --network bridge=br-ceph-linux --vnc --vncport=5900 \
    --vnclisten=0.0.0.0 --os-type=linux --os-variant=rhel7 --connect qemu:///system  


#这种安装方式注意  sda  -> vda了 
# /root/bin/kickstart/centos7_1_x64.cfg  的. ignoredisk --only-use=sda 这行也就错误了. 
# 
virt-install --vnc --noautoconsole --name=server --ram=2048 --arch=x86_64 --vcpus=1 --os-type=linux --os-variant=rhel7 \
--hvm --accelerate --disk=/vmstorage/server.img,size=80 --location=http://mirrors.aliyun.com/centos/7.2.1511/os/x86_64/  \
--extra-args="ks=http://192.168.1.11/ks.cfg" && virt-install --autostart server


virt-install --vnc \
                --noautoconsole \
                --name=server$i \
                --ram=512 --arch=x86_64 \
                --vcpus=1 --os-type=linux \
                --os-variant=rhel7 \
                --hvm --accelerate \
                --disk=/var/lib/libvirt/images/server$i.img size=8G \
                --location=ftp://192.168.0.254/pub/rhel6/dvd \
                --extra-args="ks=http://192.168.0.158/ks.cfg"  
