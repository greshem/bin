#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__

git��������
��2015/07/15 03:06�ϱ�superadmin�޸�

#�������ش�����е�ĳЩcommit����index�ж�����
git reset --hard   bf1f40efff6e6a606aac8b17496a6d39db64fc19


#��¡Զ�̴���⵽����
git clone http://git.domain.cn/gitlab/openstack/project.git

#�л���ĳ����֧
git checkout tag/branch -b new_branch

#�鿴������������Ϣ
git config -l

#�޸Ĵ�����Զ����Ϣ�����Զ�̵�ַ�������Ͳ������޸�
git config remote.origin.url http://git.domain.cn/gitlab/openstack/project.git

#�޸��û�����EMAIL����global
git config --global user.name Yan Jiajia
git config --global user.email yanjj@syscloud.cn

#push��Զ�̵�һ���·�֧�У������д�������ύ��ʱ��һ��Ҫ������
git push origin $LOCAL_BRANCH:$REMOTE_BRANCH
git push origin master


#�������ش�����е�ĳЩcommit����index�ж�����
git reset --hard COMMIT

#�ָ����ش�����е�ĳЩcommit������޸�״̬
git reset COMMIT

#�ύ�޸ĵĴ���
git commit

#�ϲ��޸ĵĴ��뵽���һ���ύ����
git commit --amend

#push my  src code to  github 
git remote  add origin  ssh://git@github.com/greshem/mysql_php_gen.git
git push -u origin master

#����һ����֧
git branch experiment 

#go to  this  branch 
git checkout experiment

3,�ύ�÷�֧��Զ�ֿ̲�
git push origin dev

########################################################################
