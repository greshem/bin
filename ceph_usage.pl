#!/usr/bin/perl
foreach (<DATA>)
{
	print $_;
}
__DATA__
#=============
rbd create newDiskVol --size 40960 
rbd list
rbd map newDiskVol  --pool rbd --name client.admin
rbd unmap   /dev/rbd0 

#=============
rbd rm  poolname/imagename 
rbd resize  poolname/imagename 
rbd cp    srcpool/imagename  destpool/destname 

rbd import 
rbd export  srcpool/srcimg  destpath 
rbd clone   poolname/imagename  newpool/imagename
rbd snap    create  poolname/imgname@snapshotname 
rbd snap create testpool/testimg@snap1 

9. 建立快照
rbd snap create <poolname/imagename@snapshotname>
如 rbd snap create testpool/testimg@snap1 表示给 testpool/testimg 这个镜像建立一个名叫 snap1 的快照

10. 快照 保护/去掉保护
rbd snap protect <poolname/imagename@snapshotname> #保护快照，只有在保护状态下的快照才可以用来克隆出新的镜像
rbd snap unprotect <poolname/imagename@snapshotname> #只有在非保护状态下的快照，才可以删除

11. 删除一个快照
rbd snap rm <poolname/imagename@snapshotname>

12. 将某个镜像回滚到某个快照时的状态
rbd snap rollback <poolname/imagename@snapshotname>

13. 将一个镜像的全部快照都删除
rbd snap purge <poolname/imagename>

14. 列出某个镜像有哪些快照
rbd snap ls <poolname/imagename>

15.格式转换
qemu-img convert -f vpc tedt.vhd -O raw rbd:<VM名字>/disk1

16.填补克隆硬盘
rbd flatten <poolname/imagename>

17. ceph osd lspools # list pools 
18. ceph osd pool create pool1024  1024
ceph osd pool stats pool1024
