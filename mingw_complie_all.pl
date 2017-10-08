#!/usr/bin/perl
#print  "/usr/bin/i686-pc-mingw32-gcc hello.c -o hello.exe -mwindows\n";
my $lib_long= " -laclui -ladvapi32 -lapcups -lavicap32 -lavifil32 -lbthprops -lcap -lcfgmgr32 -lcomctl32 -lcomdlg32 -lcrypt32 -lctl3d32 -ld3d8 -ld3d9 -ld3dim -ld3drm -ld3dx8d -ld3dx9d -ld3dxof -lddraw -ldhcpcsvc -ldinput -ldinput8 -ldlcapi -ldmoguids -ldnsapi -ldplayx -ldpnaddr -ldpnet -ldpnlobby -ldpvoice -ldsetup -ldsound -ldxapi -ldxerr8 -ldxerr9 -ldxguid -lfaultrep -lgdi32 -lgdiplus -lglaux -lglu32 -lhal -lhid -lhidparse -licmui -ligmpagnt -limagehlp -limm32 -liphlpapi -lkernel32 -lksproxy -lksuser -llargeint -llz32 -lmapi32 -lmcd -lmfcuia32 -lmgmtapi -lmpr -lmprapi -lmqrt -lmsacm32 -lmscms -lmsdmo -lmsimg32 -lmsvcp60 -lmsvfw32 -lmswsock -lnddeapi -lndis -lnetapi32 -lnewdev -lntdll -lntoskrnl -lodbc32 -lodbccp32 -lole32 -loleacc -loleaut32 -lolecli32 -loledlg -lolepro32 -lolesvr32 -lopengl32 -lpenwin32 -lpkpd32 -lpowrprof -lpsapi -lquartz -lrapi -lrasapi32 -lrasdlg -lrpcdce4 -lrpcns4 -lrpcrt4 -lrtm -lrtutils -lscrnsave -lscrnsavw -lscsiport -lsecur32 -lsetupapi -lshell32 -lshfolder -lshlwapi -lsnmpapi -lstrmiids -lsvrapi -ltapi32 -ltdi -lthunk32 -lurl -lusbcamd -lusbcamd2 -luser32 -luserenv -lusp10 -luuid -luxtheme -lvdmdbg -lversion -lvfw32 -lvideoprt -lwin32k -lwin32spl -lwininet -lwinmm -lwinspool -lwinstrm -lwldap32 -lwow32 -lws2_32 -lwsnmp32 -lwsock32 -lwst -lwtsapi32 ";
my $lib="-lwininet -luser32 -lwsock32";
my $log_erro="  ";
@array=glob("*.cpp");
@tmp=glob("*.c");
push(@array, @tmp);
if(scalar(@array)==0)
{
	gen_simple_windows_code();
	print  "/usr/bin/i686-pc-mingw32-gcc hello.c -o hello.exe -mwindows  $lib\n";
}
else
{
	@res=glob("*.rc");
	for(@res)
	{
		$tmp=$_;
		$tmp=~s/\.rc/\.res/g;
		print "mingw32-windres  $_ -o $tmp -O coff\n";
	}
	
	for(@array)
	{
		$obj=$_;
		$obj=~s/\.c$/\.exe/g; 
		$obj=~s/\.cpp$/\.exe/g; 
		if( ! -f $obj)
		{
			#print  "/usr/bin/i686-pc-mingw32-gcc -w $_ -o  $obj  -mwindows $lib > $obj.error 2>&1 \n";
			print  "/usr/bin/i686-pc-mingw32-gcc -w $_ -o  $obj  -mwindows $lib   \n";
		}
	}
}

sub gen_simple_windows_code()
{
	open(FILE, "> hello.cpp") or die("ope file error\n");
	print  FILE  <<EOF
	#include<windows.h>
	int WINAPI WinMain (HINSTANCE hInstance, HINSTANCE hPrevInstance, PSTR szCmdLine, int iCmdShow)
	{
		MessageBox (NULL, "Hello", "Hello Demo", MB_OK);
		return (0);
	}
EOF
;
	close(FILE);
}
