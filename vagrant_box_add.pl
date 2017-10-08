DATA	
#添加box到本地仓库有三种方式：
#1 . 使用http远程添加
vagrant box add my_first_box  https://github.com/tommy-muehle/puppet-vagrant-boxes/releases/download/1.1.0/centos-7.0-x86_64.box

#2 . 使用本地box文件
vagrant box add my_first_box D:/centos-7.0-x86_64.box

#3 .使用中央仓库名称
vagrant box add my_first_box hashicorp/precise64
