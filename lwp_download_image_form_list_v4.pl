#!/usr/bin/perl

#@files=@ARGV or die("Usage: $0 file1 file2 file3 \n");
use SDBM_File;
use File::Copy::Recursive qw(pathmk);

use Fcntl;
use LWP::UserAgent;
use File::Basename;
my $ua=new LWP::UserAgent;
$ua->timeout(10);
%download_his;
tie %download_his , "SDBM_File", "download_his.dat", O_CREAT|O_RDWR, 0666
	or die("tie error $! \n");

@countrys = mk_country_dir();

#while(1)
{
	$hour=(localtime(time()))[2];
#	if( $hour>=8 && $hour<=16)
	if( 0)
	{
		print " not in work time 上班时间， 应该要休息\n";
		sleep 10;
		#last;
		next;
	}
	srand(time() );
	for (sort { rand 2>1?-1:1} @countrys)
	{
		print "======> $_\n";
		sleep 4;
		download_one_country($_, \%download_his);
	}
}
sub mk_country_dir()
{
	opendir(DIR, ".");
	my @country=grep { -f && /[A-Z]{3,5}/} readdir(DIR);
	for (@country)
	{
		mkdir ($_."_img") if (! -d $_."_img");
	}
	
	return @country;
}



#传入 国家 以及 所有url 是否下载过的hash 表。 
sub download_one_country($, $)
{
	(my $country, my $download_his)=@_;

	open(FILE, $country) or die("open file error\n");
#	open(FILE, "rl $country |" ) or die("open file $countey error\n");
	while(<FILE>)
	{
		next if(/perl-5.8./);
		if(/(\S+)\s+(\S+)/)
		{
			$url=$1;
			$to_dir=$2;
			$to_file=basename $1;
			#if(!$download_his{$url} && ! -f $country."_img/".$to_dir."/".$to_file) 
			if( ! -f $country."_img/".$to_dir."/".$to_file) 
			{
				print $_;
				
				my ($a,  $len, $b, $c, $d)= $ua->head($url) or warn "error $!\n";
				if($a->{_headers}->{'content-length'}>1024*1024*10 || ! $a->{_headers}->{'content-length'} )
				{
					print "$url > 10M; skip \n";
					$download_his{$url}=">10M or head erro";
					#next;
				}
				print "\t\t Length: ",$a->{_headers}->{'content-length'}/1024,"K\n";
				$response=$ua->get($url);
				if($response->is_success)
				{
					#mkdir($country."_img/".$to_dir) if(! -d $country."_img/".$to_dir) ;
					pathmk($country."_img/".$to_dir) if(! -d $country."_img/".$to_dir) ;
					#pathmk(
					open(JPG, ">".$country."_img/".$to_dir."/".$to_file);
					print JPG $response->content;
					close(JPG);
					$download_his{$url}="OK";
				}
				else
				{
					$download_his{$url}.="NO $response ->code";
					print "Download error\n ";
				}
			}
			else
			{
				print $url, "  have download or already exists\n";
				$download_his{$url}="ALREADY exist"
			}
				
		}
	}
}
