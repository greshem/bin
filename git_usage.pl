#!/usr/bin/perl
foreach (<DATA>)
{
	print $_;
}
__DATA__
#########
��������Ͽ��Բο��� 
http://progit.org/book/zh/ 
########################################################################
#�������.
git init
git init --bare
git add  . 
git commit  //�ύ���е��ļ�
git status 
����Ŀ�Ľ��衣 

#################
#git �޸��ύ.
vim test.file 
git commit �а�test.file �ļ������ύ�ˡ� 
git show test.file ����ʾ�� test.file �����еİ汾���޸ĵļ�¼�� 

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


