#!/usr/bin/perl -w-
# perl implementation of sort(1), by pudge@pobox.com
# see POD below for more information

use Getopt::Long qw(GetOptions);
use Fcntl qw(O_RDONLY O_WRONLY O_CREAT O_TRUNC);
use Symbol qw(gensym);
use strict;
use locale;
use vars qw($VERSION *sortsub *sort1 *sort2 *map1 *map2 %fh);

$VERSION = '1.00';
Getopt::Long::config('bundling');  # -cmu == -c -m -u

{
    my(%o, @argv, @pos);

    # take care of +pos1 -pos2 now instead of in getopts
    foreach my $argv (0..$#ARGV) {
        $_ = $ARGV[$argv];
        my $n;
        if (/^\+(\d+)(?:\.(\d+))?([bdfinr]+)?/) {
           $n = $1 + 1;
           $n .= '.' . ($2 + 1) if defined $2;
           $n .= $3 if $3;
           push @argv, $argv;
        } else {
          next;
        }

        $_ = $ARGV[$argv + 1];
        if (/^\-(\d+)(?:\.(\d+))?([bdfinr]+)?/) {
           $n .= "," . (defined $2 ? ($1 + 1) . ".$2" : $1);
           $n .= $3 if $3;
           push @argv, $argv;
        }

        push @pos, $n;
    }

    # delete used elements from @ARGV
    for (reverse @argv) {
        splice(@ARGV, $_, 1);
    }

    GetOptions(\%o, 'k=s@', qw(c m u d f i n r b D),
        map {"$_=s"} qw(X t y F o R));
    push @{$o{'k'}}, @pos if @pos;   # add pos stuff back
    @ARGV = '-' unless @ARGV;
    $o{I} = [@ARGV];    # input files

    my $exit = _sort_file(\%o);
    warn "Exit status is $exit\n" if $exit != 1;
    exit($exit == 1 ? $exit ? 0 : $exit : 1);
}

sub _sort_file {
    local $\;   # don't mess up our prints
    my($opts, @fh, @recs) = shift;

    # record separator, default to \n
    local $/ = $opts->{R} ? $opts->{R} : "\n";

    # get input files into anon array if not already
    $opts->{I} = [$opts->{I}] unless ref $opts->{I};

    usage() unless @{$opts->{I}};

    # "K" == "no k", for later
    $opts->{K} = $opts->{k} ? 0 : 1;
    $opts->{k} = $opts->{k} ? [$opts->{k}] : [] if !ref $opts->{k};

    # set output and other defaults
    $opts->{o}   = !$opts->{o} ? '' : $opts->{o};
    $opts->{'y'} ||= $ENV{MAX_SORT_RECORDS} || 200000;  # default max records
    $opts->{F}   ||= $ENV{MAX_SORT_FILES}   || 40;      # default max files


    # see big ol' mess below
    _make_sort_sub($opts);

    # only check to see if file is sorted
    if ($opts->{c}) {
        local *F;
        my $last;

        if ($opts->{I}[0] eq '-') {
            open(F, $opts->{I}[0])
                or die "Can't open `$opts->{I}[0]' for reading: $!";
        } else {
            sysopen(F, $opts->{I}[0], O_RDONLY)
                or die "Can't open `$opts->{I}[0]' for reading: $!";
        }

        while (defined(my $rec = <F>)) {
            # fail if -u and keys are not unique (assume sorted)
            if ($opts->{u} && $last) {
                return 0 unless _are_uniq($opts->{K}, $last, $rec);
            }

            # fail if records not in proper sort order
            if ($last) {
                my @foo;
                if ($opts->{K}) {
                    local $^W;
                    @foo = sort sort1 ($rec, $last);
                } else {
                    local $^W;
                    @foo = map {$_->[0]} sort sortsub
                        map &map1, ($rec, $last);
                }
                return 0 if $foo[0] ne $last || $foo[1] ne $rec;
            }

            # save value of last record
            $last = $rec;
        }

        # success, yay
        return 1;

    # if merging sorted files
    } elsif ($opts->{'m'}) {

        foreach my $filein (@{$opts->{I}}) {

            # just open files and get array of handles
            my $sym = gensym();

            sysopen($sym, $filein, O_RDONLY)
                or die "Can't open `$filein' for reading: $!";

            push @fh, $sym;
        }
        
    # ooo, get ready, get ready
    } else {

        # once for each input file
        foreach my $filein (@{$opts->{I}}) {
            local *F;
            my $count = 0;

            _debug("Sorting file $filein ...\n") if $opts->{D};

            if ($filein eq '-') {
                open(F, $filein)
                    or die "Can't open `$filein' for reading: $!";
            } else {
                sysopen(F, $filein, O_RDONLY)
                    or die "Can't open `$filein' for reading: $!";
            }

            while (defined(my $rec = <F>)) {
                push @recs, $rec;
                $count++;  # keep track of number of records

                if ($count >= $opts->{'y'}) {    # don't go over record limit

                    _debug("$count records reached in `$filein'\n")
                        if $opts->{D};

                    # save to temp file, add new fh to array
                    push @fh, _write_temp(\@recs, $opts);

                    # reset record count and record array
                    ($count, @recs) = (0);

                    # do a merge now if at file limit
                    if (@fh >= $opts->{F}) {

                        # get filehandle and restart array with it
                        @fh = (_merge_files($opts, \@fh, [], _get_temp()));

                        _debug("\nCreating temp files ...\n") if $opts->{D};
                    }
                }
            }

            close F;
        }

        # records leftover, didn't reach record limit
        if (@recs) {
            _debug("\nSorting leftover records ...\n") if $opts->{D};
            _check_last(\@recs);
            if ($opts->{K}) {
                local $^W;
                @recs = sort sort1 @recs;
            } else {
                local $^W;
                @recs = map {$_->[0]} sort sortsub map &map1, @recs;
            }
        }
    }

    # do the merge thang, uh huh, do the merge thang
    my $close = _merge_files($opts, \@fh, \@recs, $opts->{o});
    close $close unless fileno($close) == fileno('STDOUT'); # don't close STDOUT

    _debug("\nDone!\n\n") if $opts->{D};
    return 1;   # yay
}

