#!/usr/bin/perl
foreach (<DATA>)
{
	print $_;
}
__DATA__
mysql -p passwd 

show databases;
show tables;

#������û�.f18 ֮ǰ�İ汾.
INSERT INTO `user` ( `Host` , `User` , `Password` , `Select_priv` , `Insert_priv` , `Update_priv` , `Delete_priv` , `Create_priv` , `Drop_priv` , `Reload_priv` , `Shutdown_priv` , `Process_priv` , `File_priv` , `Grant_priv` , `References_priv` , `Index_priv` , `Alter_priv` , `Show_db_priv` , `Super_priv` , `Create_tmp_table_priv` , `Lock_tables_priv` , `Execute_priv` , `Repl_slave_priv` , `Repl_client_priv` , `Create_view_priv` , `Show_view_priv` , `Create_routine_priv` , `Alter_routine_priv` , `Create_user_priv` , `ssl_type` , `ssl_cipher` , `x509_issuer` , `x509_subject` , `max_questions` , `max_updates` , `max_connections` , `max_user_connections` )
VALUES (
'192.168.1.74', 'root', PASSWORD( 'q**************n' ) , 'Y', 'Y', 'Y', 'Y', 'Y', 'Y', 'Y', 'Y', 'Y', 'Y', 'Y', 'Y', 'Y', 'Y', 'Y', 'Y', 'Y', 'Y', 'Y', 'Y', 'Y', 'Y', 'Y', 'Y', 'Y', 'Y', '', '', '', '', '0', '0', '0', '0'
);

ע�� /etc/hosts �Ľ���  ���߰� 192.168.1.74 Ҳ��ӽ�ȥ.

��1.74 ���� ���ӵ�ʱ��, Ҫ���������.
mysql -h 192.168.1.73 -u root -p

#����Ĭ�ϵĿ�����
/usr/bin/mysqladmin -u root password 'q**************n'

#==========================================================================
#f18  mysql   (5.5.30)
INSERT INTO USER ( Host, USER, Password, Select_priv, Insert_priv, Update_priv, Delete_priv, Create_priv, Drop_priv, Reload_priv, Shutdown_priv, Process_priv, File_priv, Grant_priv, References_priv, Index_priv, Alter_priv, Show_db_priv, Super_priv, Create_tmp_table_priv, Lock_tables_priv, Execute_priv, Repl_slave_priv, Repl_client_priv, Create_view_priv, Show_view_priv, Create_routine_priv, Alter_routine_priv, Create_user_priv, Event_priv, Trigger_priv, Create_tablespace_priv, ssl_type, ssl_cipher, x509_issuer, x509_subject, max_questions, max_updates, max_connections, max_user_connections, plugin, authentication_string) VALUES ( '127.0.0.1', 'root', '*AA057D86ECB5A367EA6A4A30882DB15E1FA75E39', 'Y', 'Y', 'Y', 'Y', 'Y', 'Y', 'Y', 'Y', 'Y', 'Y', 'Y', 'Y', 'Y', 'Y', 'Y', 'Y', 'Y', 'Y', 'Y', 'Y', 'Y', 'Y', 'Y', 'Y', 'Y', 'Y', 'Y', 'Y', 'Y', '', '', '', '', 0, 0, 0, 0, '', '')


#�򵥵Ĳ����û�. 
use mysql;
insert into user values ('localhost', 'opencmsuser', password('XXXXX'),\
   'N','N','N','N','N','N','N','N','N','N','N','N','N','N');
insert into db values ('localhost', 'opencms', 'opencmsuser',\
   'Y','Y','Y','Y','Y','Y','Y','Y','Y','Y');
flush privileges;
/usr/bin/mysqld_safe --skip-grant-tables

mysql -u root mysql -e "delete from user where User = '';"
mysql -u root mysql -e "update user set host='%' where host='::1';"

mysql -u root -ppassword -e "CREATE DATABASE keystone default character set utf8;"
mysql -u root -ppassword -e "GRANT ALL ON keystone.* TO 'keystone'@'localhost' IDENTIFIED BY '$KEYSTONE_DB_PASSWD';"
mysql -u root -ppassword -e "GRANT ALL ON keystone.* TO 'keystone'@'%' IDENTIFIED BY '$KEYSTONE_DB_PASSWD';"

