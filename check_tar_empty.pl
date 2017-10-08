#!/usr/bin/perl

my $file=shift or die("Usage: $0  input_file \n");


system("tar -tzf $file   |wc -l |grep ^1\$ ");
if($?>>8 ne 0)
{
    print (" $file  ²»Îª¿Õ\n");
}
else
{
    	print ("$file  Îª¿Õ\n");
	logger("$file #EMPTY \n");
}


sub logger($)
{
	(my $log_str)=@_;
	open(FILE, ">> /tmp/gentoo_empty.log") or warn("open all.log error\n");
	print FILE $log_str;
	close(FILE);
}

