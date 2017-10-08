#!/usr/bin/perl -w
#
# tac - concatenate and print files in reverse
#
# mail tgy@chocobo.org < bug_reports
#
# Copyright (c) 1999 Moogle Stuffy Software.  All rights reserved.
# You may play with this software in accordance with the Perl Artistic License.

use Getopt::Std;

my $VERSION = '0.17';

getopts('bBrs:S:', \my %opts);
my %long = qw/
    b before
    B binary
    r regex
    s separator
    S size
/;
%opts = map {$long{$_}, $opts{$_}} keys %opts;

if (defined $opts{separator} && $opts{regex}) {
    for ($opts{separator}) {
        s!^/(.*)/\z!$1!s;
        $_ = qr/$_/;
    }
}

$opts{files} = \@ARGV;

my $fh = new IO::Tac %opts or die "$0: can't open file: $!\n";
print while <$fh>;

END {
    close STDOUT || die "$0: can't close stdout: $!\n";
    $? = 1 if $? == 255;  # from die
}

package IO::Tac;

use strict;
use Carp;
use Symbol;
use Fcntl;

sub new {
    my $class = shift;
    my $fh    = gensym;
    tie *$fh, $class, $fh, @_;
}

sub TIEHANDLE {
    my $class = shift;
    my $self  = shift;
    my (%opts, @files);

    if (@_ > 1) {       # Construct with name/value pairs.
        %opts = @_;
        %opts = map {lc, $opts{$_}} keys %opts;
        @files = @{$opts{files}} if $opts{files};
    } else {            # Construct with one filename.
        @files = @_;
    }

    *$self = {
        %opts,
        lines   => [],  # Lines in memory.
        scrap   => '',  # Incomplete line.
        EOF     => 0,   # Finished reading current file.
        count   => 0,   # Current line number.
        ends    => [],  # Array of ORS for 'autoline'.
    };

    # Set mode for opening file.
    my $mode  = O_RDONLY;
       $mode |= O_BINARY if *$self->{binary};

    # Open files for reading.
    @files = map {
        local *FH;
        sysopen FH, $_, $mode   or return;
        sysseek FH, 0, 2        or return;
        [$_, *FH];
    } @files ? @files : @ARGV;

    # Add files and filehandles to object.
    *$self->{files} = @files ? \@files : [['-', *STDIN]];

    # Keep track of current file.
    $ARGV = *$self->{files}[0][0];

    # Save $\ in case 'autoline' changes it.
    *$self->{ORS} = $\;

    # Process record separator.
    my ($RS) = map {
        ! defined $_                      ? '\n'     : # Default to newline.
          ref $_                          ? $_       : # Regular expression.
        ! length && ++*$self->{paragraph} ? '\n\n+'  : # Paragraph mode.
          quotemeta                                    # Literal string.
    } defined $opts{separator} ? $opts{separator} : $/;

    if (ref $RS eq 'SCALAR') {  # Record mode.
        *$self->{record} = 1;
        *$self->{binary} = 1;
        *$self->{size}   = $$RS;
        *$self->{RE} = {
            broken  => qr/\Z-\A/,   # Never match.
            RS      => qr/^/,       # Always match.
        };
    } else {                    # Line mode.
        *$self->{size} ||= 8192;
        *$self->{RE} = {
            broken  => qr/\A$RS/,   # RS broken at chunk boundary.
            RS      => qr/$RS/,     # Match RS.
            capture => qr/($RS)/,   # Capture RS.
            line    => qr/((?s:.*?)$RS|(?s:.+))/,   # Match whole line.
        };
    }

    # autoline      => boolean to indicate if option was set
    # autoline_ors  => output record separator
    # chomp         => separate from rest of autoline
    @{*$self}{qw/autoline_ors autoline/} = (*$self->{autoline}, 1)
        if exists *$self->{autoline};
    *$self->{chomp} = *$self->{autoline} && defined $_ && ! length $_
        for *$self->{autoline_ors};
    *$self->{chomp} and undef *$self->{autoline};
    *$self->{autoline_ors} = "\n\n"
        if *$self->{paragraph} && ! defined *$self->{autoline};

    bless $self, $class;
}

