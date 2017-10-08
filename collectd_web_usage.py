#!/usr/bin/python
DATA="""
########################################################################
#界面启动.
cd  /root/bin_ext/collectd/collectd-web
python runserver.py   0.0.0.0 8888



#==========================================================================
git clone https://github.com/httpdss/collectd-web.git


#参看源码: /root/collectd-web/cgi-bin/collection.modified.cgi
    sub read_config {
        的datadir字段的解析:
        配置文件一律是  key:value  有冒号的方式:

cat >>  /etc/collection2.conf <<EOF
datadir:"/var/lib/collectd/rrd/"
EOF

python runserver.py   0.0.0.0 8888

"""
print DATA;
