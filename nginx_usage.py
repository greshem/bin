#!/usr/bin/python
#coding=utf-8

DATA="""
yum install nginx 

#==========================================================================
#默认 /usr/share/nginx/ 目录:
/etc/nginx/nginx.conf
 server {
        listen       8888;
        location / {
            root   /tmp/;
            index  index.html index.htm;
            autoindex on;  
            autoindex_localtime on; 
        }
}

#==========================================================================
#

"""
print DATA;
