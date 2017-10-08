#!/usr/bin/perl
#20090709 添加了对 /tmp3/sf_mirror/find.sh 的处理方式, 假如 sf_mirror 上面7万个包没有的话, 那就从其他的源上面去获取, 
#譬如gentoo , debian , fedora freebsd, netbsd 等等. 
#还是没有的话, 暂时可能找不到了. 
use Term::ANSIColor;
	open(OUTPUT,$ARGV[0]) or die("open file error\n");
	@output=(<OUTPUT>);
	for  (@output)
	{
		chomp;
		$name=$_;
		if($name=~/^#/)
		{
			next;
		}
	
		print $_,"\n";
		my $urlfile="/tmp3/sf_mirror/".substr($_,0,1)."/".substr($_,0,2)."/".$_."/targz_url_filesize";
		if (-f $urlfile)
		{
			#print $urlfile ;
			#print "now get best url \n";
			$count=`wc -l $urlfile`;
			#chomp $count;
			($count)=($count=~/(\S+)\s+\S*$/);
			#print "    #count", $count ,"\n";
			open(URL, $urlfile);
			while(<URL>)
#http://www.mirrorservice.org/sites/download.sourceforge.net/pub/sourceforge/d/dn/dnfbb/dnfBB_beta1.zip #Length:1251K
			{
				if(/(\S+)\s+\#Length:(.*)K/)
				{
				
					#$besturl{$2}=$1;
					#if($2> 1000)
					{
						print $_;
					}
				}
				
				#if($_=~/\/$name/)
				#{
				#	print $_;
				#}
				
			}
		}
		else
		{
			print "ERROR: ", $name, "not exist, try gentoo, debian, \n";
			open(LOGFILE,  ">>logfile.log");
			print LOGFILE $name,"\n";
			close(LOGFILE);	
			chdir("/tmp3/sf_mirror");
			opendir(DIR, "/tmp3/sf_mirror/") or die("open /tmp3/sf_mirror error\n");
			@file=grep -f && /_package__/, readdir(DIR);
			for $mirror_file (@file)
			{
				open(MIRROR_FILE, "/tmp3/sf_mirror/".$mirror_file) or die("open mirror_file error\n");
				while(<MIRROR_FILE>)
				{
					if(/$name/)
					{
						print $_,"\n"
					}
				}	
			}
		}
		#open
	}
	close(OUTPUT);
