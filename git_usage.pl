#!/usr/bin/perl
foreach (<DATA>)
{
	print $_;
}
__DATA__
#########
更多的资料可以参考。 
http://progit.org/book/zh/ 
########################################################################
#服务器搭建.
git init
git init --bare
git add  . 
git commit  //提交所有的文件
git status 
最初的库的建设。 

#################
#git 修改提交.
vim test.file 
git commit 有把test.file 文件进行提交了。 
git show test.file 就显示了 test.file 的所有的版本的修改的记录。 

# checkout
#git clone
git clone https://github.com/ipankajg/ihpublic.git  #straceNt

git checkout # svn status

git fetch 	#svn update

git reset --hard  6de9c202383b96b81c4e3503ca5c71b925081c56

git config --bool core.bare true 
git config --bool core.bare fals
########################################################################

git push origin master

###
#git proxy 
cat > /root/.gitconfig  <<EOF
[http]
	proxy = http://10.4.16.32:808
[user]
	email = greshem@gmail.com
	name = greshem
[global]
http-proxy-host = 10.4.16.32
http-proxy-port = 808
EOF

########################################################################
  git config --global user.email "greshem@gmail.com"
  git config --global user.name "greshem"


