#!/usr/bin/perl 

do("shell_common_cmd_exec_or_die.pl");
extract_curdir_all_zips();
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

sub extract_curdir_all_zips()
{
	use Cwd;
  	$pwd=getcwd();
  	#print $pwd."\n";;
	for (grep { -f } glob($pwd."/*.zip"))
	{
		my $dest_dir=$_;
		$dest_dir=~s/\.zip$//g;
		if(! -f  $dest_dir.".tar.gz")
		{
		extract_onezip_to_onedir($_, $dest_dir);
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
sub extract_onezip_to_onedir($$)
{
	(my $input_zip, my $output_zip_dir )=@_;	
	
	logger("��ʼ���� $input_zip �ļ�\n");
	my_die("�����zip: $input_zip  �ļ������� \n") if (! -f $input_zip);
	my_die("�����zip: $input_zip  �ļ����Ǿ���·��\n") if ($input_zip !~/^\//);
	my_die("Error: �����ļ�����zip��β \n")  if ($input_zip !~/zip$|Zip$|ZIP$/);

	my $dirname_output=dirname($output_zip_dir);
	my $basename_output=basename($output_zip_dir);
	#(my $shortname)=($basename=~/(.*)\.[zip|Zip|ZIP]/); #����
	#########my $output_zip_dir=$dirname."/".$shortname;

	mkdir_if_not_exist_or_die($output_zip_dir);
	dir_must_exist_or_die($output_zip_dir);
	
	#my $unpack_cmd_str= "unzip -f $input_zip -d $output_zip_dir";	 -f fresh
	chdir_must_success_or_die($output_zip_dir);
	my $unpack_cmd_str= "unzip -u $input_zip ";	
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
sub logger($)
{
	(my $log_str)=@_;
	open(FILE, ">> /var/log/zip_2_targz.log") or warn("open all.log error\n");
	print FILE $log_str;
	close(FILE);
}

########################################################################
#

