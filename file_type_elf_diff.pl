#!/usr/bin/perl


#sub file_type_cmd_dum_lib()
for(glob("*.o"))
{
	my $line=$_;
	(my $name)=($line=~/(.*).o/i);	

		print <<EOF
		objdump -d  -S  $line |c++filt  > $line.demangle.asm
		readelf -S $line      |c++filt  > $line.demangle.readelf-S
		readelf -s $line      |c++filt  > $line.demangle.readelf-s
EOF
;
}

