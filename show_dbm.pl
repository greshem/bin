#!/usr/bin/env perl
# -*- perl -*-

#
# $Id: show_db,v 3.0 2006/03/06 22:26:14 eserte Exp $
# Author: Slaven Rezic
#
# Copyright (c) 1997-2004 Slaven Rezic. All rights reserved.
# This program is free software; you can redistribute it and/or
# modify it under the same terms as Perl itself.
#
# Mail: srezic@cpan.org
# WWW:  http://www.rezic.de/eserte/
#

=head1 NAME

show_db - take a quick look into dbm files

=head1 SYNOPSIS

    show_db [-dbtype type] [-d delim] [-v] [-showtable]
            [-key spec] [-val spec] [-color] [-sel key]
            dbmfile

=head1 DESCRIPTION

C<show_db> shows the content of a dbm database file (like DB_File,
GDBM_File, or CDB_File). There is also some support for MLDBM
databases.

=head2 OPTIONS

=over

=item -d delim

The output delimiter between key and value, by default " : ".

=item -dbtype type

The type of the database. This is usually a class name like
C<DB_File>. In most cases C<show_db> may determine the database
type itself, so you do not have to always specify this option.

Variants of the database type may be specified with a comma-separated
list. Currently valid variants are:

=over

=item DB_File,RECNO

The keys are the array indexes of the recno database.

=item DB_File,BTREE

The BTREE variant of a DB_File.

=item DB_File,HASH

The HASH variant of a DB_File (default for DB_File).

=item MLDBM,I<DB>,I<Serializer>

where I<DB> is C<DB_File> or another dbm class and I<Serializer> is
C<Data::Dumper> or another serializer class.

=back

=item -v

Be verbose. Multiple C<-v> cause more verbosity.

=item -showtable

Pipe the output to C<showtable> from the C<Data::ShowTable>
distribution.

=item -color

Color the key values. Needs the C<Term::ANSIColor> module installed.

=item -key spec

=item -val spec

Treat the keys or values as special data structures:

=over

=item pack:I<packspec>

C<unpack> will be used on the data. See L<perlfunc/pack> for the
format of I<packspec>.

=item storable

The data will be handled as serialized by Storable.

=item freezethaw

The data will be handled as serialized by FreezeThaw.

=item perldata

The data will be handled as a perl value or reference.

=back

The C<-key> and C<-val> specifications may be overriden by C<-color>.
The values of MLDBM databases are handled according to the
I<serializer> variant.

=item -sel key

Select the value for the specified C<key> from the database. The
C<sel> option may be given multiple times.

=back

=head1 HINTS

For a Apache::Session file with DB_File as database backend and
Storable as serializer use C<-val storable> to display the session
file contents.

=head1 README

show_db shows the content of a dbm database file (like DB_File,
GDBM_File, or CDB_File). There is also some support for MLDBM
databases.

=head1 PREREQUISITES

any dbm module

=head1 COREQUISITES

C<Data::ShowTable>, C<Term::ANSIColor>

=head1 OSNAMES

OS independent

=head1 SCRIPT CATEGORIES

Database

=head1 AUTHOR

Slaven Rezic <slaven@rezic.de>

=head1 AVAILABILITY

C<show_db> is available from the scripts section on L<http://www.cpan.org/>.

=head1 SEE ALSO

AnyDBM_File(3).

=cut

use strict;
use Fcntl;
use Getopt::Long;

BEGIN {
    if ($] < 5.006) {
	$INC{"warnings.pm"} = "dummy";
	package warnings;
	*import = sub { };
	*unimport = sub { };
    }
}

no warnings 'once';

use vars qw($VERSION);
$VERSION = sprintf("%d.%02d", q$Revision: 3.0 $ =~ /(\d+)\.(\d+)/);

my $delim = " : ";
my $v;
my $dbtype; # auto
my $do_showtable;
my $keyspec;
my $valspec;
my $cant_each;
my $do_color;
my @select;
my $dd_indent = 1; # XXX make an option

if (!GetOptions(
		'dbtype=s' => \$dbtype,
		'd=s' => \$delim,
		'v+' => \$v,
		'showtable|table' => \$do_showtable,
		'key=s' => \$keyspec,
		'val=s' => \$valspec,
		'color' => \$do_color,
		'sel|select=s@' => \@select,
	       )) {
    require Pod::Usage;
    Pod::Usage::pod2usage(1);
}

