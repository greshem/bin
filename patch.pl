#!/usr/bin/perl -w
#
# patch - apply a diff file to an original
#
# mail tgy@chocobo.org < bug_reports
#
# Copyright (c) 1999 Moogle Stuffy Software.  All rights reserved.
# You may play with this software in accordance with the Perl Artistic License.

use strict;

my $VERSION = '0.26';

$|++;

if (@ARGV && $ARGV[0] eq '-v') {
    print split /^    /m, qq[
        This is patch $VERSION written in Perl.

        Copyright (c) 1999 Moogle Stuffy Software.  All rights reserved.

        You may play with this software in accordance with the
        Perl Artistic License.
    ];
    exit;
}

my ($patchfile, @options);

if (@ARGV) {
    require Getopt::Long;
    Getopt::Long::Configure(qw/
        bundling
        no_ignore_case
    /);

    # List of supported options and acceptable arguments.
    my @desc = qw/
        suffix|b=s              force|f                 reject-file|r=s
        prefix|B=s              batch|t                 reverse|R
        context|c               fuzz|F=i                silent|quiet|s
        check|C                 ignore-whitespace|l     skip|S
        directory|d=s           normal|n                unified|u
        ifdef|D=s               forward|N               version|v
        ed|e                    output|o=s              version-control|V=s
        remove-empty-files|E    strip|p=i               debug|x=i
    /;

    # Each patch may have its own set of options.  These are separated by
    # a '+' on the command line.
    my @opts;
    for (@ARGV, '+') {  # Now '+' terminated instead of separated...
        if ($_ eq '+') {
            push @options, [splice @opts, 0];
        } else {
            push @opts, $_;
        }
    }

    # Parse each set of options into a hash.
    my $next = 0;
    for (@options) {
        local @ARGV = @$_;
        Getopt::Long::GetOptions(\my %opts, @desc);
        $opts{origfile} = shift;
        $_ = \%opts;
        $patchfile = shift unless $next++;
    }
}

$patchfile = '-' unless defined $patchfile;

my $patch = Patch->new(@options);

tie *PATCH, Pushback => $patchfile or die "Can't open '$patchfile': $!";

# Extract patches from patchfile.  We unread/pushback lines by printing to
# the PATCH filehandle:  'print PATCH'
PATCH:
while (<PATCH>) {
    if (/^(\s*)(\@\@ -(\d+)(?:,(\d+))? \+(\d+)(?:,(\d+))? \@\@\n)/) {
        # UNIFIED DIFF
        my ($space, $range, $i_start, $i_lines, $o_start, $o_lines) =
           ($1,     $2,     $3,       $4 || 1,  $5,       $6 || 1);
        $patch->bless('unified') or next PATCH;
        my @hunk;
        my %saw = map {$_, 0} split //, ' +-';
        my $re = qr/^$space([ +-])/;
        while (<PATCH>) {
            unless (s/$re/$1/) {
                $patch->note("Short hunk ignored.\n");
                $patch->reject($range, @hunk);
                print PATCH;
                next  PATCH;
            }
            push @hunk, $_;
            $saw{$1}++;
            last if $saw{'-'} + $saw{' '} == $i_lines
                 && $saw{'+'} + $saw{' '} == $o_lines;
        }
        $patch->apply($i_start, $o_start, @hunk)
            or $patch->reject($range, @hunk);
    } elsif (/^(\s*)\*{15}$/) {
        # CONTEXT DIFF
        my $space = $1;
        $_ = <PATCH>;
        unless (/^$space(\*\*\* (\d+)(?:,(\d+))? \*\*\*\*\n)/) {
            print PATCH;
            next  PATCH;
        }
        my ($i_range, $i_start, $i_end, @i_hunk) = ($1, $2, $3 || $2);
        my ($o_range, $o_start, $o_end, @o_hunk);
        $patch->bless('context') or next PATCH;
        my $o_hunk = qr/^$space(--- (\d+)(?:,(\d+))? ----\n)/;
        my $re = qr/^$space([ !-] )/;
        $_ = <PATCH>;
        if (/$o_hunk/) {
            ($o_range, $o_start, $o_end) = ($1, $2, $3 || $2);
        } else {
            print PATCH;
            for ($i_start..$i_end) {
                $_ = <PATCH>;
                unless (s/$re/$1/) {
                    $patch->note("Short hunk ignored.\n");
                    $patch->reject($i_range, @i_hunk);
                    print PATCH;
                    next  PATCH;
                }
                push @i_hunk, $_;
            }
            $_ = <PATCH>;
            unless (/$o_hunk/) {
                $patch->note("Short hunk ignored...no second line range.\n");
                $patch->reject($i_range, @i_hunk);
                print PATCH;
                next  PATCH;
            }
            ($o_range, $o_start, $o_end) = ($1, $2, $3 || $2);
        }
        $re = qr/^$space([ !+] )/;
        $_ = <PATCH>;
        if (/^$space\*{15}$/) {
            print PATCH;
        } else {
            print PATCH;
            for ($o_start..$o_end) {
                $_ = <PATCH>;
                unless (s/$re/$1/) {
                    $patch->note("Short hunk ignored.\n");
                    $patch->reject($i_range, @i_hunk, $o_range, @o_hunk);
                    print PATCH;
                    next  PATCH;
                }
                push @o_hunk, $_;
            }
        }
        $patch->apply($i_start, $o_start, \@i_hunk, \@o_hunk)
            or $patch->reject($i_range, @i_hunk, $o_range, @o_hunk);
    } elsif (/^(\s*)((\d+)(?:,(\d+))?([acd])(\d+)(?:,(\d+))?\n)/) {
        # NORMAL DIFF
        my ($space, $range, $i_start, $i_end, $cmd, $o_start, $o_end) =
           ($1,     $2,     $3,     $4 || $3, $5,   $6,       $7 || $6);
        $patch->bless('normal') or next PATCH;
        my (@d_hunk, @a_hunk);
        my $d_re = qr/^$space< /;
        my $a_re = qr/^$space> /;
        if ($cmd eq 'c' || $cmd eq 'd') {
            for ($i_start..$i_end) {
                $_ = <PATCH>;
                unless (s/$d_re//) {
                    $patch->note("Short hunk ignored.\n");
                    $patch->reject($range, @d_hunk);
                    print PATCH;
                    next  PATCH;
                }
                push @d_hunk, $_;
            }
        }
        if ($cmd eq 'c') {
            $_ = <PATCH>;
            unless ($_ eq "---\n") {
                $patch->note("Short hunk ignored...no '---' separator.\n");
                $patch->reject($range, @d_hunk);
                print PATCH;
                next  PATCH;
            }
        }
        if ($cmd eq 'c' || $cmd eq 'a') {
            for ($o_start..$o_end) {
                $_ = <PATCH>;
                unless (s/$a_re//) {
                    $patch->note("Short hunk ignored.\n");
                    $patch->reject($range, @d_hunk, "---\n", @a_hunk);
                    print PATCH;
                    next  PATCH;
                }
                push @a_hunk, $_;
            }
        }
        $patch->apply($i_start, $o_start, $cmd, \@d_hunk, \@a_hunk)
            or $patch->reject($range, @d_hunk, "---\n", @a_hunk);
    } elsif (/^(\s*)\d+(?:,\d+)?[acd]$/) {
        # ED SCRIPT
        my $space = qr/^$1/;
        $patch->bless('ed') or next PATCH;
        print PATCH;
        my @cmd;
        ED:
        while (<PATCH>) {
            unless (s/$space// && m!^\d+(?:,\d+)?([acd]|s\Q/^\.\././\E)$!) {
                print PATCH;
                last ED;
            }
            push @cmd, [$_];
            $1 =~ /^[ac]$/ or next;
            while (<PATCH>) {
                unless (s/$space//) {
                    print PATCH;
                    last ED;
                }
                push @{$cmd[-1]}, $_;
                last if /^\.$/;
            }
        }
        $patch->apply(@cmd) or $patch->reject(map @$_, @cmd);
    } else {
        # GARBAGE
        $patch->garbage($_);
    }
}

