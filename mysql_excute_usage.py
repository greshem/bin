#!/usr/bin/python
DATA="""
mysql -proot     -e "use mysql; UPDATE user SET password=PASSWORD('password') WHERE user='root';   flush privileges; "
 mysql -ppassword -e "use mysql; UPDATE user SET password=PASSWORD('root') WHERE user='root';   flush privileges; "


mysql -u root -ppassword -h 192.168.30.210 -e "CREATE DATABASE keystone default character set utf8;"
mysql -u root -ppassword -h 192.168.30.210 -e "GRANT ALL ON keystone.* TO 'keystone'@'localhost' IDENTIFIED BY 'keystone';"
mysql -u root -ppassword -h 192.168.30.210 -e "GRANT ALL ON keystone.* TO 'keystone'@'%' IDENTIFIED BY 'keystone';



"""
print DATA;
