#!/usr/bin/perl
use Image::Size;
           # Get the size of globe.gif
$pic=shift or die("Usage $0 pic.file\n");

($globe_x, $globe_y) = imgsize($pic);
           #                       # Assume X=60 and Y=40 for remaining examples

for(1..100)
{
	$startx=int (rand($globe_x));
	$starty=int (rand($globe_y));
	#if($startx > 120)
	#{$startx=-120;
	#}

	#if($starty > 80)
	#{$starty=-80;
	#}

	print "convert -crop 120x80+".$startx."+".$starty,"  $pic $_.jpg\n"; 
}