close PATCH;

if (ref $patch eq 'Patch') {
    $patch->note("Hmm...  I can't seem to find a patch in there anywhere.\n");
} else {
    $patch->end;
}

$patch->note("done\n");
exit $patch->error ? 1 : 0;

END {
    close STDOUT || die "$0: can't close stdout: $!\n";
    $? = 1 if $? == 255;  # from die
}





package Patch;

use vars qw/$ERROR/;

# Class data.
BEGIN {
    $ERROR = 0;
}

sub import {
    no strict 'refs';
    *{caller() . '::throw'} = \&throw;
    @{caller() . '::ISA'}   = 'Patch';
}

# Simple throw/catch error handling.
sub throw {
    $@ = join '', @_;
    $@ .= sprintf " at %s line %d\n", (caller)[1..2] unless $@ =~ /\n\z/;
    goto CATCH;
}

# Prints a prompt message and returns response.
sub prompt {
    print @_;
    local $_ = <STDIN>;
    chomp;
    $_;
}

# Constructs a Patch object.
sub new {
    my $class = shift;
    my %copy = %{$_[0]} if ref $_[0];
    bless {
        %copy,
        options => [@_],
        garbage => [],
        rejects => [],
    }, $class;
}

# Blesses object into a subclass.
sub bless {
    my $type = pop;
    my $class = "Patch::\u$type";

    my ($options, $garbage) = @{$_[0]}{'options', 'garbage'};

    # New hunk, same patch.
    $_[0]{hunk}++, return 1 if $_[0]->isa($class) && ! @$garbage;

    # Clean up previous Patch object first.
    $_[0]->end;

    # Get options/switches for new patch.
    my $self = @$options > 1    ? shift @$options :
               @$options == 1   ? { %{$options->[0]} } :
               {};
    bless $self, $class;

    # 'options' and 'garbage'  are probably better off as class
    # data.  Why didn't I do that before?  But it's not broken
    # so I'm not fixing it.
    $self->{options} = $options;    # @options 
    $self->{garbage} = [];          # garbage lines
    $self->{i_pos}   = 0;           # current position in 'in' file
    $self->{o_pos}   = 0;           # just for symmetry
    $self->{i_lines} = 0;           # lines read in 'in' file
    $self->{o_lines} = 0;           # lines written to 'out' file
    $self->{hunk}    = 1;           # current hunk number
    $self->{rejects} = [];          # save rejected hunks here
    $self->{fuzz}    = 2  unless defined $self->{fuzz} && $self->{fuzz} >= 0;
    $self->{ifdef}   = '' unless defined $self->{ifdef};

    # Skip patch?
    $self->{skip} and $self->skip;

    # -c, -e, -n, -u
    $self->{$_} and $type eq $_ || $self->skip("Not a $_ diff!\n")
        for qw/context ed normal unified/;

    # Speculate to user.
    my $n = $type eq 'ed' ? 'n' : '';
    $self->note("Hmm...  Looks like a$n $type diff to me...\n");

    # Change directories.
    for ($self->{directory}) {
        defined or last;
        chdir $_ or $self->skip("Can't chdir '$_': $!\n");
    }

    # Get original file to patch...
    my $orig = $self->{origfile};                   # ...from -o

    unless (defined $orig) {
        $orig = $self->rummage($garbage);           # ...from leading garbage
        if (defined $orig) {
            $self->note(
                "The text leading up to this was:\n",
                "--------------------------\n",
                map("|$_", @$garbage),
                "--------------------------\n",
            );
        } else {
            $self->skip if $self->{force} || $self->{batch};
            $orig = prompt ('File to patch: ');     # ...from user
        }
    }

    # Make sure original file exists.
    if ($self->{force} || $self->{batch}) {
        -e $orig or $self->skip;
    } else {
        until (-e $orig) {
            $self->skip unless prompt (
                'No file found--skip this patch? [n] '
            ) =~ /^[yY]/;
            $orig = prompt (
                'File to patch: '
            );
        }
    }

    my ($in, $out);

    # Create backup file.  I have no clue what Plan A is really supposed to be.
    if ($self->{check}) {
        $self->note("Checking patch against file $orig using Plan C...\n");
        ($in, $out) = ($orig, '');
    } elsif (defined $self->{output}) {
        $self->note("Patching file $orig using Plan B...\n");
        local $_ = $self->{output};
        $self->skip if -e && not rename $_, $self->backup($_) and
            $self->{force} || $self->{batch} || prompt (
                'Failed to backup output file--skip this patch? [n] '
            ) =~ /^[yY]/;
        ($in, $out) = ($orig, $self->{output});
    } else {
        $self->note("Patching file $orig using Plan A...\n");
        my $back = $self->backup($orig);
        if (rename $orig, $back) {
            ($in, $out) = ($back, $orig);
        } else {
            $self->skip unless $self->{force} || $self->{batch} or prompt (
                'Failed to backup original file--skip this patch? [n] '
            ) !~ /^[yY]/;
            ($in, $out) = ($orig, $orig);
        }
    }

    # Open original file.
    local *IN;
    open IN, "< $in" or $self->skip("Couldn't open INFILE: $!\n");
    binmode IN;
    $self->{i_fh} = *IN;    # input filehandle
    $self->{i_file} = $in;  # input filename

    # Like /dev/null
    local *NULL;
    tie *NULL, 'Dev::Null';

    # Open output file.
    if ($self->{check}) {
        $self->{o_fh} = \*NULL;     # output filehandle
        $self->{d_fh} = \*NULL;     # ifdef filehandle
    } else {
        local *OUT;
        open OUT, "+> $out" or $self->skip("Couldn't open OUTFILE: $!\n");
        binmode OUT;
        $|++, select $_ for select OUT;
        $self->{o_fh}   = *OUT;
        $self->{o_file} = $out;
        $self->{d_fh}   = length $self->{ifdef} ? *OUT : \*NULL;
    }

    $self->{'reject-file'} = "$out.rej" unless defined $self->{'reject-file'};

    # Check for 'Prereq:' line.
    unless ($self->{force}) {
        my $prereq = (map /^Prereq:\s*(\S+)/, @$garbage)[-1];
        if (defined $prereq) {
            $prereq = qr/\b$prereq\b/;
            my $found;
            while (<IN>) {
                $found++, last if /$prereq/;
            }
            seek IN, 0, 0 or $self->skip("Couldn't seek INFILE: $!\n");
            $self->skip if not $found and $self->{batch} || prompt (
                'File does not match "Prereq: $1"--skip this patch? [n] '
            ) =~ /^[yY]/;
        }
    }

    SKIP:
    $_[0] = $self;
}

