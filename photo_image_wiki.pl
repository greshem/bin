#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__
eog		#eye of gnome
gwenview		#
fbida	# really useful to cloud_map.png
jbrout	#pygtk
pony	#

shotwell #
