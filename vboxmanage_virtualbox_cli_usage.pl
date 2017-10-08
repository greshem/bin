#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__
#2012_03_02   ������   add by greshem
#3. �������������� VirtualBox
#3.1 ����һ��VM
#�� VBoxManage ����鿴��������������ν���һ������ϵͳ

VBoxManage �Chelp
#���ڴ� Ubuntu 10.10 Server �� ISO �ļ���װ ubuntu 10.10 server ������Ӳ�̿ռ�10GB,�ڴ�256M��
VBoxManage createvm --name "Ubuntu 10.10 Server" --register
VBoxManage modifyvm "Ubuntu 10.10 Server" --memory 256 --acpi on --boot1 dvd --nic1 bridged --bridgeadapter1 eth0
VBoxManage createhd --filename Ubuntu_10_10_Server.vdi --size 10000
VBoxManage storagectl "Ubuntu 10.10 Server" --name "IDE Controller" --add ide
VBoxManage storageattach "Ubuntu 10.10 Server" --storagectl "IDE Controller" --port 0 --device 0 --type hdd --medium Ubuntu_10_10_Server.vdi
VBoxManage storageattach "Ubuntu 10.10 Server" --storagectl "IDE Controller" --port 1 --device 0 --type dvddrive --medium /home/ubuntu-10.10-server-amd64.iso

#3.2  �Ӿɰ汾 VirtualBox �ĵ���һ�����ڵ� VM
#���������Ѿ���һ�� VM examplevm ���ڣ���ʱ����ֻ��Ҫ���µ��뵽�µ�host���ܹ�ʹ���ˡ�Examplevm��ӳ�������VirtualBox��װĿ¼ machine/examplevm ����Ŀ¼����Ӧ���� examplevm.xml ����ļ������ڰ� examplevm ���Ŀ¼������ examplevm.xml �ļ������Ƶ��µ� VirtualBox ��װĿ¼����� machine Ŀ¼���������û����� admin��machine ������ /home/admin/.VirtualBox/Machines ��
#ͬʱҲ��Ҫ���� example.vdi �ļ��Ӿ͵�VDI Ŀ¼���µ�Ŀ¼��
#������ע����յ���� VM
VBoxManage registervm Machines/examplevm/examplevm.xml

#3.3 �� VBoxHeadless ��ʼʹ��VM
#�������Ǹ�װ��һ���µ�VM���ǵ����Ҳ�ã�������������ܴ�
VBoxHeadless --startvm "Ubuntu 10.10 Server"
#VBoxHeadless������VM��VirtualBoxԶ��������Ʒ������Ǿ��ܹ�������һ̨�����Ϲ�������������

#�ر�VM
VBoxManage controlvm "Ubuntu 10.10 Server" poweroff

#��ͣVM
VBoxManage controlvm "Ubuntu 10.10 Server" pause

#����VM
VBoxManage controlvm "Ubuntu 10.10 Server" reset
#����
VBoxHeadless --help

#������Ϣ  http://www.virtualbox.org/manual/ch07.html#vboxheadless .

#ͨ��Զ���������ӵ� VM
#winxp ���� Զ���������� ���ӵ� VM Linux
�� Linux �����ʹ�� rdesktop ���ӵ�VM���� Fedora �����Ȱ�װ rdesktop,���նˣ��л��� root
su
yum install rdesktop
#exit

#ִ��
rdesktop �Ca 16 192.168.0.100
#�� VBoxHeadless Զ��������������

#(192.168.0.100��host IP������guest. �Ca 16����16λɫ��)


