#!/usr/bin/perl
#获取 定义 typedef struct 的时候, 但是同一行没有 { 的 行号. 

open(PIPE, "grep struct -n  *.h   |grep  typedef  -i  |grep -v '{' |")  or die("open file error \n");

for(<PIPE>)
{
	#print $_."\n";
	if($_=~/(.*?):(.*?):\s*typedef.*struct\s*(\S*)/)
	{
		#print $1."\t".$2."\t". $3."\n";
		my $file=$1;
		my $line=$2;
		my $struct_name=$3;

 		#sed '/./{N;s/\n//}' address_mail.csv 
		if(defined($struct_name))
		{
			print  "sed '/typedef.*struct.*$struct_name/\{N;s/\\n//\}'  -i  $file \n";
		}

	}
}

