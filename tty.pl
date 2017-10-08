#!/usr/bin/perl
# implementation of tty in perl
use POSIX ();
use strict;
die "not a tty" unless -t;
print POSIX::ttyname(0), "\n";
