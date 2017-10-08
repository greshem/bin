#!/usr/bin/perl
common_usage();
sub qemu_snapshot()
{
	print "qemu-img create -b  input.img  -f qcow2  output.img           \n";
}
sub common_usage()
{
	print <<EOF
#next3
#lvm 
#openiscsi
#rsnapshot  
#yum-plugin-fs-snapshot.noarch  
#unionfs
#==========================================================================
#qemu 
qemu-img create 	-b  input.img  -f qcow2  output.img           #

#==========================================================================
qemu-img snapshot  	-c  snapshot_name   input.img #create 
qemu-img snapshot   -a  snapshot_name	input.img #applies a snapshot (revert to saved state)
qemu-img snapshot   -d  snapshot_name  	input.img 							#deletes a snapshot
qemu-img snapshot   -l  input.img 					#lists 


EOF
}


