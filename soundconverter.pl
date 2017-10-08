#!/usr/bin/perl
#----------------------------------------------------------------
#   soundconverter
#   -- converts sounds from one format to another
#   (c) 2008 Benjamin Crowell
#   This free software is copyleft licensed under the same terms as Perl, or,
#   at your option, under version 2 of the GPL license.
#----------------------------------------------------------------

#----------------------------------------------------------------
# Version number
#----------------------------------------------------------------
our $version = "0.3"; 

#----------------------------------------------------------------
# Short documentation
#
# This is what is printed out if you do `soundconverter -h'. The more
# detailed documentation is after this in the source code, and
# the man page is generated from that.
#----------------------------------------------------------------

sub documentation {
return <<'DOC';
   Soundconverter
   a program to convert sound files from one format to another
   (c) 2008 Benjamin Crowell
   http://www.lightandmatter.com/soundconverter/soundconverter.html
   This free software is copyleft licensed under the same terms as Perl, or,
   at your option, under version 2 of the GPL license.

   Basic use:
     soundconverter input.wav output.mp3

   The following formats are supported:
     au, wav, mp3, ogg, flac, aac

   This program depends on the following debian packages:
     sox vorbis-tools lame madplay transcode flac faac faad
   If some of these packages are not installed, then the program will still
   run, but the corresponding functionality will be lost.
DOC
}

#----------------------------------------------------------------
# Long documentation
#
# The man page is generated from this, using pod2man.
#----------------------------------------------------------------

=head1 NAME

Soundconverter - a program to convert sound files from one format to another

=head1 SYNOPSIS

soundconverter [options] [input file] [output file]

=head1 OPTIONS

=over 8

=item -h

Prints a brief help message and exits.

=item -v

Prints the version number and exits.

=item -t

Tests the program by doing a chain of conversions, covering every possible
conversion, starting with the input file and ending up by writing the result
to the output file.

=back

=head1 DESCRIPTION

Soundconverter reads the input file and converts it to the format specified for
the output file. Both formats are inferred from the extension of the relevant
filename. The conversion is actually carried out by an external program, and
that program's output (e.g., a progress bar) will be written to the console.
Sometimes a conversion cannot be done directly by a single program; in this
situation, the file will first be converted to a temporary file in .wav
format (typically in a 16-bit integer encoding), and then the .wav will be
converted to the final format.

There are no command-line options to control quality of lossy formats,
encoding types for .wav files, etc; if you're getting that fancy, you
should probably use the relevant tools directly rather than through
soundconverter.

=head1 INSTALLATION

Do a "make install".    This program depends on the following debian packages:

sox vorbis-tools lame madplay transcode flac faac faad

If some of these packages are not installed, then the program will still
run, but the corresponding functionality will be lost.

The following formats are supported:
     au, wav, mp3, ogg, flac, aac

=head1 OTHER INFORMATION

Soundconverter's web page is at

        http://www.lightandmatter.com/soundconverter/soundconverter.html   ,

where you can always find the latest version of the software.

=head1 AUTHOR

Soundconverter was written by Ben Crowell, http://www.lightandmatter.com/personal/.

=head1 COPYRIGHT AND LICENSE

B<Copyright (C)> 2008 by Benjamin Crowell.

B<Soundconverter> is free software; you can redistribute it and/or modify it
under the terms of the GPL, or, optionally, Perl's license.

=cut

#================================================================
#
# beginning of real code
#
#================================================================

use strict;
use Getopt::Std;
use IO::File;
use POSIX qw(tmpnam);

my %option = ();
getopts("vht",\%option);

if ($option{v}) {
  print $version;
  exit();
}

if ($option{h} || @ARGV!=2) {
  print documentation();
  exit();
}

my $infile = $ARGV[0];
my $outfile = $ARGV[1];

unless (-e $infile) {  err("Input file $infile does not exist.");  exit(-1); }
unless (-r $infile) {  err("Input file $infile exists, but is not readable.");  exit(-1); }

my @formats = ('wav','au','mp3','ogg','flac','aac');
my $formats_pat = join("|",@formats);

my $in_fmt;
if ($infile=~/\.($formats_pat)$/i) {
  $in_fmt = lc($1);
}
unless ($in_fmt) {  err("Name of input file $infile does not correspond to a supported format."); exit(-1); }
my $out_fmt;
if ($outfile=~/\.($formats_pat)$/i) {
  $out_fmt = lc($1);
}
unless ($out_fmt) {  err("Name of output file $outfile does not correspond to a supported format."); exit(-1); }

my $how;

unlink($outfile) if -e $outfile; # otherwise, e.g., flac gets upset

if ($option{t}) {
  my @chain = ();
  my $n = @formats;
  push @chain,$in_fmt;

  if ($in_fmt!=$formats[0]) {push @chain,$formats[0]}
  for (my $i=0; $i<$n; $i++) {
    push @chain,$formats[$i]; # convert i to i
    for (my $j=$i+1; $j<$n; $j++) {
      push @chain,$formats[$j]; # convert i to j
      push @chain,$formats[$i]; # convert j to i
    }
    if ($i<$n-1) {push @chain,$formats[$i+1]} # convert i to i+1
  }
  push @chain,$formats[0]; # convert n-1 to 0
  if ($out_fmt!=$formats[0]) {push @chain,$out_fmt}

  my $previous = $infile;
  for (my $i=0; $i<@chain-1; $i++) {
    my $from = $chain[$i];
    my $to = $chain[$i+1];
    my $new;
    if ($i<@chain-2) {
      $new = choose_temp_file_name($to);
    }
    else {
      $new = $outfile;
    }
    print("===== Converting from $previous to  $new ========\n");    
    do_command("soundconverter $previous $new");    
    if ($i>0) {unlink($from)}
    $previous = $new;
  }
  print <<DONE;
========================================================================================================
 The chain of conversions was completed without throwing an error. 
 You should check whether the output file, $outfile, sounds right compared to the input file, $infile
========================================================================================================
DONE
  exit;  
}

