#!/usr/bin/perl
use Cwd;
use File::Basename;
my $pwd=cwd();
my $tmp=$pwd;
$tmp=~s/\//\\/g;
export_one_dir_in_win($tmp);

for (grep { -d } glob($pwd."/*"))
{
	export_one_dir_in_win($_);	
}

sub export_one_dir_in_win($)
{
	(my $pwdWin)=@_;
	$pwdWin=~s/\//\\/g;
	$pwdWin=~s/\\\\/\\/g;

	print "echo ============================ \n";
	my $name=$pwdWin;
	
	$name=~s/:/_/g;
	$name=~s/\//_/g;
	$name=~s/\\/_/g;
	#$basename = basename($pwd);

	open(FILE, $name."_share.bat");
	print FILE  "net share $name=$pwdWin  \r\n";
	print  "net share $name=$pwdWin  \r\n";
	print "pause\n";
	close(FILE);
}

# 只有在 cygwin 的perl 才运行, 现在都不需要运行了. 
sub change2Win($)
{
	($in)=@_;
	my $in2;
	if($in =~ /\/cygdrive\/([a-z]{1})\/(.*)/)
	{
		$in2=$1.":/".$2;
	}
	$in2=~s|/|\\|g;
	return $in2;
}
########################################################################
#net share LogTrans=j:\vss_working_path\[C]委托系统\委托服务平台\LogTrans  
#pause
