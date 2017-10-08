#!/usr/bin/perl

#@files=@ARGV or die("Usage: $0 file1 file2 file3 \n");
use SDBM_File;
use Fcntl;
use LWP::UserAgent;
use File::Basename;
my $ua=new LWP::UserAgent;
$ua->timeout(10);
%download_his;
tie %download_his , "SDBM_File", "download_his.dat", O_CREAT|O_RDWR, 0666
	or die("tie error $! \n");

@countrys = mk_country_dir();

while(1)
{
	$hour=(localtime(time()))[2];
	if( $hour>=8 && $hour<=16)
	{
		print "上班时间， 应该要休息\n";
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
	while(<FILE>)
	{
		if(/(\S+)\s+(\S+)/)
		{
			$url=$1;
			$to_dir=$2;
			$to_file=basename $1;
			if(!$download_his{$url})
			{
				print $_;
				$response=$ua->get($url);
				if($response->is_success)
				{
					mkdir($country."_img/".$to_dir) if(! -d $country."_img/".$to_dir) ;
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
				print $url, "  have download \n";
			}
				
		}
	}
}
