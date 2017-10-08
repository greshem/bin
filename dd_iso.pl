#!/usr/bin/perl
my $number= shift or die("Usage: $0  number \n");
if($number!~/^\d+$/)
{
	die("#input   |$number| is not a number \n");
}

sub check_exists($)
{
	(my $number)=@_;
	my @files=grep {-f} glob("/home/$number.iso");
	if(scalar(@files)>0)
	{
		die("ERROR:  $number.iso  already  exists \n");
	}

	open(FILE, "generator.log") ; 
	for(<FILE>)
	{
		if($_=~/$number.iso/)
		{
			die("ERROR:  $number.iso  already  exists,in log   \n");
		}
	}
	close(FILE);
}

while( ! open(FILE, "/dev/cdrom") )
{
	printf("open cdrom failure,  open it again \n");
	sleep(1);
}

print ("dd if=/dev/cdrom  of=/home/$number.iso \n");
system("dd if=/dev/cdrom  of=/home/$number.iso ");
sleep(5);
system("eject /dev/cdrom");
print("eject  /dev/cdrom\n ");
