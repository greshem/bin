#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__
#1.
blkid  /dev/sda1
/dev/sda1: LABEL="PQSERVICE" UUID="DA4490AD44908DBF" TYPE="ntfs" 

blkid  /dev/sda5 
/dev/sda5: UUID="7b89e326-450c-4bc9-8fba-8fe2f7b39769" TYPE="ext4" 


#2.
ls -l /dev/disk/by-uuid/

#3. 
vol_id

#4. 
/root/random_things_v3/uuid_random.pl




uuidgen�᷵��һ���Ϸ���uuid�����tune2fs����������һ��uuid��д��ext2,3,4�����У�

�����½���ı�sda5��uuid����ҪrootȨ�ޣ�
uuidgen | xargs tune2fs /dev/sda5 -U

Ҳ������fstab���ҵ�ԭuuid��д�ط���������
tune2fs -U c1b9d5a2-f162-11cf-9ece-0020afc76f16 /dev/sda5

reiserfs �� reiserfstune��jfs �� jfs_tune��xfs �� xfs_admin��������man��
�޹� fat/ntfs �� uuid ����Ҫ΢��Ĺ���
