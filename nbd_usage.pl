#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__

#���������ļ�, д�������·��
mkdir /etc/nbd-server/
cat >  /etc/nbd-server/config <<EOF
[generic]
[export]
        exportname = /var/lib/libvirt/images/f8.img
        port = 11111
EOF


nbd-server 

modprobe nbd  #Ȼ�����/dev/ndb* ���ֺܶ���豸.

nbd-client 
nbd-client  192.168.1.73  10809  /dev/nbd0            


qemu-nbd -c /dev/nbd0 $name.img  #connnect   ����
qemu-nbd -d /dev/nbd0 			 #disconnect  �Ͽ�
