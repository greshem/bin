#!/usr/bin/perl
open(FILE, "/root/pypi_index.html")  or die("pypi_index.html not exits \n");

# <a href="singleton123/">singleton123</a><br/>

mkdir ("/tmp3/pypi/"); 
for(<FILE>)
{
    if($_=~/=\"(.*?)\"/)
    {
        my $name=$1;
        $name=~s/\/$//;
        my $url= "http://mirrors.aliyun.com/pypi/simple/".$name;
        print $url."\n";;
        
        my $dest_dir="/tmp3/pypi/$name";
        mkdir($dest_dir ) if (!  -d $dest_dir); 

        if(! -f  $dest_dir."/$name.html")
        {
            system (" wget   $url -O  $dest_dir/$name.html \n");
        }
        else
        {
            print ("# $dest_dir/$name.html  exits \n");
        }
        #print $_;
    }
}
