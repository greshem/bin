#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__

pip  install --trusted-host  mirrors.aliyun.com   -r requirements.txt 

pip  install routes -i http://192.168.1.48:8888/pypi/    #不可行的问题 用 https 也可以解决掉 


cat  ~/.pip/pip.conf <<EOF
[global]
index-url = http://pypi.douban.com/simple
trusted-host = pypi.douban.com
EOF


#==========================================================================
#douban install 
pip install   --trusted-host  pypi.douban.com  -i http://pypi.douban.com/simple/     -r  requirements.txt 
