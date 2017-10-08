#!/usr/bin/perl -w
# join - relational database operator

use strict;

my $VERSION = '1.1';

END {
  close STDOUT || die "$0: can't close stdout: $!\n";
  $? = 1 if $? == 255;  # from die
}

sub help {
  print <<"HELP_YOURSELF";
join (Perl Power Tools) $VERSION
Usage: join [-a file_number | -v file_number] [-e string] [-j file_number field]
            [-o list] [-t char] [-1 field] [-2 field] file1 file2
HELP_YOURSELF
  exit 0;
}

# options
my ($j1, $j2) = (0,0); # join fields
my @fields;            # output fields ([file, field], [file. field], etc.)
my $e_string = '';     # replace empty output fields with $e_string
my $delimiter;         # input/output field delimiter
my $print_pairables = 1;        # do we print pairables?
my @unpairables = (undef) x 2;  # print unpairables from which files?

get_options();

die "$0: I expect two filenames as arguments\n" unless @ARGV == 2;
die "$0: both files cannot be standard input\n"
  if $ARGV[0] eq '-' and $ARGV[1] eq '-';

$" = defined $delimiter ? $delimiter : ' ';

my @file_names = map { $_ eq '-' ? 'STDIN' : $_ } @ARGV;

open(F1, $ARGV[0]) || die "Can't read $file_names[0]: $!\n";
open(F2, $ARGV[1]) || die "Can't read $file_names[1]: $!\n";

my @buf1; # line buffers for the two files
my @buf2; #

get_a_line(\@buf1, \*F1);
get_a_line(\@buf2, \*F2);

my ($diff, $eof1, $eof2);
while (@buf1 && @buf2) {

  $diff = ($buf1[0]->[$j1]||'') cmp ($buf2[0]->[$j2]||'');
  if ($diff < 0) {
    print_joined_lines($buf1[0], []) if $unpairables[0];
    shift @buf1;
    get_a_line(\@buf1, \*F1) || shift @buf1;
    next;
  }
  if ($diff > 0) {
    print_joined_lines([], $buf2[0]) if $unpairables[1];
    shift @buf2;
    get_a_line(\@buf2, \*F2) || shift @buf2;
    next;
  }

  $eof1 = 0;
  do {
    get_a_line(\@buf1, \*F1) || $eof1++
  } until $eof1 || ($buf1[-1]->[$j1] cmp $buf2[0]->[$j2]);

  $eof2 = 0;
  do {
    get_a_line(\@buf2, \*F2) || $eof2++
  } until $eof2 || ($buf1[0]->[$j1] cmp $buf2[-1]->[$j2]);

  if ($print_pairables) {
    for (my $left = 0; $left < @buf1 - 1; $left++) {
      for (my $right = 0; $right < @buf2 - 1; $right++) {
	print_joined_lines($buf1[$left], $buf2[$right]);
      }
    }
  }
  
  if ($eof1) { @buf1 = () }
  else       { splice @buf1, 0, @buf1 - 1 }

  if ($eof2) { @buf2 = () }
  else       { splice @buf2, 0, @buf2 - 1 }
}

if ($unpairables[0] && @buf1) {
  do{
    print_joined_lines(shift @buf1, [])
  } until !get_a_line(\@buf1, \*F1);
}
if ($unpairables[1] && @buf2) {
  do{
    print_joined_lines([], shift @buf2)
  } until !get_a_line(\@buf2, \*F2);
}

close F1 || die "Can't close $file_names[0]: $1\n";
close F2 || die "Can't close $file_names[1]: $1\n";

exit 0;

sub get_a_line {
  my ($aref, $fh) = @_;
  my $not_eof = defined(my $line = <$fh>);
  if ($not_eof) {
    chomp $line;
    push (@$aref, 
	  defined $delimiter ? 
	  [split $delimiter, $line, -1] : [split ' ', $line, -1]);
  }
  else { push @$aref, undef }
  return $not_eof;
}

