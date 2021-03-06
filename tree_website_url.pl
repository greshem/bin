#!/usr/bin/perl 
#放到 /tmp3/sf_mirror 目录执行， 其实不放也可以， 单独执行最好直接输入一个软件包的名字。 
##：
#先传入软件包的名字， 然后再可以传入 url , 之后就可以获取， 特定软件包的URL了。 
#20100513
#这里的两个参数是 url 还有是， 目标的深度， 由102行来控制。 
#20100518
#添加getopt 这样全局的数据获取起来方便一点。 
# 还存在这种情况  ./  的时候， 这个一定不会匹配， 但是一定是之目录, 解决了。 
#12:00 
#修改通过深度来历遍的方式， 现在可以支持， 无限递归了。 
#2010514 
#去掉了调试信息。 
#20100518
#ftp://  的处理 -v 选项。 
use Getopt::Std;
use HTML::LinkExtractor;
use LWP::Simple qw( get );
use LWP::UserAgent; 
#use List::Util qw(uniq);
use List::MoreUtils qw(uniq);
use List::Util qw(shuffle);
use Encode;    # qw(from_to encode decode );
#use strict;
#默认深度 15， 一般都足够用了
%opts;
getopts("d:hv", \%opts);
if($opts{'h'})
{
	print "$0","-d depth ", "\t -h help\n";
	exit(0);
}
if( $opts{'d'})
{
	$depth=$opts{'d'};	
}

#http://www.mirrorservice.org/.... 这里也已经有 9 个/ 字符了。 
#our $root_url="http://ftp.gnome.org/pub/gnome/sources/ ";
our $root_url=shift or die("Usage $0 root_url\n");
our $root_url_depth=scalar(split/\//, $root_url);

#根据不同的 深度可以 �  数量的 URL
our $max_depth=1;
our $depth=0;
our $depth=25;
#这个连接是否 已经访问过？ 
our %link;
our $ua= new LWP::UserAgent;
our $response;
our @array_url=();
our $LOGFILE;
my $package;

$ua->timeout(40);
#open($LOGFILE,">>all_targz_file.list.log"); 
#print getWebRoot("http://www.baidu.com/aaaa/aaa/aaa");
#exit(0);
get_urls($root_url);

#close($LOGFILE);
###############################################################
#这里的in 什么都可以 因为都会经过规范化过程。 
sub getUrlRoot($)
{
	my ($in)=@_;
	if( $in !~/^http/)
	{
		print STDERR  "不是 http://开头的url\n";
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
	#20100513, 这里处理url =  "http://ftp.gnome.org/pub/gnome/sources/ ";
	#的时候会出现空格， 做对应的保护性措施。 有空的时候， 可以查一下为什么会出现空格。 
	$url=~s/\ //g;
	my $urlRoot=getUrlRoot($url);	
	
#	print "Deal with ", $url,"\n";
	my @depth=split(/\//, $url);
	#	emule  形式为 e/em/  11 
	#   emule  形式为 e/em/emu/  12 的数值。 
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
			#防止通过 ../../ 的方式跳到上级 
			next if($sub_url=~/\.\./);

		
			if($sub_url=~/^http/)
			{
				$urlCur=$sub_url;				
			}
			elsif($sub_url=~/^\//)
			{
				#获取输入URL的root url 进行组装 然后在进行 递归。 
				#print "绝对路径 ,  需要添加 UrlRoot\t",$sub_url,"\n";
				$urlCur=($urlRoot.$sub_url);
			}
			elsif($sub_url=~/^ftp/)
			{
				print $sub_url,"\n";
				next;	
			}
			else
			{
				if($sub_url=~/^\.\//)
				{
					$sub_url=~s/^\.\///g; 
					print "./ 路径， 可能会出错， 调试一下\n";
				}
				$urlCur=($url."/".$sub_url);
			}
		
				
			$urlCur=~s/\/\//\//g;
			$urlCur=~s/http:\//http:\/\//;
			$urlCur=~s/ftp:\//\nftp:\/\//;
			#print "urlCur\t", $urlCur,"\n";
			if($urlCur!~/$url/)
			{
#					print $sub_url,"不是子目目录 ， next\n";
						next;
			}

			
			#是目录， 再继续递归
			if($urlCur=~/\/$/)
			{
				#print $url.$sub_url,"\n";
				#@depth=split(/\//, $url.$sub_url);
				#20100518 ,用正则的方式来表达strstr的意思 . 
				#if($urlCur=~/$url/ )
				{
					get_urls($urlCur);
				}
			}	
			else
			{
				if($opts{'v'})
				{
					print "verbos\t",$urlCur."\n";
				}
				else
				{
					#去掉以]结尾的url
					if($urlCur=~/]\s*$/)
					{
					}
					elsif($urlCur=~/\/s*$/)
					{
					}
					else
					{
						print $urlCur."\n" ;
					}
				}
				#push(@array_url, $url.$sub_url);
				#print $LOGFILE  $url.$sub_url,"\n" if($sub_url=~/tar.gz$|tar.bz2$/);
				#print  $url.$sub_url,"\n" ;#if($sub_url=~/tar.gz$|tar.bz2$/);
			}
	}

	$depth--;
}

