#!/usr/bin/perl
foreach (<DATA>)
{
	print $_;
}
__DATA__

msgfmt Languages/ko_KR/manager.po -o Languages/ko_KR/manager.mo
