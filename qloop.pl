#!/usr/bin/perl
use strict;

my $IMG=shift or die("Usage: $0 intput_iso \n");


my $dest="dir";
if( ! -d $dest)
{
	mkdir($dest);
}

my @array=`find dir/`;

if(scalar(@array) > 2)
{
	$dest="dir2";
}
if( ! -d $dest)
{
	mkdir($dest);
}

for $each qw( iso9660 ext3  cramfs   vfat squashfs romfs  )
{
	print  "mount -t $each $IMG $dest -o loop   \n"
	system("mount -t $each $IMG $dest -o loop   \n");
}

