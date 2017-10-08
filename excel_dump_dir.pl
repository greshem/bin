#!/usr/bin/perl
opendir(DIR,".") or die("error opendir  $!\n");
@files=grep { -f && /xls$|XLS$/} readdir(DIR);
for(@files)
{
	($ToFile)=($_=~/(.*).xls/);
	if(! -f $ToFile.".txt")
	{
		print "/bin/excel_dump.pl $_ |/bin/utf8_to_gb2312.sh > $ToFile.txt\n";
	}
	else
	{
		print "/bin/excel_dump.pl $_ |/bin/utf8_to_gb2312.sh > $ToFile"."_q**************n.txt\n";
	}
}
