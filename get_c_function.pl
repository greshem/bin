#!/usr/bin/perl
open(FILE,"$ARGV[0]") or die("open file error\n");
local($/);
$file=<FILE>;

#while($file=~/(\S+)\s*\((.*)\)\s*\{.*\}/)
#����Ƕ����.
#while($file=~/(\S*)\s+(\S+)\s*\((.*)\)\s+\{/g)
#���õĺ���.
while($file=~/\((.*)\)/g)
{
	if($2!~/if|while|for|switch/)
	{
	#print "$1 $2( $3 ) \n";
	print "$_ ";
	}
}
