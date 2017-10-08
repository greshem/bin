#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__
#completion of all the thing 
1.
ibus  pingying input  method #v and input english  word, and will complete the  whole word.

#2.
/etc/bash_completion

#3. vim 
ctrl-x  ctrl-o
ctrl-x  ctrl-f

#4. bash
tab tab  # 
