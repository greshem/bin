#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__

gen_makefile_from_file_latest.pl  backtrace_.cpp 

make			#gen asm 
readelf   --debug-dump=rawline backtrace_  >  backtrace_.rawline
readelf   --debug-dump=decodedline backtrace_  > backtrace_.decodedline
objdump -d -S -C  -l  backtrace_  > backtrace_.asm

nm -e  backtrace_ |grep T |c++filt  >  backtrace_.nm
gdb ./backtrace_ 
disass /m  test_funcion

#help with /bin/code_cross_index.pl

laytout dissy #gui to nm readelf objdump
