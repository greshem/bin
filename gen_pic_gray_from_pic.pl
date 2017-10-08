#!/usr/bin/perl

use GD;
use Image::Size;
$file=shift or die("Usage: $0  file \n");
($width, $height) = imgsize($file);

$im = new GD::Image($width, $height);

# allocate black -- this will be our background
$black = $im->colorAllocate(0, 0, 0);

# allocate white
$white = $im->colorAllocate(255, 255, 255);        
$ray=$im->colorAllocate(200, 200, 200);
# allocate red
$red =$im->colorAllocate(255, 0, 0);      

# allocate blue
$blue = $im->colorAllocate(0,0,255);

#Inscribe an ellipse in the image
#$im->arc(50, 25, 98, 48, 0, 360, $white);

# Flood-fill the ellipse. Fill color is red, and will replace the
# black interior of the ellipse
$im->fill(50, 21, $ray);
($output,$suffix)=($file=~/(.*)\.(.*)/);
$output.="_gray.".$suffix;
open(FILE, ">".$output) or die("open file error\n");
binmode FILE;

# print the image to stdout
print FILE $im->png;
close(FILE);

