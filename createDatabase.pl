#!/usr/bin/perl -w

#use strict;
use DBI;
use File::Basename;
our $dbh;

#connect mydns
#use rr

#####
#��ѯ��

sub insertTorr($)
{
	my ($in)=@_;	
	$query="create database ".$in; 
	
	 $dbh = DBI->connect (
		#"dbi:mysql:database=huanqiuweb:host=localhost;mysql_emulated_prepare=0",
		"dbi:mysql:database=mydns:host=localhost;",
		"root", "q**************n",
		{ RaiseError => 1, PrintError => 0 },
		);

	##
	#step1. ���ݲ��롣 
	my $s_q = $dbh->prepare($query);
	   $s_q->execute()or die("error $!");

}

###################
#step2. ���ݲ鿴�� dump
sub showAllmydns_rr_record()
{
	#my $query="select * from rr limit 0 100 ;";
	my $query="select * from rr  ;";
	my $s_q=$dbh->prepare($query);
		$s_q->execute();
	while(my @data =$s_q->fetchrow_array())
	{
		print join("|", @data),"\n";
	}
	$s_q->finish();
}
	
foreach(@ARGV)
{
    insertTorr($_);
	print $_,"\n";
}
#showAllmydns_rr_record();
