#!/usr/bin/perl
#2011_11_30_16:44:12   星期三   add by greshem
#shell 里面的find . |grep pl$ 等命令用的很爽, 移到perl 就不行了, 这里写的通用一些. 


#test2();
#test();
sub test()
{
	my @tmp= find_and_get_filelists("d:/tmp_cpt/","rar\$");
	#my @tmp= find_and_get_filelists("c:/bin/","a");
	print join("\n", @tmp);
}
sub test2()
{
	
	my @pls= find_and_get_filelists(".",".");
	print join("\n", @pls);
}

#***************************************************************************
# Description	 获取文件列表.
# @param: 
# 		$dir:  		输入的目录, 
# 		$pattern: 	需要获取的文件的模式
# @notice:  bug_100m  注意 这个东西, our my 区别 否则两次调用之后没有数据了.
#***************************************************************************/

sub  find_and_get_filelists($$)
{

	(my $dir,my  $pattern)=@_;
	#my @filelists=(); 	
	#our @filelists=();

	our @filelists=();
	our $g_pattern =$pattern;
	use File::Find ();

	use vars qw/*name *dir *prune/;
	*name   = *File::Find::name;
	*dir    = *File::Find::dir;
	*prune  = *File::Find::prune;

	sub wanted_exe;
	sub wanted_exe 
	{
		my ($dev,$ino,$mode,$nlink,$uid,$gid);

		(($dev,$ino,$mode,$nlink,$uid,$gid) = lstat($_));
		#print("$name\n");
		if($name=~/\/\./)
		{
			return ;
		}
		if($name=~/$g_pattern/i && -f $name )
		{
			#$name=~s/^$dir//g; #去掉绝对路径.
			push(@filelists , $name);
		}
	}
	
	File::Find::find({wanted => \&wanted_exe}, $dir);
	return @filelists;
}

sub  find_and_get_filelists_4_global($$)
{

	(my $dir,my  $pattern)=@_;
	#my @filelists=(); 	
	#our @filelists=();

	our @filelists=();
	our $g_pattern =$pattern;
	use File::Find ();

	use vars qw/*name *dir *prune/;
	*name   = *File::Find::name;
	*dir    = *File::Find::dir;
	*prune  = *File::Find::prune;

	sub wanted_exe;
	sub wanted_exe 
	{
		my ($dev,$ino,$mode,$nlink,$uid,$gid);

		(($dev,$ino,$mode,$nlink,$uid,$gid) = lstat($_));
		#print("$name\n");
		if($name=~/\/\./)
		{
			return ;
		}
		if($name=~/$g_pattern/i && -f $name )
		{
			#$name=~s/^$dir//g; #去掉绝对路径.
			push(@filelists , $name);
		}
	}
	
	File::Find::find({wanted => \&wanted_exe}, $dir);
	return @filelists;
}

