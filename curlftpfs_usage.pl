#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__

curlftpfs  ftp://root:qi************3@192.168.1.12 /mnt/ftp -o ro #ֻ������, ֻ��ֻ������. 


mkdir /mnt/iso_p
curlftpfs ftp://isodownload:123456@192.168.1.12 /mnt/iso_p/
