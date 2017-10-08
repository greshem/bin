#!/usr/bin/perl
use File::Basename;
use File::Path;
use File::Copy;
if (!defined  $ARGV[0])
{
	die "Usage $0 $ARGV[-1] list\n";
}
$suf = $ARGV[0]."_iso";
CheckSize($ARGV[0]);

open(FILE,$ARGV[0]);
while (<FILE>)
{
    chomp;
    $dir  = dirname($_);
    $dir  = $dir."/";
    $base = basename($_);
#    print $suf. $dir . "\n";
    mkpath( $suf."/".$dir );

#    print "cp ", $_," ",$suf, $dir,   $base,"\n";
    #copy( $_, $suf . $dir );
    #print "mv  ",$_,"  ", $suf."/".$dir,"\n";
    # move($_, $suf."/".$dir);
     #copy($_, $suf."/".$dir);
}

sub  CheckSize($)
{
	(my $in)=@_;
	open(FILE, $in) or die("open file error\n");
	my $totalSize;
	while(<FILE>)
	{
		chomp;
		$totalSize+=(-s $_);
	}
	if($totalSize<= 1024*1024*(4000+100) )
	{
		die("Error sum sizeof $in  ", $totalSize/1024/1024, "M  < 4200M\n");
	}
}
