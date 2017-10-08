#!/usr/bin/perl -w

#
# $Id: rain,v 1.2 2004/08/05 14:17:43 cwest Exp $
#
# $Log: rain,v $
# Revision 1.2  2004/08/05 14:17:43  cwest
# cleanup, new version number on website
#
# Revision 1.1  2004/07/23 20:10:15  cwest
# initial import
#
#

use strict;

my ($VERSION) = '$Revision: 1.2 $' =~ /([.\d]+)/;

if (@ARGV) {
    require File::Basename;
    $0 = File::Basename::basename ($0);
    print "$0 (Perl bin utils) $VERSION\n";
    exit;
}

print "/" x 72, "\n" while 1;

__END__

=pod

=head1 NAME

rain -- Let it rain.

=head1 SYNOPSIS

rain

=head1 DESCRIPTION

I<rain> simulates rain.

=head2 OPTIONS

I<rain> does not accept options.

=head1 ENVIRONMENT

The working of I<rain> is not influenced by any
environment variables.

=head1 BUGS

I<rain> does not have any known bugs.

=head1 REVISION HISTORY

    $Log: rain,v $
    Revision 1.2  2004/08/05 14:17:43  cwest
    cleanup, new version number on website

    Revision 1.1  2004/07/23 20:10:15  cwest
    initial import


=head1 AUTHOR

The Perl implementation of I<rain>
was written by Abigail, I<abigail@fnx.com>.

=head1 COPYRIGHT and LICENSE

This program is copyright by Abigail 1999.

This program is free and open software. You may use, modify, distribute
and sell this program (and any modified variants) in any way you wish,
provided you do not restrict others to do the same.

=cut

