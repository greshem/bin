#!/usr/bin/perl
#!/usr/bin/perl
do("c:\\bin\\iso_get_mobile_disk_label.pl");
our $disk=change_mobile_path_to_win_path('sdb1');
print "eden sdb1:\\  ->  $disk \n";


use File::Slurp qw(edit_file read_file);
sed_dir("./");

sub sed_dir($)
{
	(my $dir)=@_;
	for $each (glob("$dir/*.vmx"))
	{
		print "#deal with $each , sed to  $disk\:\\sdb \n";
		edit_file { s/[a-zA-Z]\:\\sdb/$disk\:\\sdb/g}  $each;
	}
}

__DATA__
$text=  read_file('input_file.txt' ) ;
edit_file { s/g\:\\sdb/f\:\\sdb/g}  "input.vmx";
