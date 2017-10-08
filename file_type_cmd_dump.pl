#!/usr/bin/perl
#.asm nasm asm 
#.s  
#.fortran 
#.f95  
#.o -> ld 
#.pcap   pcap info 的统计. 
#.pc 	pkgconfig 
#.rc 	windrc
#.cpp gen_make_from_file*
#.c   
#.template perl Tempalte 的文件. 
#.  
########################################################################
#假如自己是独立运行的.
if($0=~/file_type_cmd_dump.pl$/)
{
	file_type_cmd_dump();
}

sub file_type_cmd_dump()
{
	for(glob("*"))
	{
		if($_=~/iso$/)
		{
			deal_with_iso($_);
		}
		elsif($_=~/vmdk$/)
		{
			deal_with_vmdk($_);
		}
		elsif($_=~/pl$/)
		{
			#deal_with_perl($_);
		}
		elsif($_=~/py$/)
		{
			#print "python ".$_."\n";
			#deal_with_python($_);
		}
		elsif($_=~/tar.gz$/)
		{
			deal_with_targz($_);		
		}
		elsif($_=~/srpm$/)
		{
			deal_with_srpm($_);
		}
		elsif($_=~/spec$/)
		{
			deal_with_spec($_);	
		}
		elsif($_=~/dll$/)
		{
			deal_with_dll($_);		
		}
		elsif($_=~/\.sqlite$/)
		{
			deal_with_sqlite($_);
		}
		elsif($_=~/\.bkl$/)
		{
			deal_with_bkl($_);

		}
		elsif($_=~/\.iss$/)
		{
			deal_with_iss($_);

		}
		elsif($_=~/\.dsp$|\.DSP|\.Dsp/)
		{
			deal_with_dsp($_);

		}
		elsif($_=~/\.msi$/)
		{
			deal_with_msi($_);
		}
		elsif($_=~/\.dot$/)
		{
			deal_with_dot($_);
		}
		elsif($_=~/\.lib$/i)
		{
			deal_with_lib($_);
		}
		elsif($_=~/\.dll$/)
		{
			deal_with_dll($_);
		}
		elsif($_=~/\.exe$/i)
		{
			#exe一般用来调试.
			debug_with_exe($_);
		}
		elsif($_=~/\.vc$/i)
		{
			deal_with_vc_makefile($_);
		}
		elsif($_=~/\.mp3$/i)
		{
			deal_with_mp3($_);
		}
		elsif($_=~/\.xml$/i)
		{
			deal_with_xml($_);
		}
		elsif($_=~/\.cpio$/i)
		{
			deal_with_cpio($_);
		}
		elsif($_=~/\.pdb$/i)
		{
			deal_with_pdb($_);
		}
		elsif($_=~/\.cs$/i)
		{
			deal_with_cs($_);
		}
		elsif($_=~/\.vb$/i)
		{
			deal_with_vb($_);
		}
		elsif($_=~/\.img$/i  ||  $_=~/\.qcow2$/i || $_=~/\.qcow$/i  )
		{
			deal_with_img($_);
		}
		elsif($_=~/\.java$/i)
		{
			deal_with_java($_);
		}
		elsif($_=~/\.class$/i)
		{
			deal_with_class($_);
		}
		elsif($_=~/\.jar$/i)
		{
			deal_with_jar($_);
		}
		elsif($_=~/\.yml$/i)
		{
			deal_with_yml($_);
		}
	    elsif($_=~/\.yaml$/i)
		{
			deal_with_yml($_);
		}


		elsif($_=~/\.deb$/i)
		{
			deal_with_deb($_);
		}
		elsif($_=~/\.reg$/i)
		{
			deal_with_reg($_);
		}
		elsif($_=~/\.a$/i)
		{
			deal_with_static_lib($_);
		}


	}
}

#==========================================================================
sub deal_with_static_lib($)
{
	(my $line)=@_;
	($name)=($line=~/(.*)\.a/i);	
	if(! -f "/usr/bin/powerpc64-linux-gnu-ar")
	{
		warn("yum install  binutils-powerpc64-linux-gnu-2.23.88.0.1-2.fc18.i686 \n");
	}

	print "powerpc64-linux-gnu-ar xvf  $line    --target=aix5coff64-rs6000  \n";
	print "mv shr.o  $line.shr.o \n";

}
sub deal_with_reg()
{
	(my $line)=@_;
	($name)=($line=~/(.*).reg/i);	
	print "/root/bin/reg_file_change.pl $line \n";
}