sub print_joined_lines {
  my ($line1, $line2) = @_;
  my @out;
  if (@fields) {
    my ($line, $file, $field);
    foreach my $f (@fields) {
      ($file, $field) = @$f;
      if ($file == 0) {  # POSIX: 0 means join field
	($line, $field) = @$line1 ? ($line1, $j1) : ($line2, $j2);
      }
      else {
	$line = $file == 1 ? $line1 : $line2;
      }
      push @out, defined $line->[$field] ? $line->[$field] : $e_string;
    }
  }
  else {
    unless (@$line1) { ($line1,$line2) = ($line2,$line1) }
    for my $i ($j1, 0..$j1-1, $j1+1..@$line1-1) {
      push @out, defined $line1->[$i] ? $line1->[$i] : $e_string
    }
    for my $i (0..$j2-1, $j2+1..@$line2-1) {
      push @out, defined $line2->[$i] ? $line2->[$i] : $e_string
    }
  }
  print "@out\n";
}

#######################
# OPTIONS STUFF BELOW #
#######################
sub get_arg {
  # $_ contains current arg
  my ($arg,$opt) = shift;
  if    (length) { $opt = $_ }
  elsif (@ARGV)  { $opt = shift @ARGV }
  else           {die "$0: option requires an argument -- $arg\n"}  
  return $opt;
}

sub get_numeric_arg {
  my ($argname, $desc) = @_;
  my $opt = get_arg($argname);
  $opt =~ /\D/ && die "$0: invalid number of $desc: `$opt'\n";  
  return $opt;
}

sub get_file_number {
  my $argname = shift;
  my $f = get_arg($argname);
  $f =~ /^[12]$/ || die "$0: argument $argname expects 1 or 2\n";
  return --$f;
}

sub get_field_specs {
  do {
    my $text = get_arg('o');
    my @specs = split /\s+|,/, $text;
    foreach my $spec (@specs) {
      $spec =~ /^(0)$|^([12])\.(\d+)$/ || die "$0: weird field spec `$spec'\n";
      if (defined $1) { push @fields, [0, -1] }
      else {
        die "$0: fields start at 1\n" if $3 == 0;
        push @fields, [$2, $3 - 1];
      }
    }
  } while (length || (@ARGV && $ARGV[0] =~ m!^0$|^[12]\.\d+$!));
}

