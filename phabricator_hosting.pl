#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__
#==========================================================================
#2015_10_26   星期一   add by greshem
K:\sdb1\_xfile\2015_all_iso\_xfile_2015_11\_pre_cache\_pre_cache_2015_10\git_sudo_phabricator_hosting_关键步骤_.txt

#==========================================================================
useradd  daemon-user
useradd  git 
echo Emotibot1 |passwd git --stdin

cat >>  /etc/sudoers <<EOF
git ALL=(daemon-user) SETENV: NOPASSWD: /usr/libexec/git-core/git-upload-pack, /usr/libexec/git-core/git-receive-pack, /usr/bin/svnserve
EOF

sed '/requiretty/{s/^/#/g}'  -i /etc/sudoers 




#==========================================================================
cd  /var/www/html/phabricator/

/var/www/html/phabricator/bin/config set phd.user daemon-user
/var/www/html/phabricator/bin/config set diffusion.ssh-user git

cp    /var/www/html/phabricator/resources/sshd/phabricator-ssh-hook.sh /usr/libexec/phabricator-ssh-hook.sh 
sed 's/vcs-user/git/g'  /usr/libexec/phabricator-ssh-hook.sh  -i
sed -i  's|/path/to/phabricator|/var/www/html/phabricator/|g'    /usr/libexec/phabricator-ssh-hook.sh  -i

cp  /var/www/html/phabricator/resources/sshd/sshd_config.phabricator.example    /etc/ssh/sshd_config.phabricator
sed 's/vcs-user/git/g'   /etc/ssh/sshd_config.phabricator -i 

#==========================================================================
sed -i   's/#Port 22/Port 2222/g'  /etc/ssh/sshd_config
/usr/sbin/sshd  -f /etc/ssh/sshd_config
lsof -i:2222 


#==========================================================================
#ssh-keygen -t rsa -b 2048 -f /etc/ssh/ssh_host_rsa_key
ssh-keygen -t dsa -b 1024 -f /etc/ssh/ssh_host_dsa_key
/usr/sbin/sshd -f /etc/ssh/sshd_config.phabricator


#把22 的程序 先 关掉 之后 才能 体现出来 


#
#chmod 777 /var/repo/TEST/
#chmod 777 /var/repo/TEST/ -R
#git clone 
#git push origin master


#测试  
echo {} | ssh git@localhost  conduit conduit.ping
ssh git@localhost # 

#==========================================================================
#重要的一步  需要 网页的登陆的 操作,  
#登陆到 phabricator 然后 
# cat /root/.ssh/id_rsa.pub 
把   /root/.ssh/id_rsa.pub  到  http://192.168.1.11/settings/panel/ssh/ 里面的 upload ssh  


#==========================================================================
#重要 没有 -f 强制  最后 ssh 还是 权限 限制的,   需要 passwd -u  unlock  这个用户.
# sshd[2657]: User git not allowed because account is locked
#[root@iZ11jzlevymZ log]# passwd -u git 
#解锁用户 git 的密码。
#passwd: 警告：未锁定的密码将是空的。
#passwd: 不安全的操作(使用 -f 参数强制进行该操作

passwd -f -u git   #-f 强制更新`

#==========================================================================
#看到这里的信息 就算成功了
[root@host23 test]# ssh git@localhost
PTY allocation request failed on channel 0
phabricator-ssh-exec: Welcome to Phabricator.

You are logged in as admin.

You haven't specified a command to run. This means you're requesting an interactive shell, but Phabricator does not provide an interactive shell over SSH.

Usually, you should run a command like `git clone` or `hg push` rather than connecting directly with SSH.

Supported commands are: conduit, git-receive-pack, git-upload-pack, hg, svnserve.
Connection to localhost closed.

########################################################################
#sudo 单独 测试 也可以 ,  
#finally, you can usually test that sudoers is configured correctly by doing something like this:

$ su git
 sudo -E -n -u daemon-user --    /usr/libexec/git-core/git-upload-pack  --help
usage: git upload-pack [--strict] [--timeout=<n>] <dir>

# 没有 注册过的 都是需要 密码的 
[git@greshemSRV phabricator]$  sudo -E -n -u daemon-user --    /usr/bin/git
sudo：需要密码

 sudo -E -n -u another_uer  --    /usr/bin/git

############
ssh git@localhost   #bug 
ssh: Permission denied (publickey,keyboard-interactive)
git 的密码没有设置的关系.
password git   #设置密码. 


dae73ebcf8622bb7d087




