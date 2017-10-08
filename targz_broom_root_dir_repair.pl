#!/usr/bin/perl
#filename.tar.gz  ������Ŀ¼����  filename/nouse/nouse2/nouse3/nouse4/allfile.cpp 
#																	 |allfile2.cpp 
#																	 |... 
#																	 |allfile4.cpp 
#��֮Ϊɨ��rootĿ¼, ���������Ҫ�ٵ�ǰĿ¼�� ȥ��  nouse nouse2  nouse3 nouse4 ������Ŀ¼.
#��Ҫ extract_all_tar.pl �����.


#׼������.
use Cwd;
our $g_pwd=getcwd();
check_targz_files();
preprocess_with_bash_space();
chdir_must_success_or_die($g_pwd);

########################################################################
do("/bin/get_root_dir_all_arch_type.pl");
cur_dir_broom_targz_root_dir_repair();

sub cur_dir_broom_targz_root_dir_repair()
{
	
	use Cwd;
	$pwd=getcwd();
	my @subdirs=grep { -d } (glob("$pwd/*")); 
	if(scalar(@subdirs) eq 0)
	{
		die("��ǰ��Ŀ¼Ϊ0, Ӧ�� /bin/extract_all_tar.pl �⿪���е�tar.gz \n");
	}
	for $each_dir( @subdirs )
	{
		print "#���� $each_dir Ŀ¼\n";
		$sub_sub_dir=have_one_dir_and_no_files($each_dir);
		if(defined($sub_sub_dir))
		{
			logger("$each_dir �������� ���� ׼�����ƶ�\n");
			#print " cd $each_dir \n";
            #print " mv $sub_sub_dir/*  . \n"
			chdir_must_success_or_die($each_dir);
			system_exec_must_success_or_die("mv $sub_sub_dir/*  . ");
			path_must_be_empty($sub_sub_dir);
			rmrf_dir($sub_sub_dir);
		}	
		else
		{
			#logger("$each_dir ��������������\n");
			#print("$each_dir ��������������\n");
		}
	}

}
#ֻ��һ����Ŀ¼, û�������ļ�.
sub have_one_dir_and_no_files($)
{
	(my $curdir)=@_;
    my @subdirs=grep { -d } glob($curdir."/*");
    my @files=grep { -f } glob($curdir."/*");
    if(scalar(@subdirs) ne 1)
    {
        return undef;
    }
	
	if(scalar(@files) ne 0)
	{
		return undef;
	}
    return $subdirs[0];

}

#��򵥵�.
sub logger($)
{
	(my $log_str)=@_;
	open(FILE, ">> /var/log/targz_broom_root_dir_repair.log") or warn("open all.log error\n");
	print $log_str;
	print FILE $log_str;
	close(FILE);
}

sub chdir_must_success_or_die($)
{
	(my $dir)=@_;

	if(! chdir($dir))
	{ 
		my_die("$dirname_input Ŀ¼���δ���\n"); 
	}
}


sub system_exec_must_success_or_die($)
{
	(my $cmd_str)=@_;
	#logger("ִ������: $cmd_str\n");
	system($cmd_str);
	if($?>>8 ne 0)
	{
		my_die("������: $cmd_str ִ��ʧ��\n");
	}
}

sub path_must_be_empty($)
{
	(my $curdir)=@_;
    my @subdirs=grep { -d } glob($curdir."/*");
    my @files=grep { -f } glob($curdir."/*");
    if(scalar(@subdirs) ne 0)
    {
		my_die("$curdir ��Ϊ��Ŀ¼, Ŀ¼��Ϊ��\n");
    }
	
	if(scalar(@files) ne 0)
	{
		my_die("$curdir ��Ϊ��Ŀ¼,�ļ���Ϊ��\n");
	}
	return 1;
}

sub my_die($)
{
	(my $log_str)=@_;
	$log_str="����:".$log_str;
	logger($log_str);
	die($log_str);
}

#ʵ�ֺ�shell ����: rm -rf input_dir  һ����Ч��.
sub rmrf_dir($)
{
	use File::Copy::Recursive qw(pathmk dirmove pathrm pathempty );
	(my $input_dir)=@_;
	if(! -d $input_dir)
	{
		logger("rm_rf: ����� $input_dir ����Ŀ¼ ���߲����� \n");
	}	

	pathempty($input_dir);
	pathrm($input_dir);

	logger("ɾ��Ŀ¼: $input_dir \n");
	my_die("Panic: $input_dir �ļ�û��ɾ����") if(-d $output_zip_dir); #�ز�������.
}


sub check_targz_files()
{
	use Cwd;
	$pwd=getcwd();
	my @targzs=grep { -f } (glob("$pwd/*.tar.gz")); 
	if(scalar(@targzs) eq 0)
	{
		die("��ǰ tar.gz Ϊ0, �˳�\n");
	}

}

sub preprocess_with_bash_space()
{
	use Cwd;
	$pwd=getcwd();
	my @subdirs=grep { -d } (glob("$pwd/*")); 
	for $each_dir( @subdirs )
	{
		chdir_must_success_or_die($each_dir);
		system_exec_must_success_or_die("/bin/delete_space_for_bash.pl> /dev/null ");
	}

}

