#!/usr/bin/perl -w

use Net::FTP;
use File::Basename;

die("Usage: $0 file1 file2 ...\n") if(scalar(@ARGV) == 0);
### FTP VARIABLES ###
$ftpsite=	"192.168.3.47";
$username=	"root"; 
$password=	"q**************n";
#$prefix=	"wwwroot";
#$zipfile = "init";
#$datafile=	"$prefix/$zipfile";
#$save_prefix = "/tmp";
#$saved_file = "$save_prefix/$zipfile";
####################

#$deflate_file = "CN747.DBF";
our $ftp;
$ftp = Net::FTP->new($ftpsite) or die ("Couldn't connect to ftp site!! $!\n");
print "Connected to server: $ftpsite\n";
$ftp->login($username,$password) or die ("Could not log into server $ftpsite\n"); 
print "��½ $ftpsite\n";

sub put($) {

	($file)=@_;
	$basename=basename($file);



	if(!$ftp->binary) 
	{
	 print  ("���óɶ�����ģʽʧ�� $!\n");
	}
	#$ftp->get($datafile, $saved_file) or die ("Couldn't get $datafile : $!\n");

	#ѡ��·����ʽ
	if(! $ftp->mkdir(dirname($file), 1 ))
	{
		print ("����  $file �� Ŀ¼ʧ��,next ");
		next;
	}
	#$ftp->put("$file", "wwwroot/$basename") or die ("couldnt put ip \n");
	if(!$ftp->put("$file", "$file")) 
	{
		print ("couldnt put $file to server \n");
	}
	else
	{
		print ("$_ �ļ��ϴ��ɹ�\n");
	}
}
@ARGV or die("Usage: $0 file1 file2 ...");
@files=@ARGV;

for (@files)
{
put($_);
}

	
if ($ftp->close()) {
		print "Connection closed\n";
	}
