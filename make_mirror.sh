#!/bin/sh
mkdir /tmp5/
touch /.qianlong
chkconfig kudzu off
cat /etc/dhcpd.conf > /etc/dhcpd.conf.bak
cat /dev/null > /etc/dhcpd.conf

tar -cjvf /tmp5/as4.6.tar.bz2   /bin   /tftpboot  /cache /etc /home /lib /media /misc /mnt /net  /opt /root /sbin  /tmp /usr  /var  /splash_boot /boot /.qianlong
rm -f /.qianlong
cat /etc/dhcpd.conf.bak > /etc/dhcpd.conf
