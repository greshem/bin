#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__
########################################################################
#iso_search_file.pl aoe root client �����ҵ�֮ǰ����Ŀ. 2009 ��Ķ�����.
modprobe aoe
modprobe aoe aoe_iflist="eth0 eth1"
mkdir /dev/etherd
aoe-interfaces eth0
aoe-discover
aoe-stat
mke2fs /dev/etherd/e1.1
mkdir /mnt/e1.1
mount /dev/etherd/e1.1 /mnt/e1.1
aoe-revalidate e1.1


########################################################################
#�����һЩ���趼���ϰ汾������
#�°汾 ls /dev/etherd/ �����豸�Ļ���ȥ���� 
֮��Ŀ��豸���÷� ��  mount_img_usage.pl ������һ����.

