#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__

gawk -F\/  '{print       $1"/"$2}'    |uniq   #gentoo lib_depend.pl 
awk -F\/  '{print       $2" "$3}'   
awk -F\/  '{print       $2" "$3" "$4}' 
awk -F\/  '{print       $2" "$3" "$4" "$5}' 

awk -F, '{print $3,",",$4,",",$5,",",$6,",",$7,",",$8,",",$9}' files.csv  > content_name.txt  #csv 
awk -F, '{print $4,",",$3,",",$5,",",$6,",",$7,",",$8,",",$9}' files.csv  > name_content.txt  #csv 


