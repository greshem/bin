#!/usr/bin/perl
#use strict;
use File::Basename;
use List::MoreUtils qw();
use Cwd;
 
our $g_pwd=getcwd();


our $g_inFile=shift or die("Usage: input\n");
if( -d $g_inFile )
{
	$g_inFile.="/";
}
logger("########################################################################\n");
print "$g_pwdĿ¼: ��ʼͳ�� ���� ".$g_inFile."�Ŀ������� \n";
logger("$g_pwdĿ¼: ��ʼͳ�� ���� ".$g_inFile."�Ŀ������� \n");

my %static= genSuffixHash($g_inFile);

if(scalar(keys(%static) eq 0))
{
	logger("����: [$g_pwd|$g_inFile]  û���ҵ��κ�Դ���ļ�\n");
	logger_lang("ERROR");
	die("����: [$g_pwd|$g_inFile]  û���ҵ��κ�Դ���ļ�\n");
}
stat_dev_lang_from_hash(%static);


########################################################################
#ȥ���Ǵ����ļ�������,Ϊ0.�ڴ���С��������ų�,HTML����ɵ�ӡ��.
#20100126
#ΪʲôҪ��0�� ��Ϊ ԭ���Ĵ���� .ogg�Ȼ���Ҫռ�� �ļ�
#��������� 99��OGG�ļ��� һ��CPP�ļ��� һ����Ϊ����� CPP���Եģ� �����������Ϊ�� ���������ˡ� 
sub stat_dev_lang_from_hash(%)
{

my %static; my $total; 
my $total_c; my $total_php; my $total_perl; my $total_python; my $total_java; 
my $total_ruby; my $total_tcl; my $total_bash; my $total_other; 
my %g_return_val=("error"=>0,
		"c"=>1,
		"cpp"=>2,
		"php"=>3,
		"perl"=>4,
		"python"=>5,
		"java"=>6,
		"ruby"=>7,
		"tcl"=>8,
		"bash"=>9,
		"other"=>10,
		"csharp"=>11,
		"javascript"=>12,
		);
my $total_csharp;
my $total_javascript;

my $g_total_prog={"error"=>0,
		"c"=>0,
		"cpp"=>0,
		"php"=>0,
		"perl"=>0,
		"python"=>0,
		"java"=>0,
		"ruby"=>0,
		"tcl"=>0,
		"bash"=>0,
		"other"=>0,
		"csharp"=>0,
		"javascript"=>0,
		};

	(my %static)=@_;
	for $each (keys %static)
	{
		if($each=~/\.o|\.xpm|\.ppm|\.ogg|\.pdf|\.tex|\.tif|\.am|\.man|\.xsl|\.xml|\.in|\.txt|\.sln|\.png|\.tif|\.html|\.jpg|\.gif|\.m4|\.po|\.gmo|\.svn-base$/)
		{	
		#	print $static{$each};
			$static{$each}=0;
		}
	}

	for $each (keys %static)
	{
		$total=$total+$static{$each};
		$each=lc($each);
		if( $each=~/\.c$|\.h$/)
		{
		#	print "CC=>".$each;
			$total_c=$total_c+$static{$each};
			$g_total_prog{"c"}=$total_c
		}
		elsif ($each=~/\.cc|\.hpp|\.cpp|\.hh|\.cxx|\.hxx/)
		{
		#	print "CC=>".$each;
			$total_cpp=$total_cpp+$static{$each};
			$g_total_prog{"cpp"}=$total_cpp;
		}
		elsif ($each=~/\.py/)
		{
			$total_python=$total_python+$static{$each};
			$g_total_prog{"python"}=$total_python;
		
		}
		elsif ($each=~/\.php/)
		{
			$total_php=$total_php+$static{$each};
			$g_total_prog{"php"}=$total_php;
		
		}elsif ($each=~/\.java|\.jsp|\.jar/)
		{
			#print "DEBUG ".$each."-->".$static{$each};
			$total_java=$total_java+$static{$each};

			$g_total_prog{"java"}=$total_java;
		
		}elsif ($each=~/\.pl|\.pm|\.cgi/)
		{
			$total_perl=$total_perl+$static{$each};
			$g_total_prog{"perl"}=$total_perl;
		
		}elsif ($each=~/\.rb|\.ruby/)
		{
			$total_ruby=$total_ruby+$static{$each};
			$g_total_prog{"ruby"}=$total_ruby;
		
		}elsif ($each=~/\.tcl|\.tk/)
		{
			$total_tcl=$total_tcl+$static{$each};
			$g_total_prog{"tcl"}=$total_tcl;
		
		}elsif ($each=~/\.sh|\.shell/)
		{
			$total_bash=$total_bash+$static{$each};
			$g_total_prog{"bash"}=$total_bash;
		
		}
		elsif ($each=~/\.cs/)
		{
			$total_csharp=$total_csharp+$static{$each};
			$g_total_prog{"csharp"}=$total_csharp;
		}
		elsif ($each=~/\.js/)
		{
			$total_javascript=$total_javascript+$static{$each};
			$g_total_prog{"javascript"}=$total_javascript;
		}
		else
		{	
		#	print "OTHER".$each."->".$static{$each};
			$total_other=$total_other+$static{$each};
			$g_total_prog{"other"}=$total_other;
		}	



	}

	logger( $total."\n");
	logger( "c_cpp_pecent\t".int($total_c*100/$total)."\n");
	logger( "java_pecent\t".int($total_java*100/$total)."\n");
	logger( "php_pecent\t".int($total_php*100/$total)."\n");
	logger( "python_pecent\t".int($total_python*100/$total)."\n");
	logger( "perl_pecent\t".int($total_perl*100/$total)."\n");
	logger( "other_pecent\t".int($total_other*100/$total)."\n");
	logger( "+++++++++++++++++++++++++++++++++++++++++++++++++\n");
	for $each (keys %g_total_prog)
	{	
		if($max< $g_total_prog{$each})
		{
			$max=$g_total_prog{$each};
			$max_lang=$each;
		}
		#print $each."=>".$g_total_prog{$each}."\n";
		$g_total_prog{$each}=$total_prog{$each}*100/$total;	
		#print "percent ".$each."   ".int($g_total_prog{$each})."\n";
	#	if( $g_total_prog{$each}>=50)
	#	{print $each;
	#	 exit 0;
	#	}
	#	exit -1;
	}

		print "RESULT=>".$max_lang."\n";
		logger("���������:  RESULT=> [$max_lang]\n");
		logger_lang($max_lang);
		exit $g_return_val{$max_lang};
}

