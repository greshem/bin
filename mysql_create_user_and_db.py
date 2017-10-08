
#!/usr/bin/python
DATA="""

#centos7.3 下 执行成功.
#centos7.1.  不能成功.
mysql -u root -ppassword -e "CREATE DATABASE keystone2 default character set utf8;"
mysql -u root -ppassword -e "GRANT ALL ON keystone2.* TO 'keystone2'@'localhost' IDENTIFIED BY '123456';"
mysql -u root -ppassword -e "GRANT ALL ON keystone2.* TO 'keystone2'@'%' IDENTIFIED BY '123456';"


"""
print DATA;
