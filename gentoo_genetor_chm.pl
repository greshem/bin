#!/usr/bin/perl
#整个程序 输入 就是当前的目录,  gentoo portage 的 子目录. 
do("/root/bin/gentoo_common.pl");

#system("  /root/bin/gentoo_downloader.pl");
system(" /root/bin/atool_unpack_all_2_targz_dir.pl  |sh ");


init_check();
%g_chm=load_chm_file_info();
gen_chm();

########################################################################
sub init_check()
{
	if(! -f "/root/chm_all.txt")
	{
		die("/root/chm_all.txt error , not exists \n");
	}

	if(! -f "/root/gentoo_chm_check.log")
	{
		die("/root/gentoo_chm_check.log error , not exists \n");
	}

	if(! -f "/usr/bin/grep")
	{
		system("cp /bin/grep /usr/bin/grep  \n");
	}
}
########################################################################
#这个chm 文件在个人的4t硬盘里面 是否 存在 而且 代码正确索引 
sub  chm_exist_in_isodb_OK($)
{
	(my $chm_name)=@_;
	if($g_chm{"$chm_name"}=~/GOOD/i)
	{
		logger_chm( "ISODB: $chm_name ISODB存在,状态为GOOD, SKIP \n");
		return 1;
	}
	elsif($g_chm{"$chm_name"}=~/BAD/)
	{
		logger_chm("ISODB: $chm_name  ISODB存在,状态为BAD:  但是最好重新创建 chm ,  \n");
	}
	else
	{
		logger_chm( "ISODB: $chm_name 不存在,  需要重新创建  \n");
	}
	return undef;
}


########################################################################
sub gen_chm()
{

use Cwd;
use Cwd;
use File::Basename;

our $g_pwd=getcwd();
our $g_basename=basename($g_pwd);
our $g_dirname=dirname($g_pwd);

	open(FILE, "Manifest") or die("open Manifest error , maybe not in gentoo portage dir \n");
	for(<FILE>)
	{
		if($_=~/^DIST/)
		{
			print "#--------------------------------------------------------------------------\n";
			my @array=split(/\s+/, $_);
			my $targz=$array[1];
			logger_chm ("#".$targz."\n"); 
			$name=delete_targz_suffix($targz); 
			#delete_targz_suffix($)
			
			if($targz!~/\.tar.gz$|\.tar.bz2$|\.tar.xz$|\.tgz$|\.tar.Z$|\.tar.lzma$|\.zip$|\.tbz$|\.tbz2$|\.rar$|\.tar$/)	
			#if($targz=~/\.patch$|patch.gz$|patch.bz2$|patch.sz$|diff.gz|patch.xz$|el.xz$|el.bz2$|el.gz$/)
			{
				logger_chm("$targz  atool 无法处理 skip \n");
				delete_tmp_src_code_path($name);
				next;
			}

			if( chm_exist_in_isodb_OK("$name".".chm"))
			{
					logger_chm("$g_pwd/$name.chm , 存在 /root/chm_all.txt,   chm 不用制作了, \n");
					#system("/usr/bin/grep $name.chm /root/chm_all.txt\n");
					delete_tmp_src_code_path($name);
					next;	
			}
			else
			{
					logger_chm("$name.chm isodb中存在, 但是质量不好,需要重新制作, 或者不存在 \n");
			}


			if ( -f $name.".chm")
			{
				logger_chm("#$name.chm 本地已经存在\n");
				delete_tmp_src_code_path($name);
				next;
			}	
			if( ! -f $targz)
			{
				logger_chm("#$targz 本地不存在, distfile 没有 这个文件?   或者进行下载: gentoo_downloader.pl  \n");
				delete_tmp_src_code_path($name);
				next;
			}
			chdir($g_pwd);
			if(! -d $name)
			{
				die("DIR: $name not exists , after /bin/atool_unpack_all_2_targz_dir.pl \n");
			}
			else
			{
				logger_chm("cd  $g_pwd/".$name."\n");
				chdir("$g_pwd/".$name);
				#system("/bin/cur_dir_gen_chm.sh");
				system("bash /root/global-4.4_logger/python_plug/one_step.sh");

				system("mv *.chm $g_pwd/");
				chdir("$g_pwd/");
			}

			chdir($g_pwd);
			delete_tmp_src_code_path($name);
			
		}
	}

}
#删除 临时解压处理的目录,  chm 制作完成之后 
sub  delete_tmp_src_code_path($)
{
	(my $name)=@_;

		warn("CHM:  already generator , delete  |$name| dir \n");
		if($name=~/^\.\/$/|| $name=~/^\.\./)
		{
			die("PANIC:  路径错误, 是上级路径 本地路径? \n");
		}
		system("rm -rf $name/ \n");
}


