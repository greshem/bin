#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__
gnugo --score aftermath -l filename.sgf
gnugo --score finish -l filename.sgf
gnugo --score estimate -l filename.sgf

