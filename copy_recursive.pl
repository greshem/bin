#!/usr/bin/perl
use File::Copy::Recursive qw(fcopy rcopy dircopy fmove rmove dirmove);

  #fcopy($orig,$new) or die $!;
  #rcopy($orig,$new) or die $!;
  die("Usage: rcopy src_dir to_dir \n") if(! @ARGV); 
  $src_dir=$ARGV[0] or die("src_dir needed\n");
  $to_dir =$ARGV[1] or die("to_dir  needed\n");
  dircopy($src_dir, $to_dir) or die $!;

  #fmove($orig,$new) or die $!;
  #rmove($orig,$new) or die $!;
  #dirmove($orig,$new) or die $!;
  
  #rcopy_glob("orig/stuff-*", $trg [, $buf]) or die $!;
  #rmove_glob("orig/stuff-*", $trg [,$buf]) or die $!;