############
##autoconf �ļ��ų��б� 
#autoconf ������ļ������� 
###########
sub IsInExcludePatten($)
{
	our @exclude=qw(Makefile Makefile.in config.status config.guess config.log configure.in configure config.sub config.in.old  README  svn-base 
\.class \.html \.png \.gif \.css  \.htm  \.diff \.patch \.cron \.log  \.txt \.ogg \.spec \.xml \.in \.dat
\.pdf \.pam \.jpg \.ogg \.sec \.desktop  
\.patch \.spec \.tar.gz \.tar.bz2 diff xml \.txt \.conf \.desktop 
\.zip \.tgz \.sig \.sign \.init \.diff \.in \.sysconfig \.pdf \.pam \.png \.jpg \.ogg \.asc \.scm \.sec \.el \.Z 
\.md5 \.map  \.3
); 
	(my $in)= @_;
	for $pattern (@exclude)
	{
		if($in =~/$pattern$/)
		{
			return 1;
		}
	}	
	return undef;
}

#ֻ��ע��ĺ�׺���Ž���ͳ��.
sub IsInIncludePattern($)
{
	our @exclude=qw(
	\.sh 
	\.cpp \.cxx  \.c \.cc  
	\.hh  \.hpp \.h \.hxx
	\.rb \.ruby 
	\.pl \.pm  \.cgi
	\.python \.py  
	\.scm 
	\.el
	\.cs  \.asp \.aspx 
	\.java 
	\.php
	\.bas \.vb \.vb6
	\.asm
	\.pas 	
	\.R \.r
	\.js
	\.hs 
	); 
	(my $in)= @_;
	for $pattern (@exclude)
	{
		if($in =~/$pattern$/)
		{
			return 1;
		}
	}	
	return undef;
}

############
# ��targz �ļ� ����� �ļ� ��׺���ָ���, ��󷵻�  hasn 
#���� ����: 
# .cpp-> 33
# .pl -> 100
# .hh -> 1 
# ��׺��-> ������ 
# ������hash. 
##########
sub genSuffixHash($)
{
	(my $input) =@_;

	my @lines= get_content_array($input);
	my %suffix;
	my %statSuffix;
	for(@lines)
	{
		next if(/\/$/) ; ;# Ŀ¼������ 
		$_=basename($_);
		next if( IsInExcludePatten($_)); 
		next if( ! IsInIncludePattern($_));
		if(/(.*)(\..*)/)
		{
			$suffix{$_}=$2;
		}
	}
	for(values %suffix)
	{
		$statSuffix{$_}++; #��׺�����ָ���.
	}

	@sortKeys=sort { $statSuffix{$b}<=> $statSuffix{$a}} (keys %statSuffix);
	my $each;
	for  $each (@sortKeys)
	{
		logger( "��".$each."��׺���ļ���: ".$statSuffix{$each}." ��\n");
	}

	return %statSuffix;
}

#������ tar.gz  ��ȡ�ļ��б�.
#���� tar.bz2
#����Ŀ¼:     ��ȡ�ļ��б�.
#��ȡ�ļ��б�����
sub get_content_array($)
{
	(my $input)=@_;
	my @ret_line;
	if( -d $input) 
	{
		$tmp=`find $input`;
		@ret_line= split(/\n/, $tmp);
	}
	elsif($input=~/tar.gz$/ && -f $input)
	{
		my $tmp=`tar -tzf $input `;
		@ret_line= split(/\n/, $tmp);
	}
	elsif($input=~/tar.bz2$/ && -f $input)
	{
		my $tmp=`tar -tjf $input`;
		@ret_line= split(/\n/, $tmp);
	}
	else  
	{
		logger("��֧�ֵ�ѹ����ʽ, �޷������������ ��ȡ �����ļ��б�\n");
		return undef;	
	}
	return @ret_line;
}


#��򵥵�.
sub logger($)
{
	(my $log_str)=@_;
	open(FILE, ">> judge_dev_lang.log") or warn("open all.log error\n");
	print FILE $log_str;
	close(FILE);
}

sub logger_lang($)
{
	(my $lang)=@_;
	my $file= "/var/log/dev_lang_".$lang.".log";
	open(LOG,">>".$file )  or warn("����$file ����\n");

	print LOG $g_pwd."/".$g_inFile."\n";;	
	close(LOG);
}