# Skip current patch.
sub skip {
    my $self = shift;
    $self->note(@_) if @_;
    $self->note("Skipping patch...\n");
    $self->{skip}++;
    goto SKIP;
}

# Let user know what's happening.
sub note {
    my $self = shift;
    print @_ unless $self->{silent} || $self->{skip};
}

# Add to lines of leading garbage.
sub garbage {
    push @{shift->{garbage}}, @_;
}

# Add to rejected hunks.
sub reject {
    push @{shift->{rejects}}, [@_];
}

# Total number of hunks rejected.
sub error {
    $ERROR;
}

# End of patch clean up.
sub end {
    my $self = shift;

    return if $self->{skip} || ref $self eq 'Patch';

    $self->print_tail;
    $self->print_rejects;
    $self->remove_empty_files;
}

# Output any lines left in input handle.
sub print_tail {
    my $self = shift;
    print {$self->{o_fh}} readline $self->{i_fh};
}

# Output rejected hunks to reject file.
sub print_rejects {
    my $self = shift;
    my @rej = @{$self->{rejects}};

    $ERROR += @rej;

    @rej or return;

    $self->note(
        @rej . " out of $self->{hunk} hunks ignored--saving rejects to ",
        "$self->{'reject-file'}\n\n"
    );
    if (open REJ, "> $self->{'reject-file'}") {
        print REJ map @$_, @rej;
        close REJ;
    } else {
        $self->note("Couldn't open reject file: $!\n");
    }
}

# Remove empty files... d'uh
sub remove_empty_files {
    my $self = shift;
    $self->{'remove-empty-files'} or return;
    close $self->{o_fh};
    defined && -z and $self->note(
        unlink($_)
        ? "Removed empty file '$_'.\n"
        : "Can't remove empty file '$_': $!\n"
    ) for $self->{o_file};
}

# Go through leading garbage looking for name of file to patch.
sub rummage {
    my ($self, $garbage) = @_;

    for (reverse @$garbage) {
        /^Index:\s*(\S+)/ or next;
        my $file = $self->strip($1);
        -e $file or next;
        return $file;
    }

    return;
}

# Strip slashes from path.
sub strip {
    my $self = shift;
    my $path = shift;
    $path = $_ unless defined $path;

    local $^W;
    if (not exists $self->{strip}) {
        unless ($path =~ m!^/!) {
            $path =~ m!^(.*/)?(.+)$!;
            $path = $2 unless -e $1;
        }
    } elsif ($self->{strip} > 0) {
        my $i = $self->{strip};
        $path =~ s![^/]*/!! while $i--;
    }

    $path;
}

# Create a backup file from options.
sub backup {
    my ($self, $file) = @_;
    $file =
        $self->{prefix}                 ? "$self->{prefix}$file" :
        $self->{'version-control'}      ? $self->version_control_backup(
            $file, $self->{'version-control'}) :
        $self->{suffix}                 ? "$file$self->{suffix}" :
        $ENV{VERSION_CONTROL}           ? $self->version_control_backup(
            $file, $ENV{VERSION_CONTROL}) :
        $ENV{SIMPLE_BACKUP_SUFFIX}      ? "$file$ENV{SIMPLE_BACKUP_SUFFIX}" :
                                          "$file.orig";  # long filename
    my ($name, $extension) = $file =~ /^(.+)\.([^.]+)$/
        ? ($1, $2)
        : ($file, '');
    my $ext = $extension;
    while (-e $file) {
        if ($ext !~ s/([a-z])/\U$1/) {
            $ext = $extension;
            $name =~ s/.// or die "Couldn't create a good backup filename.\n";
        }
        $file = $name . $ext;
    }
    $file;
}

