#!/usr/bin/perl
foreach (<DATA>)
{
	print $_;
}
__DATA__

#ip地址排序.
sort -t .  -k 4 -n emotibot_db.pl 
