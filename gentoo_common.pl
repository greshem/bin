#!/usr/bin/perl


sub logger_chm($)
{
	(my $log_str)=@_;
	open(FILE, ">> /tmp/gentoo_chm.log") or warn("open all.log error\n");
	print FILE $log_str;
	print $log_str;
	close(FILE);
}

sub  chm_exist_in_isodb_OK_method2($$)
{
	(my $chm_db, my $chm_name)=@_;
	if($chm_db->{"$chm_name"}=~/GOOD/i)
	{
		logger_chm( "#ISODB: $chm_name ISODB����,״̬ΪGOOD, SKIP \n");
		return 1;
	}
	elsif($chm_db->{"$chm_name"}=~/BAD/)
	{
		logger_chm("#ISODB: $chm_name  ISODB����,״̬ΪBAD:  ����������´��� chm ,  \n");
	}
	else
	{
		logger_chm( "#ISODB: $chm_name ������,  ��Ҫ���´���  \n");
	}
	return undef;
}

#/media/sda3/gentoo_portage_ISO_9_iso/dev-perl/chi	 chi-0.56.chm #û�д����ļ�
#/media/sda3/gentoo_portage_ISO_9_iso/dev-perl/chi	ERROR: chi-0.56.chm �д����ļ�2�� 
sub load_chm_file_info()
{
	my %hash;
	open(FILE, "/root/gentoo_chm_check.log") or die("/root/gentoo_chm_check.log error ");
	for(<FILE>)
	{
		my @tmp=split(/\s+/, $_);
		#print "DDD: ".join("|", @tmp)."\n";
		if($tmp[3]=~/û�д����ļ�/)
		{
			$hash{$tmp[2]}="BAD";
		}
		elsif ($tmp[3]=~/�д����ļ�.*��/)
		{
			$hash{$tmp[2]}="GOOD";
		}
	}

	return %hash;
}

sub delete_targz_suffix($)
{
	(my $input_file)=@_;
	my $raw=$input_file;

$input_file=~s/\.tar.gz$//g;
$input_file=~s/\.tar.bz2$//g;
$input_file=~s/\.tar.xz$//g; 
$input_file=~s/\.tgz$//g;  
$input_file=~s/\.tar$//g;  
$input_file=~s/\.tar.Z$//g;  
$input_file=~s/\.tar.lzma$//g;  
$input_file=~s/\.zip$//g;  
$input_file=~s/\.tbz$//g;  
$input_file=~s/\.tbz2$//g; 
$input_file=~s/\.rar$//g;  
$input_file=~s/\.lzma$//g;  
	
	print("#INFO �����ļ���  $raw \n");
	print("#INFO ����ļ���  $input_file \n");
	return $input_file;
}