# Create a backup file using version control.
sub version_control_backup {
    my ($self, $file, $version) = @_;
    if ($version =~ /^(?:ne|s)/) {  # never|simple
        $file .= $self->suffix_backup;
    } else {
        opendir DIR, '.' or die "Can't open dir '.': $!";
        my $re = qr/^\Q$file\E\.~(\d+)~$/;
        my @files = map /$re/, readdir DIR;
        close DIR;
        if (@files) {               # version number already exists
            my $next = 1 + (sort {$a <=> $b} @files)[-1];
            $file .= ".~$next~";
        } else {                    # t|numbered   # nil|existing
            $file .= $version =~ /^(?:t|nu)/ ? '.~1~' : $self->suffix_backup;
        }
    }
    $file;
}

# Create a backup file using suffix.
sub suffix_backup {
    my $self = shift;
    return $self->{suffix}              if $self->{suffix};
    return $ENV{SIMPLE_BACKUP_SUFFIX}   if $ENV{SIMPLE_BACKUP_SUFFIX};
    return '.orig';
}

# Apply a patch hunk.  The default assumes a unified diff.
sub apply {
    my ($self, $i_start, $o_start, @hunk) = @_;

    $self->{skip} and throw 'SKIP...ignore this patch';

    if ($self->{reverse}) {
        my $not = { qw/ + - - + / };
        s/^([+-])/$not->{$1}/ for @hunk;
    }

    my @context = map /^[ -](.*)/s, @hunk;
    my $position;
    my $fuzz = 0;

    if (@context) {
        # Find a place to apply hunk where context matches.
        for (0..$self->{fuzz}) {
            my ($pos, $lines) = ($self->{i_pos}, 0);
            while (1) {
                ($pos, $lines) = $self->index(\@context, $pos, $lines) or last;
                my $line = $self->{i_lines} + $lines + 1;
                if ($line >= $i_start) {
                    my $off = $line - $i_start;
                    $position = [$lines, $off]
                        unless $position && $position->[-1] < $off;
                    last;
                }
                $position = [$lines, $i_start - $line];
                $pos++, $lines = 1;
            }
            last if $position;
            last unless $hunk[0]  =~ /^ / && shift @hunk
                     or $hunk[-1] =~ /^ / && pop @hunk;
            @context = map /^[ -](.*)/s, @hunk or last;
            $fuzz++;
        }
        # If there's nowhere to apply the first hunk, we check if it is
        # a reversed patch.
        if ($self->{hunk} == 1) {
            if ($self->{reverse_check}) {
                $self->{reverse_check} = 0;
                if ($position) {
                    unless ($self->{batch}) {
                        local $_ = prompt (
                            'Reversed (or previously applied) patch detected!',
                            '  Assume -R? [y] '
                        );
                        if (/^[nN]/) {
                            $self->{reverse} = 0;
                            $position = 0;
                            prompt ('Apply anyway? [n] ') =~ /^[yY]/
                                or throw 'SKIP...ignore this patch';
                        }
                    }
                } else {
                    throw 'SKIP...ignore this patch' if $self->{forward};
                }
            } else {
                unless ($position || $self->{reverse} || $self->{force}) {
                    $self->{reverse_check} = 1;
                    $self->{reverse} = 1;
                    shift;
                    return $self->apply(@_);
                }
            }
        }
        $position or throw "Couldn't find anywhere to put hunk.\n";
    } else {
        # No context.  Use given position.
        $position = [$i_start - $self->{i_lines} - 1]
    }

    my $in  = $self->{i_fh};
    my $out = $self->{o_fh};
    my $def = $self->{d_fh};
    my $ifdef = $self->{ifdef};

    # Make sure we're where we left off.
    seek $in, $self->{i_pos}, 0 or throw "Couldn't seek INFILE: $!";

    my $line = $self->{o_lines} + $position->[0] + 1;
    my $off  = $line - $o_start;

    # Set to new position.
    $self->{i_lines} += $position->[0];
    $self->{o_lines} += $position->[0];

    print $out scalar <$in> while $position->[0]--;

    # Apply hunk.
    my $was = ' ';
    for (@hunk) {
        /^([ +-])(.*)/s;
        my $cmd = substr $_, 0, 1, '';
        if ($cmd eq '-') {
            $cmd eq $was or print $def "#ifndef $ifdef\n";
            print $def scalar <$in>;
            $self->{i_lines}++;
        } elsif ($cmd eq '+') {
            $cmd eq $was or print $def $was eq ' ' ?
                "#ifdef $ifdef\n" :
                "#else\n";
            print $out $_;
            $self->{o_lines}++;
        } else {
            $cmd eq $was or print $def "#endif /* $ifdef */\n";
            print $out scalar <$in>;
            $self->{i_lines}++;
            $self->{o_lines}++;
        }
        $was = $cmd;
    }
    $was eq ' ' or print $def "#endif /* $ifdef */\n";

    # Keep track of where we leave off.
    $self->{i_pos} = tell $in;

    # Report success to user.
    $self->note("Hunk #$self->{hunk} succeeded at $line.\n");
    $self->note("    Offset: $off\n") if $off;
    $self->note("    Fuzz: $fuzz\n") if $fuzz;

    return 1;

    # Or report failure.
    CATCH:
    $self->{skip}++ if $@ =~ /^SKIP/;
    $self->note( $self->{skip}
        ? "Hunk #$self->{hunk} ignored at $o_start.\n"
        : "Hunk #$self->{hunk} failed--$@"
    );
    return;
}

# Find where an array of lines matches in a file after a given position.
#   $match  => [array of lines]
#   $pos    => search after this position and...
#   $lines  => ...after this many lines after $pos
# Returns the position of the match and the number of lines between the
# starting and matching positions.
sub index {
    my ($self, $match, $pos, $lines) = @_;
    my $in = $self->{i_fh};

    seek $in, $pos, 0 or throw "Couldn't seek INFILE [$in, 0, $pos]: $!";
    <$in> while $lines--;

    if ($self->{'ignore-whitespace'}) {
        s/\s+/ /g for @$match;
    }

    my $tell = tell $in;
    my $line = 0;

    while (<$in>) {
        s/\s+/ /g if $self->{'ignore-whitespace'};
        if ($_ eq $match->[0]) {
            my $fail;
            for (1..$#$match) {
                my $line = <$in>;
                $line =~ s/\s+/ /g if $self->{'ignore-whitespace'};
                $line eq $match->[$_] or $fail++, last;
            }
            if ($fail) {
                seek $in, $tell, 0 or throw "Couldn't seek INFILE: $!";
                <$in>;
            } else {
                return ($tell, $line);
            }
        }
        $line++;
        $tell = tell $in;
    }

    return;

    CATCH: $self->note($@), return;
}




