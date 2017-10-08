#!/usr/bin/perl
my $total=0;
$file=shift or die("Usage: $0 fileList\n");
open(FILE, $file) or die(" open file error\n");
while(<FILE>)
{
	chomp;
	$total+= -s $_;
	
}
print "Total:"  ,$total/1024/1024/1024,"G","\n"; 
print "Total:"  ,$total/1024/1024,"M", "\n";
