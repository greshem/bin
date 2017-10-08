#!/usr/bin/perl
foreach (<DATA>)
{
	print $_;
}
__DATA__

########################################################################
#./dev-python/carbon/carbon-0.9.15
#./dev-python/django-tagging/django-tagging-0.4
#./app-admin/collectd/collectd-5.6.1
#./app-admin/diamond/Diamond-4.0
#./net-analyzer/graphite-web/graphite-web-0.9.13



########################################################################
pip install  --upgrade   --trusted-host  pypi.douban.com  -i http://pypi.douban.com/simple/   diamond

#diamond
pip install  graphite-web
pip install  carbon
pip install  whisper
pip install  django-tagging
pip install  service_identity


cd /opt/graphite/bin/
./carbon-cache.py
./carbon-cache.py   start

cp /opt/graphite/conf/carbon.conf.example  /opt/graphite/conf/carbon.conf
./carbon-cache.py   start

cp /opt/graphite/conf/storage-schemas.conf.example  /opt/graphite/conf/storage-schemas.conf
./carbon-cache.py   start


#==========================================================================
#检查端口是否开启了
lsof -i:2003 

#==========================================================================
cd /opt/graphite/webapp/graphite
python  manage.py migrate

#==========================================================================
python manager.py runserver 0:33344


#==========================================================================
#数据源
1. python /opt/graphite/examples/ example-client.py
2. diamond  默认的配置文件 就已经有了.

