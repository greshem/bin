#!/usr/bin/perl 
$g_package="commLib_r261.rar";
$g_output_dir="commLib";
$g_url="http://nchc.dl.sourceforge.net/project/commLib/commLib/2.6.2/commLib_2_6_2.zip";

sub check_cpp_env()
{
	
	$vc_2003= "C:\\Program Files\\Microsoft Visual Studio\ .NET\ 2003\\Vc7\\bin";
	$vc_2003_upper= "C:\\Program Files\\Microsoft\ Visual Studio\ .NET\ 2003\\VC7\\BIN";
	$bakefile="C:\\Program Files\\Bakefile";
	$cygwin="c:\\cygwin";
	push( @progs_path , $cygwin);
   	push( @progs_path , $vc_2003);
	push( @progs_path , $vc_2003_upper);
	push(@progs_path, $bakefile);
	
	for $each (@progs_path)
	{
		if( ! -d  $each)
		{
				warn("$each û�а�װ\n");
				logger("vc2003 û�а�װ ���Ȱ�װvc2003\n");
		}
	}
}

#########################################################################
sub commLib_have_install()
{
	$include_dir= "D:\\usr\\include\\commLib";
	if( ! -d  $include_dir )
	{
		logger("commLib û�а�װ, ��Ϊû�ж�Ӧ�� $include_dir Ŀ¼\n");
		return 0;
	}
	if( ! -d  "D:\\usr\\lib")
	{
		mkdir("D:\\usr\\lib");
	}
}
sub download_commLib()
{
	if ( -f "C:\\cygwin\\bin\\wget.exe")
	{
		if(! -f "$g_package")
	   	{	
			system("C:\\cygwin\\bin\\wget.exe  $g_url");
			if( ! -f "$g_package")
			{
				logger("wget ֮�� ���ǲ� ����, ��ַ����, �������粻ͨ\n");
				die("wget ֮�� ���ǲ� ����, ��ַ����, �������粻ͨ\n");
			}
		}
		else
		{
			logger(" $g_package �ļ����� ����������\n");
		}
	}
	else
	{
		logger("wget.exe û��, û�а�װ cygwin \n");
		warn("$g_package û��, ȥ ����\n");
		print "�뵽������ַȥ����: ";
		print "���غ�, $g_package �ŵ���ǰĿ¼,Ȼ��������д˽ű�,�벻Ҫ�ֶ���װcommLib";
	}
}


sub create_commLib_bkl()
{

	@cpp_files=glob("*.cpp");
	if( scalar(@cpp_files)== 1)
	{
		logger("ע��; ���� commLib ���ϰ汾, ֻ��һ��cpp �ļ�\n");
	}
	open(FILE, "> build.bkl") or die("create file error\n");
	print FILE <<EOF
<?xml version="1.0" ?>
	<!-- \$Id: bakefile_quickstart.txt,v 1.5 2006/02/11 18:41:11 KO Exp \$ -->
	<makefile>
			<lib id="commLib">
				<cxxflags>/Od</cxxflags>
				<cxxflags>/D_DEBUG</cxxflags>
				<cxxflags>/D_LIB</cxxflags>
				<cxxflags>/D_MBCS</cxxflags>
				<cxxflags>/Gm</cxxflags>
				<cxxflags>/RTC1</cxxflags>
				<cxxflags>/W3</cxxflags>
				<cxxflags>/TP</cxxflags>
				<cxxflags>/ZI</cxxflags>
				<cxxflags>/MTd</cxxflags>
				<ldflags>/NOLOGO</ldflags>
				<include>include</include>
				<sys-lib>kernel32</sys-lib>
				<sys-lib>user32</sys-lib>
				<sys-lib>gdi32</sys-lib>
				<sys-lib>winspool</sys-lib>
				<sys-lib>comdlg32</sys-lib>
				<sys-lib>advapi32</sys-lib>
				<sys-lib>shell32</sys-lib>
				<sys-lib>ole32</sys-lib>
				<sys-lib>oleaut32</sys-lib>
				<sys-lib>uuid</sys-lib>
				<sys-lib>odbccp32</sys-lib>
				<sys-lib>ws2_32</sys-lib>

				<sources>\$(fileList('*.cpp'))</sources>

			</lib>
			
	</makefile>
EOF
;
	close(FILE);
	if( -f "build.bkl")
	{
		logger("build.bkl �ļ����ɳɹ�\n");
	}
	else
	{
		logger("build.bkl �ļ�����ʧ��, windows ϵͳȨ������? \n");
	}
}

