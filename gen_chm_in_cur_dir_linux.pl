#!/usr/bin/perl 
use Cwd;
# �� windows ƽ̨����� cygwin ƽ̨�������У� ���Զ���û���漰�� c:\����������ġ� 
#
#$root=getcwd();   
#opendir(DIR, ".");
#@file=grep { -f && /tar.gz$/} readdir(DIR);
# �����ļ���С˳�� �������� ����������
use File::Copy::Recursive qw(fcopy pathempty pathrm);
use File::Basename;
#use get_root_dir_all_arch_type;
#use getAllFileFromDir;
@files=grep { -f } (<*.tar.gz>);

@file_sort= sort {-s $a <=> -s $b} @files;
my $number=0;
for (@file_sort)
{
	#chdir("$root");
	$number++;
	print "x"x80,"\n";
	print "Round ", $number,"Size ", int((-s $_)/1024)."K","\n";
	($name)=($_=~/(.*)\.tar\.gz/);
	$basename=basename($name);
	$chm=dirname(dirname($name))."/$basename.chm";
	print "CHM ", $chm,"\n";
	$toDir=dirname($_);
	#print $_, " -> $name\n";
	#print "tar -xzvf $_ ";
	#system("mkdir $name");
	unlink($toDir."/HTML/HTML.chm");
	if(-f $toDir."/HTML/HTML.chm" )
	{
		print " HTML.chm �Ѿ�����\n";
		next;
	}
	if( -f $chm)
	{
		print $chm,"�Ѿ�����\n";
		next;
	}
	print " tar -xzf $_ -C $toDir";
	` tar -xzf $_ -C $toDir`;
	print("cd $toDir/HTML && hhc.exe HTML.hpp\n");
	chdir("$toDir/HTML") or warn("dir not exist\n");
#	system("touch HTML.chm");
	system("wine  hhc.exe HTML.hpp");
	system(" rm -rf D ");
	system(" rm -rf I");
	system(" rm -rf R");
	system(" rm -rf defines");
	system(" rm -rf S");
	system(" rm -rf files");
	chdir("..");
	#fmove()
	#system("pwd");

	#system("cd $root/$name/HTML ");

}
