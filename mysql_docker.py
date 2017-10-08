docker pull mysql
docker run -v /data/var/mysql/:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=kS4pJUIb mysql

#docker stop [CONTAINER ID]
docker run -it -v /data/var/mysql/:/var/lib/mysql mysql /bin/bash

#mysqld_safe&
grant all privileges on *.* to 'wuxiao'@'%' identified by 'password';

docker cp [CONTAINER ID]:/etc/mysql/my.cnf /data/local/my.cnf

docker run -d -p 3306:3306 -v /data/var/mysql/:/var/lib/mysql -v /data/local/my.cnf:/etc/mysql/my.cnf mysql

#add [CMD] to  /etc/rc.local
