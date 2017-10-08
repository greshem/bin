#!/usr/bin/perl -w
#
# cpdvd
# written by Christian Vogelgsang <chris@lallafa.de>
# under the GNU Public License V2
#
# modified on 04 Jan 2003 by Sven Over <over@hep.physik.uni-siegen.de>
#
# cpdvd <targetDir>
# Automatically copy titles of a dvd to the given directory.
# Copies necessary *.ifo and *.vob files.
#

print "cpdvd: " . '$Revision: 1.10 $ $Date: 2004/01/31 09:53:41 $ ' . "\n";

# ----- Configure cpdvd -----

# --- config ---
# try to fetch DVD mount point and device from environment
if(defined $ENV{'DVD_MOUNT'}) {
  $dir = $ENV{'DVD_MOUNT'};
} else {
  $dir = "/dvd"; # default mount point
}
if(defined $ENV{'DVD_DEV'}) {
  $dev = $ENV{'DVD_DEV'};
} else {
  undef $dev;
}

$dummyMode  = 0;
$infoOnly   = 0;
$use_vobcopy = 0;
$use_tccat   = 0;
$domount    = 0;

# read args
while($_=shift) {
  if( m/^-(.)$/ ) {
    if($1 eq 't') {
      push(@ripTitles,shift);
    } elsif($1 eq 'd') {
      $dev = shift;
    } elsif($1 eq 'm') {
      $dir = shift;
    } elsif($1 eq 'n') {
      $dummyMode = 1;
    } elsif($1 eq 'i') {
      $infoOnly = 1;
    } elsif($1 eq 'v') {
      $use_vobcopy = 1;
    } elsif($1 eq 'c') {
      $use_tccat = 1;
    } elsif($1 eq 'f') {
      $domount = 1;
    } else {
      print "ERROR: unknown switch '$_'\n";
      &Usage;
      exit(1);
    }
  } else {
    $tgt = $_;
  }
}

# if not in dummy/info mode then a target is required
if(!$infoOnly) {
  if(!defined($tgt)) {
    print "ERROR: no target directory specified!\n";
    &Usage;
  }
}

# cut trailing '/'
$dir =~ s/\/+$//;
$tgt =~ s/\/+$//;

# check if $dir is a directory
# -> cause automounter (if used) to mount device
if(! -d $dir) {
  print "ERROR: given path '$dir' does not lead to a directory\n";
  exit(1);
}

