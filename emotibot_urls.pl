
#!/usr/bin/perl
foreach (<DATA>)
{
	print $_;
}
__DATA__

scp   -r  pydev_eclipse.tar.gz   192.168.1.11:/mnt/sdb1/tmp3/samba_shared/software/eclipse/
http://192.168.1.11:8888/samba_shared/software/eclipse/
http://192.168.1.11:8888/linux_src/


#website  6787 -> 1.48 
ssh://root@mail.emotibot.com.cn:6787/mnt/dir/svn_git/bin
ssh://root@192.168.1.48:2222/mnt/dir/svn_git/bin

