#!/usr/bin/perl
#2012_01_28   星期六   add by greshem
our @g_paths;	#当前的iso 里面存储的所有的路径
our $g_iso_file; #当前处理的iso文件.

our @tmp;
if($^O=~/win32/i)
{
	do("c:\\bin\\iso_get_mobile_disk_label.pl");
	do("c:\\bin\\iso_path_db.pl");
	push(@tmp, @g_iso_paths);
	do("c:\\bin\\os_iso_path_db.pl");
	push(@tmp, @g_iso_paths);
	@g_iso_paths=@tmp;
}
else
{
	do("./iso_get_mobile_disk_label.pl");
	#do("/bin/iso_path_db.pl");
	do("/bin/os_iso_path_db.pl");
	#do("iso_get_mobile_disk_label.pl");
}

#gen_iso_index_list("d:\\vs2003_3.iso");
#gen_iso_index_list("d:\\_develop_20100711.iso");
#print get_iso_from_path("d:\\_develop_20100711.iso")."\n";
#print get_iso_from_path("d:\\ffffff\\_develop_20100711.iso")."\n";;
our @g_all_iso_lists;

for  (@g_iso_paths)
{
	#print $_."\n";
	get_iso_from_one_dir($_);
}

my $operator=shift;
if(!defined($operator))
{
	$operator="sort";
	#warn("Usage: $0  [sort|mask|unmask|print|print_mask|print_unmask|keyword]\n");
	usage();
}

if( $operator=~/sort/i)
{
	get_least_isos(@g_all_iso_lists);
}
elsif($operator=~/^mask/i)
{
	my $pattern=shift;
	print "#Mask iso filelist \n";
	mask_iso_file_list($pattern, @g_all_iso_lists);
}
elsif($operator=~/^unmask/i)
{
	my $pattern=shift;
	print "#Unask iso filelist \n";
	unmask_iso_file_list($pattern, @g_all_iso_lists);
}
elsif( $operator=~/^print_mask/i)
{
	my $pattern=shift;
	print "#print masked  iso filelist \n";
	if(!defined($pattern)){$pattern=".";};
	print_masked_iso_file_list($pattern, @g_all_iso_lists);
}
elsif( $operator=~/^print_unmask/i)
{
	my $pattern=shift;
	print "#print masked  iso filelist \n";
	if(!defined($pattern)){$pattern=".";};
	print_unmasked_iso_file_list($pattern, @g_all_iso_lists);
}
elsif ($operator=~/^print/i)
{
	my $pattern=shift;
	print "#print iso filelist \n";
	if(!defined($pattern)){$pattern=".";}
	print_iso_file_list($pattern, @g_all_iso_lists);
}
elsif($operator=~/^copy/)
{
	copy_iso_file_list(@g_all_iso_lists);

	my $cur_month=get_MM_month();
	copy_iso_file_list("G:\\sdb1\\_xfile\\2014_all_iso\\_xfile_2014_$cur_month.txt");
}
elsif($operator=~/^keyword/)
{
	print "#print keyword  \n";
	#print_keyword_(@g_all_iso_lists)
	print_keyword_(@g_iso_paths)
}
elsif($operator=~/^dupkiller/)
{
	dupkiller(@g_all_iso_lists);	
}
elsif ($operator=~/^iso_backup/)
{
	iso_backup(@g_all_iso_lists);
}
else
{
}


########################################################################
sub get_MM_month()
{
    use POSIX 'strftime';
    my $month=POSIX::strftime('%m',localtime(time()));
    return $month;
}


sub iso_backup(@)
{
	use File::Path  qw(make_path remove_tree mkpath);

	use File::Copy::Recursive qw(fcopy rcopy dircopy fmove rmove dirmove);
	use File::Copy;
use Cwd;
use File::Basename;
	#fcopy("mktree_.pl", "tmp/bbb/bbb/bbbZ.txt");

	if(! -d "c:\\log")
	{
		mkdir("c:\\log");
	}

	(my  @input_iso_lists)=@_;

	#my @array=get_least_isos(@input_iso_lists);
 	my @array=get_one_year_isos(@input_iso_lists);
	for $each_iso (@array)
	{
			my  $dest= $each_iso;
			$dest=~s/^.:/.\\/g;
		
			#fcopy("${each_iso}", "${dest} ");
			print "mkdir   ".dirname($dest)."\n"; #windows mkdir whill mktree 
			if(! -f $dest )
			{	
				print "cp  $each_iso  $dest\n";
			}
			else
			{
				print "echo not cp $each_iso $dest \n";
			}
	}
}
sub  dupkiller(@)
{
	(my  @input_iso_lists)=@_;
	my %hash ;
	for $path (@input_iso_lists)
	{
		$path=~s/\\/\//g;		
		print "#处理  $path.txt 文件\n";
		get_basename_from_one_file($path.".txt", \%hash);
	}

	if( -f "h:\\portage\\gentoo_filelist.txt")
	{
		print "#处理  h:\\portage\\gentoo_filelist.txt  文件\n";
		get_basename_from_one_file( "h:\\portage\\gentoo_filelist.txt", \%hash);
	}
	else
	{
		warn("h:\\portage\\gentoo_filelist.txt,  文件不存在, 注意路径  \n")
	}

	open(OUTPUT, ">c:\\log\\dupkiller.log") or die("open  c dupkiller.log error \n");

foreach my $key (sort {$hash{$b} <=> $hash{$a}} keys %hash)
{
	#print "$key\t$hash{$key}\n";
	print OUTPUT "  $key -> $hash{$key} \n";
}


	for(keys(%hash))
	{
		#print OUTPUT "  $_ -> $hash{$_} \n";
	}
	close(OUTPUT);
}
sub get_basename_from_one_file($)
{
use Cwd;
use File::Basename;

#my $g_basename=basename($g_pwd);
#my$g_dirname=dirname($g_pwd);


	(my $input_file, $hash_ref )=@_;
	open(FILE,  $input_file) or die(" open file error , $input_file\n");
	for(<FILE>)
	{
		chomp;
		my $basename=basename($_);
		#print $basename."\n";
		$hash_ref->{$basename}++;
	}
}

