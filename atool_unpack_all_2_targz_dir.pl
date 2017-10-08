#!/usr/bin/perl
#2011_11_10_10:47:26   ������   add by greshem
#�ο��ϰ汾�� perl_new_20081125_unpack_all.pl 
#�Լ����°汾�� unpack_all.pl, �ó���������ݿ�.
#ע��: ��chdir Ȼ�� �� unpack_cmd inputfile �������� �������ֲ�ķ�ʽ, ���һ��������, �����������������.  
# dtrx # yum install dtrx 
#
sub  del_gentoo_package_dir()
{
    do("/root/bin/gentoo_common.pl");
    %g_chm=load_chm_file_info();
    extract_gentoo_tarball();
}

#$db=\%g_chm;

#/media/sda3/gentoo_portage_ISO_10_iso/dev-scheme/hop	INFO: hop-2.0.1.chm #�д����ļ�3�� 
#chm_exist_in_isodb_OK_method2(\%g_chm, "hop-2.0.1.chm");

unpack_all(".tar.gz");
unpack_all(".zip");

#for  $each ( glob("*.tar.gz"))
#{
#    atool_unpack_one("$targz");
#}


sub extract_gentoo_tarball()
{
	open(FILE, "Manifest") or die("open Manifest error , maybe not in gentoo portage dir \n");
	for(<FILE>)
	{
		if($_=~/^DIST/)
		{
			my @array=split(/\s+/, $_);
			my $targz=$array[1];
			print "#".$targz."\n";


			if($targz!~/\.tar.gz$|\.tar.bz2$|\.tar.xz$|\.tgz$|\.tar.Z$|\.tar.lzma$|\.zip$|\.tbz$|\.tbz2$|\.rar$|\.tar$/)	
			{
				next;
			}
			my $name=delete_targz_suffix($targz);
			if(chm_exist_in_isodb_OK_method2(\%g_chm, "$name.chm"))
			{
				print "# eden iso chm �Ѿ�����, atool ���ٽ�ѹ�� \n";
				next;
			}
			if(-f $targz)
			{
				atool_unpack_one("$targz");
			}
			else
			{
				print "#ERROR: $targz not exists \n";
			}
		}
	}
}

sub test()
{
	unpack_all(".zip");
	unpack_all(".rar");
	unpack_all(".tar.gz");
	unpack_all(".tar.bz2");
	unpack_all(".tar");
	unpack_all(".tgz");
	unpack_all(".cpio");
	unpack_all(".7z");
	unpack_all(".jar");
}

sub atool_unpack_one()
{
	(my $input_file  )=@_;
	my  $name=delete_targz_suffix($input_file);
	if( -f $name.".chm")
	{
		print "#$name.chm �Ѿ����� , skip \n";
		return ;
	}
	if( -d $name)
	{
		print "#$name/, already exists \n";
		return ;
	}
	if(tar_subdir_hava_same_name($input_file, $name))
	{
		print "#һ��Ŀ¼�� ������ͬ,  ֱ�ӽ�ѹ\n";
		print "atool -x $input_file\n";
	}
	else
	{	
		print "#һ��Ŀ¼�� ���ֲ�ͬ,  ����Ŀ¼֮���ѹ\n";
		mkdir($name);
		print "atool -X $name  $input_file\n";

	}
}

#tar gz ��Ŀ¼������ �� ��������� ��ͬ 
sub tar_subdir_hava_same_name($$)
{
	(my $input_file, $pattern)=@_;
	my $count=0;
	my $file_lines=0;
	open(PIPE, "atool -l $input_file|") or die("open $input_file error \n");
	for(<PIPE>)
	{
		$file_lines++;
		if($_=~/\/$pattern\//i)
		{
			$count++;
		}
	}
	if($count != $file_lines)
	{
		return undef;
	}

	return $count;
}




sub check_pattern($)
{
	(my $input_file)=@_;
	open(FILE, "atool -L $input_file");
}

sub unpack_all($)
{
 	our %unpack_cmd_str=(
   	".zip"=>"unzip ",
   	".jar"=>"jar -xvf  ",
   	#".rar"=>"rar x ",
   	".rar"=>"rar x  -o+ -r ",
	".cab"=>"cabextract ", 	
	".7z"=>" 7z x",
	".cpio"=>" cpio -iv <  ",
	".lha"=>"lha x ",
	".arj"=>"unarj x", 
	".ace"=>"unace x",
	".tar.gz"=>"tar -xzvf ",
	".tgz"=>"tar -xzvf ",
	".tar.bz2"=>"tar -xjvf", 
	".tbz2"=>"tar -xjvf", 
	".tbz"=>"tar -xjvf", 
	".tar"=>"tar -xf",
	".lzma"=>"lzma -d ",
	);

	(my $suffix)=@_;
	if($suffix!~/^\./)
	{
		die("��׺���е� .suffix .zip .rar .tar.gz\n"); 
	}
	$cmd_str= $unpack_cmd_str{$suffix};
	if(!defined($cmd_str))
	{
		die("��֧�ֵĽ�ѹ��ʽ\n");
	}
	use Cwd;
	$pwd=getcwd();

	for( grep { -f } glob($pwd."/*$suffix"))
	{
		my $dest_dir=$_;
		$dest_dir=~s/${suffix}$//g;
		if(! -d  $dest_dir)
		{
			print "##############\n";
			print "mkdir $dest_dir\n";
			print "cd $dest_dir\n";
			print "$cmd_str $_ \n"; 
			print "#help with targz_broom_root_dir_repair.pl \n";
		}
	}
}

sub shell_usage()
{
	foreach (<DATA>)
	{
		print $_;
	}
}
__DATA__
#!/bin/bash
for each in $(dir -1 |grep rar$)
do
#x extrace
#-o+   ����ģʽ. 
#r 	 �ݹ�ģʽ.
#  $each �� ��ѹ�ļ�. 
#  ���һ���� �����Ŀ¼�� ����û�����Ŀ¼�� �����´������Ŀ¼.  
echo unrar x -o+ -r $each ${each%%.rar}
unrar x -o+ -r $each ${each%%.rar}
	if [ $? -eq 1 ];then
		mkdir ${each%%.rar}
		unrar x -o+ -r $each ${each%%.rar}

	fi
done

