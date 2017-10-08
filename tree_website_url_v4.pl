#!/usr/bin/perl 
#·Åµ½ /tmp3/sf_mirror Ä¿Â¼Ö´ĞĞ£¬ ÆäÊµ²»·ÅÒ²¿ÉÒÔ£¬ µ¥¶ÀÖ´ĞĞ×îºÃÖ±½ÓÊäÈëÒ»¸öÈí¼ş°üµÄÃû×Ö¡£ 
##£º
#ÏÈ´«ÈëÈí¼ş°üµÄÃû×Ö£¬ È»ºóÔÙ¿ÉÒÔ´«Èë url , Ö®ºó¾Í¿ÉÒÔ»ñÈ¡£¬ ÌØ¶¨Èí¼ş°üµÄURLÁË¡£ 
#20100513
#ÕâÀïµÄÁ½¸ö²ÎÊıÊÇ url »¹ÓĞÊÇ£¬ Ä¿±êµÄÉî¶È£¬ ÓÉ102ĞĞÀ´¿ØÖÆ¡£ 
#20100518
#Ìí¼Ógetopt ÕâÑùÈ«¾ÖµÄÊı¾İ»ñÈ¡ÆğÀ´·½±ãÒ»µã¡£ 
# »¹´æÔÚÕâÖÖÇé¿ö  ./  µÄÊ±ºò£¬ Õâ¸öÒ»¶¨²»»áÆ¥Åä£¬ µ«ÊÇÒ»¶¨ÊÇÖ®Ä¿Â¼, ½â¾öÁË¡£ 
#12:00 
#ĞŞ¸ÄÍ¨¹ıÉî¶ÈÀ´Àú±éµÄ·½Ê½£¬ ÏÖÔÚ¿ÉÒÔÖ§³Ö£¬ ÎŞÏŞµİ¹éÁË¡£ 
#2010514 
#È¥µôÁËµ÷ÊÔĞÅÏ¢¡£ 
use Getopt::Std;
use HTML::LinkExtractor;
use LWP::Simple qw( get );
use LWP::UserAgent; 
#use List::Util qw(uniq);
use List::MoreUtils qw(uniq);
use List::Util qw(shuffle);
use Encode;    # qw(from_to encode decode );
#use strict;
#Ä¬ÈÏÉî¶È 15£¬ Ò»°ã¶¼×ã¹»ÓÃÁË
%opts;
getopts("d:h", \%opts);
if($opts{'h'})
{
	print "$0","-d depth ", "\t -h help\n";
	exit(0);
}
if( $opts{'d'})
{
	$depth=$opts{'d'};	
}

