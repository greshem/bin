#!/usr/bin/perl
use File::Basename;
use File::Path;
use File::Copy;
our @dir;
use Cwd;
use File::Basename;

our $g_pwd=getcwd();
our $g_basename=basename($g_pwd);
our $g_dirname=dirname($g_pwd);


if(!$ARGV[0])
{
	opendir(DIR,".");
	@dir=grep{/^ISO/ && -f }  readdir(DIR);
	if(!@dir)
	{
		die "Usage $0 $ARGV[-1] list\n";
	}
}

for $each (@dir)
{
	print "Deal with $each\n";
	CheckSize($each);
	moveDir2Iso($each);
}

sub moveDir2Iso($)
{
	(my $in)=@_;

	my $suf = $in."_iso";
	open(FILE,$in);
	while (<FILE>)
	{
	    chomp;
	    $dir  = dirname($_);
	    $dir  = $dir."/";
	    $base = basename($_);
	#    print $suf. $dir . "\n";
	    mkpath( $suf."/".$dir );

	   # print "cp ", $_," ",$suf, $dir,   $base,"\n";
	    #copy( $_, $suf . $dir );
	    #print "mv  ",$_,"  ", $suf."/".$dir,"\n";
		if($^O=~/linux/i)
		{
	    	move($_, $suf."/".$dir);
		}
		else
		{
			$abs_suf=$g_pwd."\\".$suf;
			$abs_suf=~s/\//\\/g;

			my $input_file=$_;
			$input_file=$g_pwd."\\".$input_file;
			$dir=~s/\//\\/g;
			$input_file=~s/\//\\/g;
			
			#copy  gentoo portage  拷贝到 1TG 的空盘, 制作iso   小文件太多了.
			$abs_suf=~s/^H:/I:/g;
			mkpath("$abs_suf\\$dir\\");
			print( "$input_file -> $abs_suf\\$dir\\$base\n ");
			copy( $input_file, "$abs_suf\\$dir\\$base");

			#mklink 的顺序注意一下 
			#print("mklink  $abs_suf\\$dir\\$base 	$input_file    \n");
				
		}
	     #copy($_, $suf."/".$dir);
	}
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
		#warn("Error sum sizeof $in  ", $totalSize/1024/1024, "M  < 4200M\n");
	}
}
