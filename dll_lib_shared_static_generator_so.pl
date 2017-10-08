#!/usr/bin/perl

use Cwd;
use File::Basename;

$g_pwd=getcwd();
$g_basename=basename($g_pwd);
$g_dirname=dirname($g_pwd);

my 	@obj_files=grep { -f } glob("*.o");

if(scalar(@obj_files) == 0)
{
	print " #==========================================================================  \n";
	print "#cur dir have no object file \n";
	print_demo_usage();
}
else
{
	gen_static_lib();
	gen_shared_lib();

}


########################################################################
#sub functions
sub gen_shared_lib()
{
	my 	@files=grep { -f } glob("*.o");
	print " gcc -g -shared  -o lib$g_basename.so  ".join(" ", @files)."\n";

}


sub gen_static_lib()
{
	my 	@files=grep { -f } glob("*.o");
	print " ar -r lib$g_basename.a  ".join(" ", @files)."\n";

}

sub print_demo_usage()
{
	print <<EOF
link /LIB /NOLOGO /OUT:lmyunit4.lib  file.obj file2.obj file3.obj  file4.obj
link /DLL /NOLOGO /OUT:lmyunit.dll  /LIBPATH:D:\usr\lib /INCREMENTAL:NO /NOLOGO /RELEASE /SUBSYSTEM:console /MACHINE:X86  file1.obj file2.obj file3.obj
ar -r libUnitLib.a file1.o file2.o file3.o  file4.o
gcc -g -shared   -o libUnitLib.so   file1.o file2.o file3.o  file4.o
#/root/lmyunit/lmyunit/unitcode/one_step_lib.bat       #静态库的一个例子 vc2003 下.; 
EOF
;
}




