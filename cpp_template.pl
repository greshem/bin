#!/usr/bin/perl
#20100601, ���lmy���֧�֡� 
use POSIX qw(strftime);
$g_file=shift or die("$0 filename \n");
if($g_file!~/cpp$/)
{
	$g_file.=".cpp";
}

$snippet=shift ;
if($snippet=~/stl/i)
{
	gen_stl_cpp();
}
elsif ($snippet =~/commlib/i)
{
	gen_commlib_cpp();
}
elsif( $snippet =~/mfc_gui/i)
{
	gen_mfc_gui_cpp();
}
elsif( $snippet =~/mfc_daemon/i)
{
	gen_mfc_daemon_cpp();
}
elsif( $snippet =~/lmyunit/i)
{
	gen_lmyunit_cpp();
}
elsif( $snippet =~/winmain_gui/i)
{
	gen_winmain_gui_cpp();
}
elsif( $snippet =~/winmain_thread/i)
{
	gen_winmain_thread_cpp();
}
elsif( $snippet =~/winmain_daemon/i)
{
	gen_winmain_daemon_cpp();
}

else
{
	gen_mfc_daemon_cpp();
	print "Usage: $0 name  [stl|commlib|mfc_gui|mfc_daemon|lmyunit|winmain_daemon|winmain_gui|winmain_thread]\n";
}
########################################################################
sub gen_winmain_thread_cpp()
{
	$time=strftime("%Y_%m_%d", localtime(time()));
	open(FILE,">".$g_file) or die("open file error $!\n");
	print FILE  <<EOF
#include<windows.h>
#include<stdlib.h>
#include<stdio.h>

DWORD WINAPI ThreadProc(LPVOID lpParameter)
{
	while(1)
	{
    	Sleep( 1000);
	}
    return 0;
}
int WINAPI WinMain (HINSTANCE hInstance, HINSTANCE hPrevInstance, PSTR szCmdLine, int iCmdShow)
{
	for(int i=0;i<=4;i++)
	{
		printf("create thread  \\n");
		OutputDebugString("winmain_thread �����߳� \\n");
		//CreateThread( NULL, 0, ThreadProc, 0, CREATE_SUSPENDED, NULL );
		CreateThread( NULL, 0, ThreadProc, 0, 0, NULL );
	}
	while(1)
	{
    	Sleep( 1000);
	}
	return (0);
}

EOF
;
	close(FILE);
}

########################################################################
sub gen_winmain_gui_cpp()
{

	$time=strftime("%Y_%m_%d", localtime(time()));
	open(FILE,">".$g_file) or die("open file error $!\n");
	print FILE  <<EOF
#include<windows.h>
#include<stdlib.h>
#include<stdio.h>

int WINAPI WinMain (HINSTANCE hInstance, HINSTANCE hPrevInstance, PSTR szCmdLine, int iCmdShow)
{
	while(1)
	{
		printf("Do Some thing \\n");
		MessageBox (NULL, "Hello", "Hello Demo", MB_OK);
		OutputDebugString("winmain_gui ��ʼ������\\n");
		Sleep(10000);
	}

	return (0);
}

EOF
;
	close(FILE);

}

########################################################################
sub gen_winmain_daemon_cpp()
{
	$time=strftime("%Y_%m_%d", localtime(time()));
	open(FILE,">".$g_file) or die("open file error $!\n");
	print FILE  <<EOF
#include <windows.h>
#include<stdlib.h>
#include<stdio.h>
int APIENTRY WinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, LPSTR     lpCmdLine, int       nCmdShow)
{
	while(1)
	{
		printf("Do Some thing \\n");
		OutputDebugString("��ʼ������\\n");
		Sleep(1000);
	}
	return 0;
}

EOF
;
	close(FILE);

}
########################################################################
sub gen_lmyunit_cpp()
{
	$time=strftime("%Y_%m_%d", localtime(time()));
	open(FILE,">".$g_file) or die("open file error $!\n");
	print FILE  <<EOF

#include <stdlib.h>
#include <lmyunit/unitlib.h>
#include <stdio.h>
#include <string.h>
#include <iostream>
#include <string> 
#include <fstream>
#include <iterator>  
#include <vector> 
#include <algorithm>
#include <iostream> 
#include <map>
//$time  by greshem. 


MLogFile logger;
using namespace std;
int main(int argc, char *argv[])
{
	if(argc != 2)
    {
        printf("Usage: %s file_list \\n", argv[0]);
        exit(-1);
    }
    printf("%s\\n", "$g_file");

	logger.Instance(MString(argv[0])+".log", 1000);

	for(int i=0; i<100; i++)
	{
		logger.WriteError("test", "test");
	}

	MString str("$g_file");
	cout<<str.c_str()<<endl;
	return 0;
}
EOF
;
	close(FILE);
}

