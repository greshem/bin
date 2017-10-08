#!/usr/bin/perl


our $g_manifest=get_manifest();
wget_src_url();




#######################################################################
sub get_manifest()
{
	if(-f "manifest")
	{
		return  "manifest";
	}

	if(-f "Manifest")
	{
		return  "Manifest";
	}
	return  "Manifest";
}

sub get_src_code_file_size($)
{
	(my $input_file)=@_;
	my $size=undef;
	open(FILE, "$g_manifest") or die("open $g_manifest error \n");
	for(<FILE>)
	{
		if($_=~/\s+$input_file\s+(\d+)\s+/)
		{
			$size=$1;	
		}	
	}
	return $size; 
}

sub wget_src_url()
{
	(my $name)=@_; 
	my $dist="http://mirrors.163.com/gentoo/distfiles/";
	if(! -f "$g_manifest")
	{
		die("ERROR: $g_manifest not exists,  not in  gentoo   portage package  dir   \n");
	}

	open(PIPE,  "grep  DIST $g_manifest | awk '{print \$2}' |  ") or die(" open  $g_manifest error \n");
	for(<PIPE>)
	{
		chomp($_);
		#logger_download $_."\n";

		$size= get_src_code_file_size($_);
		logger_download ("$_ Size is $size \n");
		if($size> 50*1024*1024)
		{
			warn("INFO: size large than  50M , skip \n");
            #next;
		}

		if(!  -f $_ &&  ! -f  "/tmp3/linux_src/".$_ )
		{
			logger_download  ("wget  $dist/$_\n");
			print(" wget  $dist/$_\n");
			system("echo wget  $dist/$_");
			if( $?>>8  ne  0 )
			{
				logger_download( "ERROR:  $dist/$_  , wget ³ö´í   \n");
			}


		}
		else
		{
			logger_download ("# $_ exists in /tmp3/linux_src/ or cur dir  \n");
		}
	}
}


sub logger_download($)
{
	(my $log_str)=@_;
	open(FILE, ">> /tmp/gentoo_download.log") or warn("open all.log error\n");
	print FILE 	$log_str;
	print STDOUT $log_str;
	close(FILE);
}

