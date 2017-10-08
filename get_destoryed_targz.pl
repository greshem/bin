#!/usr/bin/perl 
$in_dir=$ARGV[0];
$in_dir=~s/\/$//g;

opendir(DIR, "$in_dir") or die ("opendir error\n");
@targz_files=grep { -f "$in_dir/".$_ && /tar.gz$/ } readdir(DIR);
for (@targz_files)
{
	`tar -tzf $in_dir/$_`;
	if( $?>>8  gt  0 )
	{
	print $_," destoryed \n";
	}
}
