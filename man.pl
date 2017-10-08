#!/usr/bin/perl
# 
# man - perl rewrite of man system
# tom christiansen <tchrist@perl.com>
#
# --------------------------------------------------------------------------
# begin configuration section
#
# this should be adequate for CONVEX systems.  if you copy this script 
# to non-CONVEX systems, or have a particularly outre local setup, you may
# wish to alter some of the defaults.
# --------------------------------------------------------------------------

use DB_File;
@Any_DBM_File::ISA = qw(DB_File);

$PAGER = $ENV{'MANPAGER'} || $ENV{'PAGER'} || 'more';

# assume "less" pagers want -sf flags, all others must accept -s.
# note: some less's prefer -r to -f.  you might also add -i if supported.
#
$is_less = $PAGER =~ /^\S*less(\s+-\S.*)?$/;
$PAGER    .= $is_less ? ' -si' : ' -s';       # add -f if using "ul"

# man roots to look in; you would really rather use a separate tree than 
# manl and mann!  see %SECTIONS and $MANALT if you do.
$MANPATH  = &config_path;

# default section precedence
$MANSECT  = $ENV{'MANSECT'} || 'ln16823457po';

# colons optional unless you have multi-char section names
# note that HP systems want this:
#	$MANSECT  = $ENV{'MANSECT'} || '1:1m:6:8:2:3:4:5:7';

# alternate architecture man pages in 
# ${MANALT}/${machine}/man(.+)/*.\11*
$MANALT = $ENV{'MANALT'} || '/usr/local/man';

# default program for -t command 
$TROFF    = $ENV{'TROFF'} || 'troff';

$NROFF    = 'nroff';
$NROFF_CAN_BOLD = 0;	# if nroff puts out bold as H\bH

# this are used if filters are needed
$TBL	  = 'tbl';
$NTBL 	  = "$TBL";	# maybe you need -TX instead
$NEQN	  = 'neqn';
$EQN	  = 'eqn';
$SED	  = 'sed';

# define this if you don't have/want UL;
# without ul, you probably need COL defined unless your PAGER is very smart
# you also must use col instead of ul if you've any tbl'd man pages, such 
# as from the X man pages or the eqnchar.7 page.
$COL	  = 'col';  
$UL	  = '';		# set to '' if you haven't got ul
die 'need either $UL or $COL' unless $UL || $COL;

# need these for .gz files or dirs
$COMPRESS = 'gzip';
$ZCAT	  = 'zcat';
$CAT	  = 'cat';

# define COMPRESS_DIR if pages might have moved to manX.gz/page.X (like HPs)
$COMPRESS_DIR = 1;
# define COMPRESS_PAGE if pages might have moved to manX/page.X.gz  (better)
$COMPRESS_PAGE = 1;

# Command to format man pages to be viewed on a tty or printed on a line printer
$CATSET	  = "$NROFF -h -mandoc -";

$CATSET  .= " | $COL" if $COL;

# Command to typeset a man page
$TYPESET  = "$TROFF -mandoc";


# flags: GNU likes -i, BSD doesn't; both like -h, but BSD doesn't document it
# if you don't put -i here, i'll make up for it later the hard way
#$EGREP = '/usr/local/bin/egrep';	
#if (-x $EGREP) {
    #$EGREP .= ' -i -h';
#} else {
    $EGREP = '/usr/bin/egrep';
    unless (-x $EGREP) {
	$EGREP = '';
    } else {
	$EGREP .= ' -h';
    }
#} 

# sections that have verbose aliases
# if you change this, change the usage message
#
# if you put any of these in their own trees, comment them out and make 
# a link in $MANALT so people can still say 'man local foo'; for local,
#	cd $MANALT; ln -s . local
# for the other trees (new, old, public) put either them or links
# to them in $MANALT
#
%SECTIONS = (				
    'local',	'l',
    'new',	'n',
    'old',	'o',
    'public',	'p' );

# turn this on if you want linked (via ".so" or otherwise) man pages
# to be found even if the thing they are linked to doesn't know it's
# being linked to -- that is, its NAME section doesn't have reference
# to it.  eg, if you call a man page 'gnugrep' but it's own NAME section
# just calls it grep, then you need this.  usually a good idea.
#
$STUPID_SO	= 1;  

# --------------------------------------------------------------------------
# end configuration section
# --------------------------------------------------------------------------

# CONVEX RCS keeps CHeader; others may prefer Header
($bogus, $version) = split(/:\s*/,'$CHeader: man 0.41 91/10/28 13:48:01 $',2);
chop($version); chop($version);

require 'getopts.pl';

$winsize = "\0" x 8;
$TIOCGWINSZ = 0x40087468;

$isatty = -t STDOUT;
if (ioctl(STDIN, $TIOCGWINSZ, $winsize)) {
    ($rows, $cols, $xpixel, $ypixel) = unpack('S4', $winsize);
} else {
    ($rows, $cols) = (24, 80);
}

%options = (
    'man',	'T:m:P:M:S:fkltvwdguhaAiDKn',
    'apropos',	'm:P:MvduaK',
    'whatis',	'm:P:M:vduh',
    'whereis',	'm:P:M:vduh'
);

($program = $0) =~ s,.*/,,;

$apropos = $program eq 'apropos';
$whatis  = $program eq 'whatis';
$whereis = $program eq 'whman';
$program = 'man' unless $program;

&Getopts($options = $options{$program}) || &usage;

if ($opt_u) {
    &version if $opt_v;
    &usage;
    # not reached
} 

if ($opt_v) {
    &version;
    exit 0;
}

&usage if $#ARGV < 0;

$MANPATH = $opt_P 	if $opt_P;	# backwards contemptibility
$MANPATH = $opt_M 	if $opt_M;

$hard_way = $opt_h	if $opt_h;

if ($opt_T) {
    $opt_t = 1;
    $TYPESET =~ s/$TROFF/$opt_T/;
    $TROFF = $opt_T;
} 

$MANPATH = "$MANALT/$opt_m"		# want different machine type (undoc)
			if $machine = $opt_m;