package Patch::Context;

BEGIN { Patch->import }

# Convert hunk to unified diff, then apply.
sub apply {
    my ($self, $i_start, $o_start, $i_hunk, $o_hunk) = @_;

    my @hunk;
    my @i_hunk = @$i_hunk;
    my @o_hunk = @$o_hunk;

    s/^(.) /$1/ for @i_hunk, @o_hunk;

    while (@i_hunk and @o_hunk) {
        my ($i, $o) = (shift @i_hunk, shift @o_hunk);
        if ($i eq $o) {
            push @hunk, $i;
            next;
        }
        while ($i =~ s/^[!-]/-/) {
            push @hunk, $i;
            $i = shift @i_hunk;
        }
        while ($o =~ s/^[!+]/+/) {
            push @hunk, $o;
            $o = shift @o_hunk;
        }
        push @hunk, $i;
    }
    push @hunk, @i_hunk, @o_hunk;

    $self->SUPER::apply($i_start, $o_start, @hunk);
}

# Check for filename in diff header, then in 'Index:' line.
sub rummage {
    my ($self, $garbage) = @_;

    my @files = grep -e, map $self->strip,
        map /^\s*(?:\*\*\*|---) (\S+)/, @$garbage[-1, -2];

    my $file =
        @files == 1 ? $files[0] :
        @files == 2 ? $files[length $files[0] > length $files[1]] :
        $self->SUPER::rummage($garbage);

    return $file;
}




package Patch::Ed;

BEGIN { Patch->import }

# Pipe ed script to ed or try to manually process.
sub apply {
    my ($self, @cmd) = @_;

    $self->{skip} and throw 'SKIP...ignore this patch';

    my $out = $self->{o_fh};

    $self->{check} and goto PLAN_J;

    # We start out by adding a magic line to our output.  If this line
    # is still there after piping to ed, then ed failed.  We do this
    # because win32 will silently fail if there is no ed program.
    my $magic = "#!/i/want/a/moogle/stuffy\n";
    print $out $magic;

    # Pipe to ed.
    eval {
        local $SIG{PIPE} = sub { die 'Pipe broke...' };
        local $SIG{CHLD} = sub { die 'Bad child...' };
        open ED, "| ed - -s $self->{i_file}" or die "Couldn't fork ed: $!";
        print ED map @$_, @cmd               or die "Couldn't print ed: $!";
        print ED "1,\$w $self->{o_file}"     or die "Couldn't print ed: $!";
        close ED                             or die "Couldn't close ed: $?";
    };

    # Did pipe to ed work?
    unless ($@ or <$out> ne $magic) {
        $self->note("Hunk #$self->{hunk} succeeded at 1.\n");
        return 1;
    }

    # Erase any trace of magic line.
    truncate $out, 0 or throw "Couldn't truncate OUT: $!";
    seek $out, 0, 0  or throw "Couldn't seek OUT: $!";

    # Try to apply ed script by hand.
    $self->note("Pipe to ed failed.  Switching to Plan J...\n");

    PLAN_J:

    # Pre-process each ed command.  Ed diffs are reversed (so that each
    # command doesn't end up changing the line numbers of subsequent
    # commands).  But we need to apply diffs in a forward direction because
    # our filehandles are oriented that way.  So we calculate the @offset
    # in line number that this will cause as we go.
    my @offset;
    for (my $i = 0; $i < @cmd; $i++) {
        my @hunk = @{$cmd[$i]};

        shift(@hunk) =~ m!^(\d+)(?:,(\d+))?([acds])!
            or throw "Unable to parse ed script.";

        my ($start, $end, $cmd) = ($1, $2 || $1, $3);

        # We don't parse substitution commands and assume they all mean
        # s/\.\././ even if they really mean s/\s+// or such.  And we
        # blindly apply the command to the previous hunk.
        if ($cmd eq 's') {
            $cmd[$i] = '';
            s/\.\././ for @{$cmd[$i-1][3]};
            next;
        }

        # Remove '.' line used to terminate hunks.
        pop @hunk if $cmd =~ /^[ac]/;

        # Calculate where we actually start and end by removing any offsets.
        my ($s, $e) = ($start, $end);
        for (@offset) {
            $start > $_->[0] or next;
            $s -= $_->[1];
            $e -= $_->[1];
        }

        # Add to the total offset.
        push @offset, [$start, map {
            /^c/ ? scalar @hunk - ($end + 1 - $start) :
            /^a/ ? scalar @hunk :
            /^d/ ? $end + 1 - $start :
            0
        } $cmd];

        # Post-processed command.
        $cmd[$i] = [$s, $e, $cmd, \@hunk, $i];
    }

    # Sort based on calculated start positions or on original order.
    # Substitution commands have already been applied and are ignored.
    @cmd = sort {
        $a->[0] <=> $b->[0] || $a->[-1] <=> $b->[-1]
    } grep ref, @cmd;

    my $in  = $self->{i_fh};
    my $def = $self->{d_fh};
    my $ifdef = $self->{ifdef};

    # Apply each command.
    for (@cmd) {
        my ($start, $end, $cmd, $hunk) = @$_;
        if ($cmd eq 'a') {
            my $diff = $start - $self->{i_lines};
            print $out scalar <$in> while $diff--;
            print $def "#ifdef $ifdef\n";
            print $out @$hunk;
            $self->{i_lines} = $start;
        } elsif ($cmd eq 'd') {
            my $diff = $start - $self->{i_lines} - 1;
            print $out scalar <$in> while $diff--;
            print $def "#ifndef $ifdef\n";
            print $def scalar <$in> for $start..$end;
            $self->{i_lines} = $end;
        } elsif ($cmd eq 'c') {
            my $diff = $start - $self->{i_lines} - 1;
            print $out scalar <$in> while $diff--;
            print $def "#ifndef $ifdef\n";
            print $def scalar <$in> for $start..$end;
            print $def "#else\n";
            print $out @$hunk;
            $self->{i_lines} = $end;
        }
        print $def "#endif /* $ifdef */\n";
    }

    # Output any lines left in input handle.
    print $out readline $in;

    # Report success to user.
    for (my $i = 0; $i < @cmd; $i++) {
        $self->note(
            'Hunk #', $i+1, ' succeeded at ',
            $cmd[$i - not ref $cmd[$i]][0], "\n",
        );
    }

    return 1;

    # Or report failure.
    CATCH:
    $self->{skip}++ if $@ =~ /^SKIP/;
    $self->note( $self->{skip}
        ? "Hunk #$self->{hunk} ignored at 1.\n"
        : "Hunk #$self->{hunk} failed--$@"
    );
    return;
}

# End of patch clean up.  $self->print_tail is omitted because ed diffs are
# applied all at once rather than one hunk at a time.
sub end {
    my $self = shift;

    return if $self->{skip};

    $self->print_rejects;
    $self->remove_empty_files;
}




package Patch::Normal;

BEGIN { Patch->import }

# Convert hunk to unified diff, then apply.
sub apply {
    my ($self, $i_start, $o_start, $cmd, $d_hunk, $a_hunk) = @_;

    $i_start++ if $cmd eq 'a';
    $o_start++ if $cmd eq 'd';
    my @hunk;
    push @hunk, map "-$_", @$d_hunk;
    push @hunk, map "+$_", @$a_hunk;

    $self->SUPER::apply($i_start, $o_start, @hunk);
}




package Patch::Unified;

BEGIN { Patch->import }

# Check for filename in diff header, then in 'Index:' line.
sub rummage {
    my ($self, $garbage) = @_;

    my @files = grep -e, map $self->strip,
        map /^\s*(?:---|\+\+\+) (\S+)/, @$garbage[-1, -2];

    my $file =
        @files == 1 ? $files[0] :
        @files == 2 ? $files[length $files[0] > length $files[1]] :
        $self->SUPER::rummage($garbage);

    return $file;
}




package Pushback;

# Create filehandles that can unread or push lines back into queue.

sub TIEHANDLE {
    my ($class, $file) = @_;
    local *FH;
    open *FH, "< $file" or return;
    bless [*FH], $class;
}

sub READLINE {
    my $self = shift;
    @$self == 1 ? readline $self->[0] : pop @$self;
}

sub PRINT {
    my $self = shift;
    $self->[1] = shift;
}

sub CLOSE {
    my $self = shift;
    $self = undef;
}




package Dev::Null;

# Create filehandles that go nowhere.

sub TIEHANDLE { bless \my $null }
sub PRINT {}
sub PRINTF {}
sub WRITE {}
sub READLINE {''}
sub READ {''}
sub GETC {''}




__END__

=head1 NAME

patch - apply a diff file to an original

=head1 SYNOPSIS

B<patch> [options] [origfile [patchfile]] [+ [options] [origfile]]...

but usually just

B<patch> E<lt>patchfile

=head1 DESCRIPTION

I<Patch> will take a patch file containing any  of  the  four
forms  of  difference listing produced by the I<diff> program
and apply those differences to an original file, producing
a patched version.  By default, the patched version is put
in place of the original, with the original file backed up
to  the  same name with the extension ".orig" [see L<"note 1">],
or as  specified
by  the  B<-b>,  B<-B>,  or B<-V> switches.  The extension used for
making backup files may also  be  specified  in  the
B<SIMPLE_BACKUP_SUFFIX>  environment variable, which is overridden
by above switches.

If the backup file already exists,  B<patch>  creates  a  new
backup file name by changing the first lowercase letter in
the last component of the file's name into uppercase.   If
there  are  no  more  lowercase  letters  in  the name, it
removes the first character from  the  name.   It  repeats
this  process  until  it  comes up with a backup file that
does not already exist.

You may also specify where you want the output to go  with
a  B<-o> switch; if that file already exists, it is backed up
first.

If I<patchfile> is omitted, or is a hyphen, the patch will be
read from standard input.

Upon  startup, patch will attempt to determine the type of
the diff listing, unless over-ruled by a B<-c>, B<-e>, B<-n>, or B<-u>
switch.  Context diffs [see L<"note 2">], unified diffs,
and normal diffs are applied by the I<patch> program  itself,
while ed diffs are simply fed to the I<ed> editor via a pipe [see L<"note 3">].

I<Patch> will try to skip  any  leading  garbage,  apply  the
diff,  and then skip any trailing garbage.  Thus you could
feed an article or message containing a  diff  listing  to
I<patch>, and it should work.  If the entire diff is indented
by a consistent amount, this will be taken into account.

With context diffs, and to a  lesser  extent  with  normal
diffs, I<patch> can detect when the line numbers mentioned in
the patch are incorrect, and  will  attempt  to  find  the
correct place to apply each hunk of the patch.  A linear search is made  for  a
place  where  all  lines of the context match.
The hunk is applied at the place nearest the line number mentioned in the
diff [see L<"note 4">].
If no such
place is found, and it's a context diff, and  the  maximum
fuzz  factor  is set to 1 or more, then another scan takes
place ignoring the first and last  line  of  context.   If
that  fails,  and  the  maximum fuzz factor is set to 2 or
more, the first two and last  two  lines  of  context  are
ignored,  and  another scan is made.  (The default maximum
fuzz factor is 2.)   If  I<patch>  cannot  find  a  place  to
install  that  hunk of the patch, it will put the hunk out
to a reject file, which normally is the name of the output
file  plus ".rej" [see L<"note 1">].  The format of the
rejected hunk remains unchanged [see L<"note 5">]. 

As  each  hunk  is completed, you will be told whether the
hunk succeeded or failed, and which line (in the new file)
I<patch> thought the hunk should go on.  If this is different
from the line number specified in the  diff  you  will  be
told  the offset.  A single large offset MAY be an indication that a hunk was installed in the  wrong  place.   You
will  also  be  told if a fuzz factor was used to make the
match, in which case you should also  be  slightly  suspicious.

If  no  original  file  is  specified on the command line,
I<patch> will try to figure out from the leading garbage what
the  name of the file to edit is.  In the header of a context diff, the filename is found from lines beginning with
"***" or "---", with the shortest name of an existing file
winning.  Only context diffs have lines like that, but  if
there  is  an  "Index:" line in the leading garbage, I<patch>
will try to use the filename from that line.  The  context
diff  header  takes  precedence over an Index line.  If no
filename can be intuited from  the  leading  garbage,  you
will be asked for the name of the file to patch.

No attempt is made to look up SCCS or RCS files [see L<"note 6">].

Additionally, if the leading garbage contains a "Prereq: "
line,  I<patch>  will  take   the   first   word   from   the
prerequisites  line  (normally a version number) and check
the input file to see if that word can be found.  If  not,
I<patch> will ask for confirmation before proceeding.

The  upshot of all this is that you should be able to say,
while in a news interface, the following:

     | patch -d /usr/src/local/blurfl

and patch a file in the blurfl directory directly from the
article containing the patch.

If the patch file contains more than one patch, I<patch> will
try to apply each of them as if they  came  from  separate
patch  files.   This means, among other things, that it is
assumed that the name of the file to patch must be  determined  for  each diff listing, and that the garbage before
each diff listing will be examined for interesting  things
such  as filenames and revision level, as mentioned previously.  You can give switches (and another  original  file
name)  for the second and subsequent patches by separating
the corresponding argument lists by a '+'.  (The  argument
list  for  a  second or subsequent patch may not specify a
new patch file, however.)

I<Patch> recognizes the following switches:

=over

=item -b or --suffix

causes the next argument to  be  interpreted  as  the
backup  extension,  to be used in place of ".orig" [see L<"note 1">].

=item -B or --prefix

causes the next argument to be interpreted as a  prefix  to  the  backup  file  name. If this argument is
specified any argument from B<-b> will be ignored.

=item -c or --context

forces I<patch> to interpret the patch file as a context
diff.

=item -C or --check

checks  that  the patch would apply cleanly, but does
not modify anything.

=item -d or --directory

causes I<patch> to interpret  the  next  argument  as  a
directory, and cd to it before doing anything else.

=item -D or --ifdef

causes  I<patch>  to use the "#ifdef...#endif" construct
to mark changes.  The argument following will be used
as the differentiating symbol.  [see L<"note 7">]

=item -e or --ed

forces  I<patch>  to  interpret  the patch file as an ed
script.

=item -E or --remove-empty-files

causes I<patch> to remove output files  that  are  empty
after the patches have been applied.

=item -f or --force

forces  I<patch>  to  assume that the user knows exactly
what he or she is doing, and to  not  ask  any  questions.   It  assumes  the following: skip patches for
which a file to patch can't  be  found;  patch  files
even  though  they  have  the  wrong  version for the
``Prereq:''  line  in  the  patch;  and  assume  that
patches  are not reversed even if they look like they
are.  This option does not suppress  commentary;  use
B<-s> for that.

=item -t or --batch

similar  to  B<-f>, in that it suppresses questions, but
makes some different assumptions:  skip  patches  for
which  a  file  to  patch can't be found (the same as
B<-f>); skip patches for which the file  has  the  wrong
version  for  the  ``Prereq:'' line in the patch; and
assume that patches are reversed if  they  look  like
they are.

=item -Fnumber or --fuzz number

sets  the  maximum  fuzz  factor.   This  switch only
applies to context diffs, and causes I<patch> to  ignore
up  to  that  many  lines  in  looking  for places to
install a hunk.   Note  that  a  larger  fuzz  factor
increases  the  odds  of a faulty patch.  The default
fuzz factor is 2, and it may not be set to more  than
the  number  of lines of context in the context diff,
ordinarily 3.

=item -l or --ignore-whitespace

causes the pattern matching to be  done  loosely,  in
case  the  tabs  and  spaces have been munged in your
input file.  Any sequence of whitespace in  the  pattern  line will match any sequence in the input file.
Normal characters must  still  match  exactly.   Each
line  of  the  context must still match a line in the
input file.

=item -n or --normal

forces I<patch> to interpret the patch file as a  normal
diff.

=item -N or --forward

causes  I<patch>  to  ignore  patches that it thinks are
reversed or already applied.  See also B<-R .>

=item -o or --output

causes the next argument to  be  interpreted  as  the
output file name.

=item -pnumber or --strip number

sets  the  pathname  strip  count, which controls how
pathnames found in the patch  file  are  treated,  in
case the you keep your files in a different directory
than the person who sent out the  patch.   The  strip
count  specifies  how many slashes are to be stripped
from the front of  the  pathname.   (Any  intervening
directory  names also go away.)  For example, supposing the filename in the patch file was

   /i/want/a/moogle/stuffy

setting B<-p> or B<-p0> gives the entire  pathname  unmodified, B<-p1> gives

   i/want/a/moogle/stuff

without the leading slash, B<-p4> gives

   moogle/stuffy

and   not   specifying  B<-p>  at  all  just  gives  you
"stuffy", unless all  of  the  directories  in  the
leading  path  (i/want/a/moogle)  exist  and that
path is relative, in which case you  get  the  entire
pathname  unmodified.   Whatever  you  end up with is
looked for either in the current  directory,  or  the
directory specified by the B<-d> switch.

=item -r or --reject-file

causes  the  next  argument  to be interpreted as the
reject file name.

=item -R or --reverse

tells I<patch> that this patch was created with the  old
and  new  files  swapped.  (Yes, I'm afraid that does
happen occasionally, human nature being what it  is.)
I<Patch>  will  attempt  to swap each hunk around before
applying it.  Rejects will come out  in  the  swapped
format.   The  B<-R>  switch  will not work with ed diff
scripts because there is too  little  information  to
reconstruct the reverse operation.

If  the  first  hunk  of  a  patch  fails, I<patch> will
reverse the hunk to see if it  can  be  applied  that
way.   If  it  can,  you will be asked if you want to
have the B<-R> switch set.  If it can't, the patch  will
continue  to be applied normally.  (Note: this method
cannot detect a reversed patch if it is a normal diff
and if the first command is an append (i.e. it should
have been a delete) since appends always succeed, due
to  the fact that a null context will match anywhere.
Luckily, most patches add or change lines rather than
delete them, so most reversed normal diffs will begin
with  a  delete,  which  will  fail,  triggering  the
heuristic.)

