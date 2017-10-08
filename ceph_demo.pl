#!/usr/bin/perl
foreach (<DATA>)
{
	print $_;
}
__DATA__

#这种方式 更简单一些
docker run -d --net=host -v /etc/ceph:/etc/ceph -e MON_IP=192.168.166.7 -e CEPH_PUBLIC_NETWORK=192.168.166.0/24 ceph/demo
#/etc/ceph 生成了配置文件了.  可以直接利用这个配置文件了.

CONTAINER_ID=`docker ps -a | grep ceph/demo | awk '{print $1}'`


#docker  exec -it    $CONTAINER_ID /bin/bash
#docker  exec -it    $CONTAINER_ID ceph -s 

#或者命令行的方式执行/或者放到docker 里面执行
rbd list
rbd create --image-format 2  test  -s 1024
rbd create --image-format 2  test  -s 32
rbd create --image-format 2  test2  -s 32
ceph -s 
rbd list
rbd copy test test3
rbd copy test test4
rbd copy test test6
rbd copy test test7

