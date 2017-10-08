#!/usr/bin/perl
foreach (<DATA>)
{
    print $_;
}
__DATA__

ldapsearch -b "dc=wzcloud,dc=com" -x "uid=greshem"   #
