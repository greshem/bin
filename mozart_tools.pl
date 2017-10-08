#!/usr/bin/perl
sub rename_files()
{
	my @files=grep{-f}glob("*.ape");
	my @tmps=grep{-f}glob("*.cue");
	push(@files, @tmps);

	for (@files)
	{
		if($_=~/(volume.\d)/)
		{
			my $VOL=$1;
			mkdir($VOL);
			#print "mv \"$_\"   $VOL \n";
			print "move \"$_\"  $VOL \n";
		}
	}

}

#shntool split -t "%n.%p-%t" -f 1.cue -o flac 1.ape  -d "output_dir/"    


sub split_files()
{
	mkdir("output_dir");
	my @files=grep{-f}glob("*.ape");
	
	my $count=0;
	my $prefix="./";
	#my $prefix="/media/sda1/";
	for(@files)
	{
		mkdir("$prefix/output_dir/$count");
		my $cue=$_;
		$cue=~s/ape$/cue/g;
		print <<EOF
		mkdir $prefix/output_dir/$count -p 
shntool split -t "%n.%p-%t" -f "$cue" -o flac "$_"  -d "$prefix/output_dir/$count"    

EOF
;
		if($_=~/.*(CD\d+).*/)
		{
			print "mv output_dir/$count  output_dir/$1 \n";
		}
		$count++;
		
	}
	

}

split_files();
