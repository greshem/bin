#!/usr/bin/perl
#20100129
#������ d_ ��ͷ��Ŀ¼ �����������ˡ� ���Ŀ¼����Ҫ�������ڡ� 
use Data::Dumper; 
opendir(DIR,".");
@all=readdir(DIR); 
@dir=map {if(-d){ $_;} else {} } @all;
$nogzip=1 if(grep(/nogzip/, @ARGV));
#print Dumper(@dir);
for  (@dir) 
{
if(/^d_|^D_/)
{
	next;
}
if( $_ eq "\." || $_ eq  "\.\."  )
 {
#	print length($_),"\n";
#	print $_,"DDDD\n";
 }
 else 
 {
#	print $_,"\n";
	if($ARGV[0] =~/del/)
	{
		if($ARGV[1]=~/space/ && $_=~/^\./)
		{
		print "rm -rf $_ &\n";
		}
		elsif($ARGV[1]=~/space/)
		{
		}
		else
		{
			
		print "rm -rf $_ &\n";
		}
	
	
	}
	
	else
	{
		if($ARGV[0]=~/space/ && $_=~/^\./)
		{

		print "tar -czf ",$_,".tar", " ",$_,"\n"; 
		}
		elsif ($ARGV[0] =~/space/)
		{
		}
		else 
		{	
			
			if($nogzip)
			{
				print "tar -cf ",$_,".tar", " ",$_,"\n"; 
				print "rm -rf $_\n";	
				print "ccencrpty ".$_."tar\n";
			}
			else
			{
				print "tar -czf ",$_,".tar.gz", " ",$_,"\n"; 
				print "rm -rf $_\n";	
				print "ccencrpty ".$_."tar.gz\n";
			}
		}
		
	}
	
 } 
}