# take optional arrayref of handles of sorted files,
# plus optional arrayref of sorted scalars
sub _merge_files {
    # we need the options, filehandles, and output file
    my($opts, $fh, $recs, $file) = @_;
    my($uniq, $first, $o, %oth);

    # arbitrarily named keys, store handles as values
    %oth = map {($o++ => $_)} @$fh;

    # match handle key in %oth to next record of the handle    
    %fh  = map {
        my $fh = $oth{$_};
        ($_ => scalar <$fh>);
    } keys %oth;

    # extra records, special X "handle"
    $fh{X} = shift @$recs if @$recs;

    _debug("\nCreating sorted $file ...\n") if $opts->{D};

    # output to STDOUT if no output file provided
    if ($file eq '') {
        $file = \*STDOUT;

    # if output file is a path, not a reference to a file, open
    # file and get a reference to it
    } elsif (!ref $file) {
        my $tfh = gensym();
        sysopen($tfh, $file, O_WRONLY|O_CREAT|O_TRUNC)
            or die "Can't open `$file' for writing: $!";
        $file = $tfh;
    }

    my $oldfh = select $file;
    $| = 0; # just in case, use the buffer, you knob

    while (keys %fh) {
        # don't bother sorting keys if only one key remains!
        if (!$opts->{u} && keys %fh == 1) {
            ($first) = keys %fh;
            my $curr = $oth{$first};
            my @left = $first eq 'X' ? @$recs : <$curr>;
            print $fh{$first}, @left;
            delete $fh{$first};
            last;
        }

        {
            # $first is arbitrary number assigned to first fh in sort
            if ($opts->{K}) {
                local $^W;
                ($first) = (sort sort2 keys %fh);
            } else {
                local $^W;
                ($first) = (map {$_->[0]} sort sortsub
                    map &map2, keys %fh);
            }
        }

        # don't print if -u and not unique
        if ($opts->{u}) {
            print $fh{$first} if
                (!$uniq || _are_uniq($opts->{K}, $uniq, $fh{$first}));
            $uniq = $fh{$first};
        } else {
            print $fh{$first};
        }

        # get current filehandle
        my $curr = $oth{$first};

        # use @$recs, not filehandles, if key is X
        my $rec = $first eq 'X' ? shift @$recs : scalar <$curr>;

        if (defined $rec) {     # bring up next record for this filehandle
            $fh{$first} = $rec;

        } else {                # we don't need you anymore
            delete $fh{$first};
        }
    }

    seek $file, 0, 0;  # might need to read back from it
    select $oldfh;
    return $file;
}

