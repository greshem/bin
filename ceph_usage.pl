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

9. ��������
rbd snap create <poolname/imagename@snapshotname>
�� rbd snap create testpool/testimg@snap1 ��ʾ�� testpool/testimg ���������һ������ snap1 �Ŀ���

10. ���� ����/ȥ������
rbd snap protect <poolname/imagename@snapshotname> #�������գ�ֻ���ڱ���״̬�µĿ��ղſ���������¡���µľ���
rbd snap unprotect <poolname/imagename@snapshotname> #ֻ���ڷǱ���״̬�µĿ��գ��ſ���ɾ��

11. ɾ��һ������
rbd snap rm <poolname/imagename@snapshotname>

12. ��ĳ������ع���ĳ������ʱ��״̬
rbd snap rollback <poolname/imagename@snapshotname>

13. ��һ�������ȫ�����ն�ɾ��
rbd snap purge <poolname/imagename>

14. �г�ĳ����������Щ����
rbd snap ls <poolname/imagename>

15.��ʽת��
qemu-img convert -f vpc tedt.vhd -O raw rbd:<VM����>/disk1

16.���¡Ӳ��
rbd flatten <poolname/imagename>

17. ceph osd lspools # list pools 
18. ceph osd pool create pool1024  1024
ceph osd pool stats pool1024
