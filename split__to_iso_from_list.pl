#! /usr/bin/perl -w
    eval 'exec /usr/bin/perl -S $0 ${1+"$@"}'
        if 0; #$running_under_some_shell

#use strict;
use File::Find ();
use File::Copy;
use Cwd;

#		    K	M	
my $isofile_size= 1024*1024*(4000+000);
my $current_size;
my $number=1;
my @isofile;
my %global_list;
my $pwd;

$pwd=cwd();

my $file=shift or die("Usage: $0 fileList\n");

getList($file);
#my %tmp=sort{$global_list{$a}<=>$global_list{$b} } (keys %global_list);

my %tmp=%global_list;
gen_iso_from(%tmp);
#print (@global_list);
exit;


sub getList ()
{
	my ($file)=@_;
	open(FILE, $file )or die("open file $file error\n");
	for(<FILE>)
	{
		chomp;
		if(/([\d|\.]+)\s+(\S+)/)
		{
			my $size=$1;
			my $src=$2;
			$global_list{$src}=$size;
		}
	}
}
sub gen_iso_from()
{
	my (%list)=@_;
	my $file;
	#�������еĶ��� , �����ļ�����Ŀ¼��	
	for  (sort {$global_list{$a}<=>$global_list{$b} } keys (%list))
	{
		$current_size+=$list{$_};
		push(@isofile, $_);
		if($current_size > $isofile_size)
		{
			#����4.4G, �ܽ�һ��DVD���̡� 
			print "ISO_",$number,"\n";
			
			print "filesize =".int($current_size/1024/1024)."M","  filenumber ".scalar(@isofile),"\n";
			open(FILE_OUTPUT,">"."ISO_".$number) or die "open file error\n";
			#map{print FILE_OUTPUT $_,"\n"} @isofile;
			for $file (sort @isofile)
			{	
				if(defined ($global_list{$file}))
				{
				print FILE_OUTPUT $file."\t".$global_list{$file}." \n";
				}
			}
			close(FILE_OUTPUT);
			$number++;
			@isofile="";
			$current_size=0;
		}
	
	}
		#��������һ�����̣� �����γ�4.4G�Ĺ��̣� ����һ������<4.4G, Ҳ�ǿ��Եġ� 
		print "ISO_",$number,"\n";
		
		print "filesize =".int($current_size/1024/1024)."M","  filenumber ".scalar(@isofile),"\n";
		open(FILE_OUTPUT,">"."ISO_".$number) or die "open file error\n";
		#map{print FILE_OUTPUT $_,"\n"} @isofile;
		for $file (sort @isofile)
		{	
			if(defined ($global_list{$file}))
			{
				print FILE_OUTPUT $_,"\t",$list{$file},"\n";
			}
		}
		close(FILE_OUTPUT);

	
}