sub READLINE {
    my $self = shift;

    @{*$self->{lines}} or *$self->{lines} = $self->get_lines or return;

    $. = ++*$self->{count}       if *$self->{autocount};
    $\ = pop @{*$self->{ends}}   if *$self->{autoline};

    pop @{*$self->{lines}};
}

sub get_lines {
    my $self = shift;

    # Start on next file.
    if (*$self->{EOF}) {
        shift @{*$self->{files}};
        unless (@{*$self->{files}}) {
            $\ = *$self->{ORS} if *$self->{autoline};
            *$self->{autoline} = 0;
            return;
        }
        $ARGV = *$self->{files}[0][0];
        *$self->{EOF} = 0;
    }

    local $_ = '';
    my %re   = %{*$self->{RE}};
    my $size = *$self->{size};
    my $fh   = *$self->{files}[0][1];
    my (@lines, @ends);

    if (*$self->{files}[0][0] eq '-') {
        # Next chunk of data comes from STDIN.
        local $/;
        $_ = <$fh>;
        *$self->{EOF}++;
        if (*$self->{record}) {
            unshift @lines, substr $_, -$size, $size, '' while length;
            return \@lines;
        }
    } else {
        # Get next chunk of data.  Make sure that it contains at least
        # one record separator (hence, at least one line) and that no
        # record separator has been broken across two chunks.
        my $file = *$self->{files}[0];
        CHUNK: {
            my $tell = tell $fh;
            unless ($tell > $size) {
                sysseek $fh, 0, 0       or confess "Bad seek on [$file]: $!";
                sysread $fh, $_, $tell  or confess "Bad read on [$file]: $!";
                *$self->{EOF}++, last CHUNK;
            }
            sysseek $fh, -$size, 1      or confess "Bad seek on [$file]: $!";
            sysread $fh, $_, $size      or confess "Bad read on [$file]: $!";
            /$re{broken}/   and $size += 10,                redo CHUNK;
            not /$re{RS}/   and $size += *$self->{size},    redo CHUNK;
        }
        unless (*$self->{EOF}) {
            sysseek $fh, -$size, 1      or confess "Bad seek on [$file]: $!";
        }
        return [$_] if *$self->{record};
    }

    # Append incomplete line from last chunk.
    $_ .= *$self->{scrap};

    # Parse chunk for records (a..c) and separators (1..3).  The last
    # record of a chunk may be missing its separator.
    #   Full chunk:     a1b2c3
    #   Half chunk:     a1b2c

    if (*$self->{chomp}) {
        @lines = split /$re{RS}/, $_, -1;
            # Full:  a b c ''
            # Half:  a b c
        *$self->{scrap} = *$self->{EOF} ? '' : shift @lines;
        length $lines[-1] or pop @lines;
            # Full:  b c
            # Half:  b c
    } elsif (*$self->{autoline}) {
        if (defined *$self->{autoline_ors}) {
            @lines = split /$re{RS}/, $_, -1;
                # Full:  a b c ''
                # Half:  a b c
            *$self->{scrap} = *$self->{EOF} ? '' : shift @lines;
            my $last = pop @lines;
            @ends = (*$self->{autoline_ors}) x @lines;
            push @lines, $last and push @ends, '' if length $last;
                # Full:  [a] b c + ors ors
                # Half:  [a] b c + ors ''
        } else {
            my @array = split /$re{capture}/, $_, -1;
                # Full:  a 1 b 2 c 3 ''
                # Half:  a 1 b 2 c
            *$self->{scrap} = *$self->{EOF} ? '' : join '', splice @array, 0, 2;
            length $array[-1] ? push @array, '' : pop @array;
            push @lines, shift @array and push @ends, shift @array while @array;
                # Full:  [a1] b c + 2 3
                # Half:  [a1] b c + 2 ''
        }
    } elsif (*$self->{before}) {
        if (*$self->{paragraph}) {
            @lines = split /$re{RS}/, $_, -1;
                # Full:  a b c ''
                # Half:  a b c
            if (*$self->{EOF}) {
                *$self->{scrap} = '';
                my $first = shift @lines;
                @lines = map "\n\n$_", @lines;
                unshift @lines, $first;
            } else {
                *$self->{scrap} = shift @lines;
                @lines = map "\n\n$_", @lines;
            }
                # Full:  [a] \n\nb \n\nc \n\n
                # Half:  [a] \n\nb \n\nc
        } else {
            my @array = split /$re{capture}/, $_, -1;
                # Full:  a 1 b 2 c 3 ''
                # Half:  a 1 b 2 c
            if (*$self->{EOF}) {
                *$self->{scrap} = '';
                my $first = shift @array;
                push @lines, join '', splice @array, 0, 2 while @array;
                unshift @lines, $first;
            } else {
                *$self->{scrap} = shift @array;
                push @lines, join '', splice @array, 0, 2 while @array;
            }
                # Full:  [a] 1b 2c 3
                # Half:  [a] 1b 2c
        }
    } else {
        if (*$self->{paragraph}) {
            @lines = split /$re{RS}/, $_, -1;
                # Full:  a b c ''
                # Half:  a b c
            *$self->{scrap} = *$self->{EOF} ? '' : shift @lines;
            my $last = pop @lines;
            @lines = map "$_\n\n", @lines;
            push @lines, $last if length $last;
                # Full:  [a] b\n\n c\n\n
                # Half:  [a] b\n\n c
        } else {
            @lines = /$re{line}/g;
            *$self->{scrap} = *$self->{EOF} ? '' : shift @lines;
                # Full:  [a1] b2 c3
                # Half:  [a1] b2 c
        }
    }

    # For autoline mode.
    *$self->{ends} = \@ends;

    \@lines;
}

