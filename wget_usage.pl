#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__
wget -t 3 -T 3 --mirror -np --accept=tar.gz  http://ftp.gnu.org/gnu/grub/ #mirror filter  过滤器.
wget -t 3 -T 3 --mirror -np --accept=tar.gz ftp://ftp.heanet.ie/pub/download.sourceforge.net/pub/sourceforge/u/ud/udis86/udis86/


wget  --no-check-certificate https://wiki.openstack.org/wiki/Mellanox-Neutron-Havana-Redhat\#InfiniBand_Network 

#-w,  --wait=SECONDS            等待间隔为 SECONDS 秒。
wget --mirror -np http://www.richxr.com/en -w 5 

wget -e "http_proxy=http://gsx:3128/" http://www.google.com
wget -e "http_proxy=http://10.4.16.32:808/" http://www.google.com


wget --http-user=useradmin --http-passwd=de7ys  --save-cookie=dlink.cookie   http://192.168.1.1/login.html

#-r 递归.
wget  --mirror  -r -np  --accept=tar.gz ftp://ftp.bind.com/pub/bind9/  #匹配 regex match 

#ftp.gnu.org 
wget -t 3 -T 3 --mirror -np --accept=tar.gz http://ftp.gnu.org/gnu/fdisk/



wget -U "Mozilla/5.0 (Windows NT 6.1; WOW64; rv:22.0) Gecko/20100101 Firefox/22.0"  


#金苗网mp3 的下载
wget   --referer="http://www.jinmiao.cn/storys_list.php?big_type=116"  -U "Mozilla/5.0 (Windows NT 6.1; WOW64; rv:22.0) Gecko/20100101 Firefox/22.0"  --cookies=on --load-cookies=cookie.txt --keep-session-cookies --save-cookies=cookie.txt   www.jinmiao.cn/mp3file/02mingzhu/17/xila137wu.mp3 


#cookie 获取 


#oss4aix 
wget --accept=rpm  -r -np  http://www.oss4aix.org/download/latest/aix71/ 
wget -r -np  http://www.oss4aix.org/download/latest/aix71/ 
for each in $(cat www.oss4aix.org/list)
do
wget  --mirror   -np  http://www.oss4aix.org/download/latest/aix71/$each
done


#
wget --post-data="question=$q&answer=$a"   http://myemotibot.com/qa/question_modifyok.php

wget --post-data="id=100001740"   http://192.168.1.11/tree/wdTree/datafeed.php  
curl -d "id=0"    http://192.168.1.11/tree/wdTree/datafeed.php   |jq   #wget curl  

wget -c -r -np --reject=html,gif,A,D -nH   http://mirrors.163.com/centos/7.2.1511/extras/x86_64/  #kilo  openstack  repo 

