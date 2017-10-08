#!/usr/bin/perl
#2011_11_30_16:44:12   ������   add by greshem
#shell �����find . |grep pl$ �������õĺ�ˬ, �Ƶ�perl �Ͳ�����, ����д��ͨ��һЩ. 


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
# Description	 ��ȡ�ļ��б�.
# @param: 
# 		$dir:  		�����Ŀ¼, 
# 		$pattern: 	��Ҫ��ȡ���ļ���ģʽ
# @notice:  bug_100m  ע�� �������, our my ���� �������ε���֮��û��������.
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
			#$name=~s/^$dir//g; #ȥ������·��.
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
			#$name=~s/^$dir//g; #ȥ������·��.
			push(@filelists , $name);
		}
	}
	
	File::Find::find({wanted => \&wanted_exe}, $dir);
	return @filelists;
}

