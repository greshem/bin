#!/usr/bin/perl
foreach (<DATA>)
{
	print $_;
}
__DATA__
python -m SimpleHTTPServer 8088
