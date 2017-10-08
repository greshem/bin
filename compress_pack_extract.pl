#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__
atool.noarch ÍÆ¼öÊ¹ÓÃ: 
yum search "hive"

decompression
packaging
unpacking
Compression
yum search  extract
archiver


#==========================================================================
tar+gzip (.tar.gz, .tgz)
tar+bzip (.tar.bz, .tbz)
tar+bzip2 (.tar.bz2, .tbz2)
tar+compress (.tar.Z, .tZ)
tar+lzop (.tar.lzo, .tzo)
tar+lzip (.tar.lz, .tlz)
tar+xz (.tar.xz, .txz)
tar+7z (.tar.7z, .t7z)
tar (.tar)
zip (.zip)
jar (.jar, .war)
rar (.rar)
lha (.lha, .lzh)
7z (.7z)
alzip (.alz)
ace (.ace)
ar (.a)
arj (.arj)
arc (.arc)
rpm (.rpm)
deb (.deb)
cab (.cab)
gzip (.gz)
bzip (.bz)
bzip2 (.bz2)
compress (.Z)
lzma (.lzma)
lzop (.lzo)
lzip (.lz)
xz (.xz)
rzip (.rz)
7zip (.7z)
lrzip (.lrz)
cpio (.cpio)