sub _check_last {
    # add new record separator if not one there
    ${$_[0]}[-1] .= $/ if (${$_[0]}[-1] !~ m|$/$|);
}

sub _write_temp {
    my($recs, $opts) = @_;
    my $temp = _get_temp() or die "Can't get temp file: $!";

    _check_last($recs);

    _debug("New tempfile: $temp\n") if $opts->{D};

    if ($opts->{K}) {
        local $^W;
        print $temp sort sort1 @{$recs};
    } else {
        local $^W;
        print $temp map {$_->[0]} sort sortsub map &map1, @{$recs};
    }

    seek $temp, 0, 0;  # might need to read back from it
    return $temp;
}

sub _parse_keydef {
    my($k, $topts) = @_;

    # gurgle
    $k =~ /^(\d+)(?:\.(\d+))?([bdfinr]+)?
        (?:,(\d+)(?:\.(\d+))?([bdfinr]+)?)?$/x;

    # set defaults at zero or undef
    my %opts = (
        %$topts,                            # get other options
        ksf => $1 || 0,                     # start field
        ksc => $2 || 0,                     # start field char start
        kst => $3 || '',                    # start field type
        kff => (defined $4 ? $4 : undef),  # end field
        kfc => $5 || 0,                     # end field char end
        kft => $6 || '',                    # end field type
    );

    # their idea of 1 is not ours
    for (qw(ksf ksc kff)) { #  kfc stays same
        $opts{$_}-- if $opts{$_};
    }

    # if nothing in kst or kft, use other flags possibly passed
    if (!$opts{kst} && !$opts{kft}) {
        foreach (qw(b d f i n r)) {
            $opts{kst} .= $_ if $topts->{$_};
            $opts{kft} .= $_ if $topts->{$_};
        }

    # except for b, flags on one apply to the other
    } else {
        foreach (qw(d f i n r)) {
            $opts{kst} .= $_ if ($opts{kst} =~ /$_/ || $opts{kft} =~ /$_/);
            $opts{kft} .= $_ if ($opts{kst} =~ /$_/ || $opts{kft} =~ /$_/);
        }
    }

    return \%opts;
}

