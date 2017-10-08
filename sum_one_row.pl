#!/usr/bin/perl
##gentoo 的distfile 统计 总的文件大小: 

$file=shift ;
if(! defined($file))
{
#	open(STDIN, $file);
}
else
{
	open(STDIN, $file) or die("open file error\n");

}
$total=0;
for(<STDIN>)
{
#	if($_!~/\d$/)
#j	{
#		continue;
#	}

	#print "#====\n";
	chomp();
	$tmp=$_;
	#print "|INPUT:".$tmp."|\n";
	if($_=~/m$|M$/)
	{
		$tmp=~s/m$|M$//g;
		$tmp=$tmp*1024*1024;
		$total+=$tmp;
	}
	elsif($_=~/g$|G$/)
	{
		$tmp=~s/g$|G$//g;
		$tmp=$tmp*1024*1024*1024;
		$total+=$tmp;
	}

	elsif($_=~/k$|K$/)
	{
		$tmp=~s/k$|K$//g;
		$tmp=$tmp*1024;
		$total+=$tmp;
	}
	else
	{
		$total+=$tmp;
	}
	#print "RESULT: tmp=$tmp\n";
}
print $total,"\n";
if($total > 1024*1024*1024)
{
	print "#total ",$total/1024/1024/1024,"G\n";
}
elsif($total > 1024*1024)
{
	print "#total ",$total/1024/1024,"M\n";
}

