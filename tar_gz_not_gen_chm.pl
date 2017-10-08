#!/usr/bin/perl
#
sub load_hash_from_file($)
{
	(my $input_file)=@_;
	my %hash ;
	open(INPUT, $input_file) or die("open file error  $input_file\n");
	for(<INPUT>)
	{
		my @array=split(/-\>/, $_);
		#print $array[0]."-> $array[1]\n";
		my $key=$array[0];
		my $value=$array[1];
		$key=~s/^\s+//g;
		$key=~s/\s+$//g;
		$value=~s/^\s+//g;
		$value=~s/\s+$//g;
		$hash{$key}=$value;
	}

	return %hash;	
}

sub get_tar_file($)
{
	(my $all_file)=@_;

	my %tar;
	my $key;
	for $key (keys(%{$all_file}))
	{
		if($key=~/\.tar\./)
		{
			#print $key."\n";
			$tar{$key}=$all_file{$key};
		}
	}
	return  %tar;
}


my %all_file=load_hash_from_file("dupkiller.log");
my %tar = get_tar_file(\%all_file);

#print %tar;
my $key;
for $key (keys(%tar))
{
	my $org_key=$key;
	$key=~s/tar.gz$//;
	$key=~s/tar$//;
	$key=~s/tar.bz2$//;
	my $chm= $key."chm";
	if(defined($all_file{$chm}))
	{
		print "OK  ".$key."have chm file  $all_file{$chm}  \n";
	}
	else
	{
		print "Error  $org_key \n";
	}
}
