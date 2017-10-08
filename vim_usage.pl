#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__
#1. page down,   scrolling
	ctrl-f ctrl-F 	ctrl-E ctrl-E
#2. help search
helpgrep  subject

3. new table  switch in tables
:tabnew
gt  

#4. open file with the current line path
gf
ctrl-o #return to previos file

#5. split line
:LL1	 :LL0

