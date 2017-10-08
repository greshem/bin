#!/usr/bin/perl 

use Cwd;
$pwd=getcwd();

for( grep { -f } glob($pwd."/*"))
{
	check_one_archiver($_);
}


# �� hash ת�� �������ַ���, ��һ�����Բο� "develop_perl/suffix_match_array_assign.pl" ��ʵ��.
sub check_one_archiver($)
{
   	#".rar"=>"rar x ",
	#".lha"=>"lha x ",
	#".ace"=>"unace x",

 	our %test_pack_cmd_str=(
   	".zip"=>"unzip -t ",
   	".rar"=>"rar t  ",
	".cab"=>"cabextract -t", 	
	".7z"=>" 7z x",
	".cpio"=>" cpio -t  <  ",
	".arj"=>"unarj x ", 
	".tar.gz"=>	"tar -tzf ",
	".tgz"=>	"tar -tzf ",
	".tar.bz2"=>"tar -tjf ", 
	".tbz2"=>	"tar -tjf ", 
	".tbz"=>	"tar -tjf ", 
	".tar"=>	"tar -tf ",
	);

	(my $input_file)=@_;
	logger("######\n�����ļ� $input_file\n");
	my ($name,   $suffix)=($input_file=~/(.*)(\.zip|\.rar|\.cab|\.7z|\.cpio|\.tar.gz|\.tar.bz2|\.tar)$/);
	if(!defined($suffix) )
	{
		logger("��֧�ֵĺ�׺�� $input_file \n");
		return ;
	}

	$test_cmd_str=$test_pack_cmd_str{$suffix};
	$cmd_str=$test_cmd_str.$input_file;
	system($cmd_str);
	if($? >>8 ne 0)
	{
		logger("ִ������: $cmd_str, ����.\n");
		logger("$input_file �ļ�У�����\n");
	}
}

sub logger($)
{
	(my $log_str)=@_;
	open(FILE, ">> /var/log/all_packed_check.log") or warn("open all.log error\n");
	print FILE $log_str;
	close(FILE);
}