sub _make_sort_sub {
    my($topts, @sortsub, @mapsub, @sort1, @sort2) = shift;

    # if no keydefs set
    if ($topts->{K}) {
        $topts->{kst} = '';
        foreach (qw(b d f i n r)) {
            $topts->{kst} .= $_ if $topts->{$_};
        }

        # more complex stuff, act like we had -k defined
        if ($topts->{kst} =~ /[bdfi]/) {
            $topts->{K} = 0;
            $topts->{k} = ['K'];    # special K ;-)
        }
    }

    # if no keydefs set
    if ($topts->{K}) {
        _debug("No keydef set\n") if $topts->{D};

        # defaults for main sort sub components
        my($cmp, $aa, $bb, $fa, $fb) = qw(cmp $a $b $fh{$a} $fh{$b});

        # reverse sense
        ($bb, $aa, $fb, $fa) = ($aa, $bb, $fa, $fb) if $topts->{r};

        # do numeric sort
        $cmp = '<=>' if $topts->{n};

        # add finished expression to array
        my $sort1 = "sub { $aa $cmp $bb }\n";
        my $sort2 = "sub { $fa $cmp $fb }\n";

        _debug("$sort1\n$sort2\n") if $topts->{D};

        {
            local $^W;
            *sort1  = eval $sort1;
            die "Can't create sort sub: $@" if $@;
            *sort2  = eval $sort2;
            die "Can't create sort sub: $@" if $@;
        }

    } else {

        # get text separator or use whitespace
        $topts->{t} =
            defined $topts->{X} ? $topts->{X} :
            defined $topts->{t} ? quotemeta($topts->{t}) :
            '\s+';
        $topts->{t} =~ s|/|\\/|g if defined $topts->{X};

        foreach my $k (@{$topts->{k}}) {
            my($opts, @fil) = ($topts);
            
            # defaults for main sort sub components
            my($cmp, $ab_, $fab_, $aa, $bb) = qw(cmp $_ $fh{$_} $a $b);

            # skip stuff if special K
            $opts = $k eq 'K' ? $topts : _parse_keydef($k, $topts);

            if ($k ne 'K') {
                my($tmp1, $tmp2) = ("\$tmp[$opts->{ksf}]",
                    ($opts->{kff} ? "\$tmp[$opts->{kff}]" : ''));

                # skip leading spaces
                if ($opts->{kst} =~ /b/) {
                    $tmp1 = "($tmp1 =~ /(\\S.*)/)[0]";
                }

                if ($opts->{kft} =~ /b/) {
                    $tmp2 = "($tmp2 =~ /(\\S.*)/)[0]";
                }

                # simpler if one field, goody for us
                if (! defined $opts->{kff} || $opts->{ksf} == $opts->{kff}) {

                    # simpler if chars are both 0, wicked pissah
                    if ($opts->{ksc} == 0 &&
                        (!$opts->{kfc} || $opts->{kfc} == 0)) {
                        @fil = "\$tmp[$opts->{ksf}]";

                    # hmmmmm
                    } elsif (!$opts->{kfc}) {
                        @fil = "substr($tmp1, $opts->{ksc})";

                    # getting out of hand now
                    } else {
                        @fil = "substr($tmp1, $opts->{ksc}, ". 
                            ($opts->{kfc} - $opts->{ksc}) . ')';
                    }

                # try again, shall we?
                } else {

                    # if spans two fields, but chars are both 0
                    # and neither has -b, alrighty
                    if ($opts->{kfc} == 0 && $opts->{ksc} == 0 &&
                        $opts->{kst} !~ /b/ && $opts->{kft} !~ /b/) {
                        @fil = "join(''," .
                            "\@tmp[$opts->{ksf} .. $opts->{kff}])";

                    # if only one field away
                    } elsif (($opts->{kff} - $opts->{ksf}) == 1) {
                        @fil = "join('', substr($tmp1, $opts->{ksc}), " .
                            "substr($tmp2, 0, $opts->{kfc}))";

                    # fine, have it your way!  hurt me!  love me!
                    } else {
                        @fil = "join('', substr($tmp1, $opts->{ksc}), " .
                            "\@tmp[" . ($opts->{ksf} + 1) . " .. " .
                                ($opts->{kff} - 1) . "], " .
                            "substr($tmp2, 0, $opts->{kfc}))";
                    }
                }
            } else {
                @fil = $opts->{kst} =~ /b/ ?
                    "(\$tmp[0] =~ /(\\S.*)/)[0]" : "\$tmp[0]";
            }

            # fold to upper case
            if ($opts->{kst} =~ /f/) {
                $fil[0] = "uc($fil[0])";
            }

            # only alphanumerics and whitespace, override -i
            if ($opts->{kst} =~ /d/) {
                $topts->{DD}++;
                push @fil, "\$tmp =~ s/[^\\w\\s]+//g", '"$tmp"';

            # only printable characters
            } elsif ($opts->{kst} =~ /i/) {
                require POSIX;
                $fil[0] = "join '', grep {POSIX::isprint \$_} " .
                    "split //,\n$fil[0]";
            }

            $fil[0] = "\$tmp = $fil[0]" if $opts->{kst} =~ /d/;


            # reverse sense
            ($bb, $aa) = ($aa, $bb) if ($opts->{kst} =~ /r/);

            # do numeric sort
            $cmp = '<=>' if ($opts->{kst} =~ /n/);

            # add finished expressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sortsub + $aa, $bb) = qw(ressions to arrays
            my $n = @sorts