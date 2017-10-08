#!/usr/bin/perl
use File::Find;
use Cwd;
use vars qw(*name);

$dir=shift or die("Usage: $0 dir depth\n");
#our $depth= shift or die("Usage: $0 dir depth\n");
our $printDepth=undef;
if(grep{/print|depth/} @ARGV)
{
	$printDepth=1;
}
*name=*File::Find::name;

our @globalFileList;
sub wanted()
{
	if ( -d $_ && $_ =~/HTML$/)
	{
		$cwd=cwd();
		$name.="/";
		@array=split(/\//, $name);

		#####对于深度的处理方式。 
		#print "Depth ", scalar(@array),"\n" if($printDepth);
		#if(scalar(@array) == $depth)
		#{
		#	push(@globalFileList, $name);
		#	print $name,"\n";
		#}
		my @file= grep{ -f }  (<HTML/*>);
		if(grep (/chm$/, @file))
		{
			print STDERR "有chm 文件， 暂时不删除",$cwd,"/HTML\n";
		}
		else
		{
			print STDERR "没有chm 文件， 可以删除",$cwd,"/HTML\n";
			print $cwd."/HTML\n";
			for (@file)
			{
				print "rm -f $_\n";
			    unlink($_);
			}

		}
		rmdir("HTML");
	}
}

sub getAllFileFromDir($)
{
	(my $in)=@_;
	File::Find::find({wanted=>\&wanted}, $in);
	#map{print $_,"\n"} @globalFileList;
	return @globalFileList;
}
##############
#main
##############
while(1)
{
	getAllFileFromDir($dir);
	print  "x"x80, "sleep 180 second \n";
	sleep 60*30;

}
#for( @globalFileList)
{
#	print $_,"\n";
}

