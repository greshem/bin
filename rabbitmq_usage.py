
#!/usr/bin/python
DATA="""

二、用户相关 
要使用RabbitMQ，请先添加用户。默认情况下，只有guest用户存在，只能连接localhost。 
1、新增用户

# rabbitmqctl add_user [user] [password]
# rabbitmqctl add_user wuyeliang password 
Creating user "wuyeliang" ...
...done.


2、查看用户

# rabbitmqctl list_users 
Listing users ...
guest [administrator]
wuyeliang []
...done.


3、修改用户密码

# rabbitmqctl change_password wuyeliang strongpassword 
Changing password for user "wuyeliang" ...
...done.


4、赋予管理员权限

# rabbitmqctl set_user_tags serverworld administrator
Setting tags for user "wuyeliang" to [administrator] ...
...done.

5、删除用户

# rabbitmqctl delete_user wuyeliang 
Deleting user "wuyeliang" ...
...done.

三、虚拟主机相关 
1、新增虚拟主机

# rabbitmqctl add_vhost [vhost]
# rabbitmqctl add_vhost /my_vhost 
Creating vhost "/my_vhost" ...
...done.


2、查看虚拟主机

# rabbitmqctl list_vhosts 
Listing vhosts ...
/
/my_vhost
...done.


3、删除虚拟主机

rabbitmqctl delete_vhost /my_vhost 
#Deleting vhost "/my_vhost" ...
#...done.


四、关联用户到虚拟主机 
1、关联 
格式如下：

# rabbitmqctl set_permissions [-p vhost] [user] [permission ⇒ (modify) (write) (read)]
# rabbitmqctl set_permissions -p /my_vhost wuyeliang ".*" ".*" ".*" 
Setting permissions for user "wuyeliang" in vhost "/my_vhost" ...
...done.


2、查看权限

rabbitmqctl list_permissions -p /my_vhost 
#Listing permissions in vhost "/my_vhost" ...
#wuyeliang     .*      .*      .*
#...done.


#3、查看用户权限
# rabbitmqctl list_user_permissions wuyeliang 
Listing permissions for user "wuyeliang" ...
/my_vhost       .*      .*      .*
...done.


4、删除用户权限

# rabbitmqctl clear_permissions -p /my_vhost wuyeliang 
Clearing permissions for user "wuyeliang" in vhost "/my_vhost" ...
...done.
"""
print DATA;
