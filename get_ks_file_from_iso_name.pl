#!/usr/bin/perl
use Cwd;
use File::Basename;

#×îºó 
if($0=~/get_ks_file_from_iso_name.pl$/)
{
	my $input_iso= shift or Usage();

	my $basename=basename($input_iso);
	(my $os_name)=($basename=~/(.*)\.iso$/);
	(my $major, $minor)=($os_name=~/(.*?)_(\d+)_*/);

	#print "major=>$major ;   $minor=> $minor \n";

	my $kick_start_cfg=get_ks_cfg_with_number($major, $minor);

	if(defined($kick_start_cfg))
	{
		if( -f $kick_start_cfg)
		{
			print("cp $kick_start_cfg  /var/www/html/ 		\n");
			print("cp $kick_start_cfg  /var/www/html/ks.cfg \n");
			print("echo cp $kick_start_cfg  /var/www/html/ 		\n");
			print("echo cp $kick_start_cfg  /var/www/html/ks.cfg \n");

		}
		else
		{
			die("$kick_start_cfg not exists \n");
		}	
	}
}

sub get_ks_cfg_with_number($$)
{
	(my $name, my $number)=@_;
	$name=lc($name);
	#print("ls  /root/bin/kickstart/${name}*_${number}*.cfg\n");

	for $each (glob("/root/bin/kickstart/${name}*_${number}_*.cfg"))
	{
		#print "   $each \n";
		return $each;
	}

	return undef;
}




sub Usage()
{
	die ("$0  input.iso \n");
}

