#!/usr/bin/perl
foreach (<DATA>)
{
	print $_;
}
__DATA__
#==========================================================================
docker pull    docker.io/phpmyadmin/phpmyadmin    

#==========================================================================
#通过 这个 8080的端口 访问本机的 mysql 服务器了.
docker run --name myadmin -d -e PMA_HOST=localhost -p 8080:80 phpmyadmin/phpmyadmin
docker run --name myadmin -d -e PMA_HOST=192.168.1.5 -p 8080:80 phpmyadmin/phpmyadmin

#==========================================================================
mysql server 
update user set host='%' where user='root' and host='localhost';
1. 假如还是不能连接上  把 还有一条的root 记录删除掉, 
2. delete from   user where  Host="localhost" and  User="root"

