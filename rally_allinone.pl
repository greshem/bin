#!/usr/bin/perl
foreach (<DATA>)
{
    print $_;
}
__DATA__

yum install libffi* gcc gcc-c++
yum install python-devel   openssl-devel

cd ~
virtualenv   /root/venv/rally 

git clone http://git.openstack.org//openstack/rally/


source /root/venv/rally/bin/activate 

#pip install rally 
pip install   --trusted-host  pypi.douban.com  -i http://pypi.douban.com/simple/    rally 

source  /root/venv/rally/etc/bash_completion.d/rally.bash_completion 

rally-manage db recreate

#==========================================================================
source ~/keystonerc_admin
source  /root/keystonerc_admin 

rally deployment   create  --name  a   --fromenv #推荐这种方式.
#rally deployment create --filename=existing.json --name=existing  #废弃掉.
rally deployment list
rally deployment check

#--------------------------------------------------------------------------
#所有的case 跑起来.
for each in $( find ~/rally/samples/tasks/scenarios/ |grep json$ )
do
rally  task  start   $each 
done

#==========================================================================
#result
rally task list  > tmp
rally task report  --tasks $( awk -F\   '{print $2}'   tmp |grep -v uuid ) > allinone.html

#url 替换成如下的地方 否则 页面不会渲染的:
"https://cdn.bootcss.com/angular.js/1.3.3/angular.min.js"