$MANSECT = $opt_S	if $opt_S;	# prefer our own section ordering

$whatis = 1		if $opt_f;
$apropos = 1		if $opt_k || $opt_K;
$fromfile = 1		if $opt_l;
$whereis = 1  		if $opt_w;
$grepman = 1		if $opt_g;	
$| = $debug = 1		if $opt_d;
$full_index = 1 	if $opt_i;
$show_all = 1		if $opt_a;
$stripBS = 1		if $opt_D;
$query_all = $opt_A	if $opt_A;

$roff = $opt_t ? 'troff' : 'nroff';   # for indirect function call


# maybe they said something like 'man vax ls'
if ($#ARGV > 0) {
    local($machdir) = $MANALT . '/' . $ARGV[0];
    if (-d $machdir) {
	$MANPATH = $machdir;
	$machine = shift;
    } 
} 

@MANPATH = split(/:/,$MANPATH);

# assign priorities to the sections he cares about
# the nearer the front the higher the sorting priority
$secidx = 0;
$delim = ($MANSECT =~ /:/) ? ':' : ' *';
for (reverse split(/$delim/, $MANSECT)) {
    if ($_ eq '') {
	warn "null section in $MANSECT\n";
	next;
    } 
    $MANSECT{$_} = ++$secidx;
} 


if ($whatis) {
    &whatis;
} elsif ($apropos) {
    &apropos;
} elsif ($whereis) {
    &whereis;
} elsif ($grepman) {
    &grepman;
} else {
    &man;
} 

exit $status;

# --------------------------------------------------------------------------
# fill out @whatis array with all possible names of whatis files
# --------------------------------------------------------------------------
sub genwhatis {
    local($elt,$whatis);

    for $elt (@MANPATH) {
	$whatis = "$elt/whatis";
	if (-f $whatis) {
	    push(@whatis, $whatis);
	} else {
	    warn "$whatis: $!\n";# if $opt_M || $opt_P; # they asked for it
	} 
    } 

    die "$program: No whatis databases found, please run makewhatis\n" 
	if $#whatis < 0;
} 

# --------------------------------------------------------------------------
# run whatis (man -f)
# --------------------------------------------------------------------------
sub whatis {
    local($target, %seeking, $section, $desc, @entries);

    &genwhatis;

    for $target (@ARGV) { $seeking{$target} = 1; } 

    if ($hard_way) {
	&slow_whatis;
    } else { 
	&fast_whatis;
    }

    for $target (keys %seeking) {
	print "$program: $target: not found.\n";
	$status = 1;
    } 
} 

# --------------------------------------------------------------------------
# do whatis lookup against dbm file(s)
# --------------------------------------------------------------------------
sub fast_whatis {
    local($entry, $cmd, $page, $section, $desc, @entries);

    for $INDEX (@whatis) {
	unless (-f "$INDEX.db" && dbmopen(INDEX,"$INDEX.db",0444)) {
	    warn "$program: No dbm file $INDEX.db: $!\n" if $debug; 
	    #$status = 1;
	    if (-f $INDEX) {
		local(@whatis) = ($INDEX);  # dynamic scoping obfuscation
		&slow_whatis;
	    }
	    next;
	} else {
	    warn "$program: dbmopened $INDEX.db";
	} 
       	for $target (@ARGV) {
	    local($ext);
	    @entries = &quick_fetch($target,'INDEX');
	    next unless @entries;
	    # $target =~ s/([^\w])/\\$1/g;
	    for $entry (@entries) {
		($cmd, $page, $section, $desc) = split(/\001/, $entry);
		#  STUPID_SO is one that .so's that reference things that
		#  don't know they are being referenced.  STUPID_SO may cause
		#  some peculiarities.
		unless ($STUPID_SO) {
		    next unless $cmd =~ /$target/i || $cmd =~ /\.{3}/;
		}

		delete $seeking{$target};
		($ext) = $page =~ /\.([^.]*)$/;
		printf("%-20s - %s\n", "$cmd ($ext)", $desc);
	    }
	} 
	dbmclose(INDEX);
    } 
    
} 

# --------------------------------------------------------------------------
# do whatis lookup the hard way
# --------------------------------------------------------------------------
sub slow_whatis {
    local($query);
    local($WHATIS);

    for (@ARGV) { s/([^\w])/\\$1/g; } 

    $query = '^[^-]*\b?(' . join('|',@ARGV) . ')\b[^-]* -';

    if ($EGREP)  {
	if (&run("$EGREP '$query' @whatis")) {
	    # pity can't tell which i found
	    %seeking = ();
	}
    } else {
	foreach $WHATIS (@whatis)  {
	    unless (open WHATIS) {
		warn "can't open $WHATIS: $!\n";
		next;
	    } 
	    while (<WHATIS>) {
		next unless /$query/i;
		($target = $+) =~ y/A-Z/a-z/;
		delete $seeking{$target};
		print;
	    } 
	    close WHATIS;
	} 
    } 
} 

