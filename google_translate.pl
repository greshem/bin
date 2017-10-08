#!/usr/bin/perl 
#��¼ÿ�εĲ�ѯ�ĵ��ʣ����ӵ���˼��
#2011_02_24_14:38:59   ������   add by greshem
#�������Ŀ¼ ���˳���ִ�е�Ŀ¼�ˣ� ���˵� Ӣ�����ĵ�ת�� ���������Я���Ĳ�����.  
require LWP::UserAgent;
use Encode qw(from_to encode decode );
use URI::Escape;

my $verbose=undef;
my $force;
if(grep {/verbose/} @ARGV) 
{
	$verbose=1;
	die("verbose ");
}

if(grep {/force/} @ARGV) 
{
	$force=1;
}

$google_word= "/root/bin/google_word.pl";
if( ! -f $google_word) 
{
	$google_word= "/bin/google_word.pl";
}

$found=undef;
$tmp=shift or die("Usage: $0 word \n");
if( -f  $google_word)
{
	open(FILE, $google_word)or warn("open file error $!");
	foreach (<FILE>)
	{
		if(/$tmp/)
		{
			print $_;
			$found=1;
		}
	}
}
if($found)
{
	if( $force!=1)
	{
		exit(1);
	}
}
google_write_word($tmp."\t\t|");

#20100322 ע���� encode ��ʱ�� ��Ϊû�����ú������ UTF8λ�Ĺ�ϵ�� ���ǲ��ܵõ���ȷ�Ľ���� ��֪��Ϊʲô�� ��FROM_TO��OK�ˡ� 
#2010_08_27_15:39:46 add by greshem, �������򼯳ɵ���һ��en2zh  zh2en,  

my $word;
my $content;

###############################################################################
if(IsHanzhi($tmp))
{
	$word=$tmp;
	from_to($word, "gb2312", "utf8");
	$url=uri_escape($word);
	$from_lang="zh";
	$to_lang="en";
}
else
{
	$word=$tmp;
	$url=uri_escape($word);
	$from_lang="en";
	$to_lang="zh";

}

my $ua = LWP::UserAgent->new;
$ua->timeout(10);
$ua->env_proxy;

#print  $tmp,"->", $url,"\n";
$last_url='http://www.google.com/uds/Gtranslate?callback=google.language.callbacks.id101&context=4&q='.$url.'&langpair='.$from_lang.'%7C'.$to_lang.'&key=notsupplied&v=1.0'."\n";;
print STDERR $last_url;

my $response = $ua->get($last_url);
if ($response->is_success) 
{
	if($from_lang=~"/zh/")
	{
		$content= $response->content;  # or whatever
		print  STDERR $content;
	}
	#���صĴ������ĵģ� ��UTF8���룬 ��Ҫת����
	else
	{
		$content=	$response->content;
		from_to($content, "utf-8", "gb2312");
		print STDERR  $content;
	}
}
else 
{
	die $response->status_line;
}

################################################################################
#��󷵻ص��� ����ṹ���ַ�����
#google.language.callbacks.id101('4',{"translatedText":"China"}, 200, null, 200)
(undef, $en)=($content=~/.*(\".*?\").*\"(.*?)\".*/);

$en=~s/__/_/g;
print  $_ , "  ", $en,"\n";
google_write_word($en."\n");

###############################################################################
#print $response->decoded_content;  # or whatever
###############################################################################
#д���ļ�����
sub google_write_word($)
{
	($word)=@_;
	open(FILE, ">>".$google_word);
	print FILE $word;
	$atime = $mtime = time;
	utime $atime, $mtime, "/root/bin/";

	close(FILE);
	
}
###############################################################################
#�к����ַ���?
sub IsHanzhi($)
{
	(my $in)=@_;
	if( $in=~/.*([\x80-\xff]+).*/  )
	{
		return 1;	
	}
	else
	{
		return  0;
	}
}

