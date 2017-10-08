#!/usr/bin/perl
foreach (<DATA>)
{
	print $_;
}
__DATA__

wget http://192.168.1.11/linux_src/phpmyadmin.tar.gz -O /var/www/html/phpmyadmin.tar.gz 

yum install php-mbstring  php-mysql 
service httpd restart 