sub print_keyword_(@)
{
	(my  @input_iso_lists)=@_;
	my %hash ;
	for $path (@input_iso_lists)
	{
		$path=~s/\\/\//g;		
		my @words=split(/\//, $path);
		for(@words)
		{
			$hash{$_}++;		
		}
	}
	

	#对keys 排序之后 输出.
	my @tmp;
	foreach my $key (sort {$hash{$b} <=> $hash{$a}} keys %hash)
	{

		push(@tmp, $key);

	}
	for(@tmp)
	{
		#print $hash{$_}. "\t=>".$_."\n";
		print "#echo $_ \t=>".$hash{$_}."\n";
		print "mklink  c:\\bin\\iso_search_file_".$_.".pl  c:\\bin\\iso_search_file.pl \n";
		#print join("\n", keys(%hash))."\n";	
	}


	return keys(%hash);
}
sub usage()
{
	warn("######################################################################## \n");
	warn("Usage: $0  [sort|mask|unmask|print|print_mask|print_unmask|keyword|help|copy|dupkiller|iso_backup]\n");

}

#把前缀 替换成 c:\\log\\eden_cache 然后 再进行拷贝, 保留目录结构
#用于 做cache 的seach 工作 
sub copy_iso_file_list(@)
{
	use File::Path  qw(make_path remove_tree mkpath);
	#mkpath for windows 
	#mkpath("./tmp/a/b/c");

	use File::Copy::Recursive qw(fcopy rcopy dircopy fmove rmove dirmove);
	use File::Copy;
	#fcopy("mktree_.pl", "tmp/bbb/bbb/bbbZ.txt");

	if(! -d "c:\\log")
	{
		mkdir("c:\\log");
	}

	(my  @input_iso_lists)=@_;
	for $each_iso (@input_iso_lists)
	{
			my  $dest= $each_iso;
			$dest=~s/f:/c:\\log\\eden_cache\\/ig;
			$dest=~s/g:/c:\\log\\eden_cache\\/ig;
			$dest=~s/h:/c:\\log\\eden_cache\\/ig;
			$dest=~s/i:/c:\\log\\eden_cache\\/ig;
			$dest=~s/j:/c:\\log\\eden_cache\\/ig;	
			$dest=~s/k:/c:\\log\\eden_cache\\/ig;
			$dest=~s/l:/c:\\log\\eden_cache\\/ig;
			$dest=~s/m:/c:\\log\\eden_cache\\/ig;
			if($each_iso=~/iso$/)
			{	
				fcopy("${each_iso}.txt", "${dest}.txt ");
				print("${each_iso}.txt  ${dest}.txt \n");
			}
			elsif($each_iso=~/\.txt$/)
			{
				fcopy("${each_iso}", "${dest}");
				print("${each_iso}   ${dest}\n");
			}
			elsif(-d $each_iso)
			{
					$each_iso=~s/\\$//g;
					$each_iso=~s/\/$//g;
				fcopy("${each_iso}.txt", "${dest}");
				print("${each_iso}.txt    ${dest}\n");
			}
			else
			{
				print "$each_iso 文件格式不对, 不支持 , 这种方式的拷贝\n";
			}
			
	}
}
sub print_iso_file_list($@)
{
	print "############################\n";
	print "#start keyword \n";
	(my $pattern, my  @input_iso_lists)=@_;
	
	for(@input_iso_lists)
	{
		if($_=~/$pattern/)
		{
			print "ie.pl $_ \n";
		}
	}
}

sub mask_iso_file_list($@)
{
	(my $pattern, my  @input_iso_lists)=@_;
	
	for(@input_iso_lists)
	{
		if($_=~/$pattern/)
		{
			print "move $_.txt $_.txt.mask\n";
			system("move $_.txt $_.txt.mask ");
		}
	}
}

sub print_unmasked_iso_file_list($@)
{
	(my $pattern, my  @input_iso_lists)=@_;
	
	for(@input_iso_lists)
	{
		if(! -f $_.".txt.mask")
		{
			print "$_   \n";
		}
	}
}
sub print_masked_iso_file_list($@)
{
	(my $pattern, my  @input_iso_lists)=@_;
	
	for(@input_iso_lists)
	{
		if(-f $_.".txt.mask")
		{
			print "$_.txt.mask   \n";
		}
	}
}

sub unmask_iso_file_list($@)
{
	(my $pattern, my  @input_iso_lists)=@_;
	
	for(@input_iso_lists)
	{
		if($_=~/$pattern/)
		{
			if(-f $_.".txt.mask")
			{
				print "move $_.txt.mask    $_.txt\n";
				system("move $_.txt.mask    $_.txt ");
			}
		}
	}
}



########################################################################
#获取最近的 20个光盘, 便于刻录. 
sub get_least_isos(@)
{
	(my @input_iso_lists)=@_;
	my @filesSort= sort{-M $a <=> -M $b} @input_iso_lists;
	my @least_isos;

	print "########################################################################\n";
	my $count=0;
	for(@filesSort)
	{
		if($count < 40)
		{
			print $_."|".(-M $_)."\n";	
			push(@least_isos, $_);
		}
		$count++;
	}
	return @least_isos;
}

sub get_one_year_isos(@)
{
	(my @input_iso_lists)=@_;
	my @ret_isos;
	for(@input_iso_lists)
	{
		#print "#距离 修改天数  $cur - $mtime =?  $diff \n";
		if(  (-M $_) <  365)
		{
			push(@ret_isos, $_);
		}
	}
	return @ret_isos;
}

########################################################################
sub get_iso_from_one_dir($)
{
	(my $dir)=@_;
	if($dir=~/^sdb/i)
	{
		logger("$dir 是 移动硬盘格式路径\n");
 		$dir=change_mobile_path_to_win_path($dir);
		logger("转换之后的路径是 $dir\n");
	}
	if(! -d $dir)
	{
		print $dir."不是 一个目录 \n";
		logger("$dir 目录不存在\n");
		return ;
	}
	for $iso (grep {-f } glob("$dir*\.iso"))
	{
		#print $iso."\n";
		push(@g_all_iso_lists, $iso);
	}
}




sub get_iso_from_path($)
{
	(my $path_iso)=@_;
	($name)=($path_iso=~/.*\\(.*\.iso$)/);
	return $name;
}
sub logger($)
{
	(my $log_str)=@_;
	open(FILE, ">>all.log");
	print FILE $log_str;
	close(FILE);
}
sub logger_to_bat_del($)
{
	(my $log_str)=@_;
	open(FILE, ">> del_log");
	print FILE $log_str;
	close(FILE);
}

########################################################################
#will  be discarded in future
sub dummy()
{
	get_iso_from_one_dir("sdb1:\\_x_file\\");
	get_iso_from_one_dir("sdb1:\\_x_file\\2009_all_iso\\");
	get_iso_from_one_dir("sdb1:\\_x_file\\2010_all_iso\\");
	get_iso_from_one_dir("sdb1:\\_x_file\\2011_all_iso\\");
	get_iso_from_one_dir("sdb1:\\_x_file\\2012_all_iso\\");
	get_iso_from_one_dir("sdb1:\\_x_file\\d_frequent");
	get_iso_from_one_dir("sdb1:\\_x_file\\d_qianlong_all_iso\\");
	get_iso_from_one_dir("sdb1:\\_x_file_ext\\zzu_ebook\\");

	get_iso_from_one_dir("sdb1:\\all_chm\\");
	get_iso_from_one_dir("sdb1:\\dos_iso\\");
	get_iso_from_one_dir("sdb1:\\ebook\\");
	get_iso_from_one_dir("sdb1:\\game\\");
	get_iso_from_one_dir("sdb1:\\sf_mirror_iso\\");

	get_iso_from_one_dir("sdb2:\\Security\\");
	get_iso_from_one_dir("sdb2:\\ghost_targz_iso\\");
	get_iso_from_one_dir("sdb2:\\kugou_mp3_iso\\");
	get_iso_from_one_dir("sdb2:\\linux_iso_windows\\");
	get_iso_from_one_dir("sdb2:\\linux_src_all_iso\\");
	get_iso_from_one_dir("sdb2:\\oss_site_all_iso\\");
	get_iso_from_one_dir("sdb2:\\oss_site_all_iso\\d_python_pypi_mirror_iso\\");
	get_iso_from_one_dir("sdb2:\\vmware_disk_iso\\");

	get_iso_from_one_dir("sdb3:\\develop_IDE_ISO\\");
	get_iso_from_one_dir("sdb3:\\lindows\\");
	get_iso_from_one_dir("sdb3:\\photo\\");
	get_iso_from_one_dir("sdb3:\\qimeng\\");


	get_iso_from_one_dir("sdb4:\\f13_srpm_download\\d_linux_src_f13\\");
	get_iso_from_one_dir("sdb4:\\f8_srpm_done\\");
}

