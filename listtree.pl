#
# Copyright (c) 2001, by William Scott Hoge (shoge@ieee.org).
# All rights reserved. You may distribute this code under the terms 
# of either the GNU General Public License or the Artistic License, 
# as specified in the Perl README file.

use strict;
use File::Find; 

{package siteinfo; do "siteinfo";}
my($tree_depth) = 0;

my($topdir) = shift @ARGV || '.' ;
$topdir =~ s!\\!\/!g if ($^O =~ m/ms/i);

find( { wanted => \&list_tree_structure, no_chdir => 1 }, $topdir );

# clean up output to give valid HTML
while ($tree_depth > 0) {
    print "    " x $tree_depth . "</dl></dd>\n";
    $tree_depth--;
}

sub list_tree_structure  {
    return if !(-d $File::Find::name);
    
    (my $relpath = $File::Find::name) =~ s!^$siteinfo::basedir!!i;
    # $relpath =~ s!^\/!!;
    my($preview_file) = $siteinfo::basedir.$relpath."/".
      $siteinfo::img_prevue_name;

    (my $preview_url = $File::Find::name) =~ s!$File::Find::topdir(\/?)!!;
    $preview_url .= $1.$siteinfo::img_prevue_name;


    my $name = $File::Find::name;
    $name =~ s!^.*\/!!;
    $name = "(top)" if ($name eq ".") ;

    # figure out how deep we are
    my $depth = scalar( split('/',$relpath) );
    # and pad spaces accordingly
    my $spcs = '    ' x $depth;


    my($text);
    if ($depth > $tree_depth) { 
      $text = "$spcs<dd><dl>\n" x ($depth-$tree_depth); } 
    if ($depth < $tree_depth) { 
      $text = "$spcs    </dl></dd>\n" x ($tree_depth-$depth); }
    
    $text .= $spcs."<dt>".$name."</dt>\n";
    (my $anchor = $relpath) =~ s/\//\-/g;
    $text =~ s!$name!\<a href=\"$preview_url\" name=\"$anchor\"\>$name\<\/a\>!  
	if ( -f $preview_file );

    print $text;
    $tree_depth = $depth;
}


1;
