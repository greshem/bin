#!/usr/bin/perl
use File::Copy::Recursive qw(pathmk dircopy dirmove fmove);
warn("WARN: ע��  windows �µĻ��з�������, ctrl-M , dos2unix ת��һ��. \n");
opendir(DIR, ".") or die("open dir error\n");
#@dirs= grep { length($_)>2 && -d && !/\./} readdir(DIR);
@dirs= grep { length($_)>2 && -f  } readdir(DIR);

for(@dirs)
{
	#$tmp=lc(substr($_,0,1))."/";
	$tmp=lc(substr($_,0,1))."/".lc(substr($_,0,2))."/";
	pathmk($tmp);
	
	print "mv    ",$_,"   ", $tmp,"\n";
	#dirmove($_, $tmp);
	#fmove($_, $tmp);
}
