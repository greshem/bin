#!/usr/bin/perl 
#�ŵ� /tmp3/sf_mirror Ŀ¼ִ�У� ��ʵ����Ҳ���ԣ� ����ִ�����ֱ������һ������������֡� 
##��
#�ȴ�������������֣� Ȼ���ٿ��Դ��� url , ֮��Ϳ��Ի�ȡ�� �ض��������URL�ˡ� 
#20100513
#��������������� url �����ǣ� Ŀ�����ȣ� ��102�������ơ� 
#20100518
#���getopt ����ȫ�ֵ����ݻ�ȡ��������һ�㡣 
# �������������  ./  ��ʱ�� ���һ������ƥ�䣬 ����һ����֮Ŀ¼, ����ˡ� 
#12:00 
#�޸�ͨ�����������ķ�ʽ�� ���ڿ���֧�֣� ���޵ݹ��ˡ� 
#2010514 
#ȥ���˵�����Ϣ�� 
use Getopt::Std;
use HTML::LinkExtractor;
use LWP::Simple qw( get );
use LWP::UserAgent; 
#use List::Util qw(uniq);
use List::MoreUtils qw(uniq);
use List::Util qw(shuffle);
use Encode;    # qw(from_to encode decode );
#use strict;
#Ĭ����� 15�� һ�㶼�㹻����
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

#http://www.mirrorservice.org/.... ����Ҳ�Ѿ��� 9 ��/ �ַ��ˡ� 
#our $root_url="http://ftp.gnome.org/pub/gnome/sources/ ";
our $root_url=shift or die("Usage $0 root_url\n");
our $root_url_depth=scalar(split/\//, $root_url);

#���ݲ�ͬ�� ��ȿ��� �  ������ URL
our $max_depth=1;
our $depth=0;
our $depth=25;
#��������Ƿ� �Ѿ����ʹ��� 
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
#�����in ʲô������ ��Ϊ���ᾭ���淶�����̡� 
sub getUrlRoot($)
{
	my ($in)=@_;
	if( $in !~/^http/)
	{
		print STDERR  "���� http://��ͷ��url\n";
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
	#20100513, ���ﴦ��url =  "http://ftp.gnome.org/pub/gnome/sources/ ";
	#��ʱ�����ֿո� ����Ӧ�ı����Դ�ʩ�� �пյ�ʱ�� ���Բ�һ��Ϊʲô����ֿո� 
	$url=~s/\ //g;
	my $urlRoot=getUrlRoot($url);	
	
	print "Deal with ", $url,"\n";
	my @depth=split(/\//, $url);
	#	emule  ��ʽΪ e/em/  11 
	#   emule  ��ʽΪ e/em/emu/  12 ����ֵ�� 
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
			#��ֹͨ�� ../../ �ķ�ʽ�����ϼ� 
			next if($sub_url=~/\.\./);

		
			if($sub_url=~/^http/)
			{
				$urlCur=$sub_url;				
			}
			elsif($sub_url=~/^\//)
			{
				#��ȡ����URL��root url ������װ Ȼ���ڽ��� �ݹ顣 
				#print "����·�� ,  ��Ҫ��� UrlRoot\t",$sub_url,"\n";
				$urlCur=($urlRoot.$sub_url);
			}
			else
			{
				if($sub_url=~/^\.\//)
				{
					$sub_url=~s/^\.\///g; 
					print "./ ·���� ���ܻ���� ����һ��\n";
				}
				$urlCur=($url."/".$sub_url);
			}
		
				
			$urlCur=~s/\/\//\//g;
			$urlCur=~s/http:\//http:\/\//;
			print "urlCur\t", $urlCur,"\n";
			if($urlCur!~/$url/)
			{
					print $sub_url,"������ĿĿ¼ �� next\n";
						next;
			}

			
			#��Ŀ¼�� �ټ����ݹ�
			if($urlCur=~/\/$/)
			{
				#print $url.$sub_url,"\n";
				#@depth=split(/\//, $url.$sub_url);
				#20100518 ,������ķ�ʽ�����strstr����˼ . 
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

