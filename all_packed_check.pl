#!/usr/bin/perl 

use Cwd;
$pwd=getcwd();

for( grep { -f } glob($pwd."/*"))
{
	check_one_archiver($_);
}


# 把 hash 转成 正则表达字符串, 进一步可以参看 "develop_perl/suffix_match_array_assign.pl" 的实现.
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
	logger("######\n处理文件 $input_file\n");
	my ($name,   $suffix)=($input_file=~/(.*)(\.zip|\.rar|\.cab|\.7z|\.cpio|\.tar.gz|\.tar.bz2|\.tar)$/);
	if(!defined($suffix) )
	{
		logger("不支持的后缀名 $input_file \n");
		return ;
	}

	$test_cmd_str=$test_pack_cmd_str{$suffix};
	$cmd_str=$test_cmd_str.$input_file;
	system($cmd_str);
	if($? >>8 ne 0)
	{
		logger("执行命令: $cmd_str, 错误.\n");
		logger("$input_file 文件校验错误\n");
	}
}

sub logger($)
{
	(my $log_str)=@_;
	open(FILE, ">> /var/log/all_packed_check.log") or warn("open all.log error\n");
	print FILE $log_str;
	close(FILE);
}

