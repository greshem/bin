#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__

cd /root/

dd if=/dev/cdrom of=/dev/null  count=1024 bs=1k    

qloop.sh /dev/cdrom  

cp -a -r dir  dir2

cd dir2 

mv $(find -type f |grep cpt$ ) ./

echo "q**************n" > key 
chmod 777 -R . 
ccdecrypt  -k  key  *.cpt

/bin/extract_all_tar.pl  |sh 

umount /root/dir/
umount /root/dir/
umount /root/dir/
eject 

