#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__

1、git-svn clone your_svn_repository；
2、修改本地代码，使用git add/commit将修改提交到本地git库；
3、定期使用git-svn rebase获取中心svn repository的更新；
			#之后 修改的代码用git 的方式 提交, 
4、使用git-svn dcommit命令将本地git库的修改同步到中心svn库

#==========================================================================
9.将本地git库导入svn(不丢失日志)
进入本地git库目录
git svn init svn://localhost/respo/dir
git svn fetch
git rebase git-svn
#之后 修改的代码用git 的方式 提交, 
git svn dcommit


