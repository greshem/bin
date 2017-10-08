#!/usr/bin/perl

# Copyright 1999 Nathan Scott Thompson ( quimby at city-net dot com )
# You may use this according to the GNU Public License: see http://www.gnu.org
# Documentation at bottom.

if ( $ARGV[0] eq '-w' )
{
    $Words_Only = 1;
    shift;
}
$ARGV[0] ||= '-';

$HC = '\%';     # default hyphenation characters

foreach $filename ( @ARGV )
{
    open( $filename, $filename ) or die "Can't open $filename: $!\n";
    $input = $filename;

    while ( <$input> )
    {
        next if ( /^[.']\s*TS/ .. /^[.']\s*TE/ );       # skip tbl constructs
        next if ( /^[.']\s*EQ/ .. /^[.']\s*EN/ );       # skip eqn constructs

        # Handle .nx by by closing the current file.
        # Handle both .nx and .so by opening the indicated file
        # only if it hasn't been read before.

        if ( /^[.']\s*(so|nx)\s+(\S+)/ )
        {
            if ( $1 eq 'nx' )
            {
                close $input;
                $input = pop @input;
            }
            unless ( $included{ $2 } )
            {
                ++$included{ $2 };
                if ( open $2, $2 )
                {
                    push @input, $input;
                    $input = $2;
                }
                else
                {
                    warn "Can't open include file $2: $!\n";
                }
            }
        }
        $input = pop @input if ( eof($input) and @input );

        /^[.']hc\s+(\S)/ and $HC = $1;  # save optional hyphenation character
        s/^[.']\s*[A-Z]\w*\s*//;        # strip macro name, save arguments
        next if /^[.']/;                # ditch all other control requests

        s/\\".*//;                      # strip comments
        s/\\\((f[ifl])/$1/g;            # replace fi, ff, fl ligatures
        s/\\\(F([il])/ff$1/g;           # replace ffi, ffl ligatures
        s/\\0/ /g;                      # replace \0 with space
        s/\\\((hy|mi|em)/-/g;           # replace \(hy, \(mi, \(em with dash
        s/\\\(../ /g;                   # replace all others with space

        s/\\[*fgns][+-]?\(..//g;        # remove \f(xx etc.
        s/\\[*fgn][+-]?.//g;            # remove \fx etc.
        s/\\s[+-]?\d+//g;               # remove \sN
        s/\\[bCDhHlLNoSvwxX]'[^']*'//g; # remove those with quoted arguments
        s/\\[e'`|^&%acdprtu{}]//g;      # remove one character escapes
        s/\\[\$kz].//g;                 # remove \$x, \kx, \zx
        s/\\$//;                        # remove line continuation

        s/\\(.)/$1/g;                   # save all other escaped characters
        s/$HC//g;                       # remove optional hyphenation

        if ( $Words_Only )
        {
            print $&, "\n" while /\b[A-Za-z][A-Za-z\d']*[A-Za-z\d]\b/g;
        }
        else
        {
            print;
        }
    }
    close $input;
}

1;

__END__

=head1 NAME

deroff - strip troff, eqn and tbl sequences from text

=head1 SYNOPSIS

 deroff [ -w ] [ file ] ...

=head1 DESCRIPTION

B<deroff> reads the given files (or standard input) and strips
all troff control lines, comments, and escape sequences.
Additionally, all constructs for eqn (equation macros) and tbl
(table macros) are deleted.  The troff `.so' and `.nx' commands
are followed to include other files (only once for each file.)

The B<-w> flag causes B<deroff> to print only words, one per line.
Words are considered to start with a letter and contain letters,
digits or apostrophes (but no trailing apostrophe.)
Single character words are ignored.

=head1 SEE ALSO

troff, eqn, tbl

=head1 BUGS

B<deroff> is a simpleton and does not attempt to interpret troff constructs.
