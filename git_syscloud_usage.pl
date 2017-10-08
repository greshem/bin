#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__

git常用命令
在2015/07/15 03:06上被superadmin修改

#丢弃本地代码库中的某些commit，连index中都不留
git reset --hard   bf1f40efff6e6a606aac8b17496a6d39db64fc19


#克隆远程代码库到本地
git clone http://git.domain.cn/gitlab/openstack/project.git

#切换到某个分支
git checkout tag/branch -b new_branch

#查看代码库的配置信息
git config -l

#修改代码库的远程信息，如果远程地址无需变更就不用需修改
git config remote.origin.url http://git.domain.cn/gitlab/openstack/project.git

#修改用户名和EMAIL－－global
git config --global user.name Yan Jiajia
git config --global user.email yanjj@syscloud.cn

#push到远程的一个新分支中，往集中代码库中提交的时候一定要这样做
git push origin $LOCAL_BRANCH:$REMOTE_BRANCH
git push origin master


#丢弃本地代码库中的某些commit，连index中都不留
git reset --hard COMMIT

#恢复本地代码库中的某些commit，变成修改状态
git reset COMMIT

#提交修改的代码
git commit

#合并修改的代码到最后一次提交里面
git commit --amend

#push my  src code to  github 
git remote  add origin  ssh://git@github.com/greshem/mysql_php_gen.git
git push -u origin master

#创建一个分支
git branch experiment 

#go to  this  branch 
git checkout experiment

3,提交该分支到远程仓库
git push origin dev

########################################################################
