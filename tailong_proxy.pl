!/usr/bin/perl

#2011_02_25_10:42:50   ÐÇÆÚÎå   add by greshem
foreach (<DATA>)
{
        print $_;
}
__DATA__
#proxy server  3proxy 
#2016_11 最新的地址是: 
10.4.16.32:1888

#wget 
wget -e "http_proxy=http://10.4.16.32:808/" http://www.sohu.com
curl -x 10.4.16.32:808 www.sohu.com


#git  ssh 
#connect
cat >> /etc/ssh/ssh_config <<EOF
ProxyCommand connect -H 10.4.16.32:808  %h %p
EOF


#git http 


#yum repo 
# /etc/yum.conf 
# append :  
proxy=http://10.4.16.32:808 #OK 

#pip 
pip  --proxy http://10.4.16.32:808  install  psutil
