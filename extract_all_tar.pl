#!/usr/bin/perl
opendir(DIR,".") or die("opendir error\n");
@files=readdir(DIR);

@file=grep { -f  && !/^\./ && /tar.gz$/} @files; 
for (@file)
{
    my $chm=$_;
    $chm=~s/\.tar.gz$/\.chm/g;
    if(! -f $chm)
    {
	    print "echo tar -xzf $_ \n";
	    print "tar -xzf $_ \n";
    }
}

@file=grep { -f  && !/^\./ && /tar$/} @files; 
for (@file)
{
	print "echo tar -xf $_ \n";
	print "tar -xf $_ \n";
}

@file=grep { -f  && !/^\./ && /tar.bz2$/} @files; 
for (@file)
{
	print "echo tar -xjf $_ \n";
	print "tar -xjf $_ \n";
}
closedir(DIR);



