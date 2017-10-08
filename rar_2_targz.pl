#!/usr/bin/perl 


extract_curdir_all_rars();
die("�������\n");
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
logger("����Ŀ¼��:  ".join("|", @root_dirs)."\n");
logger("��Ӧ��list������:   unzip -l $in_file \n");


	
if((scalar(@root_dirs) eq 1) && ($name eq $root_dirs[0] ))
{
	repaire_have_one_root_dir_zipfile($in_path)

}
elsif ((scalar(@root_dirs) eq 1 ) && (! ($name eq  $root_dirs[0])))
{
	#print " Error: should modify it's root_dir\n";
	logger("һ��Ŀ¼�����Ǹ�Ŀ¼$name  ��$in_file �ļ�����ͬ, ��Ҫ���� $name , ��ѹ�� $name Ŀ¼\n");
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
# Description: ����  �ļ� /root/a/long/path/shortname.suffix ����ѹ��  /root/a/long/path/shortname Ŀ¼.
#		file.zip  �� 
#				root1 
#				root2 
#				root3  ... 
#				Ŀ¼.
# @notice:  
# 			1. �����ļ�ֻ�ж�� Ŀ¼, 
#		����: 1. mkdir  /root/a/long/path/shortname
#			  2. ��shortname.suffix �ļ� ��ѹ�� shortname Ŀ¼. 
#***************************************************************************/
sub repaire_have_multi_root_dir_zipfile($)
{

	(my $input_zip)=@_;	
	logger("��ʼ���� $input_zip �ļ�\n");
	my_die("�����zip �ļ����Ǿ���·��\n") if ($in_file !~/^\\/);
	my_die("Error: �����ļ�����zip��β \n")  if ($in_file !~/zip$|Zip$|ZIP$/);

	my $dirname=dirname($in_path);
	my $basename=basename($in_path);
	my $shortname=($basename=~/(.*).[zip|Zip|ZIP]/); #����
	my $output_zip_dir=$dirname."/".$shortname;

	# logger("��Ŀ¼�ж��Ŀ¼���ļ�,  ����, $name Ŀ¼, �����е��ļ���ѹ�� $name  Ŀ¼\n");	
	# mkdir($absoult_path."/".$name);
	# `cd $absoult_path && unzip -u $in_path  -d $name`;	
	# `cd $absoult_path && tar -czf $name.tar.gz $name`;
	# rmdir($absoult_path."/".$name) or ("print rmdir error\n");
	# pathempty($absoult_path."/".$name);
	# pathrm($absoult_path."/".$name);
	# print " $absoult_path/$name.tar.gz created \n";
}



#***************************************************************************
# Description: ����  /root/a/long/path/shortname.suffix ����ѹ��  /root/a/long/path/shortname Ŀ¼.
# @notice:  
# 			1. �����ļ�ֻ��һ��Ŀ¼, ���Ҹ�Ŀ¼  shortname.zip �ĵ�һ��Ŀ¼�� shortname  ����ֻ��һ��Ŀ¼.
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
			print "$_ �Ѿ��������\n";
		}
	}
}

#***************************************************************************
# Description: ��ѹһ��zip ��һ��ָ����Ŀ¼, ���Ŀ¼����������Ҫ��������.
# @param 	
#			aaa.zip ��ѹ��  /root/output_dir  ������� /root/output_dir.tar.gz
# @return 	
#***************************************************************************/
sub extract_onerar_to_onedir($$)
{
	(my $input_zip, my $output_zip_dir )=@_;	
	
	logger("��ʼ���� $input_zip �ļ�\n");
	my_die("�����zip: $input_zip  �ļ������� \n") if (! -f $input_zip);
	my_die("�����zip: $input_zip  �ļ����Ǿ���·��\n") if ($input_zip !~/^\//);
	my_die("Error: �����ļ�����zip��β \n")  if ($input_zip !~/rar$|Rar$|RAR$/);

	my $dirname_output=dirname($output_zip_dir);
	my $basename_output=basename($output_zip_dir);
	#(my $shortname)=($basename=~/(.*)\.[zip|Zip|ZIP]/); #����
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


	#������tar.gz
	my $pack_cmd_str="cd $dirname_output && tar -czf $basename_output.tar.gz $basename_output";
	system_exec_must_success_or_die($pack_cmd_str);
	my $abs_output_targz=$output_zip_dir.".tar.gz"; 	
	file_must_exist($abs_output_targz); # ����·��, һ������.
	file_must_exist($output_zip_dir.".tar.gz");		#���·�� һ������.

	rmrf_dir($output_zip_dir);
	dir_must_not_exist($output_zip_dir);
}
########################################################################
#
sub system_exec_must_success_or_die($)
{
	(my $cmd_str)=@_;
	logger("ִ������: $cmd_str\n");
	system($cmd_str);
	if($?>>8 ne 0)
	{
		my_die("������: $cmd_str ִ��ʧ��\n");
	}
}
#ʵ�ֺ�shell ����: rm -rf input_dir  һ����Ч��.
sub rmrf_dir($)
{
	(my $input_dir)=@_;
	if(! -d $input_dir)
	{
		logger("rm_rf: ����� $input_dir ����Ŀ¼ ���߲����� \n");
	}	

	pathempty($input_dir);
	pathrm($input_dir);

	my_die("Panic: $input_dir �ļ�û��ɾ����") if(-d $output_zip_dir); #�ز�������.
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
	$log_str="����:".$log_str;
	logger($log_str);
	die($log_str);
}

sub chdir_must_success_or_die($)
{
	(my $dir)=@_;

	if(! chdir($dir))
	{ 
		my_die("$dirname_input Ŀ¼���δ���\n"); 
	}
}


sub mkdir_if_not_exist_or_die($)
{
	(my $dir)=@_;
	if(-d $dir)
	{
		logger(" $output_zip_dir �Ѿ����ɹ���,������������\n");
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
		my_die("PANIC: $dir Ӧ�ô���, ���ǲ�����, \n");
	}
}
sub dir_must_not_exist($)
{
	(my $dir)=@_;
	if( -d $dir)
	{
		my_die("PANIC: $dir  Ӧ�ò�����, ���Ǵ�����. \n");
	}
}

sub file_must_exist($)
{
	(my $file)=@_;
	if(! -f $file)
	{
		my_die("PANIC: $file �ļ�������, \n");
	}
}

