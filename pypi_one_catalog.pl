#!/usr/bin/perl
use Cwd;
use File::Basename;


our  $abs_path=shift  or die("Usage: $0  keyword \n");
if( -f $abs_path   && $abs_path!~/^\//)
{
	die("abs  path must be start  /  \n");
}
our $keyword=basename($abs_path);
mkdir("/tmp3/linux_src/d_$keyword/");
chdir("/tmp3/linux_src/d_$keyword/");

if( -f  $abs_path )
{
	open(PIPE, $abs_path)  or die("open  file error  \n");
}
else
{
	open(PIPE, "pip search $keyword | ")  or die("open  pip search error \n");
}


#open(PIPE, "cat $abs_path|")    or die("open  file |$keyword|  error  \n");
for(<PIPE>)
{
	my @array=split(/\s+/, $_);
	$name=$array[0];
	system(  "perl   /root/bin/pypi_download_src.pl  $name >>  tmp   \n");	
}

system(" grep  tar.gz tmp   |grep wget  >  tmp2");
system(" rl.pl    tmp2  > tmp3  ");
system(" bash tmp3 ");
system("  /root/bin/extract_all_tar.pl  |sh ");
system("  /root/bin/for_each_dir.pl  \"bash  /root/global-4.4_logger/python_plug/one_step.sh \"  ");
