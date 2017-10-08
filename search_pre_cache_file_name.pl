#!/usr/bin/perl
#do("c:\\bin\\find_shell_implement_in_perl.pl");
#my  $pattern= shift ;
our @g_pattern_array=@ARGV;
@g_pattern_array=expand_array_with_charset(@g_pattern_array);

use POSIX 'strftime';
$cur_time=POSIX::strftime('%Y-%m-%d-%H:%M:%S',localtime(time()));
$cur_month= POSIX::strftime('%m',localtime(time()));
#print "nowTime -> ", $cur_time,"\n";

logger("[$cur_time]: ����patter������[".join("|", @ARGV)."]\n");

#==========================================================================
#��ǰ�� ���е��ļ�.
my $dest_dir="J:\\sdb1\\_xfile\\2014_all_iso\\_xfile_2014_$cur_month\\";
if(! -d $dest_dir )
{
	die(" $dest_dir Ŀ¼������\n");	
}
my @tmp= find_and_get_filelists($dest_dir,$pattern);


#==========================================================================
# _pre_cache.iso  ����Ŀ¼ ���е��ļ�. 
for (c..h)
{
	if( is_pre_cache_disk_lable($_))
	{
		my @tmp= find_and_get_filelists("$_:\\",$pattern);
	}
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
	if(-f   "$disk_lable:\\_pre_cache_����_��¼_����.txt")
	{
		return 1;
	}
	return undef;
}

#�������� and �Ĺ�ϵ.
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
# Description	 ��ȡ�ļ��б�.
# @param: 
# 		$dir:  		�����Ŀ¼, 
# 		$pattern: 	��Ҫ��ȡ���ļ���ģʽ
# @notice:  bug_100m  ע�� �������, our my ���� �������ε���֮��û��������.
#***************************************************************************/
#����  find_shell_implement_in_perl.pl

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
		if( match_line_with_array($name, @g_pattern_array))
		{
			#$name=~s/^$dir//g; #ȥ������·��.
			$name=~s/\//\\/g;
			print "ie.pl \"$name\" \n";
			push(@filelists , $name);
		}
	}
	
	File::Find::find({wanted => \&wanted_exe}, $dir);
	return @filelists;
}
#==========================================================================
#����iso_search_file.pl
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