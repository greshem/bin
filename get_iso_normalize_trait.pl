#!/usr/bin/perl
my $iso=shift or die("Usage: $0  input.iso \n");

system(" mount -t iso9660 $iso  dir -o loop \n");

my @array=`find dir |grep kernel `;

print "\'$iso\' => \n";

print "[\n";
for(@array)
{
	chomp;
	$_=~s/dir\///;
	print "\'$_\',\n";
}

print "],\n";

system("umount dir");
