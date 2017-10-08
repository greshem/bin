#!/usr/bin/perl
mkdir("output");
 for (glob("*mp3"))
{
	$number=int (rand(10000));
	print "cp \"$_\"  \"output/${number}_$_\"  \n ";
}
