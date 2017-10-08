#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__


#==========================================================================
#mac
mount_smbfs  //root@192.168.1.5/_mnt___ /Volumes/bbb/

#==========================================================================
#server in win7 
net share tmp=D:\tmp
#client in f18 ,  
mount -t cifs -o username=administrator,password=q**********9  //192.168.1.12/tmp /mnt/tmp/


#==========================================================================
#server   windows 2008 有域控制器 . 
#fedora20 f20   不需要  在输入 windows 的域了  tnsoft/zjqian  可以省略了.  kernel 3.11 
mount -t cifs //172.16.1.18/Storage/ /mnt/Storage  -o username=zjqian

#==========================================================================
#fedora 16 , 不要密码的方式 挂载. 
mkdir /mnt/cifs_1_8_qzj/
mount -t cifs 172.16.1.8:/storage/Temp/zjqian/ /mnt/cifs_1_8_qzj/


mkdir /mnt/cifs_1_8_storage/
mount -t cifs 172.16.1.8:/storage/ /mnt/cifs_1_8_storage/

mkdir /mnt/cifs_1_8_repository/
mount -t cifs 172.16.1.8:/repository/  /mnt/cifs_1_8_repository/


mkdir /mnt/cifs_1_8_image_repository/
mount -t cifs 172.16.1.8:/ImageRepository  /mnt/cifs_1_8_image_repository/

mkdir  /mnt/cifs_rtiosrv/
mount -t cifs rtiosrv:/_tmp/ /mnt/cifs_rtiosrv/


#fedora 16  挂载的时候 输入密码, 
mkdir /mnt/tnsoft_smb/
mount.cifs -o username=tnsoft/zjqian,password=passwd   172.16.1.18:/Storage/  /mnt/tnsoft_smb/Storage
mount.cifs -o username=tnsoft/zjqian,password=passwd   172.16.1.18:/Public/  /mnt/tnsoft_smb/Public
mount -t cifs 172.16.1.18:/Storage/ /mnt/Storage  -o username=tnsoft/zjqian
mount -t cifs 172.16.1.18:/Public/  /mnt/Public   -o username=tnsoft/zjqian
mount -t cifs 172.16.1.18:/Employe-Storage/  /mnt/Employe-Storage   -o username=tnsoft/zjqian
mount -t cifs //172.16.1.18/Public/  /mnt/Public   -o username=tnsoft/zjqian  # kernel 3.11
mount -t cifs //172.16.1.18/Storage/ /mnt/Storage  -o username=tnsoft/zjqian  # kernel 3.11 
mount -t cifs //172.16.1.18/Employe-Storage/  /mnt/Employe-Storage   -o username=tnsoft/zjqian  #kernel 3.11
mount -t cifs //172.16.1.18/Public/  /mnt/Public   -o username="zjqian"  #unc , 最新的内核.  cifs utils 


#==========================================================================
#client: fedora 18 , server  transoft 
mkdir /mnt/cifs_1_18_Image_Repository 
mount.cifs -o username=tnsoft/zjqian,password=q**********n   //172.16.1.18/Storage/Image_Repository  /mnt/cifs_1_18_Image_Repository 

#smbfs old format 
mount -t smbfs -o username=administrator,password=123456 //192.168.3.222/rttools /smbfs222

#==========================================================================
#client f18  server: win7  64bit 
mount.cifs -o username=administrator,password=q***3 //192.168.1.10/TDDownload /mnt/cifs/

#rhel6_2 mount 
mount -t cifs -o username="user",password="passwd" //172.16.1.18/Public/OS/Linux/RedHat/rhel_6_2 /mnt
mount -t cifs -o username="zjqian",password="passwd" //172.16.1.18/Public /mnt/Public
mount -t cifs -o username="zjqian"  //172.16.1.18/Public 		/mnt/Public
mount -t cifs -o username="zjqian"  //172.16.1.18/Employe-Storage/  	/mnt/Employe-Storage   
mount -t cifs -o username="zjqian"  //172.16.1.18/Storage/ 		/mnt/Storage  



mount -t cifs -o username="root"  //172.16.3.30/tmp2/  /mnt/cifs/    #ok in rhel4 
mount -t cifs -o username="root"  //172.16.3.30//tmp2/  /mnt/cifs/   #注意: / 不能写成 //  , 资源名 错误.  error 



#password,  input 
mount -t cifs 172.16.1.18:/storage/ /mnt/storage  -o username=tnsoft/qhjin #错误 冒号 

#==========================================================================
#rhel5.8 下cifs文件系统.
 mount.cifs  //172.16.3.52/_tmp_  /mnt/tmp/ -o username=root,password=123456  #rhel5.8 
 mount.cifs  //172.16.1.18:/Public/  /mnt/public   -o username=tnsoft/zjqian  #错误  有冒号.
 mount.cifs  //172.16.1.18/Public/  /mnt/public   -o username=tnsoft/zjqian   #OK
