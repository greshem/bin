#!/usr/bin/perl
use Cwd;
use File::Copy::Recursive;

$cmd=join(" ", @ARGV);
my $pwd=getcwd();
for(<*>)
{
	if ( -f $pwd."/".$_ && /$ARGV[0]/ )
	{
		print "  ", $_, "\n";
		#chdir($pwd."/".$_);
		#system("$cmd ");
	}
}
