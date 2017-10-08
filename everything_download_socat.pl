#!/usr/bin/perl
check_socat_port_check();

#j$input_file="psftools-1.0.7.chm";
$input_file=shift or die("Usage: $0  input_file \n");;

#@array= `grep -h $input_file -R  /root/eden_cache/ `;
@array=` cd /root/eden_cache/ &&  perl  /root/eden_cache/search_file.pl  $input_file `;


if(scalar(@array)==0)
{
    die(" $input_file not find in eden cache \n");
}

for(@array)
{
    chomp;
    print $_;
}

print ("echo  $array[0] |   socat -t 10  - TCP:192.168.1.14:8889\n");
system("echo  $array[0] |   socat -t 10  - TCP:192.168.1.14:8889");

print(" wget --http-user root  --http-passwd  q******************************n   http://192.168.1.14/C%3A/Users/Administrator/Desktop/$input_file \n");
system(" wget --http-user root  --http-passwd  q******************************n   http://192.168.1.14/C%3A/Users/Administrator/Desktop/$input_file");



sub check_socat_port_check()
{
   my $buf=` echo uptime.pl  |  socat - TCP:192.168.1.14:8889`;
   print $buf."\n";
   print  <<EOF
#exec in windows 
socat -x -v  -t100 tcp-listen:8889,reuseaddr,fork   exec:cmd,pty
EOF
;
}

sub my_system($)
{
	(my $cmd_str)=@_;
	logger(" $cmd_str\n");
	system($cmd_str);
	if($?>>8 ne 0)
	{
		my_die(" \n");
	}
}


sub my_die($)
{
	(my $log_str)=@_;
	$log_str="".$log_str;
	logger($log_str);
	die($log_str);
}

sub logger($)
{
	(my $log_str)=@_;
	open(FILE, ">> /tmp/all.log") or warn("open all.log error\n");
	print $log_str;
	print FILE $log_str;
	close(FILE);
}


sub download_cmd()
{
print <<EOF
wget http://192.168.100.43/K%3A/sdb1/software_ext_iso/gentoo_portage_ISO_24_iso.iso -O gentoo_portage_ISO_24_iso.iso
wget http://localhost:8888/K%3A/sdb1/software_ext_iso/gentoo_portage_ISO_24_iso.iso -O gentoo_portage_ISO_24_iso.iso

wget --http-user root  --http-passwd  passwd   http://192.168.1.14/C%3A/Users/Administrator/Desktop/pydot-1.0.23.chm
EOF
;
}
