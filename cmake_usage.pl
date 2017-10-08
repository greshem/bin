#!/usr/bin/perl

use Cwd;
use File::Basename;

our $g_pwd=getcwd();
our $g_basename=basename($g_pwd);
our $g_dirname=dirname($g_pwd);

gen_static_lib();
common_usage();


########################################################################
sub gen_exe_elf()
{
	my @files=glob("*.cpp");
	my $file_str=join(" ", @files);


	open(CMAKE, "> CMakeLists.txt") or die("create CMakeLists.txt error , $!\n");
	print CMAKE <<EOF
project($g_basename)
add_executable($g_basename  $file_str)
EOF
;
	print "#cmake for executable ,  CMakeLists.txt, have generated \n";
}

sub gen_static_lib()
{
	my @files=glob("*.cpp");
	my $file_str=join(" ", @files);


	open(CMAKE, "> CMakeLists.txt") or die("create CMakeLists.txt error , $!\n");
	print CMAKE <<EOF
project($g_basename)
add_library($g_basename  STATIC  $file_str)
EOF
;

	print "#cmake for library ,  CMakeLists.txt, have generated \n";
}

sub gen_shared_lib()
{
	my @files=glob("*.cpp");
	my $file_str=join(" ", @files);


	open(CMAKE, "> CMakeLists.txt") or die("create CMakeLists.txt error , $!\n");
	print CMAKE <<EOF
project($g_basename)
add_library($g_basename  SHARED  $file_str)
EOF
;

	print "#cmake for library ,  CMakeLists.txt, have generated \n";
}

sub common_usage()
{
	print <<EOF
#==========================================================================
cmake ./  && make  
cmake -G "MinGW Makefiles"
EOF
;
}
