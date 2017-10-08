#!/usr/bin/perl 
#ע�⴫����ļ��� Ӧ��������һ��ISO ��, 
#use strict;

$path=shift or die("Usage: $0  iso_file_path\n");

our $g_desktop_path=shift;

logger_copy_BBB("#�����ļ� iso_copy_out_to_desktop.pl \"$path\" \n");

if($^O=~/win/i)
{
	do("c:\\bin\\repaire_perl_path_2_win32.pl");
	do("c:\\bin\\iso_get_mobile_disk_label.pl");
	do("c:\\bin\\repaire_perl_path_2_win32.pl");
}
else
{
	do("/bin/iso_get_mobile_disk_label_linux.pl");
	#do("iso_get_mobile_disk_label.pl");
}


my $isoname;
my $filename;
if($^O=~/win/i)
{
	if(-f $path || -d $path)
	{
			$path=~s/\//\\/g;
			$path=~s/\\\\/\\/g;
			$path=~s/\\\\/\\/g;
			$path=~s/\\\\/\\/g;  #explorer ����\\ ������, ȷ��, û������.
			print("  Explorer   /select,$path");
			system("  Explorer   /select,$path");
			die("�ļ�$path ���� ������ת�� \n");
	}
	elsif($path=~/(sdb.*iso)\\(.*)/)
	{
		print "#ISO=>: ". $1."\n";
		print "#File=>: ". $2."\n";
		$isoname=$1;
		$filename=$2;
	}
	else
	{
		die("windows ·����ʽ����\n");
	}
}
else
{

	if($path=~/(sdb.*\.iso)\/(.*)/)
	{
		print "ISO=>: ". $1."\n";
		print "File=>: ". $2."\n";
		$isoname=$1;
		$filename=$2;
		$isoname=~s/\\/\//g;
		$filename=~s/\\/\//g;
	}

	else
	{
		die("linux ·����ʽ����, ·����ʽ û�� .iso ���� \n");
	}

}


if($^O=~/win/i)
{
	$isoname = change_mobile_path_to_win_path($isoname);
}
else
{
	$isoname = change_mobile_path_to_linux_path($isoname);
}
if(! -f $isoname)
{
	die("$isoname �ļ�������\n");
}

print ("ie.pl  \"$isoname\" \n");
mount_iso($isoname);

if($^O=~/win/i)
{
	#our $g_desktop_path="C:\\Documents and Settings\\Administrator\\����\\";
	if( ! defined($g_desktop_path))
	{
		$g_desktop_path="C:\\Users\\Administrator\\Desktop\\";
	}
}
else
{
	$g_desktop_path="/tmp/";
}
if(-f ("P:\\$filename"))
{
	if( -f "c:\\cygwin\\cp.exe")
	{
		print ("ie.pl  \"$isoname\" \n");
		print ("ie.pl  \"P:$filename\"\n");
		print ("cp  \"P:\\$filename\"  \"$g_desktop_path\"\n");
		system("cp  \"P:\\$filename\"  \"$g_desktop_path\"\n");
		$filename=repaire_to_win_path($filename);
		system("  Explorer   /select,P:\\$filename");
	}
	else
	{
	use File::Basename;
	#our $g_pwd=getcwd();
	#our $g_basename=basename($g_pwd);
	#our $g_dirname=dirname($g_pwd);


		print ("ie.pl  \"$isoname\" \n");
		print ("ie.pl  \"P:$filename\"\n");
		my $basename=basename($filename);
		if(! -f "$g_desktop_path\\$basename")
		{
			#logger_copy_BBB("$g_desktop_path\\$basename ������, \n");
			print ("copy   \"P:\\$filename\"  \"$g_desktop_path\"\n");
			system("copy   \"P:\\$filename\"  \"$g_desktop_path\"\n");
		}
		else
		{
			my $rand_number=int(rand(1000));
			my $version_number=get_Version_number("P:\\$filename");
			$rand_number=$version_number;
			logger_copy_BBB("���Ϊ: $g_desktop_path\\${rand_number}_${basename} \n");
			print ("copy   \"P:\\$filename\"  \"$g_desktop_path\\${rand_number}_${basename}\"\n");
			system("copy   \"P:\\$filename\"  \"$g_desktop_path\\${rand_number}_${basename}\"\n");
			#system("copy   \"P:\\$filename\"  \"$g_desktop_path\"\n");
		}
		$filename=repaire_to_win_path($filename);
		$filename=~s/^\\//g;
		print("FFFFF:   Explorer   /select,P:\\$filename");
		system("  Explorer   /select,P:\\$filename");
	}
}
elsif (-d  ("P:\\$filename"))
{
		my $last="P:\\".$filename;
		$last=~s/\\\\/\\/g;
		#system("  Explorer   /select,P:\\${last}");
		#print ("  Explorer   /select,P:\\${last}");
		system(" Explorer   /select,".$last);
		print ( "Explorer   /select,".$last);
}
elsif(-f ("/mnt/iso_mount_dir/$filename"))
{
	print ("cp  /mnt/iso_mount_dir/$filename  /tmp/ \n");
}
elsif(-d ("/mnt/iso_mount_dir/$filename"))
{
	print ("cd  /mnt/iso_mount_dir/$filename   \n");
}
else
{
	
	$filename= repaire_to_win_path($filename);
	print ("  Explorer   /select,P:$filename");
	die("PANIC: ������, $filename ������\n");
}

