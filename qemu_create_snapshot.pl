#!/usr/bin/perl 
#2012_04_15_12:14:51   星期日   add by greshem
#根据母盘生成一个子盘
#use strict;
#use warnings;


$input_name=shift or  die("$0 input.img  output_name  \n");
$output_name=shift or die("$0 input.img  output_name  \n");
if(! -f $input_name)
{
	die("$input_name  not exists \n")
}

if($output_name!~/img$/)
{
	$output_name.=".img";
}

if ( -f $output_name )
{
	die $output_name." Have created \n";
} 

print <<EOF
#==========================================================================
#qemu 
qemu-img create  -b  $input_name  -f qcow2  $output_name

#==========================================================================
qemu-img snapshot   -c  snapshot_name   $input_name 	#create 
qemu-img snapshot   -a  snapshot_name 	$input_name 	#applies a snapshot (revert to saved state)
qemu-img snapshot   -d  snapshot_name   $input_name     #deletes a snapshot
qemu-img snapshot   -l  				$input_name     #lists 
EOF
;

sub glob_and_deal()
{
	#@imgs=`find /var/lib/libvirt/images/ |grep img\$`;
	@imgs=`find ./ |grep img\$`;

	for (@imgs)
	{
		chomp($_);
		#print $_."\n";

		print "qemu-img create 	-b  $_  -f qcow2  $output_name \n";
	}
}

__DATA__
#==========================================================================
#qemu 
qemu-img create  -b  input.img  -f qcow2  output.img           #

#==========================================================================
qemu-img snapshot   -c  snapshot_name   input.img #create 
qemu-img snapshot   -a  snapshot_name input.img #applies a snapshot (revert to saved state)
qemu-img snapshot   -d  snapshot_name   input.img              #deletes a snapshot
qemu-img snapshot   -l  input.img             #lists 
