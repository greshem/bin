#!/usr/bin/perl
#2011_07_05_10:21:25   ���ڶ�   add by greshem
#windows ��û��cygwin ������ĺ�����ʵ��.
#2011_12_05_19:12:26   ����һ   add by greshem
# ������: perl_grep_cmd.pl
sub shell_grep($$)
{
	(my $pattern, $file)=@_;
	open(GREP, $file) or die("[shell_grep]:Open file $file error\n");
	my $count=undef;
	for(<GREP>)
	{
		if($_=~/$pattern/)
		{
			$count++;
		}
	}
	close(GREP);
	return $count;
}
sub test($$)
{
		(my $pattern , $file)=@_;
	#$pattern=shift or die("Usage: $0 pattern file \n");
	#$file=shift or die("Usage: $0 pattern file \n");
	if(! -f $file)
	{
		die("$file is not a file\n");
	}
	$count=shell_grep($pattern, $file);
	#exit($count%255);
}
