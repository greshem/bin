#!/usr/bin/perl -w
use 5.005;  # Need look-behind assertions

use Getopt::Std;
use Make;

getopts('gnpf:j:C:');

my @opt = ($opt_g,$opt_f,$opt_j,$opt_C,$opt_p,$opt_n);

my $info = Make->new(GNU      => $opt_g, 
                     Override => { MAKE => "$^X $0" },
                     Makefile => $opt_f, 
                     Jobs     => $opt_j,
                     Dir      => $opt_C);

$info->Print(@ARGV)  if ($opt_p);
if ($opt_n)
 {
  $info->Script(@ARGV);
 }
else
 {
  $info->Make(@ARGV);
 }

=head1 NAME

pmake - a perl 'make' replacement

=head1 SYNOPSIS

	pmake [-n] [-g] [-p] [-C directory] targets

=head1 DESCRIPTION

Performs the same function as make(1) but is written entirely in perl.
A subset of GNU make extensions is supported.
For details see L<Make> for the underlying perl module.

=head1 BUGS

=item *

No B<-k> flag

I strongly suspect there are lots more.

=head1 SEE ALSO

L<Make>, make(1)

=head1 AUTHOR

Nick Ing-Simmons 

=cut

