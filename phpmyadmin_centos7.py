#!/usr/bin/python
DATA="""
yum install phpmyadmin 
mv /usr/share/phpMyAdmin/  /var/www/html/mysql

#curl http://127.0.0.1/mysql/

cd /var/www/html/mysql 

yum install  php-mysql 
yum install  php-mbstring
yum install php-php-gettext
#epel 是否开启 看一下 

#本机端口就可以访问 33333 端口
php -S    0:33333 


"""
print DATA;