sub get_options {
  while (@ARGV && $ARGV[0] =~ /^-(.)/) {
    local $_ = shift @ARGV;
    if    (/^-[h?]$/)  { help() }        # terminates
    elsif (s/^-a//) {
      my $f = get_file_number('a');
      $unpairables[$f] = 1;
    }
    elsif (s/^-v//) {
      $print_pairables = 0;
      my $f = get_file_number('v');
      $unpairables[$f] = 1;
    }
    elsif (s/^-e//)    { $e_string = get_arg('e') }
    elsif (s/^-(?:j?([12])|j)//) {
      my $field = get_numeric_arg('j');
      die("$0: fields start at 1\n") if $field == 0;
      if ($1) { ($1 == 1 ? $j1 : $j2) = $field}
      else    { $j1 = $j2 = $field }
    }
    elsif (s/^-o//)    { get_field_specs() }
    elsif (s/^-t//)    { $delimiter = get_arg('t') }
    else {die "$0: invalid option -- $_\n"}
  }
}

__END__

=head1 NAME 

join - relational database operator

=head1 SYNOPSIS

join [B<-a> I<file_number> | B<-v> I<file_number>] [B<-e> I<string>] 
     [B<-o> I<list>] [B<-t> I<char>] 
     [B<-1> I<field>] [B<-2> I<field>] I<file1> I<file2>

=head1 DESCRIPTION

The B<join> utility performs an ``equality join'' on the specified
files and writes the result to the standard output.  The ``join
field'' is the field in each file by which the files are compared.
The first field in each line is used by default.  There is one line in
the output for each pair of lines in I<file1> and I<file2> which have
identical join fields.  Each output line consists of the join field,
the remaining fields from I<file1> and then the remaining fields from
I<file2>.

The defaults are: the join field is the first field in each line;
fields in the input are separated by one or more blanks, with leading
blanks on the line ignored; fields in the output are separated by a
space; each output line consists of the join field, the remaining
fields from I<file1>, then the remaining fields from I<file2>.

Many of the options use file and field numbers.  Both file numbers and
field numbers are 1 based, i.e. the first file on the command line is
file number 1 and the first field is field number 1.  The following
options are available:

=over

=item B<-a> I<file_number> 

In addition to the default output, produce a line for each unpairable
line in file file_number. (The argument to B<-a> must not be preceded
by a space; see the L<COMPATIBILITY> section.)

=item B<-e> I<string> 

Replace empty output fields with I<string>.

=item B<-o> I<I<field-list>>

Construct each output line according to the format in I<field-list>.
Each element in I<field-list> is either the single character `0' or
has the form M.N where the file number, M, is `1' or `2' and N is
a positive field number.

A field specification of `0' denotes the join field.  In most cases,
the functionality of the `0' field spec may be reproduced using the
explicit M.N that corresponds to the join field.  However, when
printing unpairable lines (using either of the B<-a> or B<-v>
options), there is no way to specify the join field using M.N in
I<field-list> if there are unpairable lines in both files.  To give
B<join> that functionality, POSIX invented the `0' field specification
notation.

The elements in I<field-list> are separated by commas or blanks.
Multiple I<field-list> arguments can be given after a single B<-o>
option; the values of all lists given with B<-o> are concatenated
together.  All output lines - including those printed because of any
B<-a> or B<-v> option - are subject to the specified I<field-list>.

=item B<-t> I<char>

Use character I<char> as a field separator for both input and output.
Every occurrence of I<char> in a line is significant.

=item B<-v> I<file_number>

Do not display the default output, but display a line for each
unpairable line in file I<file_number>. The options B<-v 1> and B<-v
2> may be specified at the same time.

=item B<-1> I<field>

Join on the I<field>'th field of file 1.

=item B<-2> I<field>    

Join on the I<field>'th field of file 2.

=back

When the default field delimiter characters are used, the files to be
joined should be ordered in the collating sequence of L<sort(1)>,
using the B<-b> option, on the fields on which they are to be joined,
otherwise B<join> may not report all field matches.  When the field
delimiter characters are specified by the B<-t> option, the collating
sequence should be the same as sort without the B<-b> option.

If one of the arguments I<file1> or I<file2> is ``-'', the standard
input is used.

The B<join> utility exits 0 on success or >0 if an error occurred.

=head1 COMPATIBILITY

For compatibility with historic versions of join, the following options
are available:

=over

=item B<-j1> I<field>   

Join on the I<field>'th field of file 1.

=item B<-j2> I<field>   

Join on the I<field>'th field of file 2.

=item B<-j> I<field>    

Join on the I<field>'th field of both file 1 and file 2.

=item B<-o> I<list> I<...>

Historical implementations of B<join> permitted multiple arguments to
the B<-o> option.  These arguments were of the form 
``I<file_number>.I<field_number>'' as described for the current
-o option.  This has obvious difficulties in the presence of
files named ``1.2''.

=back

=head1 SEE ALSO

L<awk(1)>,  L<comm(1)>,  L<paste(1)>,  L<sort(1)>,  L<uniq(1)>

=head1 BUGS

I<join> has no known bugs.  It does not support the following
historical switches: B<-a> with no args.  Patches are welcome.

=head1 AUTHOR

The Perl implementation of I<join> was written by Jonathan Feinberg,
I<jdf@pobox.com>.

=head1 COPYRIGHT and LICENSE

This program is copyright (c) Jonathan Feinberg 1999.

This program is free and open software. You may use, modify, distribute,
and sell this program (and any modified variants) in any way you wish,
provided you do not restrict others from doing the same.