my $file = shift || die "Specify db file";
my $db = defined $dbtype ? $dbtype : identify_db($file);
if (!defined $db) { die "Can't get DB type, please specify with -dbtype option" }
my $ref = open_db($file, $db);

my $keysub = sub { "<$_[0]>" };
my $valsub = sub { $_[0]     };

if (defined $keyspec) {
    $keysub = _spec_to_sub($keyspec);
}
if (defined $valspec) {
    $valsub = _spec_to_sub($valspec);
}

if ($db =~ /^MLDBM/) { # XXX overrides -val
    $valsub = _spec_to_sub("perldata");
}

if ($do_color) { # XXX overrides -key
    require Term::ANSIColor;
    $keysub = sub { Term::ANSIColor::color('red') . $_[0] . Term::ANSIColor::color('reset') };
}

my $pid;
if ($do_showtable) {
    pipe(RDR, WTR);
    $pid = fork;
    if ($pid == 0) {
	close WTR;
	open(STDIN, "<&RDR") or die $!;
	exec "showtable", "-d$delim";
	die $!;
    }
    close RDR;
    open(STDOUT, ">&WTR") or die $!;
}

my $selsub;
if (@select) {
    foreach my $sel (@select) {
	if ($keyspec) {
	    if ($keyspec =~ /^pack:(.*)/) {
		$sel = pack($1, $sel);
	    } # XXX other keyspec formats not supported
	}
	output_record($ref, $keysub, $valsub, $sel);
    }
} else {
    output_db($ref, $keysub, $valsub, $selsub);
}

sub identify_db {
    my $file = shift;
#XXX does not work with .dir/.pag files:
#      if (!-e $file) {
#  	die "File $file does not exist";
#      }
#      if (!-r $file) {
#  	die "File $file is not readable";
#      }
    my @types;
    {
	no warnings 'qw';
	@types = qw(DB_File GDBM_File NDBM_File SDBM_File
		    ODBM_File CDB_File DB_File,RECNO);
    }
    my $type;
 TRY: {
	foreach my $_type (@types) {
	    $type = $_type;
	    print STDERR "Try $type ... " if $v;
	    my %db;
	    if ($type eq 'DB_File,RECNO' && eval "use DB_File; 1" &&
		tie my @db, "DB_File", $file, O_RDONLY, 0644, $DB_File::DB_RECNO) {
		last TRY;
	    } elsif ($type =~ /^DB_File,(BTREE|HASH)$/ && eval q{use DB_File; tie my @db, "DB_File", $file, O_RDONLY, 0644, ($1 eq 'BTREE' ? $DB_File::DB_BTREE : $DB_File::DB_HASH) }) {
		last TRY;
	    } elsif ($type eq 'CDB_File' && eval "use $type; 1" &&
		     tie %db, $type, $file) {
		last TRY;
	    } elsif (eval "use $type; 1" &&
		     tie %db, $type, $file, O_RDONLY, 0644) {
		last TRY;
	    }
	    if ($v > 1) {
		warn "\$\@=$@, \$!=$!";
	    }
	    print STDERR "\n" if $v;
	}
	return undef;
    }

    print STDERR "OK!\n" if $v;
    return $type;
}