#http://www.mirrorservice.org/.... ÕâÀïÒ²ÒÑ¾­ÓĞ 9 ¸ö/ ×Ö·ûÁË¡£ 
#our $root_url="http://ftp.gnome.org/pub/gnome/sources/ ";
our $root_url=shift or die("Usage $0 root_url\n");
our $root_url_depth=scalar(split/\//, $root_url);

#¸ù¾İ²»Í¬µÄ Éî¶È¿ÉÒÔ Í  ÊıÁ¿µÄ URL
our $max_depth=1;
our $depth=0;
our $depth=25;
#Õâ¸öÁ¬½ÓÊÇ·ñ ÒÑ¾­·ÃÎÊ¹ı£¿ 
our %link;
our $ua= new LWP::UserAgent;
our $response;
our @array_url=();
our $LOGFILE;
my $package;

$ua->timeout(40);
open($LOGFILE,">>all_targz_file.list"); 
#print getWebRoot("http://www.baidu.com/aaaa/aaa/aaa");
#exit(0);
get_urls($root_url);

close($LOGFILE);
###############################################################
#ÕâÀïµÄin Ê²Ã´¶¼¿ÉÒÔ ÒòÎª¶¼»á¾­¹ı¹æ·¶»¯¹ı³Ì¡£ 
sub getUrlRoot($)
{
	my ($in)=@_;
	if( $in !~/^http/)
	{
		print STDERR  "²»ÊÇ http://¿ªÍ·µÄurl\n";
	}
	@array=split(/\//, $in);
	return "http://".$array[2];
}

sub  get_urls($)
{
	my ($in)=@_;
	my ($package);
	my $url;
	my $urlCur;
	my $html;
	$url= $in;
	#20100513, ÕâÀï´¦Àíurl =  "http://ftp.gnome.org/pub/gnome/sources/ ";
	#µÄÊ±ºò»á³öÏÖ¿Õ¸ñ£¬ ×ö¶ÔÓ¦µÄ±£»¤ĞÔ´ëÊ©¡£ ÓĞ¿ÕµÄÊ±ºò£¬ ¿ÉÒÔ²éÒ»ÏÂÎªÊ²Ã´»á³öÏÖ¿Õ¸ñ¡£ 
	$url=~s/\ //g;
	my $urlRoot=getUrlRoot($url);	
	
	print "Deal with ", $url,"\n";
	my @depth=split(/\//, $url);
	#	emule  ĞÎÊ½Îª e/em/  11 
	#   emule  ĞÎÊ½Îª e/em/emu/  12 µÄÊıÖµ¡£ 
	my $package;

	if( $link{$url} )
	{
		#print " have visit already  $url\n";
		return;
	}
	else
	{
	$link{$url}=1;
	}

	 $response = $ua->get($url);
	if($response->is_success)
	{
		$html=$response->content();	
		#logger("OK: url $url \n");
	}
	else
	{
		#logger(" Error: $url \n"); 
		return ;
	}

	my	$LX   = new HTML::LinkExtractor();
	my $sub_url;
	$LX->parse( \$html );

	#print qq{<base href="$base">\n};
	#@tmp_url=grep { $_->{href}=~/^\d} @{$LX-links}
	#for  $_ ( shuffle  @{ $LX->links } ) 
	for  $_ (   @{ $LX->links } ) 
	{
			$sub_url=$_->{href};
			next if(!defined($sub_url));
			#·ÀÖ¹Í¨¹ı ../../ µÄ·½Ê½Ìøµ½ÉÏ¼¶ 
			next if($sub_url=~/\.\./);

		
			if($sub_url=~/^http/)
			{
				$urlCur=$sub_url;				
			}
			elsif($sub_url=~/^\//)
			{
				#»ñÈ¡ÊäÈëURLµÄroot url ½øĞĞ×é×° È»ºóÔÚ½øĞĞ µİ¹é¡£ 
				#print "¾ø¶ÔÂ·¾¶ ,  ĞèÒªÌí¼Ó UrlRoot\t",$sub_url,"\n";
				$urlCur=($urlRoot.$sub_url);
			}
			else
			{
				if($sub_url=~/^\.\//)
				{
					$sub_url=~s/^\.\///g; 
					print "./ Â·¾¶£¬ ¿ÉÄÜ»á³ö´í£¬ µ÷ÊÔÒ»ÏÂ\n";
				}
				$urlCur=($url."/".$sub_url);
			}
		
				
			$urlCur=~s/\/\//\//g;
			$urlCur=~s/http:\//http:\/\//;
			print "urlCur\t", $urlCur,"\n";
			if($urlCur!~/$url/)
			{
					print $sub_url,"²»ÊÇ×ÓÄ¿Ä¿Â¼ £¬ next\n";
						next;
			}

			
			#ÊÇÄ¿Â¼£¬ ÔÙ¼ÌĞøµİ¹é
			if($urlCur=~/\/$/)
			{
				#print $url.$sub_url,"\n";
				#@depth=split(/\//, $url.$sub_url);
				#20100518 ,ÓÃÕıÔòµÄ·½Ê½À´±í´ïstrstrµÄÒâË¼ . 
				#if($urlCur=~/$url/ )
				{
					get_urls($urlCur);
				}
			}	
			else
			{
				print "TARGZ: ",$urlCur,"\n";
				#push(@array_url, $url.$sub_url);
				#print $LOGFILE  $url.$sub_url,"\n" if($sub_url=~/tar.gz$|tar.bz2$/);
				#print  $url.$sub_url,"\n" ;#if($sub_url=~/tar.gz$|tar.bz2$/);
			}
	}

	$depth--;
}

