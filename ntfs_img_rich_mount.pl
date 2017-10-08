#!/usr/bin/perl

for(glob("*.IMG"))
{
	deal_with_img($_);
}
for(glob("*.img"))
{
	deal_with_img($_);
}


sub deal_with_img($)
{
	(my $line)=@_;
	($name,$suffix)=($line=~/(.*)\.(.*)/i);	
	
	print <<EOF
#=================================================================================
	mkdir /mnt/$name
	mkdir /mnt/$name
mount -t ntfs-3g  -o loop,offset=\$((64*512)) $name.$suffix 		/mnt/$name
mount -t ntfs-3g  -o loop,offset=\$((63*512)) $name.$suffix	/mnt/$name
EOF
;	

}

__DATA__
mkdir /mnt/richdisk
mkdir /mnt/hhhhdisk
mount -t ntfs-3g  -o loop,offset=$((64*512))  		richdisk.IMG 		/mnt/richdisk
mount -t ntfs-3g  -o loop,offset=$((64*512))  	hhhhdisk.IMG   		/mnt/hhhhdisk


