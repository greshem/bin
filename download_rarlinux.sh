#!/bin/bash
wget http://www.rarlab.com/download.htm  -O /tmp/rar_download.html
url=$(/bin/linkextractor.pl /tmp/rar_download.html   http://www.rarlab.com/ |grep rarlinux)

#wget http://www.rarlab.com/rar_CN/rarlinux-3.9.3.tar.gz
cd /tmp/
for each in  $url
do
echo wget $each
wget $each

done