sub deal_with_deb()
{
	(my $line)=@_;
	($name)=($line=~/(.*).deb/i);	
	print "dpkg --contents $line \n";
}

#==========================================================================
sub deal_with_java()
{
	(my $line)=@_;
	($name)=($line=~/(.*).java/i);	
	print "javac $line \n";
}
sub deal_with_class()
{
	(my $line)=@_;
	($name)=($line=~/(.*).class/i);	
	print "java $name \n";
	print "jad -s java $line \n";
}

sub deal_with_jar()
{
	(my $line)=@_;
	($name)=($line=~/(.*).jar/i);	
	print "jar -xvf $line\n";
	print "/bin/jar_get_main.sh $line\n";
}
sub deal_with_yml()
{
	(my $line)=@_;
	($name)=($line=~/(.*).yml/i);	
    print "ansible-playbook --list-tasks $line  \n";
    print "  ansible-playbook -v    $line \n";
    print "  ansible-playbook -v  -i host.ini  $line \n";
}



########################################################################
#启动虚拟机.
sub deal_with_img($)
{
	(my $line)=@_;
	($name)=($line=~/(.*).img/i);	
	
	do("/bin/rand_mac_string.pl");
	$rand_mac= rand_mac_str();
	$usb_mouse_str=  "-usb -usbdevice tablet";
	$net_str=  "-net nic,macaddr=$rand_mac  -net tap ";
	
	print "qemu-system-x86_64 --enable-kvm  -hda $line   -m 1024  -localtime    -snapshot   $usb_mouse_str  $net_str  -vnc 0.0.0.0:0\n";
    print " python  /root/bin/gen_vms_libvirt/instance_class.py  --name=$name   --start_net=14  --start_ip=56  --count=1  --image=$line \n";

}

#.net 的vb 程序的编译.
sub deal_with_vb($)
{
	(my $line)=@_;
	($name)=($line=~/(.*).vb/i);	
	print " vbc   $line \n"

}
sub deal_with_cs($)
{
	(my $line)=@_;
	($name)=($line=~/(.*).cs/i);	
	print " csc   $line \n"
}
sub  deal_with_pdb($)
{
	(my $line)=@_;
	($name)=($line=~/(.*).pdb/i);	
	print ";移掉 私有符号\n";
	print " pdbcopy -p  $line ${name}_pub.pdb \n"
}

sub	deal_with_cpio($)
{
	(my $line)=@_;
	($name)=($line=~/(.*).cpio/i);	
	print "mkdir $name\n";
	print "cd $name\n";
	print " cpio -ivmd < ../$line\n";
}

sub deal_with_xml($)
{
	(my $line)=@_;
	($name)=($line=~/(.*).xml/i);	
	if( ! -f "/usr/bin/xmlstarlet")
	{
		print "yum install xmlstarlet\n";
	}
	print "#列出xml的内容\n";
	print "xmlstarlet el $line\n";
}

sub deal_with_mp3($)
{
	(my $line)=@_;
	($name)=($line=~/(.*).mp3/i);	
	print "mp32ogg.sh $line \n";	
}


sub deal_with_vc_makefile($)
{
	(my $line)=@_;
	($name)=($line=~/(.*).exe/i);	
	print "nmake /f $line\n";	
}

sub debug_with_exe($)
{
	(my $line)=@_;
	($name)=($line=~/(.*).exe/i);	
	print "cdb $line\n";	
}
sub deal_with_dll($)
{
	(my $line)=@_;
	($name)=($line=~/(.*).dll/);	
	if($^O=~/win32/i)
	{
		print "dumpbin -exports $line\n";
	}
}

sub deal_with_lib($)
{
	(my $line)=@_;
	($name)=($line=~/(.*).lib/i);	
	if($^O=~/win32/i)
	{
		print "dumpbin  /DISASM $line > $name.asm\n";
		print "#除了反汇编之外的所有的信息\n";
		print "dumpbin  /ALL $line\n";
	}
	else
	{
		#print "dumpbin  /DISASM $line > $name.asm\n";
		#源码.
		print "objdump -d  -S  $line |c++filt  > $line.asm \n";
	}
}

