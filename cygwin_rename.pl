
#2011_08_19_   ÐÇÆÚÎå   add by huanghaibo

#!/usr/bin/perl -w
use File::Basename;

sub rename_in_cygwin($)
{
    (my $name) = @_;
    $src_path="c:\\cygwin\\bin\\".$name;
    $dest_path="c:\\cygwin\\bin\\cygwin_".$name;
 
    rename($src_path, $dest_path);  
	print $dest_path."\n";
}

foreach (glob("C:\\cygwin\\bin\\*.exe"))
{
	if(-e "C:\\WINDOWS\\system32\\".basename($_))
	{
		#	print $_."\n";
		rename_in_cygwin(basename($_));
	}
} 

rename_in_cygwin( "C:\\cygwin\\bin\\link.exe");

print "Finished ....!\n";
