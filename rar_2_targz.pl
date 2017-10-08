#!/usr/bin/perl 


extract_curdir_all_rars();
die("测试完成\n");
#2010_09_22_15:15:20 add by greshem
#use get_root_dir_all_arch_type;


do("/bin/get_root_dir_all_arch_type.pl");
use File::Basename;
use File::Copy::Recursive qw(pathmk dirmove pathrm pathempty );

my $in_path=$ARGV[0] or die("Error: should input a file \n");
my_die("Error: $in_path is not a file\n") if(! -f $in_path);
my_die("Error: file should be a absoult Path \n") if($in_path!~/^\//);

#$in=lc($in);

@root_dirs=get_top_dir($in_path);
logger("顶层目录是:  ".join("|", @root_dirs)."\n");
logger("对应的list命令是:   unzip -l $in_file \n");


	
if((scalar(@root_dirs) eq 1) && ($name eq $root_dirs[0] ))
{
	repaire_have_one_root_dir_zipfile($in_path)

}
elsif ((scalar(@root_dirs) eq 1 ) && (! ($name eq  $root_dirs[0])))
{
	#print " Error: should modify it's root_dir\n";
	logger("一个目录，但是根目录$name  和$in_file 文件名不同, 需要建立 $name , 解压到 $name 目录\n");
	mkdir($absoult_path."/".$name);
	`cd $absoult_path && unzip -u $in_path  `;	
	`cd $absoult_path && mv $root_dirs[0] $name`;
	`cd $absoult_path && tar -czf $name.tar.gz $name`;
	rmdir($absoult_path."/".$name) or ("print rmdir error\n");
	pathempty($absoult_path."/".$name);
	pathrm($absoult_path."/".$name);
	print " $absoult_path/$name.tar.gz created \n";
}
elsif (scalar(@root_dirs) gt 1)
{
	repaire_have_multi_root_dir_zipfile($in_path)
}
else
{
	print "some thing error\n"
}

logger("#################################################\n");



#***************************************************************************
# Description: 输入  文件 /root/a/long/path/shortname.suffix 最后解压到  /root/a/long/path/shortname 目录.
#		file.zip  有 
#				root1 
#				root2 
#				root3  ... 
#				目录.
# @notice:  
# 			1. 输入文件只有多个 目录, 
#		策略: 1. mkdir  /root/a/long/path/shortname
#			  2. 把shortname.suffix 文件 解压到 shortname 目录. 
#***************************************************************************/
sub repaire_have_multi_root_dir_zipfile($)
{

	(my $input_zip)=@_;	
	logger("开始处理 $input_zip 文件\n");
	my_die("输入的zip 文件不是绝对路径\n") if ($in_file !~/^\\/);
	my_die("Error: 输入文件不以zip结尾 \n")  if ($in_file !~/zip$|Zip$|ZIP$/);

	my $dirname=dirname($in_path);
	my $basename=basename($in_path);
	my $shortname=($basename=~/(.*).[zip|Zip|ZIP]/); #短名
	my $output_zip_dir=$dirname."/".$shortname;

	# logger("根目录有多个目录和文件,  建立, $name 目录, 把所有的文件解压到 $name  目录\n");	
	# mkdir($absoult_path."/".$name);
	# `cd $absoult_path && unzip -u $in_path  -d $name`;	
	# `cd $absoult_path && tar -czf $name.tar.gz $name`;
	# rmdir($absoult_path."/".$name) or ("print rmdir error\n");
	# pathempty($absoult_path."/".$name);
	# pathrm($absoult_path."/".$name);
	# print " $absoult_path/$name.tar.gz created \n";
}



#***************************************************************************
# Description: 输入  /root/a/long/path/shortname.suffix 最后解压到  /root/a/long/path/shortname 目录.
# @notice:  
# 			1. 输入文件只有一个目录, 而且根目录  shortname.zip 的第一个目录是 shortname  而且只有一个目录.
#			2. 
#***************************************************************************/

sub extract_curdir_all_rars()
{
	use Cwd;
  	$pwd=getcwd();
  	#print $pwd."\n";;
	for (grep { -f } glob($pwd."/*.rar"))
	{
		my $dest_dir=$_;
		$dest_dir=~s/\.rar$//g;
		if(! -f  $dest_dir.".tar.gz")
		{
		extract_onerar_to_onedir($_, $dest_dir);
		}
		else
		{
			print "$_ 已经处理过了\n";
		}
	}
}

#***************************************************************************
# Description: 解压一个zip 到一个指定的目录, 这个目录不存在则需要建立出来.
# @param 	
#			aaa.zip 解压到  /root/output_dir  最后生成 /root/output_dir.tar.gz
# @return 	
#***************************************************************************/
sub extract_onerar_to_onedir($$)
{
	(my $input_zip, my $output_zip_dir )=@_;	
	
	logger("开始处理 $input_zip 文件\n");
	my_die("输入的zip: $input_zip  文件不存在 \n") if (! -f $input_zip);
	my_die("输入的zip: $input_zip  文件不是绝对路径\n") if ($input_zip !~/^\//);
	my_die("Error: 输入文件不以zip结尾 \n")  if ($input_zip !~/rar$|Rar$|RAR$/);

	my $dirname_output=dirname($output_zip_dir);
	my $basename_output=basename($output_zip_dir);
	#(my $shortname)=($basename=~/(.*)\.[zip|Zip|ZIP]/); #短名
	#########my $output_zip_dir=$dirname."/".$shortname;

	mkdir_if_not_exist_or_die($output_zip_dir);
	dir_must_exist_or_die($output_zip_dir);
	
	#my $unpack_cmd_str= "unzip -f $input_zip -d $output_zip_dir";	 -f fresh
	chdir_must_success_or_die($output_zip_dir);
	my $unpack_cmd_str= "unrar x -o+ -r  $input_zip ";	
	system_exec_must_success_or_die($unpack_cmd_str);
	dir_must_exist_or_die($dirname_output);
	chdir_must_success_or_die($dirname_output);
	dir_must_exist_or_die($basename_output); 


	#制作成tar.gz
	my $pack_cmd_str="cd $dirname_output && tar -czf $basename_output.tar.gz $basename_output";
	system_exec_must_success_or_die($pack_cmd_str);
	my $abs_output_targz=$output_zip_dir.".tar.gz"; 	
	file_must_exist($abs_output_targz); # 绝对路径, 一定存在.
	file_must_exist($output_zip_dir.".tar.gz");		#相对路径 一定存在.

	rmrf_dir($output_zip_dir);
	dir_must_not_exist($output_zip_dir);
}
########################################################################
#
sub system_exec_must_success_or_die($)
{
	(my $cmd_str)=@_;
	logger("执行命令: $cmd_str\n");
	system($cmd_str);
	if($?>>8 ne 0)
	{
		my_die("命令行: $cmd_str 执行失败\n");
	}
}
#实现和shell 里面: rm -rf input_dir  一样的效果.
sub rmrf_dir($)
{
	(my $input_dir)=@_;
	if(! -d $input_dir)
	{
		logger("rm_rf: 输入的 $input_dir 不是目录 或者不存在 \n");
	}	

	pathempty($input_dir);
	pathrm($input_dir);

	my_die("Panic: $input_dir 文件没有删除掉") if(-d $output_zip_dir); #必不存在了.
}

sub logger($)
{
	(my $log_str)=@_;
	open(FILE, ">> /var/log/zip_2_targz.log") or warn("open all.log error\n");
	print FILE $log_str;
	close(FILE);
}

sub my_die($)
{
	(my $log_str)=@_;
	$log_str="错误:".$log_str;
	logger($log_str);
	die($log_str);
}

sub chdir_must_success_or_die($)
{
	(my $dir)=@_;

	if(! chdir($dir))
	{ 
		my_die("$dirname_input 目录不次存在\n"); 
	}
}


sub mkdir_if_not_exist_or_die($)
{
	(my $dir)=@_;
	if(-d $dir)
	{
		logger(" $output_zip_dir 已经生成过了,不用再生成了\n");
	}
	else
	{
		mkdir($dir);
	}
}
sub dir_must_exist_or_die($)
{
	(my $dir)=@_;
	#print "Deal With: ".$dir."\n";
	if(! -d $dir)
	{
		my_die("PANIC: $dir 应该存在, 但是不存在, \n");
	}
}
sub dir_must_not_exist($)
{
	(my $dir)=@_;
	if( -d $dir)
	{
		my_die("PANIC: $dir  应该不存在, 但是存在了. \n");
	}
}

sub file_must_exist($)
{
	(my $file)=@_;
	if(! -f $file)
	{
		my_die("PANIC: $file 文件不存在, \n");
	}
}