sub open_db {
    my($file, $type, %args) = @_;
    if ($type eq 'DB_File,RECNO') {
	require DB_File;
	my @db;
	tie @db, "DB_File", $file, O_RDONLY, 0644, $DB_File::DB_RECNO or
	    die "Can't type $file with $type: $!";
	\@db;
    } elsif ($type =~ /^MLDBM/) {
	my(undef,$dbtype,$serializer) = split /,/, $type;
	my @types = ($dbtype ne ""
		     ? ($dbtype)
		     : (qw(DB_File GDBM_File NDBM_File ODBM_File CDB_File))
		    );
	$MLDBM::Serializer = $serializer || "Data::Dumper";
	require MLDBM;
	my %db;
	for $MLDBM::UseDB (@types) {
	    warn "Try $MLDBM::UseDB for MLDBM ... " if $v;
	    local $^W = 0; # XXX if !$v;
	    eval {
		if ($MLDBM::UseDB eq 'CDB_File') {
		    tie %db, 'MLDBM', $file or
			die "Can't tie $file with $type: $!";
		} else {
		    tie %db, 'MLDBM', $file, O_RDONLY, 0644 or
			die "Can't tie $file with $type: $!";
		}
	    };
	    last if tied(%db);
	}
	if (!tied(%db)) {
	    warn $@;
	}
	\%db;
    } elsif ($type =~ /^(BerkeleyDB),(.*)$/) {
	($type, my $subtype) = ($1, $2);
	eval "use $type"; die $@ if $@;
	my %db;
	tie %db, $type."::".$subtype, -Filename => $file or
	    die "Can't tie $file with ${type}::$subtype: $BerkeleyDB::Error";
	\%db;
    } else {
	my $subtype;
	if ($type =~ s/^([^,]+),(.*)$/$1/) {
	    $subtype = $2;
	}
	eval "use $type"; die $@ if $@;
	my @tie_args = ($file);
	if ($type ne 'CDB_File') {
	    push @tie_args, O_RDONLY, 0644;
	    if ($type eq 'DB_File' ||
		$type eq 'DB_File::Lock') {
		if ($subtype eq 'BTREE') {
		    push @tie_args, $DB_File::DB_BTREE;
		} elsif ($subtype eq 'HASH') {
		    push @tie_args, $DB_File::DB_HASH;
		} else {
		    if ($type eq 'DB_File::Lock') {
			die "Specification of subtype is mandatory, e.g. -dbtype DB_File::Lock,BTREE";
		    }
		}
		if ($type eq 'DB_File::Lock') {
		    push @tie_args, 'read'; # read lock
		}
	    }
	}
	my %db;
	tie %db, $type, @tie_args or
	    die sprintf("Can't tie $file as $type with flags=0x%x, mode=0%o%s: $!", $tie_args[1], $tie_args[2], ($#tie_args > 2 ? "(".join(",",@tie_args[3..$#tie_args]).")":""));
	\%db;
    }
}

sub output_db {
    my($dbref, $keysub, $valsub, $selsub) = @_;
    if (ref $dbref eq 'ARRAY') {
	my $i = 0;
	foreach my $l (@$dbref) {
	    print $keysub->($i) . $delim . $valsub->($l) . "\n"
		if !$selsub || $selsub->($i);
	    $i++;
	}
    } elsif (ref $dbref eq 'HASH') {
	if ($cant_each) {
	    foreach my $key (keys %$dbref) {
		my $val = $dbref->{$key};
		print $keysub->($key) . $delim . $valsub->($val) . "\n"
		    if !$selsub || $selsub->($key);
	    }
	} else {
	    while(my($key,$val) = each %$dbref) {
		print $keysub->($key) . $delim . $valsub->($val) . "\n"
		    if !$selsub || $selsub->($key);
	    }
	}
    }
}

sub output_record {
    my($dbref, $keysub, $valsub, $key) = @_;
    if (ref $dbref eq 'ARRAY') {
	print $keysub->($key) . $delim . $valsub->($dbref->[$key]) . "\n";
    } elsif (ref $dbref eq 'HASH') {
	print $keysub->($key) . $delim . $valsub->($dbref->{$key}) . "\n";
    }
}

sub _spec_to_sub {
    my($spec) = @_;

    require Data::Dumper;
    my $dd = sub {
	my $out = Data::Dumper->new([$_[0]],[])->Useqq(1)->Indent($dd_indent)->Dump;
	$out =~ s/\$VAR1\s*=\s*//;
	$out;
    };

    if ($spec =~ /^pack:(.*)/) {
	my $pack = $1;
	return sub { unpack($pack, $_[0]) };
    } elsif ($spec =~ /^storable$/i) {
	require Storable;
#XXX?	$cant_each = 1;
	return sub { $dd->(Storable::thaw($_[0])) };
    } elsif ($spec =~ /^freezethaw$/i) {
	require FreezeThaw;
#XXX?	$cant_each = 1;
	return sub { $dd->(FreezeThaw::thaw($_[0])) }; # XXX check
    } elsif ($spec =~ /^perldata$/i) {
#XXX?	$cant_each = 1;
	return sub { ref $_[0] ? $dd->($_[0]) : $_[0] };
    } else {
	die "Can't parse specification <$spec>";
    }
}
