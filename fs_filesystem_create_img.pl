#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__
udf
adfs
affs 	;没有工具包
afs		;有个工具	
btrfs 	;  yum install  btrfs
befs	;no
bfs		;
cifs|smbfs	; cifs-utils
cramfs	; yum install util-linux-ng
debugfs ;
devfs	; yum install udev
devpts 	;
efs		;
ext2	; yum install e2fsprogs
ext3	; yum install e2fsprogs
fat		;
freevxfs;
hfs		;
hfsplus	; yum install hfsplus-tools
hostfs	;
hpfs	;
hppfs	;
hugetblfs; 
isofs	; yum install genisoimage
jbd		;
jffs	; yum install  mtd-utils
jffs2	;
jfs		; yum install jfsutils*
minix	;
msdos	; mtools 
ncpfs	;   yum install ncpfs
nfs		;  yum install nfs-utils
ntfs	; yum install ntfs-3g
openpromfs	;
proc	;
qnx4	;
ramfs	;
reiserfs;  yum install reiserfs-utils
romfs	;  yum install genromfs
smbfs	;
squashfs; 	squashfs-tools
sysfs	; sysfsutils
sysv	;
udf		; udftools
ufs		;	no
vfat	;
xfs		;	yum install xfs*

########################################################################
#分布式文件系统
coda  ; yum install coda*
moosefs ;
afs 	
Glusterfs ;yum install glusterfs
openafs/coda
lustre
pvfs2
Ocfs2	; yum install ocfs2-tools


