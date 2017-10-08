#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__
?     : don't care
.     : empty
X     : your piece,
O     : my piece,
x     : your piece or empty
o     : my piece or empty
*     : my next move
-, |  : edge of board
+     : corner of board


#  'Y' is the anchor stone, a unique stone of color 'X' used by the pattern
#   matcher to find the pattern.


