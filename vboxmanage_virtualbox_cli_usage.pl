#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__
#2012_03_02   星期五   add by greshem
#3. 用命令行运行虚 VirtualBox
#3.1 建立一个VM
#用 VBoxManage 命令查看在命令行下面如何建立一个虚拟系统

VBoxManage –help
#现在从 Ubuntu 10.10 Server 的 ISO 文件安装 ubuntu 10.10 server ，分配硬盘空间10GB,内存256M！
VBoxManage createvm --name "Ubuntu 10.10 Server" --register
VBoxManage modifyvm "Ubuntu 10.10 Server" --memory 256 --acpi on --boot1 dvd --nic1 bridged --bridgeadapter1 eth0
VBoxManage createhd --filename Ubuntu_10_10_Server.vdi --size 10000
VBoxManage storagectl "Ubuntu 10.10 Server" --name "IDE Controller" --add ide
VBoxManage storageattach "Ubuntu 10.10 Server" --storagectl "IDE Controller" --port 0 --device 0 --type hdd --medium Ubuntu_10_10_Server.vdi
VBoxManage storageattach "Ubuntu 10.10 Server" --storagectl "IDE Controller" --port 1 --device 0 --type dvddrive --medium /home/ubuntu-10.10-server-amd64.iso

#3.2  从旧版本 VirtualBox 的导入一个存在的 VM
#假设现在已经有一个 VM examplevm 存在，这时候你只需要重新导入到新的host就能够使用了。Examplevm的映像可能在VirtualBox安装目录 machine/examplevm 里，这个目录里面应该有 examplevm.xml 这个文件。现在把 examplevm 这个目录（包括 examplevm.xml 文件）复制到新的 VirtualBox 安装目录里面的 machine 目录。如果你的用户名是 admin，machine 可能在 /home/admin/.VirtualBox/Machines 。
#同时也需要复制 example.vdi 文件从就得VDI 目录到新的目录。
#接下来注册你刚导入的 VM
VBoxManage registervm Machines/examplevm/examplevm.xml

#3.3 用 VBoxHeadless 开始使用VM
#不管你是刚装的一个新的VM还是导入的也好，用下面的命令能打开
VBoxHeadless --startvm "Ubuntu 10.10 Server"
#VBoxHeadless将启动VM和VirtualBox远程桌面控制服务。这是就能够在另外一台电脑上管理你的虚拟机了

#关闭VM
VBoxManage controlvm "Ubuntu 10.10 Server" poweroff

#暂停VM
VBoxManage controlvm "Ubuntu 10.10 Server" pause

#重置VM
VBoxManage controlvm "Ubuntu 10.10 Server" reset
#帮助
VBoxHeadless --help

#官网信息  http://www.virtualbox.org/manual/ch07.html#vboxheadless .

#通过远程桌面连接到 VM
#winxp 可用 远程桌面连接 连接到 VM Linux
在 Linux 桌面可使用 rdesktop 连接到VM，在 Fedora 上首先安装 rdesktop,打开终端，切换至 root
su
yum install rdesktop
#exit

#执行
rdesktop –a 16 192.168.0.100
#用 VBoxHeadless 远程连接你的虚拟机

#(192.168.0.100是host IP，不是guest. –a 16代表16位色彩)