# --------------------------------------------------------------------------
# run apropos (man -k)
# --------------------------------------------------------------------------
sub apropos {
    local($_, %seeking, $target, $query);
    &genwhatis;  

    for (@ARGV) { s/(\W)/\\$1/g unless $opt_K; }

    if ($EGREP)  {

	# fold case on apropos args
	for (@ARGV) { 
	    y/A-Z/a-z/; 
	    $seeking{$_} = 1; 
	} 
	$query = join('|',@ARGV);

	# need to fake a -i flag?
	unless ($EGREP =~ /-\w*i/) {
	    local($C);
	    local(@pat) = split(//,$query);
	    for (@pat) {
		($C = $_) =~ y/a-z/A-Z/ && ($_ = '[' . $C . $_ . ']');
	    } 
	    $query = join('',@pat);
	} 
	if (&run("$EGREP '$query' @whatis | $PAGER")) {
	    %seeking = ();
	} 
    } else {  # use perl
	local($code) = <<'EOF';
	if ($isatty) {
	    $pid = open(PAGER, "| $PAGER");
	    sleep 1;
	    select(PAGER);
	}
	foreach $WHATIS (@whatis) {
	    unless (open WHATIS) {
		warn "can't open $WHATIS: $!\n";
		next;
	    } 
	    WHATIS: while (<WHATIS>) {
EOF
	    for (@ARGV) {
		if ($opt_K && split(/\|/) > 1) { # speed hack
		   $code .= "OPLOOP: {\n";
		   for (@_) { $code .= "\tlast OPLOOP if /$_/i;\n"; } 
		   $code .= "next WHATIS; }\n";
		} else {
		    $code .= "    next WHATIS unless /$_/i;\n";
		}
	    } 
	    $code .= <<'EOF';
		print;
	    }
	    close WHATIS;
	}
EOF
	print "$code\n" if $debug;
	eval $code;
	if ($@ =~ /(.*)at \(eval\) line (\d+)/) {
	    ($message, $line) = ($1, $2);
	    if ((split(/\n/,$code))[$line-1] =~ /next unless/) {
		warn "EVAL ERROR: $@ $code" if $debug;
		die "$0: $message\n";
	    } else {
		die $@;
	    } 
	} elsif ($@) {
	    die $@;
	} 
    } 
    close PAGER if $isatty;
}

# --------------------------------------------------------------------------
# print out usage message via pager and exit
# --------------------------------------------------------------------------
sub usage {
    unless ($opt_u) {
	warn "usage: $program [-flags] topic ...\n";
	warn "        (use -u for long usage message)\n";
    } else {
	open (PIPE, "| $PAGER");
	print PIPE <<USAGE;  # in case he wants a page
USAGE SUMMARY: 
    man [-flags] [section] page[/index] ...
	(section is [1-8lnop], or "new", "local", "public", "old")
	(index is section or subsection header)

    man [-flags] -f topic ...  
	(aka "whatis")

    man [-flags] -k keyword ...
	(aka "apropos")

FLAGS: (most only make sense when invoked as 'man')
    -a		show all possible man pages for this topic
    -A		ask which selection if several available

    -l file	do man processing on local file
    -f topic	list table of contents entry for topic
    -k keyword	give table of contents entries containing keyword
    -K pattern  as -K but allow regexps
    -g pattern  grep through all man pages for patterns
    -w topic    which files would be shown for a given topic
    -i topic    show section and subsection index for use with topic/index

    -M path	use colon-delimited man path for searching (also as -P)
    -S sects	define new section precedence 

    -t		troff the man page
    -T path	call alternate typesetter on the man page

    -d		print out all system() commands before running them
    -h		do all lookups the hard way, ignoring any DBM files
    -u		this message
    -v		print version string
    -D		strip backspaces from output

ENVIRONMENT:
    \$PAGER	pager to pipe terminal-destined output through 
    \$MANPATH	like -M path
    \$MANSECT	like -S sects
    \$MANALT	used for alternate hardware types (or obsolete -m flag)
    \$TROFF	like -T path

CURRENT DEFAULTS:
    PAGER	$PAGER
    MANPATH	$MANPATH
    MANSECT	$MANSECT
    MANALT	$MANALT
    TROFF	$TROFF

NOTES:  (\$manroot is each component in \$MANPATH)
    * If \$manroot/whatis DBM files do not exist, a warning will be 
	printed (if -d flag) and -h will be assumed for that \$manroot only.
    * If \$manroot/tmac.an exists, it will be used for formatting 
	instead of the normal -man macros.
    * Man pages may be compressed either in (for example) man1.gz/who.1 
        or man1/who.1.gz; cat pages will go into corresponding places.
    * If the man page contains .EQ or .TS directives, eqn and/or tbl
        will be invoked as needed at format time.
USAGE
	close PIPE;
    }
    warn "couldn't run long usage message thru $PAGER?!?!\n" if $?;
    exit 1;
}

# --------------------------------------------------------------------------
# lookup a given key in the given man root; returns list of hits
# --------------------------------------------------------------------------
sub fetch {
    local($key,$root) = @_;
    local(%recursed);

    return $dbmopened{$root}
	? &quick_fetch($key,$root)
	: &slow_fetch($key,$root);
}

# --------------------------------------------------------------------------
# do a quick fetch of a key in the dbm file, recursing on indirect references
# --------------------------------------------------------------------------
sub quick_fetch {
    local($key,$array) = @_;
    local(@retlist) = ();
    local(@tmplist) = ();
    local($_, $entry);
    local($name, $ext);
    local(@newlist);

    return () unless $entry = $$array{$key};;

    @tmplist = split(/\002/, $entry);
    for (@tmplist) {
	if (/\001/) {
	    push(@retlist, $_);
	} else {
	    ($name, $ext) = /(.+)\.([^.]+)/;
	    push(@retlist, 
		grep(/[^\001]+\001[^\001]+\001${ext}\001/ || /[^\001]+${ext}\001/,
			&quick_fetch($name, $array)))
			                    unless $recursed{$name}++;

	# explain and diction are near duplicate man pages referencing
	# each other, requiring the $recursed check.  one should be removed
	}
    } 
    return @retlist;
} 

# --------------------------------------------------------------------------
# do a slow fetch for target using perl's globbing notation
# --------------------------------------------------------------------------
sub slow_fetch {
    local($target,$root) = @_;
    local($glob, $stem, $entry);

    $target =~ s/(\W)/\\$1/g;  # for str$round(3V) or /bin/[

    if ($want_section) {
	if ($MANSECT{$want_section}) {
	    $stem = $want_section;
	} else {
	    $stem = substr($want_section,0,1);
        } 
	$glob = "man$stem*";
    } else {
	$glob = 'man*';
    } 
    $glob = "$root/$glob/$target.*";
    return <${glob}>;
}

# --------------------------------------------------------------------------
# run 'man -w'
# --------------------------------------------------------------------------
sub whereis {
    local($target, @files);

    foreach $target (@ARGV) {
	@files = &find_files($target);
	if ($#files < $[) {
	    warn "$program: $target not found\n";
	    $status = 1;
	} else {
	    print "$target: " if $#ARGV;
	    for (@files) { print &verify($_), " "; }
	    print "\n";
	}
    } 
} 


# --------------------------------------------------------------------------
# what are the file names matching this target?
# --------------------------------------------------------------------------
sub find_files {
    local($target) = @_;
    local($root, $entry);
    local(@retlist) = ();
    local(@tmplist) = ();
    local(@entries) = ();
    local($tar_regx);
    local($found) = 0;
    # globals: $vars, $called_before, %dbm, $hard_way (kinda)

    $vars = 'dbm00';  # var for magic autoincrementation

    ($tar_regx = $target) =~ s/(\W)/\\$1/g;  # quote meta

    if (!$hard_way && !$called_before++) {
	# generate dbm names
	for $root (@MANPATH) {
	    $dbm{$root} = $vars++; # magic incr
	    unless (-f "$root/whatis.db" 
		    && dbmopen(%$root,"$root/whatis.db",undef)) 
	    {
		warn "No dbm file for $root/whatis: $!\n" 
		    if $opt_M || $opt_P || $debug;
		#$status = 1;
		next;
	    } else {
		warn "opened $root/whatis.db" if $debug;
	    } 
	    $dbmopened{$root} = 1;
	}
    } 

    for $root (@MANPATH) {
	local($fullname);
	@tmplist = ();
	#if ($hard_way || !$dbmopened{$root})  {
	if ($hard_way)  {
	    next unless -d $root;
	    warn "slow fetch on $target in $root\n" if $debug;
	    @tmplist = &slow_fetch($target,$root);
	} else {
	    @entries = &fetch($target,$root);
	    next if $#entries < 0;

	    for $entry (sort @entries) {
		($cmd, $page, $section, $desc) = split(/\001/, $entry);

		# STUPID_SO is so that .so's that reference things that
		# don't know they are being referenced.  STUPID_SO may
		# cause peculiarities.
		unless ($STUPID_SO) {
		    next unless $cmd =~ /$tar_regx/i || $cmd =~ /\.{3}/;
		}
		push(@tmplist, "$root/man$section/$page");
	    }
	}
	push(@retlist, sort bysection @tmplist);
	last if $#retlist >= 0 && $hard_way;
    }
#    unless (@retlist || $hard_way) {
#	# shameless (ab?)use of dynamic scoping
#	local($hard_way) = 1;
#	warn "recursing on find_files\n" if $debug;
#	return &find_files($target);
#    } 
     return &trimdups(@retlist);
} 

# --------------------------------------------------------------------------
# run a normal man command
# --------------------------------------------------------------------------
sub man {
    local($target,$page);


    while (@ARGV) {
	undef $idx_topic;

	&get_section;
	$target = shift @ARGV;

	if (!$fromfile && $target =~ m!^([^/]+)/(.*)!) {
	    if (!$isatty) {
		warn "$program: no tty, so no pager to prime with index\n";
		$target = $1;
	    }  else {
		($target, $idx_topic) = ($1, $2);
	    } 
	} else {
	    undef $idx_topic;
	} 

	if ($show_all) {
	    local(@pages);
	    local($was_defined) = defined $idx_topic;
	    @pages = &find_files($target);
	    if (!@pages) {
		&no_entry($target);
		next;
	    } 
	    while ($tpage = shift @pages) {
		undef $idx_topic unless $was_defined;
		do $roff(&verify($tpage));
		&prompt_RTN("to read $pages[0]") 
		    if $roff eq 'nroff' && @pages;
	    } 
	} else {
	    $target = &get_page($target) unless $fromfile;
	    do $roff($target) if $target;
	}
	&prompt_RTN("to read man page for $ARGV[0]") 
	    if $roff eq 'nroff' && @ARGV;
    } 
} 

# --------------------------------------------------------------------------
# find out if he wants a special section and save in $want_section
# --------------------------------------------------------------------------
sub get_section {
    local($section) = $ARGV[0];

    # interpret stty(1) as 1 stty
    if ($section =~ /^(\S+)\((\S*)\),?\s*$/) {
	shift @ARGV;
	unshift(@ARGV, $section = $2, $1);
    } 

    $section =~ tr/A-Z/a-z/;


    if (defined $SECTIONS{$section}) {
	$want_section = $SECTIONS{$section};
	shift @ARGV;
    }  elsif (defined($MANSECT{$section}) || $section =~ /^\d\S*$/i) { 
	$want_section = shift @ARGV;
    } else {
	return;
    } 

    $want_section =~ tr/A-Z/a-z/;

    die "But what do you want from section $want_section?\n" 
	if $want_section && $#ARGV < 0;
}

# --------------------------------------------------------------------------
# pick the first page matching his target and search orders
# --------------------------------------------------------------------------
sub get_page {
    local($target) = @_;
    local(@found, @want);

    unless (@found = &find_files($target)) {
	&no_entry($target);
	return '';
    } 

    if (!$want_section) {
	@want = @found;
    } else {{
	local($patsect); # in case it's section 3c++ 
	($patsect = $want_section) =~ s/(\W)/\\$1/g;

	# try exact match first
	last if @want = grep (/\.$patsect$/, @found);

	# otherwise how about a subsection
	last if @want = grep (/\.$patsect[^.]*$/, @found);

	# maybe it's in the wrong place (mano is notorious for this)
	last if @want = grep (/man$patsect[^.]*\//, @found);

	&no_entry($target);
	return '';
    }}

    for (@want) { $_ = &verify($_) ; }
    $found = $want[0];

    if (@want > 1 && $query_all) {
	local($ans, $i);

	select(STDERR);

	print "There are ", 0+@want, 
	    " manual entries available for $target:\n";
	for ($i = 0; $i <= $#want; $i++) {
	    printf "%3d\t%s\n", $i+1, $want[$i];
	} 
	{
	    print "Which section would you like? (select 0 for all) ";
	    ($ans = <STDIN>) ? chop($ans) : ($ans = "\004");

	    exit if $ans eq "\004";
	    redo if $ans eq '';

	    if ($ans eq '0') {
		# more dynamic scope abuse
		local(@ARGV) = ($target);
		local($show_all) = 1;
		&man;
		return '';
	    } 
	    if (--$ans > $#want) {
		print "But we only have ",1+$#want, " man pages!\n";
		redo;
	    } 

	    $found = $want[$ans];
	}
    } 


    select(STDOUT);

    $found;
}

# --------------------------------------------------------------------------
# figure out full path name of man page, which may have been compressed
# --------------------------------------------------------------------------
sub verify {
    local($path) = @_;
    local($orig) = $path;

    return $path if -f $path;

    if ($COMPRESS_PAGE) {
	$path .= '.gz';
	return $path if -f $path;
	$path =~ s/.gz//;
    } 

    if ($COMPRESS_DIR) {
	$path =~ s-(/[^/]*)$-.gz$1-;
	return $path if -f $path;
    } 

    warn "$program: $orig has disappeared -- rerun makewhatis\n";
    $status = 1;
    return '';
}


# --------------------------------------------------------------------------
# whine about something not being found
# --------------------------------------------------------------------------
sub no_entry {
    print STDERR "No manual entry for $_[0]";
    if ($machine || $want_section) {
	print STDERR " in";
	print STDERR " section $want_section of" if $want_section;
	print STDERR " the";
	print STDERR " $machine" if $machine;
	print STDERR " manual";
    }
    print STDERR ".\n";
    $status = 1;
} 

# --------------------------------------------------------------------------
# order by section.  if the complete extension has a section
# priority, use that.  otherwise use the first char of extension
# only.  undefined priorities are lower than any defined one.
# --------------------------------------------------------------------------
sub bysection {
    local ($e1, $e2, $p1, $p2, $s1, $s2);

    ($s1, $e1) = $a =~ m:.*/man([^/]+)/.*\.([^.]+)(\.gz)?$:;
    ($s2, $e2) = $b =~ m:.*/man([^/]+)/.*\.([^.]+)(\.gz)?$:;

    $e1 = $s1 if $e1 !~ /^${s1}.*/;
    $e2 = $s2 if $e2 !~ /^${s2}.*/;

    $p1 = $MANSECT{$e1} || $MANSECT{substr($e1,0,1)};

    $p2 = $MANSECT{$e2} || $MANSECT{substr($e2,0,1)};

    $p1 == $p2 ? $a cmp $b : $p2 <=> $p1;
} 

# --------------------------------------------------------------------------
# see whether they want to start at a subsection, then run the command
# --------------------------------------------------------------------------
sub run_topic {
    local($_);
    local($menu_rtn) = defined $idx_topic && $idx_topic eq '';
    {
	&append_sub_topic;
	last if $idx_topic eq "\004";
	if ($idx_topic eq '0') {
	    $menu_rtn = 0;
	    $idx_topic = '';
	    $command =~ s: '\+/[^']*'::;
	}
	$fromfile ? &reformat($command) : &run($command);
	if ($menu_rtn) {
	    $idx_topic = '';
	    &prompt_RTN("to return to the index");
	    $command =~ s! '\+/.*$!!;
	    redo;
	} 
    }
    
} 

# --------------------------------------------------------------------------
# run through the typesetter
# --------------------------------------------------------------------------
sub troff {
    local ($file) = $_[0];
    local ($command);
    local ($manroot);
    local ($macros);

    ($manroot) = $file =~ m,^(.*)/man([^\.]*)(\.gz)?/([^/]*),;

    $command = ((($file =~ m:\.gz:) 
			? $ZCAT 
			: $CAT) 
		. " < $file | $TYPESET");

    $command =~ s,-man,$manroot/tmac.an, if -e "$manroot/tmac.an";

    &insert_filters($command,$file);
    &run($command);
} 

# --------------------------------------------------------------------------
# just run a regular nroff, possibly showing the index first.
# --------------------------------------------------------------------------
sub nroff {
    local($manpage) = $_[0];
    local($catpage);
    local($tmppage);
    local($command);
    local(@saveidx);
    local($manroot);
    local($macros);
    local($intmp);
    local(@st_cat, @st_man);

    die "trying to nroff a null man page" if $manpage eq '';

    umask 022;

    if ($full_index) {
	&show_index($manpage);
	return;
    } 
    if ($fromfile) {
	$command = (($manpage =~ m:\.gz/:) ? $ZCAT : $CAT)
			. " < $manpage | $CATSET";
	&insert_filters($command, $manpage);
    } else {
	require 'stat.pl' unless defined &Stat;   
	# compiled version has this already


	($catpage = $manpage) 
	    =~ s,^(.*)/man([^\.]*)(\.gz)?/([^/]*)$,$1/cat$2/$4,;

	$manroot = $1;

	# Does the cat page exist?
	if (! -f $catpage && $COMPRESS_DIR){
	    # No, maybe it is compressed?
	    if (-f "$1/cat$2.gz/$4"){
		# Yes it was.
		$catpage = "$1/cat$2.gz/$4";
	    } else {
		# Nope, the cat file doesn't exist.
	    	# Prefer the compressed cat directory if it exists.
	    	$catpage = "$1/cat$2.gz/$4" 
		    if $catpage !~ /\.gz$/ && -d "$1/cat$2.gz";
	    }
	}


	@st_man = &Stat($manpage);

	if ($st_man[$ST_SIZE] == 0) {
	    warn "$program: $manpage is length 0!\n";
	    $status = 1;
	    return;
	} 

	@st_cat = &Stat($catpage);


	if ($st_cat[$ST_MTIME] < $st_man[$ST_MTIME]) {

	    $command = (($manpage =~ m:\.gz:) ? $ZCAT : $CAT)
			. " < $manpage | $CATSET";

	    $command = &insert_filters($command, $manpage);
	    $command =~ s,-man,$manroot/tmac.an, if -e "$manroot/tmac.an";

	    ($catdir = $catpage) =~ s!^(.*/?cat[^/]+)/[^/]*!$1!;

	    chdir $manroot;

	    $tmppage = "$catpage.$$";

	    unless (-d $catdir && -w _ 
		    && open(tmppage, ">$tmppage") # usually EROFS
		    && close(tmppage) )
	    {
		$catpage = $tmppage = "/tmp/man.$$";
		$intmp = 1;
	    }

	    printf STDERR "Reformatting page.  Please wait ... " if $isatty;

	    $command .= "| $COMPRESS" if $catpage =~ /\.gz/;
	    $command .= "> $tmppage";

	    $SIG{'INT'} = $SIG{'QUIT'} = $SIG{'HUP'} = $SIG{'TERM'}  
		= 'tmp_cleanup';

	    $SIG{'PIPE'} = 'PLUMBER';

REFORMAT:   { unless (&reformat($command)) {
		warn "$program: nroff of $manpage into $tmppage failed\n"
		    unless $@;
		unlink $tmppage unless $debug;
		if (!$intmp++) {
		    $catpage = $tmppage = "/tmp/man.$$";
		    warn "$program: hang on... retrying into $tmppage\n";
		    $command =~ s/> \S+$/> $tmppage/;
		    $status = 0;
		    redo REFORMAT;
		} else {
		    #$status = 1;
		    return;
		}
	    }} 
	    warn "done\n" if $isatty;

	    $intmp || rename($tmppage,$catpage) || 
		die "couldn't rename $tmppage to $catpage: $!\n";
	    
	    $SIG{'INT'} = $SIG{'QUIT'} = $SIG{'HUP'} = $SIG{'TERM'} =
		$SIG{'PIPE'} = 'DEFAULT';

	} 
	$command = (($catpage =~ m:\.gz:)
			? $ZCAT
			: $CAT)
		    . " < $catpage";
    }
    if (-z $catpage) {
	unlink $catpage;
	die "$program: $catpage was length 0; disk full?\n";
    } 
    $command .= "| $UL" 		if $UL;
    $command .= "| $SED 's/.\b//g'" 	if $stripBS;

    if ($isatty) {  
        $command .= "| $PAGER";
        # If the pager is less, use the man page as the prompt, even if pipe
        if ($is_less) { 
            # Escape all periods because less interprets them.  We also
            # need to add an extra '\' to escape the shell intrepetation
            # of '\'.  We also need to make a copy of $manpage, because
            # the substitution trashes the string and it is needed later.
            ($lessprompt = $manpage) =~ s/\./\\./g;
	    $lessprompt = "$lessprompt byte %bB?s/%s .?e(END) :?pB%pB\\%.%t"
	        if $ENV{'LESS'} =~ /M/; # he wants a long prompt
            $command .= " '-MPM$lessprompt'";
        }
    }

    &run_topic;
    unlink($tmppage) if $intmp;
} 


# --------------------------------------------------------------------------
# modify $command to prime the pager with the subsection they want
# --------------------------------------------------------------------------
sub append_sub_topic {
    if (defined $idx_topic)  {{
	local($key);
	last if $idx_topic eq '0';
	unless ($idx_topic) {
	    $idx_topic = &pick_index;
	    last if $idx_topic eq "\004" || $idx_topic eq '0';
	}
	if ($idx_topic =~ m!^/!) {
	    $command .= " '+$idx_topic'";
	    last;
	}
	unless ($key = &find_index($manpage, $idx_topic)) {
	    warn "No subsection $idx_topic for $manpage\n\n";
	    $idx_topic = '';
	    redo;
	}
	$key =~ s/([!-~])/$1.$1/g unless $is_less;
	$command .= " '+/^[ \t]*$key'";
    }}
}


# --------------------------------------------------------------------------
# present subsections and let user select one
# --------------------------------------------------------------------------
sub pick_index {
     local($_);
     print "Valid sections for $page follow.  Choose the section\n";
     print "index number or string pattern. (0 for full page, RTN to quit.)\n\n";
     &show_index;
     print "\nWhich section would you like? ";
     ($_ = <STDIN>) ? chop : ($_ = "\004");
     $_ = "\004" if 'quit' =~ /^$_/;
     return $_;
} 

# --------------------------------------------------------------------------
# strip arg of extraneous cats and redirects	
# --------------------------------------------------------------------------
sub unshell {
    $_[0] =~ s/^\s*cat\s*<?\s*([^\s|]+)\s*\|\s*([^|]+)/$2 < $1/;
    $_[0] =~ s/^([^|<]+)<([^Z|<]+)$/$1 $2/;
    ($roff eq 'troff') && $_[0] =~ s#(/usr/man/pr\S+)\s+(\S+)#$2 $1#;
}

# --------------------------------------------------------------------------
# call system on command arg, stripping of sh-isms and echoing for debugging
# --------------------------------------------------------------------------
sub run {
    local($command) = $_[0];

    &unshell($command);

    if ( $opt_n ) {
	warn "$command\n";
	return 1;
    }

    warn "running: $command\n" if $debug;
    if (system $command) {
	$status = 1;
	printf STDERR "\"%s\" exited %d, sig %d\n", $command, 
	    ($? >> 8), ($? & 255) if $debug;
    }
    return ($? == 0);
} 

# --------------------------------------------------------------------------
# check if page needs tbl or eqn, modifying command if needed
# add known problems for PR directory if applicable
# --------------------------------------------------------------------------
sub insert_filters {
    local($filters,$eqn, $tbl, $_);
    local(*PAGE);
    local($c, $PAGE) = @_;
    local($page,$sect, $prs, $prdir);

    ( $page = $PAGE ) =~ s/\.gz//;
    ($prdir = $page) =~ s#/[^/]*$##;
    $prdir =~ s#man([^/]*)$#pr$1#;
    $page =~ s#.*/([^/]+)$#$1#;

    $PAGE = "$ZCAT < $PAGE|" if $PAGE =~ /\.gz/;

    (open PAGE) || die ("$program: can't open $PAGE to check filters: $!\n");
    warn "open $PAGE to check for filters in $_[0]\n" if $debug;

    while (<PAGE>) {
	if (/^\.EQ/) {
	    $_ = <PAGE>;
	    $eqn = 1 unless /\.(if|nr)/;  # has eqn output not input
	} 
	if (/^\.TS/) {
	    $_ = <PAGE>;
	    $tbl = 1 unless /\.(if|nr)/;  # has tbl output not input
	} 
	last if $eqn && $tbl;
    } 
    close PAGE;

    if ($roff eq 'troff') {
	$eqn && $_[0] =~ s/(\S+roff)/$EQN | $1/;
	$tbl && $_[0] =~ s/(\S+roff)/$TBL | $1/;
    } else { # nroff
	$eqn && $_[0] =~ s/(\S+roff)/$NEQN | $1/;
	$tbl && $_[0] =~ s/(\S+roff)/$NTBL | $1/;
    }

    ($sect) = $page =~ /\.(\d)[^.]*$/;
    $prs = "$prdir/$page";
    if (-e $prs) {
	warn "found PRs for $page\n" if $debug;
	if ($roff eq 'nroff')  {
	    $_[0] =~ s/ - / - $prs/;
	} else {
	    $_[0] .= " $prs";
	} 
    } else {
	print "no PRS for $page in $prs\n" if $debug;
    } 
    $_[0];
} 

# --------------------------------------------------------------------------
# due to aliasing the dbase sometimes has the same thing twice
# --------------------------------------------------------------------------
sub trimdups {
    local(%seen) = ();
    local(@retlist) = ();

    while ($file = shift) {
	push(@retlist,$file) unless $seen{$file}++;
    } 
    return @retlist;
} 

# --------------------------------------------------------------------------
# just print the version
# --------------------------------------------------------------------------
sub version  {
    warn "$program: version is \"$version\"\n" ;
}

# --------------------------------------------------------------------------
# create and display subsection index via pager
# --------------------------------------------------------------------------
sub show_index {
    local($_);
    &load_index($_[0]);
    if ($#ssindex > ($rows - 4) && $isatty) {
	print "Hit <RTN> for $#ssindex subsections via pager: ";
	$_ = <STDIN>;
	local($SIG{'PIPE'}) = 'IGNORE';
	if ($no_idx_file) {
	    open (PAGER, "| $PAGER");
	    print PAGER @ssindex;
	    close PAGER;
	} else {
	    &run("$PAGER $idx_file");
	} 
    } else {
	print STDOUT @ssindex;
    }
} 

# --------------------------------------------------------------------------
# find closest match on index selection in full index
# --------------------------------------------------------------------------
sub find_index {
    local($manpage, $expr) = @_;
    local($_, @matches);

    &load_index($manpage);

    $expr =~ s!^/+!!;

    for (@ssindex) { 
	s/^\s*\d+\s+//; 
	s/\s+\d+\s*$//; 
    }

    if ($expr > 0) {
	return $ssindex[$expr];
    } else {
	$ssindex[0] = '';
	if (@matches = grep (/^$expr/i, @ssindex)) {
	    return $matches[0];
	} elsif (@matches = grep (/$expr/i, @ssindex)) {
	    return $matches[0];
	} else {
	    return '';
	}
    } 
} 

# --------------------------------------------------------------------------
# read in subsection index into @ssindex
# --------------------------------------------------------------------------
sub load_index {
    local($manpage)  = @_;
    $no_idx_file = 0;
    &getidx($manpage) if $#saveidx < 0;
    @ssindex = @saveidx;
    die "should have have an index for $manpage" if $#saveidx < 0;
} 

# --------------------------------------------------------------------------
# create subsection index is out of date wrt source man page
# --------------------------------------------------------------------------
sub getidx {
    local($manpage) = @_;
    local($is_mh);
    local($_, $i, %lines, %sec, $sname, @snames);
    local(@retlist, $maxlen, $header, @idx , @st_man, @st_idx);
    # global no_idx_file, idx_file

    ( $idx_file = $manpage ) =~ s:/man(\w+)(\.gz)?/:/idx$1/:;
    $idx_file =~ s/\.gz//;

    require 'stat.pl' unless defined &Stat;

    @st_man = &Stat($manpage);
    @st_idx = &Stat($idx_file);

    if ($st_man[$ST_MTIME] < $st_idx[$ST_MTIME]) {
	unless (open idx_file) {
	    warn "$program: can't open $idx_file: $!\n";
	    return ();
	} 
	@retlist = <idx_file>;
	close idx_file;
	return @saveidx = @retlist;
    } 

    if (!open(manpage, $manpage =~ /\.gz/ ? "$ZCAT < $manpage|" : $manpage)) {
    	warn "$program: can't open $manpage: $!\n";
	return ();
    }
    warn "building section index\n" if $debug;
    ($header = "Subsections in $manpage")  =~ s!/?\S*/!!;
    $maxlen = length($header);
    push(@snames, $sname = 'preamble');;

    # MH has these alias for sections and subsectdions
    if ($is_mh = $manpage =~ m:/mh/:) {
	%mh_sections = (
	    "NA", "NAME",
	    "SY", "SYNOPSIS",
	    "DE", "DESCRIPTION",
	    "Fi", "FILES",
	    "Pr", "PROFILE",
	    "Sa", "SEE ALSO",
	    "De", "DEFAULTS",
	    "Co", "CONTEXT",
	    "Hh", "HELPFUL HINTS",
	    "Hi", "HISTORY",
	    "Bu", "BUGS"
	);
	$mh_expr = join('|',keys %mh_sections);
    } 

    while (<manpage>) {
	if ($is_mh && /^\.($mh_expr)/) {
	    $sname = $mh_sections{$+};
	    $maxlen = length($sname) if $maxlen < length($sname); 
	    push(@snames,$sname);
	} 
	if (/^\.(?:s[sh]|ip)\s+(.*?)(\s*\d+)?$/i ) {
	    $line = $_;
	    $_ = $1;
	    s/"//g;
	    s/\\f([PBIR]|\(..)//g;	# kill font changes
	    s/\\s[+-]?\d+//g;		# kill point changes
	    s/\\&//g;			# and \&
	    s/\\\((ru|ul)/_/g;		# xlate to '_'
	    s/\\\((mi|hy|em)/-/g;	# xlate to '-'
	    s/\\\*\(..//g; 		# no troff strings
	    s/\\//g;		   	# kill all remaining backslashes 
	    $sname = $_;
	    $_ = $line;
	    $maxlen = length($sname) if $maxlen < length($sname); 
	    push(@snames,$sname);
	} 
	$lines{$sname}++;
    } 

    $mask = sprintf("%%2d   %%-%ds %%5d\n", $maxlen + 2);

    $no_idx_file = $idx_file eq $manpage || !open(idx, ">$idx_file");

    $line = sprintf(sprintf("Idx  %%-%ds Lines\n", $maxlen + 2), $header);
    @retlist = ($line);

    for ($i = 1; $i <= $#snames; $i++)  {
	push(@retlist, sprintf($mask, $i, $snames[$i], $lines{$snames[$i]}));
    } 
    if (!$no_idx_file) {
	warn "storing section index in $idx_file\n" if $debug;
	print idx @retlist;
	close idx;
    }
    return @saveidx = @retlist;
}

# --------------------------------------------------------------------------
# interrupted -- unlink temp page
# --------------------------------------------------------------------------
sub tmp_cleanup {
    warn "unlink $tmppage\n" if $debug;
    unlink $tmppage;
    die "Interrupted!\n";
} 

#--------------------------------------------------------------------------
# in case we die writing to the pipe
# --------------------------------------------------------------------------
sub PLUMBER {
    warn "unlink $tmppage\n" if $debug;
    unlink $tmppage;
    die "Broken pipe while reformating $manpage\n" ;
} 


# --------------------------------------------------------------------------
# print line with C\bC style emboldening 
# --------------------------------------------------------------------------
sub print {
    local($_) = @_;

    if (!$inbold) {
	print;
    } else {
	local($last);
	for (split(//)) {
            if ($last eq "\033") {
                print;
            } else {
                print /[!-~]/ ? $_."\b".$_ : $_;
            }
            $last = $_;
	}
    } 
}

# --------------------------------------------------------------------------
# reformat the page with nroff, fixing up bold escapes
# --------------------------------------------------------------------------
sub reformat { 
    local($_) = @_; 
    local($nroff, $col); 
    local($inbold) = 0;
    local($status);

    if ($NROFF_CAN_BOLD) {
	return &run($_);
    } 

    &unshell($_);
    ($nroff, $col) = m!(.*)\|\s*($COL.*)!;

    if ( $opt_n ) {
	warn "$_\n";
	return 1;
    }

    warn "$nroff | (this proc) | $col\n" if $debug;

    open (NROFF, "$nroff |");
    $colpid = open (COL, "| $col");

    select(COL);

    while (<NROFF>) {
	s/\033\+/\001/;
	s/\033\,/\002/;
	if ( /^([^\001]*)\002/ || /^([^\002]*)\001/ )  {
	    &print($1);
	    $inbold = !$inbold;
	    $_ = $';
	    redo;
	}   
	&print($_);
    }

    close NROFF;
    if ($?) { 
	warn "$program: \"$nroff\" failed! status=$?" if $debug;
	$status++;
    } 
    close COL;
    if ($?) {
	warn "$program: \"$col\" failed! status=$?" if $debug;
	$status++;
    }
    select(STDOUT);
    $status == 0;
} 

# --------------------------------------------------------------------------
# prompt for <RET> if we're a tty and have a non-stopping pager
# --------------------------------------------------------------------------
sub prompt_RTN {
    local($why) = $_[0] || "to continue";
    return unless $isatty;
    unless ($is_less && $ENV{'LESS'} !~ /E/) {
	print "Hit <RTN> $why: ";
	$_ = <STDIN>;
    }
}

# --------------------------------------------------------------------------
# dynamically determine MANPATH (if unset) according to PATH
# --------------------------------------------------------------------------
sub config_path {
    local($_);		# for traversing $PATH
    local(%seen);	# weed out duplicates
    local(*manpath);	# eventual return values

    if (defined $ENV{'MANPATH'}) {
	$manpath = $ENV{'MANPATH'};
    } else {
	for (split(/:/, $ENV{'PATH'})) {
	    next if $_ eq '.';
	    next if $_ eq '..';
	    s![^/+]*$!man! && -d && !$seen{$_}++ && push(@manpath,$_);
	}
	$manpath = join(':', @manpath);
    } 
    # $manpath;    # last expr is assign to this anyway
} 

# --------------------------------------------------------------------------
# grep through MANPATH for a pattern
# --------------------------------------------------------------------------
sub grepman {
    local($code, $_, $dir, $root, $FILE, $found);
    
    $code = "while (<FILE>) {\n";

    for (@ARGV) {
	s#/#\\/#g;
	$code .= <<EOCODE;
	    if (/$_/) { 
		print "\$path: \$_"; 
		\$found++;
		next; 
	    }
EOCODE
    } 

    $code .= "}\n";

    print "grep eval code: $code" if $debug;

    
    foreach $root ( split(/:/, $MANPATH)) {
	unless (chdir($root)) {
	    warn "can't chdir to $root: $!";
	    $status++;
	    next;
	} 
	foreach $dir ( <man?*> ) {
	    unless (chdir($dir)) {
		warn "can't chdir to $root/$dir: $!" if $debug;
		next;
	    } 
	    unless (opendir(DIR, '.')) {
		warn "can't opendir $root/$dir: $!" if $debug;
		next;
	    } 
	    foreach $FILE ( readdir(DIR) ) {
		next if $FILE eq '.' || $FILE eq '..';
		$path = "$root/$dir/$FILE";
		if ($FILE !~ /\S\.\S/ || !-f $FILE) {
		    print "skipping non-man file: $path\n" if $debug;
		    next;
		} 
		if ($FILE =~ /\.gz$/ || $dir =~ /\.gz$/) {
		    $FILE = "$ZCAT $FILE|";
		} 
		print STDERR "grepping $path\n" if $debug;
		unless (open FILE) {
		    warn "can't open $root/$dir/$FILE: $!";
		    $status++;
		    next;
		} 
		eval $code;
		die $@ if $@;
	    } 
	    unless (chdir ($root)) {
		warn "can't return to $root: $!";
		$status++;
		last;
	    } 
	} 
    } 
    exit ($status || !$found);
} 
