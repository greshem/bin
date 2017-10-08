#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__

#创建配置文件, 写好里面的路径
mkdir /etc/nbd-server/
cat >  /etc/nbd-server/config <<EOF
[generic]
[export]
        exportname = /var/lib/libvirt/images/f8.img
        port = 11111
EOF


nbd-server 

modprobe nbd  #然后会在/dev/ndb* 出现很多个设备.

nbd-client 
nbd-client  192.168.1.73  10809  /dev/nbd0            


qemu-nbd -c /dev/nbd0 $name.img  #connnect   连接
qemu-nbd -d /dev/nbd0 			 #disconnect  断开
