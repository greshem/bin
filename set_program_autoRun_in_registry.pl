#!/usr/bin/perl 
# win7 ��ֱ���޸ĵ�·������. 
# [HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Run]
#regjump  HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Run

use Win32::Registry;
my %RegType = (
  0 => 'REG_0',
  1 => 'REG_SZ',
  2 => 'REG_EXPAND_SZ',
  3 => 'REG_BINARY',
  4 => 'REG_DWORD',
  5 => 'REG_DWORD_BIG_ENDIAN',
  6 => 'REG_LINK',
  7 => 'REG_MULTI_SZ',
  8 => 'REG_RESOURCE_LIST',
  9 => 'REG_FULL_RESOURCE_DESCRIPTION',
 10 => 'REG_RESSOURCE_REQUIREMENT_MAP');

my $exe_path = shift or warn("usage: $0 [full_path.exe]\n\n");
if(!defined($exe_path))
{
	logger("û��ָ��Ҫ�趨exe�ļ���Ŀ¼·��\n");
	list_auto_run_program();
}
else
{
	if(-d  $exe_path)
	{
		$g_exe_file_name = get_exe_by_path($exe_path);
		$g_run_value = "\"".$exe_path."\\".$g_exe_file_name."\"";#д��ע��������ָ�ʽ
	}
	else
	{
		$g_exe_file_name= $exe_path;
		$g_run_value=$g_exe_file_name;
	}
	modify_register($g_exe_file_name);

	print "regjump  HKEY_LOCAL_MACHINE\\SOFTWARE\\Wow6432Node\\Microsoft\\Windows\\CurrentVersion\\Run \\n";

}


#########################################################################
#--------------------------------------------------------------------------
sub list_auto_run_program()
{
	print "ע�������ע����Զ����г���\n";
	my $Register = "SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Run";
    my ($hkey,@key_list,$key);
    my ($hNode,$Key,%values);
    my ($RegType,$RegValue,$RegKey,$outline);

    $HKEY_LOCAL_MACHINE->Open($Register,$hkey)||return;
    $hkey->GetValues(\%values);
    foreach my $value (keys(%values))
    {
        $RegType = $values{$value}->[1];
        $RegValue = $values{$value}->[2];
        $RegKey = $values{$value}->[0];
        next if ($RegType eq '');
        my $line='';
        $line=sprintf("%s","$RegValue");
        print "$line"."\n";
    }

    $hkey->Close();	
}
#--------------------------------------------------------------------------
sub get_exe_by_path($)
{
	(my $exe_path) = @_;
	if(!(-d $exe_path))
	{
		logger("[����:]�����·��������\n");
		die("[����:]�����·��������\n");
	}
	chdir($exe_path);
	
	my $exe_file_name = glob("*exe");
	if(defined($exe_file_name))
	{
		print "��ȡ��exe�ļ���Ϊ:".$exe_file_name."\n";
		logger("��ȡ��exe�ļ���Ϊ:".$exe_file_name."\n");			
	}
	else
	{
		logger("��·��û��.exe�ļ�\n");
		die("��·��û��.exe�ļ�\n");	
	}
	return $exe_file_name;
}
#--------------------------------------------------------------------------
sub modify_register($)
{
	(my $input_exe)=@_;
	
	my $Register = "SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Run";
	my $hkey;

	if( ! $HKEY_LOCAL_MACHINE->Open($Register , $hkey) )
	{
		logger("[����:]".$Register."������\n");
		die($Register."������\n");
	}

	my $name=$input_exe;
	substr($name,-4) = "";#ȥ��.exe
	if(!$hkey->SetValueEx($name,undef, REG_SZ,$input_exe))
	{
		logger("[����:] дע������!");
	}
	else
	{
		print "ע�������Ϊ ".$input_exe."\n";
		logger("ע�������Ϊ ".$input_exe."\n");
	}
	$hkey->Close();	
}
#--------------------------------------------------------------------------
sub logger($)
{
	if( ! -d "d:\\log")
	{
		mkdir("d:\\log");
	}

	(my $log_str)=@_;
	open(FILE, ">> d:\\log\\set_program_autoRun_by_register.log");
	print FILE $log_str;
	close(FILE);
}