########################################################################
sub mount_iso($)
{
	(my $isoname)=@_;
	if( ! -f $isoname)
	{
		print $isoname."�ļ�������\n";
		return ;
	}
	if($^O=~/win/i)
	{
		print "#iso��windows·����:  $isoname \n";
		#system("batchmnt64.exe /unmountall  ");
		print("batchmnt64.exe /unmountall  \n");
		print("batchmnt64.exe /unmount p:  \n"); #ע��ð��
		system("batchmnt64.exe /unmount p:  "); #ע��ð��
		print("\nbatchmnt64.exe $isoname   p\n");
		system("batchmnt64.exe $isoname    p /wait");
		#print "#sleep 2�� �ȴ� ���̾����ʼ��\n";
		#sleep(2);

		if( ! -d "p:\\")
		{
				warn("PANIC: P �̴���: why?\n");
		}
	}
	else
	{
		if(! -d  "/mnt/iso_mount_dir/")
		{
			mkdir("/mnt/iso_mount_dir/");
		}

		system("mount -t iso9660 $isoname /mnt/iso_mount_dir/  -o loop ");
	}

}

sub logger_copy_BBB($)
{
	use POSIX 'strftime';

	(my $log_str)=@_;
	if(! -d "c:\\log\\")
	{
		mkdir("c:\\log\\");
	}
 	my $log_time;
	if($^O=~/win/i)
	{
	$log_time = POSIX::strftime('%Y-%m-%d-%H:%M:%S',localtime(time()));
	open(FILE, ">>c:\\log\\iso_copy_out_to_desktop.log");
	}
	else
	{
	$log_time = POSIX::strftime('%Y-%m-%d-%T',localtime(time()));
	open(FILE, ">>/var/log/iso_copy_out_to_desktop.log");
	}
	print FILE  "[$log_time]: $log_str";
	close(FILE);
}

#ProductVersion
sub get_Version_number
{
	use Win32::File::VersionInfo;
	
    my $file = shift;
    my $ver = GetFileVersionInfo($file);
    return 0 if(!$ver);

	#print Data::Dumper->Dump([$ver]);

    my $lang = ( keys %{$ver->{Lang}} )[0] ;
    if($lang){
        $copyright = $ver->{Lang}{$lang}{LegalCopyright};
		$desc=       $ver->{Lang}{$lang}{FileDescription};
		$version=    $ver->{Lang}{$lang}{ProductVersion};
		$fileVersion =  $ver->{Lang}{$lang}{FileVersion};
		$desc=  $ver->{Lang}{$lang}{FileDescription};
        #print $copyright,"\n";
		#print $version."\t";
		#print $fileVersion."\t";
		
		return $version
    }
    return undef;
}
