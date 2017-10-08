#!/usr/bin/perl

open(PIPE, "docker images |")  or die("usage:   docker images error \n");
for(<PIPE>)
{

    @array=split(/\s+/,$_);
    $raw=$array[0];
    $name=$array[0];
    $tag=$array[1];
    next if($name=~/none/);
    next if($name=~/127.0.0.1/);

    $name=~s/\//_/g;


    print "\ndocker  tag  $raw:$tag     127.0.0.1:5001/$raw:$tag \n";
    print "docker  push     127.0.0.1:5001/$raw:$tag \n";
}

