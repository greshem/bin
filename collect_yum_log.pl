#!/usr/bin/perl
my @logs=glob("/var/log/yum*.log");
my $today= get_today();
my $number=get_start_number();

for(@logs)
{
	$number++;
	print ("mv $_ 		/root/develop_perl/yum_${today}_${number}_log  \n");
	print ("/bin/txt_file_2_perl_script.pl   /root/develop_perl/yum_${today}_${number}_log  \n");
	print ("rm -f   /root/develop_perl/yum_${today}_${number}_log  \n");
	print ("svn add   /root/develop_perl/yum_${today}_${number}_log.pl \n");
	print ("cd  /root/develop_perl/\n");
	print ("svn commit -m \"add_1m:  $today   yum.log\" \n");


}


#½á¹û: 2011-01-05
sub get_today()
{
	use POSIX qw (strftime);
	my $today=POSIX::strftime('%Y_%m_%d',localtime(time()));
	return $today;
}


sub get_start_number()
{
	my $today= get_today();
	my @array=  glob("/root/develop_perl/yum_${today}*log.pl");
	return scalar(@array);
}

