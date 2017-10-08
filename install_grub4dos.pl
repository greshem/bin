#!/usr/bin/perl

sub extract_grub4dos()
{
	#��ѹgrub4dos.zip
	if (! -d ("grub4dos-0.4.4"))
	{
		if (-f "C:\\Program Files\\WinRAR\\WinRar.exe")
		{
			if(-f "grub4dos-0.4.4-2009-01-11.zip")
			{
				system('"C:\\Program Files\\WinRAR\\WinRar.exe" x grub4dos-0.4.4-2009-01-11.zip');
				print "��ѹ���\n";
				logger("grub4dos ��ѹ���\n");
				return 0;
			}
			else
			{
				return -1;
			}
		}
		else
		{
			logger("winrar û�а�װ\n");
			print "��⵽WinRARû�а�װ��C:\\Program Files\\Ŀ¼��";
			print "���ֶ���װWinRAR��C:\\Program Files\\,Ȼ�������д˽ű�";
			return -1;
		}
	}

}

sub copy_to_dirC()
{
	system("copy /y grub4dos-0.4.4\\grldr C:\\");
	system("copy /y grub4dos-0.4.4\\menu.lst C:\\");
	if(! -f ("C:\\grldr"))
	{
		logger("����ʧ�ܣ�C����û��grldr�ļ�\n");
		exit();
	}
	if(! -f ("C:\\menu.lst"))
	{
		logger("����ʧ�ܣ�C����û��menu.lst�ļ�\n");
		exit();
	}
	else
	{
		logger("grldr menu.lst�ļ��Ѿ�������C��\n");
		print "grldr menu.lst�ļ��Ѿ�������C��\n";
	}
}
sub get_boot_ini_content()
{
	open(FILE,"C:\\boot.ini")or logger("when checking,open file boot.ini error\n");
	my $file_content;
	for(<FILE>)
	{
		$file_content .= $_;
	}
	close(FILE);
	return $file_content;
}
sub modify_boot_ini()
{
	system("attrib -R -A -H C:\\boot.ini");	
	my $ret_file_content = get_boot_ini_content();
	if($ret_file_content =~/C:\\grldr=GRUB/)
	{
		logger("C:\grldr=GRUB�Ѿ���ӵ���һ��\n");
		print "C:\grldr=GRUB�Ѿ���ӵ���һ��\n";
	}
	else
	{
		open(FILE,">>C:\\boot.ini")or logger("when modify,open file boot.ini error\n");#fixme Ϊʲô�ں�����ʼopen,�ļ�����д
		print FILE "C:\\grldr=GRUB\n";
		logger("boot.ini�Ѿ��޸ĺ�\n");
		print  "boot.ini�Ѿ��޸ĺ�\n";
		close(FILE);
	}

}

sub logger($)
{
	if( ! -d "d:\\log")
	{
		mkdir("d:\\log");
	}

	(my $log_str)=@_;
	open(FILE, ">> d:\\log\\grub4dos.log");
	print FILE $log_str;
	close(FILE);
}

if(0 == extract_grub4dos())#��ѹgrubѹ����
{
	copy_to_dirC();		#��grldr menu.lst�ļ�������C��
	modify_boot_ini();	#��boot.ini�ļ����һ��
	#system("del -S -F -Q grub4dos-0.4.4");#  fixme ɾ����ѹ�����ļ�ʧ��	
	unlink("˵��_Readme.html");
}
else
{
	print "��װ��������\n";
	logger("��װ��������\n");
}
