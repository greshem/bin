#!/usr/bin/perl -w

#
# $Id: false,v 1.2 2004/08/05 14:17:43 cwest Exp $
#
# $Log: false,v $
# Revision 1.2  2004/08/05 14:17:43  cwest
# cleanup, new version number on website
#
# Revision 1.1  2004/07/23 20:10:05  cwest
# initial import
#
# Revision 1.1  1999/02/25 04:16:05  abigail
# Initial revision
#
#

use strict;

my ($VERSION) = '$Revision: 1.2 $' =~ /([.\d]+)/;

my $STATUS = $0 =~ /true$/ ? 0 : 1;

if (@ARGV) {
    if ($ARGV [0] eq '--version') {
        $0 =~ s{.*/}{};
        print "$0 (Perl bin utils) $VERSION\n";
        exit;
    }
    if ($ARGV [0] eq '--help') {
        $0 =~ s{.*/}{};
        my $success = $STATUS ? "failure" : "success";
        print <<EOF;
Usage: $0 [OPTION]

Exit with a $success status.

Options:
       --version:  Print version number, then exit.
       --help:     Print usage, then exit.
EOF
        exit;
    }
}

exit $STATUS;

__END__

=pod

=head1 NAME

true - Exit succesfully.
false - Exit unsuccesfully.

=head1 SYNOPSIS

(true | false) [OPTION]

=head1 DESCRIPTION

I<true> exits succesfully. I<false> exits unsuccesfully.

=head2 OPTIONS

I<true> and I<false> accept the following options:

=over 4

=item --help

Print out a short help message, then exit.

=item --version

Print out its version number, then exit.

=back

=head1 ENVIRONMENT

The working of I<true> and I<false> are not influenced by any
environment variables.

=head1 BUGS

I<true> and I<false> have no known bugs.

=head1 REVISION HISTORY

    $Log: false,v $
    Revision 1.2  2004/08/05 14:17:43  cwest
    cleanup, new version number on website

    Revision 1.1  2004/07/23 20:10:05  cwest
    initial import

    Revision 1.1  1999/02/25 04:16:05  abigail
    Initial revision

=head1 AUTHOR

The Perl implementation of I<true> and I<false>
was written by Abigail, I<abigail@fnx.com>.

=head1 COPYRIGHT and LICENSE

This program is copyright by Abigail 1999.

This program is free and open software. You may use, modify, distribute
and sell this program (and any modified variants) in any way you wish,
provided you do not restrict others to do the same.

=cut

