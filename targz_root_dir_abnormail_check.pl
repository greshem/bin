#!/usr/bin/perl
do("/bin/get_root_dir_all_arch_type.pl");
cur_dir_targz_root_dir_check();

sub cur_dir_targz_root_dir_check()
{
	for $each_targz( glob("*.tar.gz"))
	{
		(my $filename)=($each_targz=~/(.*)\.tar\.gz/);
		my @root_dirs=get_top_dir($each_targz);
		if(scalar(@root_dirs) eq 1)
		{
			$root_dir=shift(@root_dirs);
			if($root_dir ne $filename)
			{
				logger("#处理文件 $each_targz\n");
				logger("错误: 主目录 $root_dir 不等于 文件名  $filename \n");
			}
		}
		else
		{

			logger("#处理文件 $each_targz\n");
			logger("错误: $each_targz 有多个目录\n");
		}
	}

}

#最简单的.
sub logger($)
{
	(my $log_str)=@_;
	open(FILE, ">> /var/log/targz_root_dir_check.log") or warn("open all.log error\n");
	print $log_str;
	print FILE $log_str;
	close(FILE);
}

