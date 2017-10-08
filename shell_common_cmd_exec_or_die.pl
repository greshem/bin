
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
	use File::Copy::Recursive qw(pathmk dirmove pathrm pathempty );
	(my $input_dir)=@_;
	if(! -d $input_dir)
	{
		logger("rm_rf: ����� $input_dir ����Ŀ¼ ���߲����� \n");
	}	

	pathempty($input_dir);
	pathrm($input_dir);

	my_die("Panic: $input_dir �ļ�û��ɾ����") if(-d $output_zip_dir); #�ز�������.
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

