#!/usr/bin/perl
foreach (<DATA>)
{
    print $_;
}
__DATA__
    
skopeo --debug inspect docker://docker.io/centos 
skopeo --debug inspect docker://docker.io/django

