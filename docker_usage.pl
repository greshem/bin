#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__
#  docker -d -H unix:///var/run/docker.sock

#镜像列表 
docker search   ceph 

#下载镜像: 
docker pull  fedora
docker run -i -t fedora  /bin/bash

docker pull  centos
docker run -i -t centos  /bin/bash

docker pull  ubuntu 
docker run -i -t ubuntu   /bin/bash

#docker   ps  

docker export       befa4bab3a07 > /tmp/bbb.tar 

docker import    http://localhost/bbb.tar    ubuntu_wget  new_version 


#server 
docker run -p 3307:3306 -v /home/data/var/mysql/:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=tgbygv mysql
#client 
mysql -P 3307  -h 127.0.0.1 -p 

#
docker  exec -it    $CONTAINER_ID /bin/bash

