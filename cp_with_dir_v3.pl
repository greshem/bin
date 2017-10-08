#!/usr/bin/perl
use File::Basename;
use File::Path;
use File::Copy;
my $move=undef;
if (!defined  $ARGV[0])
{
	print "Usage  $ARGV[-1] list\n";
}
$move=1 if(grep{/move/} @ARGV);

$suf = $ARGV[0]."_iso";
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
	if($move)
	{
    	print "mv  ",$_,"  ", $suf."/".$dir,"\n";
     	move($_, $suf."/".$dir);
	}
	else
	{
		#copy($_, $suf."/".$dir);
		if(-d $_)
		{
			print "cp -a -r   ",$_,"  ", $suf."/".$dir,"\n";
		}else
		{
			print "cp  ",$_,"  ", $suf."/".$dir,"\n";
		}
		copy($_, $suf."/".$dir);
	}
}
