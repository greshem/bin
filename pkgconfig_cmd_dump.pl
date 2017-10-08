#!/usr/bin/perl
@files=glob("/usr/share/pkgconfig/*.pc");

@tmp=glob("/usr/lib/pkgconfig/*.pc");
push(@files, @tmp);

@tmp=glob("/usr/lib64/pkgconfig/*.pc");
push(@files, @tmp);

for (@files)
{
	#print $_,"\n";
	$path=$_;
	($name)=($path=~/.*\/(.*)\.pc/g); 
	print "#".$name,"\n";;
	print "pkg-config   --libs    ".$name."\n";
	print "pkg-config    --cflags        ".$name."\n";
	print "rpm -qf $path\n";
	#print "pkg-config    --cxxflags        ".$name."\n";
	#print "rpm -ql ".$name."-devel\n";

}
