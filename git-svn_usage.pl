#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__

1��git-svn clone your_svn_repository��
2���޸ı��ش��룬ʹ��git add/commit���޸��ύ������git�⣻
3������ʹ��git-svn rebase��ȡ����svn repository�ĸ��£�
			#֮�� �޸ĵĴ�����git �ķ�ʽ �ύ, 
4��ʹ��git-svn dcommit�������git����޸�ͬ��������svn��

#==========================================================================
9.������git�⵼��svn(����ʧ��־)
���뱾��git��Ŀ¼
git svn init svn://localhost/respo/dir
git svn fetch
git rebase git-svn
#֮�� �޸ĵĴ�����git �ķ�ʽ �ύ, 
git svn dcommit


