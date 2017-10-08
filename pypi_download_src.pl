#!/usr/bin/perl

my $keywords=shift or die("Usage: $0  keywords \n");;
if(! -f "/root/pypi_index.html") 
{
	system("wget  http://mirrors.aliyun.com/pypi/simple/  -O  /root/pypi_index.html" );
}

if(-f $keywords)
{
    my_link_extrat($keywords);
}
else
{
    print "#========================================================================== \n";
    system(" wget -k  http://mirrors.aliyun.com/pypi/simple/$keywords  -O  $keywords.html \n");

    system(" urlview.pl  $keywords.html \n");
    my_link_extrat($keywords.".html");
}



sub Usage($)
{
    (my $keyword)=@_;

    #<a href="zwxtest/">zwxtest</a><br/>
    open(PIPE, "grep $keywords  /root/pypi_index.html |") or die("open  grep error \n");
    for(<PIPE>)
    {
        if($_=~/"(.*)"/)
        {
            my $match=$1;
            $match=~s/\/$//g;	
            print ("perl $0  $match \n");
        }
    }
    close(PIPE);
}



#<a href="http://mirrors.aliyun.com/pypi/packages/py2.py3/b/bosonnlp/bosonnlp-0.2.1-py2.py3-none-any.whl#md5=3dc919a755b5caf565409e4cc36b4a73" rel="internal">bosonnlp-0.2.1-py2.py3-none-any.whl</a><br/>
sub  my_link_extrat($)
{
	(my $file)=@_;
	open(FILE, "tac $file| head -n 10 | ") or die("open file error \n");
	for(<FILE>)
	{
		if($_=~/href=\".*\/(package.*)\#md5=.*/)
		{
            use File::Basename;
            my $path=$1;
            my $tar_gz=basename($1);

            if( ! -f $tar_gz &&  $tar_gz=~/tar|tgz|gz|zip/i)
            {
			    print "wget http://mirrors.aliyun.com/pypi/$path \n";
            }
            else
            {
                print STDERR "SKIP, $tar_gz exists , or not  tar gz file \n";
            }
		}
	}
}
