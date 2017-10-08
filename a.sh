
#也可以采用virt-install命令下直接产生虚机
/usr/bin/virt-install \
        --name CentOS-7.0-1406-x86_64-Everything.iso \
        --ram 1024 \
        --virt-type kvm \
        --vcpus 1 \
        --disk path=/vmstorage/CentOS-7.0-1406-x86_64-Everything.iso.img,size=20 \
        --cdrom /mnt/a/sdb2/linux_iso_windows/centos7/CentOS-7.0-1406-x86_64-Everything.iso \
        --graphics vnc,password=123456,listen=0.0.0.0 \
        --network network=mybridge166 \
        --force \
        --autostart 

