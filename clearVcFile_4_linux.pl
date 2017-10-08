#!/usr/bin/perl
#c:\\bin\\perl.exe
#***************************************************************************
# Description	����ֱ�������� dir_recursive_subdir_compile_dsp_dsw.pl 
# @param 	
# @return 	
#***************************************************************************/
sub  find_and_get_dsp_filelist($)
{
	(my $dir)=@_;
	my @vc_dsp_vcproj_files=();

	use File::Find ();

	use vars qw/*name *dir *prune/;
	*name   = *File::Find::name;
	*dir    = *File::Find::dir;
	*prune  = *File::Find::prune;

	sub wanted;
	sub wanted 
	{
		my ($dev,$ino,$mode,$nlink,$uid,$gid);

		(($dev,$ino,$mode,$nlink,$uid,$gid) = lstat($_));
		#$name=~s/\//\\\\/g;
		#print("$name\n");
		if($name=~/dsw$|dsp$|vcproj$|makefile.vc$|mak$/i && -f $name )
		{
			push(@vc_dsp_vcproj_files , $name);
		}
	}
	
	File::Find::find({wanted => \&wanted}, $dir);

	return @vc_dsp_vcproj_files;
}

sub clear_vcFiles_in_path($)
{
	(my $path)=@_;
	logger("��$path Ŀ¼��ʼ ����vc�ļ�\n");
	chdir_must_success_or_die($path);

	use File::Copy::Recursive qw(pathrm pathempty);
	#use File::Copy;

	for(<*>)
	{
		if(-f $_ && $_=~/\.ncb|\.plg|\.opt|\.positions|UpgradeLog.XML|MakeFile.aps|^_UpgradeReport|.suo$|.aps$|suo.old$|sln.old$|7.10.old$|ilk$|clw$|obj$|res$|pch$|pdb$|scc$|\.sbr$|\.idb$|\.tlh$|\.tli$/i)
		{
			print "rm -rf ", $_,"\n";
			unlink($_);
		}
		elsif(-d $_ && $_=~/Debug$|Release$|_UpgradeReport_Files$/i)
		{
			system("copy /y Debug\\*.exe  .") if(-d "Debug");
			system("copy /y debug\\*.exe  .") if(-d "debug");
			system("copy /y Release\\*.exe  .") if(-d "Release");
			system("copy /y release\\*.exe  .") if(-d "release");

			system("copy /y Debug\\*.dll  .") if(-d "Debug");
			system("copy /y debug\\*.dll  .") if(-d "debug");
			system("copy /y Release\\*.dll  .") if(-d "Release");
			system("copy /y release\\*.dll  .") if(-d "release");

			system("copy /y Debug\\*.lib  .") if(-d "Debug");
			system("copy /y debug\\*.lib  .") if(-d "debug");
			system("copy /y Release\\*.lib  .") if(-d "Release");
			system("copy /y release\\*.lib  .") if(-d "release");



			pathempty($_);
			pathrm($_);
			print "rm -rf ", $_,"\n";
		}
	}
}
########################################################################
sub chdir_must_success_or_die($)
{
	(my $dir)=@_;

	if(! chdir($dir))
	{ 
		my_die("$dirname_input Ŀ¼���δ���\n"); 
	}
}

sub logger($)
{
	(my $log_str)=@_;
	if($^O=~/win32/i)
	{
		open(FILE, ">>  d:\\log\\clearVcFile_4_linux.log");
	}
	else
	{
		open(FILE, ">>  /var/log/clearVcFile_4_linux.log");
	}
	print FILE $log_str;
	close(FILE);
}


########################################################################
sub my_die($)
{
	(my $log_str)=@_;
	$log_str="����:".$log_str;
	logger($log_str);
	die($log_str);
}


sub clear_vcFiles_with_fileArray(@)
{
	use File::Basename;
	(my @input_files)=@_;
	for $each_dsp (@input_files)
	{
		my $dirname=dirname($each_dsp);
		clear_vcFiles_in_path($dirname);	
		#chdir_must_success_or_die($dirname);
	}
}

########################################################################
#mainloop
use Cwd;
my $pwd=getcwd();
logger("�� $pwd Ŀ¼��ʼ �ݹ����vc�ļ�.\n");
my @dsp_files=find_and_get_dsp_filelist($pwd);
if(scalar(@dsp_files) eq 0)
{
	logger("��ǰĿ¼$pwd ��, dsp vc�����ļ�����Ϊ0\n");
	logger("ֻ�����ǰĿ¼ $pwd \n");
	clear_vcFiles_in_path($pwd);
}
else
{
	clear_vcFiles_with_fileArray(@dsp_files)
}



