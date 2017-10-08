#!/usr/bin/perl
foreach (<DATA>)
{
	print $_;
}
__DATA__

mkdir /cgroup/blkio/
mount -t cgroup -o blkio non /cgroup/blkio

cgcreate  -g blkio:/backup


#8:0 链接  写法 
ll /dev/block/
253:0  253:2  67:32  67:48  67:50  67:65  67:80  67:82  67:97  7:1    7:3    8:1    8:3    8:6    8:8    8:97   
253:1  253:3  67:33  67:49  67:64  67:66  67:81  67:96  7:0    7:2    8:0    8:2    8:5    8:7    8:96   

cgset  -r   blkio.throttle.read_iops_device="8:0 16000"  backup
cgset  -r   blkio.throttle.write_iops_device="8:0 16000" backup


#20M 读写. 
cgset  -r   blkio.throttle.read_iops_device="8:0 100"  backup
cgset  -r   blkio.throttle.write_iops_device="8:0 100" backup

#mv 进程 
echo 19909 >> /cgroup/blkio/backup/tasks 
cat /proc/19909/cgroup 


