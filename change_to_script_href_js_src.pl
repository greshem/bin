#!/usr/bin/perl

my $file=shift or die("Usage: $0 input file \n");

open(FILE, $file) or die("Open file error \n");

for(<FILE>)
{
	chomp;
	#print "<a href=\"$_\"> $_ </a> </br> \n";
    print  <<EOF
    <script src="$_"></script>
EOF
;
}

__DATA__
    <script src="//cdn.bootcss.com/jquery/3.0.0/jquery.js"></script>