sub deal_with_dot($)
{
	(my $line)=@_;
	($name)=($line=~/(.*).dot/);	
	print "dot -Tps $line -o $name.ps\n";
	print "dot -Tjpg $line -o $name.jpg \n";
}

sub	deal_with_msi($)
{
	(my $line)=@_;
	($name)=($line=~/(.*).msi/);	
	print "msiexec /i $line  INSTDIR=c:\\$name\n";
}

sub deal_with_dsp($)
{
	(my $line)=@_;
	($name)=($line=~/(.*).(dsp|DSP|Dsp)/);	
	print "  msdev $line /make \"all\" \n";
	print " \"C:\\Program Files\\Microsoft Visual Studio\\COMMON\\MSDev98\\Bin\\msdev.exe\"  $line /make \"all\" \n";
}

sub deal_with_iss($)
{
	(my $line)=@_;
	($name)=($line=~/(.*).iss/);	
	print " /bin/gen_bakefile_bkl.pl   $name \n";
	print '"C:\Program Files\Inno Setup 5\ISCC.exe" "'.$line.'"</command>'
}


sub deal_with_bkl($)
{
	(my $line)=@_;
	($name)=($line=~/(.*).bkl/);	
	#print " /bin/gen_bakefile_bkl.pl   $line \n";
	
	#dmars          dmars_smake   
	#borland       
	#symbian  watcom    xcode2        
	@formats=qw(
	msvc msevc4prj  msvc6prj      msvs2003prj   msvs2005prj   msvs2008prj   
	autoconf      
	gnu 
	mingw 
	);
	foreach $format (@formats)
	{
		if($line=~/release/i && ($format eq "msvc"))
		{
			print "bakefile -f ".$format."  $line  -o makefile_release.vc\n";
		}
		elsif($line=~/debug/i  && ($format eq "msvc"))
		{
			print "bakefile -f ".$format."  $line  -o makefile_debug.vc\n";
		}
		else
		{
			print "bakefile -f ".$format."  $line   \n";
		}
	}


}

sub deal_with_sqlite($)
{
	(my $line)=@_;
	#.sqlite  sqlite 
	($name)=($line=~/(.*).sqlite/);	
	print "sqlite3 $name \n";
	print " /bin/sqlite_usage.pl\n";

}
sub deal_with_dll($)
{
	(my $line)=@_;
	#.dll  dll export 
	($name)=($line=~/(.*).dll/);
	print "pexport $name \n";
}
sub deal_with_spec($)
{
	#spec rpmbuild -ba  
	(my $line)=@_;
	($name)=($line=~/(.*).spec/);
	print "rpmbuild -ba $name \n";
}

sub deal_with_srpm($)
{
	(my $line)=@_;
	#srpm rpmbuild --rebuild
	($name)=($line=~/(.*).srpm/);
	print "rpmbuild --rebuild $_\n";
}

sub deal_with_targz($)
{
	(my $line)=@_;
	#tar.gz  tar -xzvf 
	($name)=($line=~/(.*).tar.gz/);
	print "tar -xzvf  $_ \n";

}

sub deal_with_vmdk($)
{
	(my $line)=@_;
	($name)=($line=~/(.*).vmdk/);
	print "qemu-img convert -f vmdk -O raw  $line  $name\.img\n";
	$line=~s/vmdk$/img/;
    	deal_with_img($line);
}
sub deal_with_iso($)
{
	(my $line)=@_;
	($name)=($line=~/(.*).iso/);
	if($^O =~/linux/i)
	{
		if(! -d $name)
		{
			print "mkdir /mnt/$name &&";
		}

	do("/bin/rand_mac_string.pl");
	$rand_mac= rand_mac_str();
	$usb_mouse_str=  "-usb -usbdevice tablet";
	$net_str=  "-net nic,macaddr=$rand_mac  -net tap ";

		print "mount -t iso9660 $_ /mnt/$name -o loop \n";
		print "qemu-system-x86_64  --enable-kvm -cdrom $line   -m 1024  -localtime   $usb_mouse_str  $net_str  -vnc 0.0.0.0:0\n"; 

	}
	else
	{
		#"batchmnt.exe dos_0.iso p"
		print "batchmnt.exe $line	 p\n";
	}
}
