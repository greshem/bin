#!/usr/bin/perl 
for $each (glob("*.zip"))
{
	my $dir=$each;
	$dir=~s/\.zip$//g;
	print <<EOF
	unzip  $each -d $dir 
EOF
;
}
