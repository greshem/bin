#!/usr/bin/perl 

#use strict;
#use warnings;

#==========================================================================
#load from access-control, all the svn project, which means than it have registed.
%hash;
open(FILE, "access-control") or die("access-control open file error $!, May not in the svn repo path \n");
for(<FILE>)
{
	if($_=~/\[(.*):.*\]/)
	{
		#print $1."\n";	
		$hash{$1}=1;
	}	
}
close(FILE);

#==========================================================================
#
for( grep {-d } glob("*"))
{
	#print $_."\n";;	
	if( $hash{$_})
	{
	}
	else
	{
		print "$_ not register in access-control \n";
		append_project($_);
	}
}

#==========================================================================
sub append_project($)
{
	(my $name)=@_;
	open(ACCESS, ">> access-control") or die("append to file error \n");
	print ACCESS <<EOF
[$name:/]
root=rw
greshem=rw
wenshuna=rw
huanghaibo=rw
gengerbin=rw

EOF
;

	
}