sub CLOSE {
    my $self = shift;
    $. = *$self->{count} = 0;
    $\ = *$self->{ORS} if *$self->{autoline};
}

sub DESTROY {
    shift->CLOSE;
}

# *readline = \&READLINE;
# *close    = \&CLOSE;

sub eof {
    my $self = shift;
    *$self->{EOF} && ! @{*$self->{lines}};
}

1;

__END__

=head1 NAME

tac - concatenate and print files in reverse

=head1 SYNOPSIS

B<tac> [-br] [-s separator] [-B] [-S bytes] [file...]

=head1 DESCRIPTION

B<tac> copies files or standard input to standard output with the order of
records reversed.

=head1 OPTIONS

=over

=item -b

Attach separator to the beginning of the record that it precedes in the file.

=item -B

Read files in binary mode.

=item -r

The separator is a regular expression.

=item -s STRING

Use STRING as record separator.  Set to C<''> for paragraph mode.  Defaults to
newline.

=item -S BYTES

Number of bytes to read at a time.  Defaults to 8192.

=back

=head1 NOTES

=over

=item 1

B<-B> and B<-S> are peculiar to this implementation of B<tac>.

=item 2

Regular expressions are as in Perl with some caveats:

=item /foo(bar)/

Do not use capturing parenthesis.  They will conflict with B<tac>'s internal use
of them.

=item /foo|bar/

Alternation may match out of sequence, because matches are made against chunks
of files rather than whole files.  Set B<-S> to a suitably large number to avoid
this.

=back

=head1 AUTHOR

Tim Gim Yee | tgy@chocobo.org | I want a moogle stuffy!

=head1 COPYRIGHT

Copyright (c) 1999 Moogle Stuffy Software.  All rights reserved.

You may play with this software in accordance with the Perl Artistic License.

=cut

