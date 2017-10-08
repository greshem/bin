#!/usr/bin/perl
foreach (<DATA>)
{
    print $_;
}
__DATA__
    
docker run --name some-mysql -e MYSQL_ROOT_PASSWORD=password  -d mysql:5.5 

#ip port
docker  run -D -p3306:3307  -v /mysql/data:/var/lib/mysql       docker.io/mysql:5.5            


#--------------------------------------------------------------------------
##case 2  link 
docker run --name some-mysql -e MYSQL_ROOT_PASSWORD=password  -d mysql:5.5 
docker run --name some-mediawiki --link some-mysql:mysql  -e MEDIAWIKI_DB_USER=root -e MEDIAWIKI_DB_PASSWORD=password   -d synctree/mediawiki


#--------------------------------------------------------------------------
#case 3 server 
docker run -name mysql_db_server  -p 3307:3306 -v /home/data/var/mysql/:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=tgbygv mysql
##client 
#mysql -P 3307  -h 127.0.0.1 -p 
#
#

#--------------------------------------------------------------------------
#phpmyadmin  link  phpmyadmin 
docker run -name mysql_db_server  -p 3307:3306 -v /home/data/var/mysql/:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=tgbygv mysql
docker run --name myadmin -d --link mysql_db_server:db -p 8080:80 phpmyadmin/phpmyadmin