########################################################################
#���mfc daemon ������.
sub gen_mfc_daemon_cpp()
{
	$time=strftime("%Y_%m_%d", localtime(time()));
	open(FILE,">".$g_file) or die("open file error $!\n");
	print FILE  <<EOF
#include <afxwin.h>
//����һ��CWinApp��������
class CMinApp:public CWinApp
{
	public:
 		virtual BOOL InitInstance();
};

//����CWinApp��Ա����InitInstance()
BOOL CMinApp::InitInstance()                     //Ӧ�ó����ʼ��
{
	while(1)
	{
		system("ipconfig >> c:\\test");
		Sleep(1000);
	}
	return TRUE;
};

CMinApp HelloApp;   
EOF
;
	close(FILE);
}


########################################################################
#���mfc gui ������.
sub gen_mfc_gui_cpp()
{
	$time=strftime("%Y_%m_%d", localtime(time()));
	open(FILE,">".$g_file) or die("open file error $!\n");
	print FILE  <<EOF
#include <afxwin.h>
//����һ��CWinApp��������
class CMinApp:public CWinApp
{
public:
 virtual BOOL InitInstance();
};

//����CWinApp��Ա����InitInstance()
BOOL CMinApp::InitInstance()                     //Ӧ�ó����ʼ��
{
	CFrameWnd* pFrame=new CFrameWnd;     //��̬���������������
	pFrame->Create(0,_T("A Minimal MFC Program")); //����������
	pFrame->ShowWindow(SW_SHOWMAXIMIZED); //��ʾ������
	pFrame->UpdateWindow();                                         //ˢ��������
	AfxGetApp()->m_pMainWnd=pFrame;                   //ָ��Ӧ�ó���������
	return TRUE;
};

CMinApp HelloApp;   
EOF
;
	close(FILE);
}

########################################################################
#mfc ������.
sub gen_template_cpp()
{
	$time=strftime("%Y_%m_%d", localtime(time()));
	open(FILE,">".$g_file) or die("open file error $!\n");
	print FILE  <<EOF
this is mfc
EOF
;
	close(FILE);

}
sub gen_commlib_cpp()
{	
	$time=strftime("%Y_%m_%d", localtime(time()));
	open(FILE,">".$g_file) or die("open file error $!\n");
	print FILE  <<EOF
#include <windows.h>
#include <stdlib.h>
#include <iostream>
#include <string> 
#include <fstream>
#include <iterator>  
#include <vector> 
#include <iostream> 
#include <commLib/CommLib.h> 
using namespace std;
int main(int argc, char *argv[])
{
	if(argc != 2)
	{
		printf("Usage: %s file_list \\n", argv[0]);
		exit(-1);
	}
	printf("%s\\n", "$g_file");

  	CString tmp=CGlobalFunc::GetAppExe();

	string  str("$g_file");
	cout<<str.c_str()<<endl;
	return 0;
}
EOF
;



}
########################################################################
sub gen_stl_cpp()
{
	$time=strftime("%Y_%m_%d", localtime(time()));
	open(FILE,">".$g_file) or die("open file error $!\n");
	print FILE  <<EOF
#include <stdlib.h>
#include <iostream>
#include <string> 
#include <fstream>
#include <iterator>  
#include <vector> 
#include <iostream> 

#ifndef WINDOWSCODE
#include <unistd.h>
#endif

//$time by greshem. 

using namespace std;
int main(int argc, char *argv[])
{
	if(argc != 2)
	{
		printf("Usage: %s file_list \\n", argv[0]);
		exit(-1);
	}
	printf("%s\\n", "$g_file");


	string  str("$g_file");
	cout<<str.c_str()<<endl;
	return 0;
}
EOF
;
	close(FILE);
}
########################################################################
sub gen_lmyunit()
{
	$time=strftime("%Y_%m_%d", localtime(time()));
	#print $time;
	open(FILE,">".$g_file) or die("open file error $!\n");
	print FILE  <<EOF
//#include <QzjUnit.hpp>
//#include <Baselib.hpp>
//#include <dirent.h>

#include <stdlib.h>
#include <unitlib.h>
#include <stdio.h>
#include <string.h>
#include <iostream>
#include <string> 
#include <fstream>
#include <iterator>  
#include <vector> 
#include <algorithm>
#include <iostream> 
#include <map>
#include <gtest/gtest.h>
//$time by greshem. 


MLogFile logger;
using namespace std;
int main(int argc, char *argv[])
{
	if(argc != 2)
	{
		printf("Usage: %s file_list \\n", argv[0]);
		exit(-1);
	}
	printf("%s\\n", "$g_file");

	logger.Instance(MString(argv[0])+".log", 1000);
	logger.WriteError("test", "test");

	MString str("$g_file");
	cout<<str.c_str()<<endl;
	return 0;
}
EOF
;
	close(FILE);
}

print ("/bin/gen_makefile_from_file_latest.pl $g_file ");
system("/bin/gen_makefile_from_file_latest.pl $g_file ");

