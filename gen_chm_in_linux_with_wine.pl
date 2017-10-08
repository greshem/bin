#!/usr/bin/perl 
use Cwd;
# 在 windows 平台下面的 cygwin 平台下面运行， 所以都是没有涉及到 c:\这样的问题的。 
#
#$root=getcwd();   
#opendir(DIR, ".");
#@file=grep { -f && /tar.gz$/} readdir(DIR);
# 按照文件大小顺序 进行排序， 并进行制作
use File::Copy::Recursive qw(fcopy pathempty pathrm);
use File::Basename;
#use get_root_dir_all_arch_type;
#use getAllFileFromDir;
$in=$ARGV[0] or die("Usage: $0 filelist or dir\n");
my @files;
if(-d $in)
{
	@tmp = grep {-f && /tar.gz$/} getAllFileFromDir($in);
	@files=sort{ (-s $a)<=>(-s $b)} @tmp;
}
else
{
	open(FILE, $in) or die("open file error\n");
	@tmp=(<FILE>);
	@tmp2=map{chomp; $_;} @tmp;
	@files=grep { -f && /tar.gz$/} @tmp2;
}

@file_sort= sort {-s $a <=> -s $b} @files;
#@file_sort=@files;
my $number=0;
for (@file_sort)
{
	#chdir("$root");
	$number++;
	print "x"x80,"\n";
	print "Round ", $number,"Size ", int((-s $_)/1024)."K","\n";
	($name)=($_=~/(.*).tar\.gz/);
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
		print " HTML.chm 已经生成\n";
		next;
	}
	if( -f $chm)
	{
		print $chm,"已经生成\n";
		next;
	}
	print " tar -xzf $_ -C $toDir";
	` tar -xzf $_ -C $toDir`;
	print("cd $toDir/HTML && hhc.exe HTML.hpp\n");
	chdir("$toDir/HTML") or warn("dir not exist\n");
#	system("touch HTML.chm");
	system("wine  hhc.exe HTML.hpp");
	system(" mv HTML.chm $chm");
	system(" net_ftp_put_chm_back_v2.pl $chm");
	system(" rm -rf D ");
	system(" rm -rf I");
	system(" rm -rf R");
	system(" rm -rf defines");
	system(" rm -rf S");
	system(" rm -rf files");
	#system("pwd");

	#system("cd $root/$name/HTML ");

}