#����commLib �Ĵ���Ŀ¼.
sub compile_commLib_and_copy_install()
{
		system("bakefile -f msvc build.bkl");
		if(! -f "makefile.vc")
		{
			logger("Panic:  compile_commLib_and_copy_install ����,  makefile.vc �ļ�������, �����޷�����, die\n");
			die("Panic: makefile.vc �ļ�������\n");
		}
		
		system("nmake /f makefile.vc");
		
		if(! -f "commLib.lib")
		{
			logger("commLib.lib �ļ�������, ������� ");
			die("commLib.lib �ļ�������, ������� ");
		}
		system("copy /y commLib.lib D:\\usr\\lib\\");
		if( ! -d "D:\\usr\\include\\commLib")
		{
			mkdir("D:\\usr\\include\\commLib")
		}
		system("xcopy /y /S include\\*.h D:\\usr\\include\\commLib");
}
sub extract_commLib()
{
	#��ѹ$g_package
	logger("��ѹ $g_package \n");
	if (-f "C:\\Program Files\\WinRAR\\WinRar.exe")
	{
		system("\"C:\\Program Files\\WinRAR\\WinRar.exe\" x $g_package");
	}
	else
	{
		print "��⵽WinRARû�а�װ��C:\\Program Files\\Ŀ¼��";
		print "���ֶ���װWinRAR��C:\\Program Files\\,Ȼ�������д˽ű�";
		exit();
	}
		
			#system("copy /y commLib-1.6.0\\src\\commLib-all.cc commLib-1.6.0\\")

}
sub check_commLib()
{
	$commLib_lib= "d:\\usr\\lib\\commLib.lib";
	if (!  -f  $commLib_lib)
	{
		logger("commLib.lib ������,   ���Ʊ���û�гɹ�\n");
		die("commLib.lib ������,   ���Ʊ���û�гɹ�\n");
	}
	else
	{
		logger(" $commLib_lib ���� ���밲װ�ɹ�\n");
	}

	if ( ! -d "d:\\usr\\include\\commLib\\")
	{
		die("commLib include Ŀ¼������,  copy Ҳ�����.\n");
		logger("commLib include Ŀ¼������,  copy Ҳ�����.\n");
	}
}


sub logger($)
{
	(my $log_str)=@_;
	
	if($^O=~/win32/i)
	{
		if(! -d ("d:\\log"))
		{
			mkdir("d:\\log");
		}
		open(FILE, ">>  d:\\log\\commLib_install.log");
	}
	else
	{
		open(FILE, ">> /var/log/commLib_install.log");
	}

		print FILE $log_str;
		close(FILE);
}
logger("this is a logger\n");


sub check_dir_delete($)
{
	(my $delete_dir)=@_;
	(! -d $delete_dir) && logger(" $delete_dir Ŀ¼ɾ���ɹ�\n");
	(  -d $delete_dir) && logger(" $delete_dir Ŀ¼ɾ��ʧ��\n");
}
sub check_file_delete($)
{
	(my $delete_file)=@_;
	(! -d $delete_file) && logger(" $delete_file �ļ�ɾ���ɹ�\n");
	(  -d $delete_file) && logger(" $delete_file �ļ�ɾ��ʧ��\n");
}

########################################################################
sub clean_commLib()
{
	my $include_dir= "d:\\usr\\include\\commLib\\" ;
	system("erase /S   /Q  $include_dir ");
	check_dir_delete($include_dir);
	

	my $lib_file= "d:\\usr\\lib\\commLib.lib" ;
	system("erase /S   /Q  $lib_file ");
	check_file_delete($lib_file);

	my $extract_dir= "tinxyml";
	system("erase /S /Q $extract_dir ");
	check_dir_delete($extract_dir);

}
sub install_commLib()
{
	check_cpp_env();
	commLib_have_install();
	download_commLib();
	extract_commLib();

	if(! -d "$g_output_dir")
	{
		logger("Error: ��ѹ֮���Ŀ¼ , ������, ��ѹ����");
		die("Error: ��ѹ֮���Ŀ¼ , ������, ��ѹ����");

	}
	chdir("$g_output_dir");
	if( ! -f "makefile.vc")
	{
		create_commLib_bkl();
	}
	else
	{
		logger("Դ��Ŀ¼ ����, makefile.vc �ļ�, ������ȥ����bkl �ļ���\n");
	}
	compile_commLib_and_copy_install();
	chdir("..");
	check_commLib();
}
$mode= shift;
if(defined($mode))
{
	clean_commLib();
}
else
{
	install_commLib();
}