# try to find device automatically
if (!defined $dev) {
  # directory is already mounted - use /proc/mounts to find device
  open(MOUNTS,"/proc/mounts") or 
    die "ERROR: can't access /proc/mounts.\n"
      . "Please use -d option to specify dvd device\n";
  while(<MOUNTS>) {
    chomp;
    my @fields=split(/\s+/);
    $dev=$fields[0] if($dir eq $fields[1]);
  }
  close(MOUNTS);

  # directory is currently not mounted - try to find mount device in /etc/fstab
  open(FSTAB,"/etc/fstab") or
    die "ERROR: can't access /etc/fstab.\n"
      . "Please use -d option to specify dvd device\n";
  while(<FSTAB>) {
    chomp;
    # skip comments or empty lines
    next if(m/^\s*\#/ or m/^\s*$/);
    my @fields=split(/\s+/);
    if($dir eq $fields[1]) {
      $dev=$fields[0];
      $domount = 1;
    }
  }
  close(FSTAB);

  # hmm. device cannot be found!
  if (!defined $dev) {
    print "ERROR: could not find mount device node for '$dir'.\n"
      . "Please use -d option to specify dvd device directly\n";
    exit(1);
  }
}
print " device=$dev  mount=$dir\n";

# ----- title parsing with tcprobe and IFOs -----

print "Probing DVD...\n";

# first tcprobe: get total number of titles
$probe = `tcprobe -i \"$dev\" 2>&1`;
if(!($probe =~ m,DVD title \d+/(\d+),)) {
  print STDERR "... FAILED! - No DVD?\n";
  exit(1);
}
$totalTitles = $1;
print " titles: total=$totalTitles\n";

# check list of requested titles
if(defined(@ripTitles)) {
  # take user specified titles
  @checkTitles = @ripTitles;
} else {
  # take all titles
  @checkTitles = 1 .. $totalTitles;
}

# now probe each title and find longest
$longestLen   = 0;
$longestTitle = 0;
for(@checkTitles) {

  # call tcprobe for info
  $probe = `tcprobe -i \"$dev\" 2>&1 -T $_`;

  # extract title playback time -> titlelen
  if(!($probe =~ m,title playback time: .* (\d+) sec,)) {
    print STDERR "No time found in tcprobe for title $_ !\n";
    exit(1);
  }
  $titleLen[$_] = $1;

  # extract title set (VTS file) -> titleset
  if(!($probe =~ m,title set (\d+),)) {
    print STDERR "No title set found in tcprobe for title $_ !\n";
    exit(1);
  }
  $titleSet[$_] = $1;

  # extract angles
  if(!($probe =~ m,(\d+) angle\(s\),)) {
    print STDERR "No angle found in tcprobe for title $_ !\n";
    exit(1);
  }
  $angles = $1;

  # extract chapters
  if(!($probe =~ m,(\d+) chapter\(s\),)) {
    print STDERR "No chapter found in tcprobe for title $_ !\n";
    exit(1);
  }
  $chapters = $1;

  # calc hour, minute of title len
  $sec  = $titleLen[$_];
  $hour = int($sec / 3600);
  $sec -= $hour * 3600;
  $min  = int($sec / 60);
  $sec -= $min * 60;

  # verbose
  printf("  #%02d: len=%02d:%02d:%02d titleset=%02d angles=%02d chapters=%02d\n",
  	$_,$hour,$min,$sec,$titleSet[$_],$angles,$chapters);

  # find largest title
  if($titleLen[$_] > $longestLen) {
    $longestLen   = $titleLen[$_];
    $longestTitle = $_;
  }
}
print " main title guess: $longestTitle\n";

# exit now if we are in info mode
exit(0) if($infoOnly);

# ----- setup target directory -----

# create target dir
if(! -d $tgt) {
  print "Creating target dir '$tgt'\n";
  Do("mkdir \"$tgt\"",$dummyMode);
} else {
  print "WARNING: Directory '$tgt' already exists!\n";
}

# ----- read and parse video_ts directory -----
# mount dvd if domount-option (-M) was given
if ($domount) {
  print "Mounting DVD at '$dir'\n";
  Do("mount \"$dir\"",0);
}

# read video_ts dir
print "Reading title sets\n";
$vdir="$dir/video_ts";
if(!opendir(FH,"$vdir")) {
  $vdir="$dir/VIDEO_TS";
  if(!opendir(FH,"$vdir")) {
    print STDERR "Can't read DVD dir!\n";
    Do("umount \"$dir\"",0) if ($domount);
    exit(1);
  }
}
@files = readdir(FH);
closedir(FH);

# parse title sets
print "Checking title set files\n";
$vtsMin = 9999;
$vtsMax = 0;
foreach(@files) {
  # count vob files in each title set
  if(m/^vts_(\d\d)_\d.vob/i) {
    $set = int($1);
    if($set < $vtsMin) {
      $vtsMin = $set;
    }
    if($set > $vtsMax) {
      $vtsMax = $set;
    }
    $vtsParts{$set}++;
  }
  # fetch names for IFOs
  elsif(m/video_ts.ifo/i) {
    $video_ts=$_;
  }
  elsif(m/vts_(\d+)_0.ifo/i) {
    $ifo{int($1)}=$_;
  }
}

# check title sets
@vtsIDs   = keys(%vtsParts);
$vtsTotal = scalar @vtsIDs;
print " min=$vtsMin, max=$vtsMax, total=$vtsTotal\n";
if(($vtsMin!=1)||($vtsMax!=$vtsTotal)) {
  print "WARING: strange title sets!"
}

# ----- Determine titles to rip -----
print "Selecting titles and sets\n";
# user specified titles
if(defined(@ripTitles)) {
  foreach(@ripTitles) {
    $set = $titleSet[$_];
    $ripVtsSet{$set}++;
    if($ripVtsSet{$set}>1) {
      print "ERROR: title $_ also in set $set (Only one title per set!)\n";
      Do("umount \"$dir\"",0) if ($domount);
      exit(1);
    }
  }
} 
# take longest
else {
  push @ripTitles,$longestTitle;
  $ripVtsSet{$titleSet[$longestTitle]}=1;
}
@ripVts=keys(%ripVtsSet);
print " titles: " . join(' ',@ripTitles) . "\n";
print " sets:   " . join(' ',@ripVts) . "\n";

# ========== NOW THE ACTUAL DATA TRANSFER CAN BEGIN ==========

# ----- IFO copy -----
if($use_vobcopy || $use_tccat) {
  print "Copying IFOs for VTSs: " . join(' ',@ripVts) . "\n";
  # main ifo
  Do("cp \"$vdir/$video_ts\" \"$tgt/video_ts.ifo\"",$dummyMode);
  # vob ifos
  foreach(@ripVts) {
    $tifo = sprintf("$tgt/vts_%02d_0.ifo",$_);
    Do("cp \"$vdir/$ifo{$_}\" \"$tifo\"",$dummyMode);
  }
}

# unmount dvd if domount option (-M) was given
if ($domount)
{
  print "Unmounting DVD at '$dir'\n";
  Do("umount \"$dir\"",0);
}

# ----- copy with vobcopy -----
if ($use_vobcopy) {
  # now use vobcopy to copy/decrypt movie
  print "Copying Titles: " . join(' ',@ripTitles) . "\n";
  foreach(@ripTitles) {
    $set = $titleSet[$_];
    print " copying title $_ (set $set)\n";
    $tname = sprintf("\"$tgt/vts_%02d_\"",$set);
    $cmd = "vobcopy -i \"$dev\" -n $_ -t $tname";
    Do($cmd,$dummyMode);
  }

  # rename split files
  print "Renaming VOBs\n";
  opendir(FH,"$tgt") || die "Can't read target dir '$dir'";
  @files = readdir(FH);
  closedir(FH);
  foreach(@files) {
    # rename _X_1 -> _0.vob, _X_2 -> _1.vob ...
    if(m/^vts_(\d\d)_\d+-(\d+)/) {
      $new = sprintf "vts_%s_%d.vob", $1,$2-1;
      Do("mv \"$tgt/$_\" \"$tgt/$new\"",$dummyMode);
    }
  }
}
# ----- copy via transcode -----
elsif($use_tccat) {
  # now use transcode to copy/decrypt movie
  print "Copying Titles: " . join(' ',@ripTitles) . "\n";
  foreach(@ripTitles) {
    $set = $titleSet[$_];
    print " copying title $_ (set $set)\n";
    $tname = sprintf("\"$tgt/vts_%02d_\"",$set);
    $cmd = "tccat -i \"$dev\" -P $_ -t dvd | split -b 1024m - $tname";
    Do($cmd,$dummyMode);
  }

  # rename split files
  print "Renaming VOBs\n";
  opendir(FH,"$tgt") || die "Can't read target dir '$dir'";
  @files = readdir(FH);
  closedir(FH);
  foreach(@files) {
    # rename _aa -> _0.vob, _ab -> _1.vob ...
    if(m/^vts_(\d\d)_.(.)$/) {
      $digit = ord($2) - ord("a");
      $new = "vts_${1}_" . chr($digit+ord("1")) . ".vob";
      Do("mv \"$tgt/$_\" \"$tgt/$new\"",$dummyMode);
    }
  }
}
# ----- use cpvts -----
else {
  foreach(@ripVts) {
    Do("cpvts -d \"$dev\" -t $_ \"$tgt\"",$dummyMode);
  }
}

# end program
if(defined($errors)) {
  print "Ready, but $errors ERROR(s) occured!\n";
  exit(1);
}
print "Ready! Summary: You can use the following title(s) in '$tgt':\n"
  . join(' ',@ripTitles) . "\n";
exit 0;

# ----- Usage information -----
sub Usage {
  print STDERR <<EOF;
Usage: cpdvd [options] <targetDir>

  -t <num>  copy title <num>    (repeat for more titles/none: whole disc)
  -m <mnt>  set DVD mount point (default: DVD_MOUNT or "/dvd")
  -d <dev>  set DVD device      (default: DVD_DEV or probe automatically)
  -v        use vobcopy for data transfer   (default: cpvts)
  -c        use tccat for data transfer
  -f        force mount and unmount of dvd device
  -i        only fetch info and exit
  -n        dummy mode (do not execute copy commands)
EOF
  exit(1);
}

# ----- Execute an external command and check result -----
sub Do {
  my($cmd,$dummyMode) = @_;
  my($result);

  if($dummyMode) {
    print "\t$cmd\n";
    return;
  }
  $result = system($cmd);
  if($result==-1) {
    print STDERR "ERROR: Can't execute '$cmd'\n";
    $errors++;
  }
  $result /= 256;
  if($result!=0) {
    print STDERR "ERROR: Got error result while executing '$cmd'\n";
    $errors++;
  }
}