=item -s or --quiet or --silent

makes  I<patch>  do  its  work silently, unless an error
occurs.

=item -S or --skip

causes I<patch> to ignore  this  patch  from  the  patch
file,  but  continue on looking for the next patch in
the file.  Thus

   patch -S + -S + < patchfile

will ignore the first and second of three patches.

=item -u or --unified

forces I<patch> to interpret the patch file as a unified
context diff (a unidiff).

=item -v or --version

causes  I<patch>  to  print  out its revision header and
patch level.

=item -V or --version-control

causes the next  argument  to  be  interpreted  as  a
method  for  creating backup file names.  The type of
backups made can also be given in the B<VERSION>I<_>B<CONTROL>
environment  variable,  which  is  overridden by this
option.  The B<-B> option overrides this option, causing
the  prefix  to always be used for making backup file
names.  The value of the B<VERSION>I<_>B<CONTROL>  environment
variable  and  the argument to the B<-V> option are like
the GNU Emacs `version-control' variable;  they  also
recognize  synonyms  that  are more descriptive.  The
valid values are (unique abbreviations are accepted):

=over

=item `t' or `numbered'

Always make numbered backups.

=item `nil' or `existing'

Make  numbered  backups  of files that already
have them, simple backups of the others.  This
is the default.

=item `never' or `simple'

Always make simple backups.

=back

=item -xnumber or --debug number

sets  internal  debugging  flags,
and is of no interest to I<patch> patchers [see L<"note 8">].

=back

=head1 ENVIRONMENT

B<SIMPLE_BACKUP_SUFFIX>
Extension  to  use for backup file names instead of
".orig" or "~".

B<VERSION_CONTROL>
Selects when numbered backup files are made.

=head1 SEE ALSO

diff(1), ed(1)

=head1 NOTES FOR PATCH SENDERS

There are several things you should bear in  mind  if  you
are  going to be sending out patches.  First, you can save
people a lot of grief by keeping a patchlevel.h file which
is  patched to increment the patch level as the first diff
in the patch file you send out.  If you put a Prereq: line
in  with the patch, it won't let them apply patches out of
order without some  warning.   Second,  make  sure  you've
specified  the  filenames  right, either in a context diff
header, or with an Index: line.  If you are patching something in a subdirectory, be sure to tell the patch user to
specify a B<-p> switch as needed.  Third, you  can  create  a
file  by  sending  out a diff that compares a null file to
the file you want to create.  This will only work  if  the
file  you want to create doesn't exist already in the target directory.  Fourth, take care not to send out reversed
patches, since it makes people wonder whether they already
applied the patch.  Fifth, while you may be  able  to  get
away  with  putting 582 diff listings into one file, it is
probably wiser to  group  related  patches  into  separate
files in case something goes haywire.

=head1 DIAGNOSTICS

Too many to list here, but generally indicative that I<patch>
couldn't parse your patch file.

The message "Hmm..." indicates that there  is  unprocessed
text  in  the  patch  file and that I<patch> is attempting to
intuit whether there is a patch in that text and,  if  so,
what kind of patch it is.

I<Patch> will exit with a non-zero status if any reject files
were created.  When applying a set of patches in a loop it
behooves  you to check this exit status so you don't apply
a later patch to a partially patched file.

=head1 CAVEATS

I<Patch> cannot tell if the line numbers are  off  in  an  ed
script,  and  can only detect bad line numbers in a normal
diff when it finds a "change" or a  "delete"  command.   A
context  diff  using fuzz factor 3 may have the same problem.  Until a suitable interactive interface is added, you
should probably do a context diff in these cases to see if
the changes made  sense.   Of  course,  compiling  without
errors  is a pretty good indication that the patch worked,
but not always.

I<Patch> usually produces the correct results, even  when  it
has  to  do  a  lot of guessing.  However, the results are
guaranteed to be correct only when the patch is applied to
exactly  the  same  version of the file that the patch was
generated from.

=head1 BUGS

Could  be  smarter  about  partial  matches,   excessively
deviant  offsets  and swapped code, but that would take an
extra pass.

Check patch mode ( B<-C>) will fail if you try to check  several  patches in succession that build on each other.  The
whole code of I<patch> would have to be restructured to  keep
temporary  files  around so that it can handle this situation.

If code has been duplicated (for instance with #ifdef OLDCODE  ... #else ...  #endif), I<patch> is incapable of patch-
ing both versions, and, if it works at  all,  will  likely
patch  the  wrong  one,  and tell you that it succeeded to
boot.

If you apply a patch you've already  applied,  I<patch>  will
think  it  is  a reversed patch, and offer to un-apply the
patch.  This could be construed as a feature.

=head1 COMPATIBILITY

The perl implementation of patch is based on but not entire compatible with the
documentation for GNU patch version 2.1:

=head2 note 1

On systems that do not support long filenames,
GNU patch uses the extension "~" for backup files and the extension "#" for
reject files.
How to know if a system support long filenames?

=head2 note 2

Only new-style context diffs are supported.
What does old-style context diff look like?

=head2 note 3

If the pipe to ed fails, B<patch> will attempt to apply the ed script on its
own.

=head2 note 4

This algorithm differs from the one described in the documentation for GNU
patch, which scans forwards and backwards from the line number mentioned in the
diff (plus any offset used in applying the previous hunk).

=head2 note 5

Rejected hunks in GNU patch all come out as context diffs regardless of the
input diff, and the lines numbers reflect the approximate location GNU patch
thinks the failed hunks belong in the new file rather than the old one.

=head2 note 6

If the original file cannot be found or is read-only, but a suitable SCCS or RCS
file is handy, GNU patch will attempt to get or check out the file.

=head2 note 7

GNU patch requires a space between the B<-D> and the argument.  This has been
made optional.

=head2 note 8

There are currently no debugging flags to go along with B<-x>.

=head1 AUTHOR

Tim Gim Yee | tgy@chocobo.org | I want a moogle stuffy!

=head1 COPYRIGHT

Copyright (c) 1999 Moogle Stuffy Software.  All rights reserved.

You may play with this software in accordance with the Perl Artistic License.

You may use this documentation under the auspices of the GNU General Public
License.

=cut

