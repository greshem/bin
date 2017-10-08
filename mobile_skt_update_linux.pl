#!/usr/bin/perl
use strict;

if ( $^O  =~/linux/)
{
	do("/bin/iso_get_mobile_disk_label_linux.pl");
}
elsif ($^O =~/mswin32/i)
{
    	print "this is windows32\n";
	do("c:\\bin\\iso_get_mobile_disk_label.pl");
}

my $disk1=change_mobile_path_to_linux_path('sdb1');
my $disk2=change_mobile_path_to_linux_path('sdb2');
my $disk3=change_mobile_path_to_linux_path('sdb3');
my $disk4=change_mobile_path_to_linux_path('sdb4');
#print "\n";
#print "sdb1-> ".$disk1."\n";

print  "\n#######################################################################\n";
my @disks;
push(@disks, $disk1);
push(@disks, $disk2);
push(@disks, $disk3);
push(@disks, $disk4);

my @depth1=glob_dirs(@disks);
print join("\n", @depth1);

print "##############################\n";
my @depth2=glob_dirs(@depth1);
my @depth2_filters=grep {/\/d_|\\d_/} @depth2;
print join("\n", @depth2_filters);


my @iso_files=glob_iso_files(@depth1);
print join("\n", @iso_files);

our @save;
push(@save,"#移动硬盘的一级目录");
push(@save, @depth1);

push(@save,"#移动硬盘的二级级目录, 以d_开头");
push(@save, @depth2_filters);

push(@save,"#移动硬盘的所有的iso文件");
push(@save, @iso_files);
save_file(@save);

sub save_file(@)
{
	(my @input)=@_;

	open(FILE, "> /bin/mobile_harddisk_skeletion_linux.pl") or die("输出文件错误\n");
	print FILE<<EOF
#!/usr/bin/perl
\$pattern=shift;
foreach (<DATA>)
{
	
	if(\$_=~/\$pattern/)
	{
		print $_;
	}
}
__DATA__
EOF
;
	for(@input)
	{
		if($_=~/^[a-z]:/)
		{
			my $mobile_path=  change_win_path_to_mobile_path($_);
			print FILE  "ie.pl  ".$mobile_path."\n";
		}
		else
		{
			print FILE $_."\n";;
		}
	}
	close(FILE);
}

########################################################################
#返回 一个目录数组 下的 子目录数组.
sub glob_dirs(@)
{
	(my @dirs)=@_;
	my @ret;
	for(@dirs)
	{
		my @tmp=grep { -d }glob_one_dir($_);
		push(@ret, @tmp);
	}
	return @ret;
}
#返回一个目录数组下的 iso文件数组.
sub glob_iso_files(@)
{
	(my @dirs)=@_;
	my @ret;
	for(@dirs)
	{
		my @tmp=grep { -f && /iso$/ }glob_one_dir($_);
		push(@ret, @tmp);
	}
	return @ret;
}
sub glob_one_dir($)
{
	(my $pattern)=@_;
	if( $pattern=~/^.$/) #是盘符.
	{
		$pattern.=":\\*";
	}
	elsif($pattern!~/\/$/)
	{
		$pattern.="/*";
	}
	my @dirs_depth1;
	for( (glob($pattern)))
	{
		if($_!~/RECYCLER$|System.*Volume.*Information$|Recycled$/i)
		{
			#print $_."\n";
			push(@dirs_depth1, $_);
		}
	}
	return @dirs_depth1;

	#return @dirs;
	#my @dirs_depth2;

	#for(  @dirs_depth1)
	#{
	#	for $depth2 ( (grep {-d } glob($_."\\*")))
	#	{
	#		print "#### $depth2\n";
	#	}
	#}
}
