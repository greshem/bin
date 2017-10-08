#!/usr/bin/perl -w  

 use strict;  
 use Spreadsheet::ParseExcel;  
 use Encode qw(from_to);
my $tmp;
 my $parser   = Spreadsheet::ParseExcel->new();  
 my $workbook = $parser->Parse($ARGV[0]);  

 for my $worksheet ( $workbook->worksheets() ) {  

     my ( $row_min, $row_max ) = $worksheet->row_range();  
     my ( $col_min, $col_max ) = $worksheet->col_range();  

     for my $row ( $row_min .. $row_max ) {  
         for my $col ( $col_min .. $col_max ) {  

             my $cell = $worksheet->get_cell( $row, $col );  
             next unless $cell;  

#             print "Row, Col    = ($row, $col)\n";  
#             print "Value       = ", $cell->value(),       "\n";  
#             print "Unformatted = ", $cell->unformatted(), "\n";  
			 $tmp=$cell->value();
			#from_to($tmp, "UTF8", "gb2312");
			print $tmp;	
             print "\t|";  
         }  
	 	print "\n";
     }  
 }  
