#!/usr/bin/perl	
for(glob("*.iso"))
{
	deal_with_iso($_);
}


sub deal_with_iso($)
{
	(my $line)=@_;
	($name)=($line=~/(.*).iso/);
	if($^O =~/linux/i)
	{
		if(! -d $name)
		{
			print "mkdir /mnt/$name \n";
		}

		print "mount -t iso9660 $_ /mnt/$name -o loop \n";
		print "mkdir ${name}_rw/ \n";
		print "mkdir ${name}_w/ \n";
		print " mhddfs  /mnt/$name  ${name}_w  ${name}_rw \n";

	}
	else
	{
		#"batchmnt.exe dos_0.iso p"
		#print "batchmnt.exe $line	 p\n";
	}
}
