#!/usr/bin/perl
#2011_07_05_ ���ڶ� add by greshem
if($^O=~/win32/i)
{
	do("c:\\bin\\iso_get_mobile_disk_label.pl");
	do("c:\\bin\\iso_path_db.pl");
}
else
{
	do("/bin/iso_get_mobile_disk_label_linux.pl");
	do("/bin/iso_path_db.pl");
}
our @g_pattern_array=@ARGV;
@g_pattern_array=expand_array_with_charset(@g_pattern_array);

use POSIX 'strftime';
$cur_time=POSIX::strftime('%Y-%m-%d-%H:%M:%S',localtime(time()));
#print "nowTime -> ", $cur_time,"\n";

logger("[$cur_time]: ����patter������[".join("|", @ARGV)."]\n");
our $g_pattern=$ARGV[0] or die("Usage: $0 pattern\n");

#search_one_dir("H:\\_x_file\\");
if(! -d "c:\\log\\eden_cache\\")
{
	for  (@g_iso_paths)
	{
		print $_."\n";
		search_one_dir($_);
	}
}
else
{
	print "#eden_cache ����, ʹ�� cache Ŀ¼, ��  iso_filelist_tools.pl copy ����. \n";
	#do("c:\\bin\\find_shell_implement_in_perl.pl");
	my @tmp= find_and_get_filelists("c:\\log\\eden_cache\\","txt\$");
	my $catalog= get_search_catalog_from_exe();
	if(defined($catalog))
	{
		@tmp=grep {/$catalog/} @tmp;
	}
	logger("catalog, �����Ϊ  |$catalog| \n");
	for $iso_txt (@tmp)
	{
		shell_grep_array($iso_txt, @g_pattern_array);
	}
	gentoo_search();	
}

print "\n#========================================================================== \n";
print "#������search ���� \n";
for (glob("*search*"))
{
	print "$_  \t\t\t\t".join(" ", @ARGV)."\n";;
}
#==========================================================================
# iso_search_file_jianpu.pl,  ��ȡ catalog Ϊjianpu  
sub get_search_catalog_from_exe()
{
	use File::Basename;
	my $tmp=basename($0);	
	$tmp=~s/^iso_search_file//g;
	$tmp=~s/^_//g;
	$tmp=~s/\.pl//g;
	if(length($tmp) > 0)
	{
		logger("����Ϊ> 0\n");
		return $tmp;
	}
	else
	{
		logger("����Ϊ���� 0\n");
		return undef;
	}
}
########################################################################
sub search_one_dir($)
{
	(my $dir)=@_;
	print "##$dir \n";
	if($^O =~/win/i)
	{
		$dir=change_mobile_path_to_win_path($dir);
	}
	else
	{
		$dir= change_mobile_path_to_linux_path($dir);

	}
	if(! -d $dir)
	{
		print ("����: $dir Ŀ¼������\n");
		return ;
	}

	if($^O=~/win/i)
	{
		for $iso (grep {-f } glob("$dir\\*iso.txt"))
		{
			if($iso=~/src.iso.txt/)
			{
				logger("����Դ���ѹ ����, $iso,  ���ﲻ������\n");
				next;
			}
			shell_grep_array($iso, @g_pattern_array);
		}
	
		gentoo_search();
	}
	else
	{
		for $iso (grep {-f } glob("$dir/*iso.txt"))
		{
			if($iso=~/src.iso.txt/)
			{
				logger("����Դ���ѹ ����, $iso,  ���ﲻ������\n");
				next;
			}
			shell_grep_array($iso, @g_pattern_array);
		}

	}
}

sub gentoo_search()
{
	if(-f "h:\\portage\\gentoo_filelist.txt")
	{
		shell_grep_array("h:\\portage\\gentoo_filelist.txt", @g_pattern_array);
	}
	else
	{
		warn("h:\\portage\\gentoo_filelist.txt, �ļ�������");
	}
}
sub shell_grep($$)
{
	( my $file, my $pattern)=@_;
	open(FILE, $file) or die("Open file $file error\n");
	my $count=undef;
	for(<FILE>)
	{
		if($_=~/$pattern/i)
		{
			#$count++;
			chomp;
			print " iso_copy_out_to_desktop.pl "."\"".$_."\"\n";
		}
	}
	return $count;
}

sub shell_grep_array($@)
{
	(my $file, my  @pattern_array)=@_;
	open(FILE, $file) or die("Open file $file error\n");
	my $count=undef;
	my @lines;
	for(<FILE>)
	{
		if(match_line_with_array($_, @pattern_array ))
		{
			$count++;
			chomp;
			#print " iso_copy_out_to_desktop.pl "."\"".$_."\"\n";
			if($^O=~/win/i)
			{
			push(@lines,  " iso_copy_out_to_desktop.pl "."\"".$_."\"\n");
			}
			else
			{
				$_=~s/\\/\//g;
				push(@lines,  " iso_copy_out_to_desktop.pl $_ \n");
			}

		}
	}
	#��ƥ���ӡ����Ӧ��iso ��ƥ�䵽����.
	if($count)
	{
		print "\n#ƥ�䵽�Ĺ���: ".$file."\n";
		for(@lines)
		{
			print $_;
		}
	}
	return $count;

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


#***************************************************************************
# Description	 ��ȡ�ļ��б�.
# @param: 
# 		$dir:  		�����Ŀ¼, 
# 		$pattern: 	��Ҫ��ȡ���ļ���ģʽ
# @notice:  bug_100m  ע�� �������, our my ���� �������ε���֮��û��������.
#***************************************************************************/
#������ find_shell_implement_in_perl.pl
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
		if($name=~/$g_pattern/i  )
		{
			#$name=~s/^$dir//g; #ȥ������·��.
			$name=~s/\//\\/g;
			#print "ie.pl \"$name\" \n";
			push(@filelists , $name);
		}
	}
	
	File::Find::find({wanted => \&wanted_exe}, $dir);
	return @filelists;
}

