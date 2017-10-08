#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__

easy_install  django 
yum  install  django 

django-admin.py startproject helloworld
cd helloworld

python manage.py runserver 0.0.0.0:8080

python manage.py startapp  bbbb

#append my url  
#_pre_cache_greshem\_pre_cache_2016_03\django_helloworld_diff_文件.txt
# :  django_helloworld_diff  txt 


#create admin  and password 
 python manage.py  syncdb

#=================================
#syslcoud 
git clone  ssh://root@mail.emotibot.com.cn:6787/home/git_linux_src/horizon_syscloud /root/horizon_syscloud/ 

cp  /root/horizon_syscloud/openstack_dashboard/locale/zh_CN/LC_MESSAGES/django.po /usr/share/openstack-dashboard/openstack_dashboard/locale/zh_CN/LC_MESSAGES/django.po

sed -i  's/云主机/作业/g'  /usr/share/openstack-dashboard/openstack_dashboard/locale/zh_CN/LC_MESSAGES/django.po

cd  /usr/share/openstack-dashboard/openstack_dashboard/
django-admin  makemessages -l zh_CN
django-admin  compilemessages

service httpd restart 
