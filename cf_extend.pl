#!/usr/bin/perl
$g_count=0;
use Data::Dumper; 
@g_register_path=qw(
develop_bash
develop_cpp
develop_ddk
develop_etc
develop_kernel
develop_mfc
develop_network
develop_perl
develop_perl_windows
develop_php
develop_python
develop_qemu_kvm
develop_reg_register_bak
develop_sed_txt_tools
develop_thread
develop_wxwidgets
develop_wxwidgets_73
develop_xxunit
);

$pattern=shift;


#print "#========================================================================== \n";
#print "#sys PATH \n";
@sys_paths=split(/:/, $ENV{PATH});
for $each (@sys_paths) 
{
	if($each=~/^\/bin$/ || $each=~/root\/bin/)
	{
		next;
	}
	find_in_dir($each, $pattern);
}


#print "#========================================================================== \n";
#print "#/root/develop_* \n";
for (@g_register_path)
{
	my $path="/root/".$_."/";
	if(-d $path)
	{
		find_in_dir($path, $pattern);
	}
	else
	{
		#print "#$path not exists\n";
	}
}

#print "#========================================================================== \n";
#print "#/mnt/sda3/_pre_cache/\n";
find_in_dir("/mnt/sda3/_pre_cache/", $pattern);

#print "#========================================================================== \n";
#print  "#/root/dir/ \n";
if ( -d  "/root/dir/")
{
	find_in_dir_recurse("/root/dir/", $pattern);
}
else
{
	print "#please excute /bin/_pre_cache_mount.pl\n";	
}

#  for furthor  info,  please user "iso_search_file.pl"  "iso_*" tools 
#==========================================================================
#匹配的数量太少了, 要从自己的光盘目录开始搜寻了, 光盘目录  通过 
#find  /media/sdb*  |grep iso.txt$  > mobile_iso_txt
#/bin/cp_with_dir_v3.pl    mobile_iso_txt 
#来的.
print "#========================================================================== \n";
print "#iso.txt \n";
do("/bin/grep_file.pl");
if( $0=~/extend/)
{

	print "#count less then 30, extend find in iso.txt \n";
	if( ! -d  "/mnt/sda3/media_sdb_iso_txt/")
	{
		warn("# sdb 光盘索引目录不存在, 请建立 索引,  便于查找 \n");
		exit(0);
	}

	@iso_txts=` find /mnt/sda3/media_sdb_iso_txt/ -type f `	;
	for (@iso_txts)
	{
		chomp;
		use Encode;
		if($ENV{"LANG"}=~/utf8/i)
		{
			system(" grep $pattern $_  ");
		}
		else
		{
			#$pattern= encode("gb2312", decode("utf-8", $pattern));
			#shell_grep($pattern, $_);
			system("grep $pattern $_ | /bin/gb2312_to_utf8.sh ");
		}
	}
	
}
########################################################################
#sub functions 
#在这个目录下找有没有 匹配 这个模式的文件, 一层.
sub find_in_dir($$)
{
	(my $dir, $pattern)=@_;
	chdir($dir) or warn("chdir $dir error, $!");
	@b=glob("*"); 
	for $each2 (@b) 
	{
		if( $each2=~/$pattern/i)
		{
			$g_count++;
			if($each2=~/pl$/)
			{
				print "perl ".$dir."/".$each2,"\n";
			}
			elsif ($each2=~/py$/)
			{
				print "python ".$dir."/".$each2,"\n";
			}
			elsif ($each2=~/php$/)
			{
				print "php ".$dir."/".$each2,"\n";
			}
			elsif ($each2=~/rb$/)
			{
				print "ruby ".$dir."/".$each2,"\n";
			}

			elsif ($each2=~/sh$/)
			{
				print "bash ".$dir."/".$each2,"\n";
			}
			elsif (-d $each2)
			{
				print "cd ".$dir."/".$each2,"\n";
			}
			else
			{
				print "cat ".$dir."/".$each2,"\n";
			}
		}
	}
}
sub find_in_dir_recurse($$)
{
	(my $dir , $pattern)=@_;
	if(! defined($pattern))
	{
		die("not input pattern \n");	
	}	
	@lines=`find $dir |grep $pattern`;
	for(@lines)
	{
			$g_count++;
			chomp;

			$lang=$ENV{"LANG"};
			if($lang=~/utf8/i)
			{
				print ("gb2312_to_utf8.sh $_ \n");
			}
			else
			{
				print "cat \"$_\"\n";
			}
	}
}
