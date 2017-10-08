#!/usr/bin/perl 
use List::MoreUtils qw(uniq);

############################################################################################
#获取压缩文件里面的顶层目录.
sub get_top_dir($)
{
	(my $in_file )=@_;
	my @ret_root;
	
	if($in_file=~/tar.gz$|tgz$/)
	{
		@tmp=get_list_from_targz($in_file);
	}
	elsif ($in_file=~/tar.bz2$/)
	{
		@tmp=get_list_from_tarbz2($in_file);
	}
	elsif ($in_file=~/zip$/)
	{
		@tmp= get_list_from_zip($in_file);
	}
	elsif ($in_file=!/rar$/i)
	{
		@tmp= get_list_from_rar($in_file);
	}
	@tmp1=map{s/^\.\///; $_} @tmp;
	@tmp2=awk_print_first(@tmp1);
	@tmp3=grep {defined($_)} sort(@tmp2);
	@ret_root=  uniq(@tmp3);
	return @ret_root;
}	

sub awk_print_first(@)
{
	(my @in)=@_;
	# awk -f '{print $1}' 	
	my @ret_dirs;
	for ( @in)
	{
			@array=split(/\//, $_);
			push(@ret_dirs, $array[0]);
	}
	return @ret_dirs;
}
#zip 
sub awk_print_forth(@)
{
	(my @in)=@_;
	# awk -f '{print $1}' 	
	my @ret_dirs;
	for ( @in)
	{
			@array=split(/\//, $_);
			push(@ret_dirs, $array[0]);
	}
	return @ret_dirs;
}


########################################################################
sub get_list_from_targz($)
{
	(my $in_file)=@_;
	if(! -f $in_file)
	{
		return undef;
	}
	#$tmp = ` tar -tzf  $in_file |awk -F\/ '{print $1}'|sort |uniq)`;
	my $tmp= `tar -tzf $in_file`;
	my @list = split(/\n/, $tmp);	
	return @list;
	
}
########################################################################
sub get_list_from_tarbz2($)
{
	(my $in_file)=@_;
	if(! -f $in_file)
	{
		return undef;
	}
	#my $tmp;
	#$tmp = ` tar -tjf  $in_file |awk -F\/ '{print $1}'|sort |uniq)`;
	my $tmp=`tar -tjf $in_file`;
	my @list = split(/\n/, $tmp);	
	return @list;
	
}
########################################################################
#zip 的文件格式  
sub get_list_from_zip($)
{
	(my $in_file)=@_;
	if(! -f $in_file)
	{
		return undef;
	}
	my $tmp = ` unzip -l $in_file`;
	my @lines = split(/\n/, $tmp);
	###########################################
	#输出格式如下:
	#      size  time             file_name 
	#      2050  10-16-05 17:22   1ftheme/index.php
	
	my @list;
	for (@lines)
	{
		if(/^\s+\d+.*/)
		{	
			@array=split(/\s+/, $_);
			push(@list, $array[4]);
		}
	}
	return @list;
}

########################################################################
#rar 的文件格式  
#2010_10_14_18:50:42 add by greshem
sub get_list_from_rar($)
{
	(my $in_file)=@_;
	if(! -f $in_file)
	{
		return undef;
	}
	# l list  b bare  单纯的列出文件没有其他的信息了。 
	my $tmp = `rar lb $in_file`;
	my @lines = split(/\n/, $tmp);
	###########################################
	#      size  time             file_name 
	#      2050  10-16-05 17:22   1ftheme/index.php
	
	my @list;
	for (@lines)
	{
		if(/^\s+\d+.*/)
		{	
			@array=split(/\s+/, $_);
			push(@list, $array[4]);
		}
	}
	return @list;
}

1;
