#!/usr/bin/perl
use Data::Dumper;
#use strict;
use Cwd;
use Cwd 'abs_path';
use Switch;
use File::Basename;
use File::Spec;
use File::Temp qw/ tempdir /;


if ($#ARGV == -1 or $ARGV[0] =~ /-help/) 
{
  print "usage: ";
  print basename $0 . " ARCHIVE_FILE\n";
  print "If you have the necessary extract program installed, it should work for\n";
  print "7-zip, CAB (Micro\$soft and installshield), CPIO, LHa, ACE, RAR, ARJ, and TAR files\n";
  print "See http://pturing.firehead.org/software/archery/recommended_support_programs.txt \n";
  print "for suggested programs to install for each file format\n\n";
  exit;
}




########################################################################
sub logger_simplest($)
{
	(my $log_str)=@_;
	open(FILE, ">> all.log") or warn("open all.log error\n");
	print FILE $log_str;
	close(FILE);
}

########################################################################
#determine a command to extract the file. exit if we can't figure one out
#根据 /bin/file 返回的字符串 来决定最后 最后的解压的命令.
sub get_extract_command($)
{
	#my($type) = $_[0];
	my($type) = $@;;
	my($test) = '';
	switch($type) 
	{
		case /^Zip/ 
		{
			$test = `unzip -v`;
			if ($test =~ /UnZip/) 
			{
				return 'unzip';
			}
		}
		case /Microsoft Cabinet archive/ 
		{
			$test = `cabextract --version`;
			if ($test =~ /cabextract/) 
			{
			return 'cabextract';
			}      
		}
		case /7-zip archive/ 
		{
			$test = `7z | head -n 2 | tail -n 1`;
			if ($test =~ /7-Zip/) 
			{
			return '7z x';
			}      
		}
		case /InstallShield CAB/ 
		{
			$test = `unshield -V`;
			if ($test =~ /Unshield/) 
			{
			return 'unshield x';
			}      
		}
		case /cpio/ 
		{
			$test = `cpio --version`;
			if ($test =~ /cpio/) 
			{
				return 'cpio -iv <';
			}      
		}
		case /^LHa/ 
		{
			#My copy of lha outputs its version and help info to stderr
			$test = `lha --version 2>&1`;
			if ($test =~ /LHa/) 
			{
				return 'lha x';
			}
		}
		case /^ARJ/ 
		{
			$test = `unarj`;
			if ($test =~ /UNARJ/) 
			{
				return 'unarj x';
			}      
		}
		case /^ACE/ 
		{
			#Try for the non-free unace first
			$test = `/opt/bin/unace | head -n 2 | tail -n 1`;
			if ($test =~ /UNACE/) 
			{
				return '/opt/bin/unace x';
			}
			$test = `unace`;
			if ($test =~ /UNACE/) 
			{
				return 'unace x';
			}      
			$test = `unace-free`;
			if ($test =~ /UNACE/) 
			{
				return 'unace-free x';
			}
		}
		case /^RAR/ 
		{
			#My copy of unrar prints a blank line first
			$test = `unrar --help | head -n 2 | tail -n 1`;
			if ($test =~ /UNRAR/) 
			{
				return 'unrar x';
			}
			#Maybe someone else has a sane copy that doesn't
			$test = `unrar --help`;
			if ($test =~ /UNRAR/) 
			{
				return 'unrar x';
			}      
			$test = `rar --help | head -n 2 | tail -n 1`;
			if ($test =~ /RAR/) 
			{
				return 'rar x';
			}      
			$test = `rar --help`;
			if ($test =~ /RAR/) 
			{
				return 'rar x';
			}      
		}
		# Really I should use recursion on this function when encountering .bz2 or .gz files
		# and I should test for the presence of tar
		# but anyone that doesn't have tar or is dealing with a .zip.bz2 file is clearly insane
		case /^bzip2 compressed data/ 
		{
		  return 'tar xjf';
		}
		case /^gzip compressed data/ 
		{
		  return 'tar xzf';
		}
		case /tar archive/ 
		{
		  return 'tar xf';
		}
		else 
		{
		  print "type not supported - $type\n";
		  exit;
		}
	}
	print "No program found for type $type\n";
	exit;
}


########################################################################
#mainloop
my $file = $ARGV[0];
my $basename = basename($file);
my $fullpath = abs_path($file);
my $orig_dir = getcwd();
my $type = `file -b \"$file\"`;
my ($in, $out) = '';


#FIXME: print extract command output on failure
#extract the archive to a temporary directory
my($cmd) = get_extract_command($type) . " \"$fullpath\"";
my($tempdir) = tempdir('archery_XXXXXXX');
chdir($tempdir);
#print "ALL_CMD =>".$cmd."\n";
logger(" $fullpath 对应的解压命令是 $cmd\n");


my($result) = `$cmd`;
chdir('..');
opendir(DIR, $tempdir);
my(@extracted) = readdir(DIR);
closedir DIR;
#Dumper(@extracted);
#sort @extracted;
print "#################\n";
for  ( @extracted)
{
	print $_;
}
print "##################\n";
#this should be updated to keep trying to find a new name when the one we want is taken
if ($#extracted > 2) 
{
  $in = $tempdir;
  if (-e $basename) { $out = $basename."_extracted"; }
  else { $out = $basename; }
} 
else 
{
	for $each (@extracted)
	{ 
		chomp;
		if($each=~/^\.$|^\.\.$/)
		{
			print "FFF".$each."\n";
		}
		else
		{
			$temp_dir=$each;
			print "BBB".$each."\n";
		}
	}
	print "DDD->".$temp_dir."\n";
	$in = $tempdir."/".$temp_dir;
	if (-e $temp_dir) 
	{
		$out = $temp_dir . "_extracted";
	} 
	else 
	{
		$out = $temp_dir;
	}
}

print "mv  ".$in."          ".$out."\n";
`mv \"$in\" \"$out\"`;
`tar -czf \"$out\".tar.gz \"$out\"`;
my($out_type) = `file -b \"$out\"`;
chomp($out_type);
print "extracted to $out ($out_type)\n";
rmdir($tempdir);
