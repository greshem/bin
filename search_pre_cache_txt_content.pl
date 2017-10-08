#!/usr/bin/perl
#do("c:\\bin\\find_shell_implement_in_perl.pl");
#my  $pattern= shift ;
our @g_pattern_array=@ARGV;
@g_pattern_array=expand_array_with_charset(@g_pattern_array);

use POSIX 'strftime';
$cur_time=POSIX::strftime('%Y-%m-%d-%H:%M:%S',localtime(time()));
$cur_month= POSIX::strftime('%m',localtime(time()));
#print "nowTime -> ", $cur_time,"\n";

logger("[$cur_time]: 配置patter数组是[".join("|", @ARGV)."]\n");

#==========================================================================
#当前月 所有的文件.
my $dest_dir="H:\\sdb1\\_xfile\\2015_all_iso\\_xfile_2015_$cur_month\\_pre_cache\\";
if(! -d $dest_dir )
{
	die(" $dest_dir 目录不存在\n");	
}
our @g_filelist= find_and_get_filelists($dest_dir,"txt");


#==========================================================================
# _pre_cache.iso  光盘目录 所有的文件. 
for (c..h)
{
	if( is_pre_cache_disk_lable($_))
	{
		my @tmp1= find_and_get_filelists("$_:\\", "txt");
		push(@g_filelist, @tmp1);
	}
}

$pattern=shift(@g_pattern_array);
print "#开始搜索 所有文件内容\n";
for $each (@g_filelist)
{
	#print "处理 $each, pattern=$pattern 文件\n";
	search_in_file($each, $pattern);
	#search_in_file($$)
}

#==========================================================================
#my @tmp= find_and_get_filelists("c:/bin/","a");
#print join("\n", @tmp);


#my @tmp= find_and_get_filelists("g:\\",$pattern);
#my @tmp= find_and_get_filelists("c:/bin/","a");
#print join("\n", @tmp);

sub is_pre_cache_disk_lable()
{
	(my $disk_lable)=@_;
	if(-f   "$disk_lable:\\_pre_cache_备份_记录_回溯.txt")
	{
		return 1;
	}
	return undef;
}

#联合条件 and 的关系.
sub match_line_with_array($@)
{
	(my $line, @patterns)=@_;
	for $pattern (@patterns)
	{
		if($line!~/$pattern/i)
		{
			return undef;	
		}
	}
	return 1;
}


#***************************************************************************
# Description	 获取文件列表.
# @param: 
# 		$dir:  		输入的目录, 
# 		$pattern: 	需要获取的文件的模式
# @notice:  bug_100m  注意 这个东西, our my 区别 否则两次调用之后没有数据了.
#***************************************************************************/
#来自  find_shell_implement_in_perl.pl

sub  find_and_get_filelists($$)
{

	(my $dir,my  $pattern)=@_;
	#my @filelists=(); 	
	#our @filelists=();

	our @filelists=();
	our $g_pattern =$pattern;
	use File::Find ();

	use vars qw/*name *dir *prune/;
	*name   = *File::Find::name;
	*dir    = *File::Find::dir;
	*prune  = *File::Find::prune;

	sub wanted_exe;
	sub wanted_exe 
	{
		my ($dev,$ino,$mode,$nlink,$uid,$gid);

		(($dev,$ino,$mode,$nlink,$uid,$gid) = lstat($_));
		#print("$name\n");
		if($name=~/\/\./)
		{
			return ;
		}
		#if($name=~/$g_pattern/i && -f $name )
		#if($name=~/$g_pattern/i  )
		if($name=~/$pattern/i  )
		#if( match_line_with_array($name, @g_pattern_array))
		{
			#$name=~s/^$dir//g; #去掉绝对路径.
			$name=~s/\//\\/g;
			#print "ie.pl \"$name\" \n";
			push(@filelists , $name);
		}
	}
	
	File::Find::find({wanted => \&wanted_exe}, $dir);
	return @filelists;
}
#==========================================================================
#来自iso_search_file.pl
sub expand_array_with_charset(@)
{
	(my @input)=@_;
	my @ret;
	for $each_word (@input)
	{
		@tmp=split(/[_\.+-]+/, $each_word);
		push(@ret, @tmp);
	}

	return @ret;
}
sub logger($)
{
	if(! -d "c:\\log")
	{
		mkdir("c:\\log");
	}
	(my $log_str)=@_;
	if($^O=~/win/i)
	{
		open(FILE, ">>c:\\log\\iso_search_file.log") or warn("open all.log error\n");
	}
	else
	{
		open(FILE, ">>/var/log/iso_search_file.log") or warn("open all.log error\n");
	}
	print FILE $log_str;
	close(FILE);
}

#可以沿用   iso_seach_file.pl 的. shell_grep_array($@)
sub search_in_file($$)
{
	(my $input_file, my $pattern)=@_;
	#print "#search_in_file 模式 $pattern\n";
	open(FILE, $input_file) or die("open file |$input_file| error $!\n");
	for(<FILE>)
	{
		if($_=~/$pattern/)
		{
			print $input_file."|".$_."\n";
		}
	}
	close(FILE);
}
