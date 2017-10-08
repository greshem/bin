#!/usr/bin/python 

print """
wget  http://mirrors.aliyun.com/linux-kernel/v4.x/linux-4.9.tar.gz

wget https://cdn.kernel.org/pub/linux/kernel/v4.x/linux-4.6.tar.xz
wget https://cdn.kernel.org/pub/linux/kernel/v4.x/linux-4.8.12.tar.gz
scp 192.168.1.11:/var/www/html/linux_src/linux-4.6.tar.xz ./
wget  192.168.1.11/linux_src/linux-4.6.tar.xz 

""";
