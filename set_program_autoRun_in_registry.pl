#!/usr/bin/perl 
# win7 下直接修改的路径是了. 
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
	logger("没有指明要设定exe文件的目录路径\n");
	list_auto_run_program();
}
else
{
	if(-d  $exe_path)
	{
		$g_exe_file_name = get_exe_by_path($exe_path);
		$g_run_value = "\"".$exe_path."\\".$g_exe_file_name."\"";#写入注册表是这种格式
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
	print "注册表中已注册的自动运行程序\n";
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
		logger("[错误:]输入的路径不存在\n");
		die("[错误:]输入的路径不存在\n");
	}
	chdir($exe_path);
	
	my $exe_file_name = glob("*exe");
	if(defined($exe_file_name))
	{
		print "获取的exe文件名为:".$exe_file_name."\n";
		logger("获取的exe文件名为:".$exe_file_name."\n");			
	}
	else
	{
		logger("该路径没有.exe文件\n");
		die("该路径没有.exe文件\n");	
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
		logger("[错误:]".$Register."不存在\n");
		die($Register."不存在\n");
	}

	my $name=$input_exe;
	substr($name,-4) = "";#去除.exe
	if(!$hkey->SetValueEx($name,undef, REG_SZ,$input_exe))
	{
		logger("[错误:] 写注册表错误!");
	}
	else
	{
		print "注册表设置为 ".$input_exe."\n";
		logger("注册表设置为 ".$input_exe."\n");
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

