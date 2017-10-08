#!/usr/bin/perl
use File::Copy::Recursive qw(pathmk dircopy dirmove fmove);
warn("WARN: 注意  windows 下的换行符的问题, ctrl-M , dos2unix 转换一下. \n");
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
