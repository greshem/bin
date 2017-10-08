#!/usr/bin/perl
#use strict;
use DBI;
my $host='localhost';
my $port='3306';
my $user="root";
my $passwd='q**************n';
my $dsn="dbi:mysql:hostname=$host:port=$port:";

my $dbh= DBI->connect($dsn,$user,$passwd);
my %database;
unless ($dbh)
{
        die "Connect error!\n";
}
my $sql="show databases";
my $sth= $dbh->prepare("$sql");
$sth->execute;
#�������е�database
while (my @row=$sth->fetchrow_array())
{
		print $row[0],"\n";
        $dbh->do("use $row[0]");
		$database{$row[0]}=[];
       
		
		my $show_table="show tables";
        my $sth_table= $dbh->prepare("$show_table");
        $sth_table->execute;

		# �����������еı� 
        while ( my @rr = $sth_table->fetchrow_array())
        {
			# print "mysqldump --opt $row[0] $rr[0]>$row[0]_$rr[0].sql.gz\n";
			print "\t", $rr[0],"\n";
			push @{$database{$row[0]}}, $rr[0];
			
			#��ӡ���е��ֶΡ� 
			#if($show_fields)
			{		
				my $tth_table=$dbh->prepare("describe $rr[0]");
				$tth_table->execute;
				my @fields=();
				#  ���� �������е��ֶΡ� 
				while( my @array= $tth_table->fetchrow_array())
				{
					print "\t\t", $array[0],"\n";
					#push(@fields, $array[0]);
				}
				
			}
		
        }
}
$dbh->disconnect();