if ($in_fmt eq 'au') {
  $how = {'au'=>'cp','mp3'=>'wav','ogg'=>'wav','wav'=>'sox','flac'=>'wav','aac'=>'wav'}->{$out_fmt};
}
if ($in_fmt eq 'mp3') {
  $how = {'au'=>'madplay','mp3'=>'cp','ogg'=>'transcode','wav'=>'madplay','flac'=>'wav','aac'=>'wav'}->{$out_fmt};
}
if ($in_fmt eq 'ogg') {
  $how = {'au'=>'ogg123','mp3'=>'wav','ogg'=>'cp','wav'=>'ogg123','flac'=>'wav','aac'=>'wav'}->{$out_fmt};
  # flac is supposed to be able to convert directly from ogg, but when I tested it, it didn't seem to work?
}
if ($in_fmt eq 'wav') {
  $how = {'au'=>'sox','mp3'=>'lame','ogg'=>'oggenc','wav'=>'cp','flac'=>'flac','aac'=>'faac'}->{$out_fmt};
}
if ($in_fmt eq 'flac') {
  $how = {'au'=>'wav','mp3'=>'wav','ogg'=>'wav','wav'=>'flac','flac'=>'cp','aac'=>'wav'}->{$out_fmt};
  # flac is supposed to be able to convert directly to ogg, but when I tested it, it didn't seem to work?
}
if ($in_fmt eq 'aac') {
  $how = {'au'=>'wav','mp3'=>'wav','ogg'=>'wav','wav'=>'faad','flac'=>'wav','aac'=>'cp'}->{$out_fmt};
  # flac is supposed to be able to convert directly to ogg, but when I tested it, it didn't seem to work?
}

if ($how eq 'cp') {
  tell_about_how($in_fmt,$out_fmt,$how);
  do_command("cp $infile $outfile");
}
if ($how eq 'oggenc') {
  tell_about_how($in_fmt,$out_fmt,$how);
  do_command("oggenc $infile -o $outfile");
}
if ($how eq 'lame') {
  tell_about_how($in_fmt,$out_fmt,$how);
  do_command("lame $infile $outfile");
}
if ($how eq 'sox') {
  tell_about_how($in_fmt,$out_fmt,$how);
  do_command("sox $infile -u $outfile");
  # The -u applies to the output file, and says that we want it written as unsigned linear.
  # Without this option, sox may, e.g., write ITU G.711 mu-law as its output encoding, and other software
  # can't handle that.
}
if ($how eq 'madplay') {
  tell_about_how($in_fmt,$out_fmt,$how);
  do_command("madplay -o $outfile $infile");
}
if ($how eq 'ogg123') {
  tell_about_how($in_fmt,$out_fmt,$how);
  do_command("ogg123 -d $out_fmt -f $outfile $infile");
}
if ($how eq 'wav') {
  tell_em("The file $infile will first be converted to .wav, and then to .$out_fmt.");
  # We have to do indirect conversion via a .wav file.
  # Can't do it using transcode, because transcode doesn't ship with an mp3 encoder (presumably due to licensing).
  my $wav = choose_temp_file_name('wav');
  do_command("soundconverter $infile $wav && soundconverter $wav $outfile");
  unlink $wav;
}
if ($how eq 'transcode') {
  tell_about_how($in_fmt,$out_fmt,$how);
  # For mp3->ogg conversion this is typically slightly faster than madplay|oggenc, because transcode is SMP-aware.
  do_command("transcode -x null,$in_fmt -y null,$out_fmt -p $infile -m $outfile");
}
if ($how eq 'flac') {
  tell_about_how($in_fmt,$out_fmt,$how);
  if ($out_fmt eq 'flac') {
    do_command("flac -o $outfile $infile");
  }
  else {
    do_command("flac -d -o $outfile $infile");
  }
}
if ($how eq 'faac' || $how eq 'faad') {
  tell_about_how($in_fmt,$out_fmt,$how);
  do_command("$how -o $outfile $infile");
}

sub do_command {
  my $cmd = shift;
  print "$cmd\n";
  if (system($cmd)==0) {
    return;
  }
  else {
    err("Command $cmd failed, $?");
    exit(-1);
  }
}

sub choose_temp_file_name {
  my $suffix = shift;
  my $f;
  do { $f=tmpnam().".$suffix" } until !-e $f;
  return $f;
}

sub err {
  my $message = shift;
  print STDERR $message;
}

sub tell_about_how {
  my $in_fmt = shift;
  my $out_fmt = shift;
  my $how = shift;
  tell_em("The input $in_fmt file will be converted to $out_fmt using the program $how.");
}

sub tell_em {
  my $message = shift;
  print "$message\n";
}
