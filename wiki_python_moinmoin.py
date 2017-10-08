#!/usr/bin/perl
foreach (<DATA>)
{
    print $_;
}
__DATA__
    docker run -it -d  -p 3033:80                     --name=my_wiki3                     eternnoir/moinmoin

