#!/usr/bin/perl
foreach (<DATA>)
{
    print $_;
}
__DATA__
    
systemctl restart etcd
vim /etc/etcd/etcd.conf 
lsof -i:2380
etcd-server     2380/tcp                # etcd server to server communication
etcd-client     2379/tcp                # etcd client communication


etcdctl ls / --recursive
etcdctl mkdir /demo
etcdctl ls / --recursive
etcdctl mk /demo/hello "Hello Etcd"

etcdctl ls / --recursive
etcdctl get /demo/hello
etcdctl update /demo/hello "Hello CoreOS"
etcdctl get /demo/hello

#执行update 就会返回 
etcdctl watch  /demo/hello
etcdctl watch --recursive /
etcdctl update /demo/hello "Hello CoreO2"

