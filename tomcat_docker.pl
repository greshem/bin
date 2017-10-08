#!/usr/bin/perl
foreach (<DATA>)
{
    print $_;
}
__DATA__

    docker run -it --rm -p 8887:8080 tomcat:8.0
