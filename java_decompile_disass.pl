#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__
#javap 
#jad 
/bin/unpack_all_2_targz_dir_usage.pl

#==========================================================================
#所有的jar 都反汇编成java 
for each in $(find $(pwd)  -type d ); 
do 
	echo cd $each; 
	cd $each; 
	echo jad -s javs *.class; 
	jad -s javs *.class; 
done 



