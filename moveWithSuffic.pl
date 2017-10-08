#!/usr/bin/perl 

#20100707 添加 file_type 的目录， 用来存储其他格式的文件。 

#2010_07_26_20:20:27 add by qzj
#push(@INC, "/root/PerlQzjLib/");

use strict;
use filename_increase_copy;
use Cwd;
our $pwd=getcwd();
#print $pwd."\n";;



my %suffixDir=(
			"awk"=>"develop_awk/",
			"bat"=>"develop_bash/",
			"c"=>"develop_c/",
			"cc"=>"develop_cpp/",
			"cgi"=>"develop_cgi/",
			"class"=>"develop_java/",
			"conf"=>"develop_conf/",
			"cpp"=>"develop_cpp/",
			"css"=>"develop_css/",
			"gdb"=>"develop_gdb/",
			"h"=>"develop_c/",
			"f"=>"develop_fortran/",
			"hh"=>"develop_cpp/",
			"hpp"=>"develop_cpp/",
			"html"=>"develop_html/",
			"ini"=>"develop_conf/",
			"jar"=>"develop_java/",
			"java"=>"develop_java/",
			"js"=>"develop_javascript/",
			"lftp"=>"develop_lftp/",
			"lua"=>"develop_lua",
			"m"=>"develop_octave",
			"pcap"=>"pcap_packet/",
			"php"=>"develop_php/",
			"pl"=>"develop_perl/",
			"pov"=>"develop_povray/",
			"ps1"=>"develop_powershell/",
			"py"=>"develop_python/",
			"pyc"=>"develop_python/",
			"pyo"=>"develop_python/",
			"rb"=>"develop_ruby/",
			"rpm"=>"rpm_packages/",
			"reg"=>"develop_register/",
			"s"=>"develop_cpp/",
			"sh"=>"develop_bash/",
			"sql"=>"develop_sql/",
			"tcl"=>"develop_tcl/",
			"tdy"=>"develop_perl/",
			"txt"=>"develop_txt/",
			"vim"=>"develop_vim/",
			#"gz"=>"_sync_tar_gz/",
		"file_type"=>"file_type/"

);
			
for my $each (values %suffixDir)
{
#	mkdir($each);
}
			
for(<*>)
{
	if(-f $_) 
	{
		my $suffix=getSuffix($_);
		if(defined $suffix)
		{
#			print $_," --> ", $suffix ,"\n";	
			#有根据后缀得出的 toDir 目录. 
			if($suffixDir{$suffix})
			{
				if( ! -d  $suffixDir{$suffix})
				{
					mkdir( $suffixDir{$suffix});
				}
				#print "mv ",  $_, "\t", ,"/root/",filename_increase_copy($suffixDir{$suffix}."/".$_),"\n";
				print "mv ",  $_, "\t", ,"./",filename_increase_copy($suffixDir{$suffix}."/".$_),"\n";
			}
			elsif( $suffix =~/gz/)
			{
				if($pwd=~/tmp2\/root_data/)
				{
					print "mv ",$_," linux_src/\n";
				}
				else
				{
					print "# \t", $_, " SKIP \n";
				}
				
			}
			else
			{
				print "mv ",  $_, "\t", "file_type", "\t", ,"\n";
			}
		
		}
		else
		{
	#		print $_," 无法分类\n";
			
		}
	}
}
sub getSuffix($)
{
	(my $in)=@_;
	if($in=~/\./)
	{
		my @array=split(/\./, $in);
		return $array[scalar(@array)-1];	
	}
	else
	{
		return undef;
	}
}
