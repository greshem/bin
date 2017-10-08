#!/usr/bin/perl
#2010_07_26_21:56:08 add by qzj
use POSIX qw(strftime);
$file=$ARGV[0] or die("$0 filename \n");
if($file!~/pl$/)
{
	$file.=".pl";
}
$time=strftime("%Y_%m_%d", localtime(time()));
print $time;
open(FILE,">".$file) or die("open file error $!\n");
while(<DATA>)
{
	if(/__TEMPLATE__/)
	{
		$_=~s/__TEMPLATE__/$file/g;
		print FILE $_;
	}
	elsif(/__TIME__/)
	{
		$_=~s/__TIME__/$time/g;
		print FILE $_;
	}
	else
	{
		print FILE $_;
	}
}
close(FILE);
chmod (0776, $file);

__DATA__
#!/usr/bin/perl
#__TIME__ by qzj. 

$in=shift or die("usage: $0 input \n");
print  "__TEMPLATE__\n";

