#!/usr/bin/perl -sw

=head1 NAME

htmltable2csv - Script to convert HTML tables to CSV

=head1 VERSION

0.01

=head1 SYNOPSIS

  htmltable2csv file.html > file.csv

  curl -sS some/url | htmltable2csv > file.csv

  htmltable2csv --separator '
  ' file.html > file.csv

=head1 DESCRIPTION

The name says it all, except for the C<--separator> option, which will be
inserted in the CSV file between tables. The default is a new line
character.

=begin comment

=head1 README

Script to convert HTML tables to CSV

=end comment

=head1 BUGS

Column and row spanning is currently ignored.

Character encoding is not taken into account. If the file is in any
encoding other than ISO Latin 1, it can easily be mangled.

This script is currently slow. It would probably run faster if I made it
use HTML::TableExtract or HTML::TableContentParser, but I couldn't be
bothered to learn the former's interface and the latter does not support
HTML entities, and I already know how to use the bloated monstrosity known
as 'HTML::DOM,' even though its interface is horrible clunky.


=head1 PREREQUISITES

HTML::DOM 0.010
Text::CSV_XS

=head1 SCRIPT CATEGORIES

Web

=head1 AUTHOR AND COPYRIGHT

Copyright (C) 2007 Father Chrysostomos (gro.napc ta tuorps [backwards])

This program is free software; you may redistribute it and/or modify
it under the same terms as perl.

=head1 SEE ALSO

L<HTML::DOM> and L<Text::CSV_XS>, which this script uses.

L<HTML::TableContentParser> and L<HTML::Entities>, or
L<HTML::TableExtract>, which this script would probably do well to use.

L<xls2csv.pl>, which inspired me to write this (when I found that UPS's
2008 zone charts are HTML files with C<.xls> extensions [!]).

=cut


# OK, here鈥檚 the code:

my $s = ${'-separator'};
defined $s or $s = "\n";

use Text::CSV_XS;
#use HTML::TableContentParser;
use HTML::DOM;
use Data::Dumper;
my $tcx = new Text::CSV_XS { binary => 1};

# HTML::TableContentParser doesn鈥檛 support entities.
#my $not_first;
#for(@{new HTML::TableContentParser->parse(join '', <>)}){
#	print $s if $not_first++;
#	for (@{$$_{rows}}) {
#		combine $tcx map $$_{data}, @{$$_{cells}};
#		print +string $tcx, "\n";
#	}
#}

my $not_first;
my $doc = new HTML::DOM;
$doc->write($_) while <>;
for(getElementsByTagName $doc 'table'){
#	print $s if $not_first++;
	for (rows$_) {
		combine $tcx map as_text$_, cells$_;
#		print "qian"x10;
#		print +string $tcx, "\n";
		my $tmp_str= +string $tcx,"\n";
		if($tmp_str=~/^\d/)
		{
			#格式如下面的
			#2009105(849)," 2009-9-8 ",10,16,02,27,30,08,15,208614594
			print $tmp_str,"\n";
			#@a=split(/\,/,  $tmp_str);
			#print "number\t",$a[0],"\n";
			#print "data\t", $a[1],"\n";
			#my @red;
			#for( 2..7)
			#{
			#push(@red, $a[$_]);
			#}
			#@red_sort=	sort(@red);
			#print_red(@red_sort);
			#print "red ", Dumper(@red_sort);
			#print "red ",$a[2..7],"\n";
			#print "blud\t",$a[8], "\n";
			#print "money\t",$a[9],"\n";
			#print "#"x80,"\n";
		}
	}
}

sub print_red(@)
{
	(@red)=@_;
	print "red ";
	for(@red_sort)
	{
		print $_,"\t";
	}
	print "\n";

}
# That鈥檚 it! Short, isn鈥檛 it?

