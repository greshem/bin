#!/usr/bin/perl
mkdir("delete_dir");

deal_with_one_type("*.tar*");
deal_with_one_type("*.zip");
deal_with_one_type("*.Zip");
deal_with_one_type("*.ZIP");
deal_with_one_type("*.rar");
deal_with_one_type("*.RAR");

deal_with_one_type("*.chm");
deal_with_one_type("*.7z");
deal_with_one_type("*.7Z");
deal_with_one_type("*.msi");
deal_with_one_type("*.exe");


#==========================================================================
sub deal_with_one_type($)
{
	(my $pattern)=@_;
	for (grep {-f } (glob($pattern)))
	{
		print $_."\n";;	
		my $count;
		if(-f "c:\\log\\dupkiller.log")
		{
			logger( "c:\\log\\dupkiller.log, cache 文件存在, 使用 cache \n");
			$count= is_duplicate_file_from_cache($_);
		}
		else
		{
			$count= is_duplicate_file($_);
		}

		if(defined($count))
		{
			logger("找到, $count 个   $_ 文件\n");
			logger_2_bat("mv  $_  delete_dir\  \n");
			logger_2_delete_findstr("iso_search_file.pl $_ |findstr /i \\$_ |findstr iso_copy >> delete_copy.bat\n");
		}
		else
		{
			logger(" $_ 存储库 找不到 对应文件\n");
		}
	}
}

#==========================================================================
sub is_duplicate_file_from_cache($)
{
	(my $file)=@_;
	my $count=undef;
	open(CACHE, "c:\\log\\dupkiller.log") or die("  dupkiller.log  not  exists \n");
	for(<CACHE>)
	{
		if($_=~/$file/)
		{
			$count++;	
		}
	}
	return $count;
}

sub is_duplicate_file($)
{
	open(PIPE, "iso_search_file.pl  binutils-2.11.2a.tar.bz2 |findstr  binutils-2.11.2a.tar.bz2 |") or die("open  cmd error ");
	logger("执行命令: iso_search_file.pl  binutils-2.11.2a.tar.bz2 |findstr  binutils-2.11.2a.tar.bz2 |\n");
	my $count=undef;
	for(<PIPE>)
	{
		#print $_;
		logger($_."\n");
		$count++;
	}
	close(PIPE);
	return $count;
}


#最简单的.
sub logger($)
{
	(my $log_str)=@_;
	open(FILE, ">>c:\\log\\delete_dupcliate.log") or warn("open c:\\ delete_dupcliate.log error\n");
	print FILE $log_str;
	print $log_str;
	close(FILE);
}

sub logger_2_bat($)
{
	(my $log_str)=@_;
	open(FILE, ">>delete.bat") or warn("delete.bat   error\n");
	print FILE $log_str;
	close(FILE);
}
sub logger_2_delete_findstr($)
{
	(my $log_str)=@_;
	open(FILE, ">>delete_findstr.bat") or warn("delete.bat   error\n");
	print FILE $log_str;
	close(FILE);
}
