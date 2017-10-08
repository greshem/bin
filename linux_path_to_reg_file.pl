#!/usr/bin/perl 
#use strict;
#use warnings;

use File::Basename;
print basename("/root/linux/bbb"); 

%name=(
"default"=>"HKEY_CURRENT_USER",
"software"=>"HKEY_LOCAL_MACHINE",
);
use Cwd;
my $pwd=getcwd();
print $pwd."\n";;
#"/root/develop_reg_register/data/default/Environment"

if($pwd=~/.*\/(default|software)(.*)/)
{
	$prefix=$1;
	$prefix=$name{$prefix};
	$append=$2;
	$key=$prefix."/".$append;
	$key=~s/\//\\/g;
	print $key;
	$output_name=basename($pwd);
	put_to_file($output_name, $key);
}
else
{
	print "not match \n";
}

sub put_to_file($$)
{
	(my $name, $key)=@_;
	$key=~s/\\\\/\\/g;
	open(FILE, ">".$name.".reg") or die("create output file error $!, $name.reg\n");
	print FILE "REGEDIT4\n\n";


	print FILE "[".$key."]\n";;
	close(FILE);
	#print "__VALUE__ append to $name.reg \n";
	system("cat __VALUE__ >> \"$name.reg\" ");
}


