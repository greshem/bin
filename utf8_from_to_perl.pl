#!/usr/bin/perl
use Encode qw(from_to);

$a="utf8";
from_to($a,"utf8", "gb2312");
print$a,"\n";
