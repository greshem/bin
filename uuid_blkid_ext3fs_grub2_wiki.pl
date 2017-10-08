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




uuidgen会返回一个合法的uuid，结合tune2fs可以新生成一个uuid并写入ext2,3,4分区中：

比如新建或改变sda5的uuid（需要root权限）
uuidgen | xargs tune2fs /dev/sda5 -U

也可以在fstab中找到原uuid并写回分区，例如
tune2fs -U c1b9d5a2-f162-11cf-9ece-0020afc76f16 /dev/sda5

reiserfs 用 reiserfstune，jfs 用 jfs_tune，xfs 用 xfs_admin，具体请man。
修过 fat/ntfs 的 uuid 则需要微软的工具
