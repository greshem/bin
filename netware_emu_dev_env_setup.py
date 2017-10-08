#coding:gbk

import os
import re
import sys
import site
import _winreg
import time
import glob

#���������࣬���ڷ�װ�������߻�������������
class dev_tools_env:
	HKCU = _winreg.HKEY_CURRENT_USER
	ENV = "Environment"
	PATH = "PATH"
	DEFAULT = u"%PATH%"

	def add_path_to_ENV_PATH(self, add_path):
		with _winreg.CreateKey(dev_tools_env.HKCU, dev_tools_env.ENV) as key:
			try:
				envpath = _winreg.QueryValueEx(key, dev_tools_env.PATH)[0]
			except WindowsError:
				envpath = dev_tools_env.DEFAULT

			#Ĭ����ӵķ�ʽ.  
			paths = [envpath]
			if add_path and add_path not in envpath and os.path.isdir(add_path):
				paths.append(add_path)

			envpath = os.pathsep.join(paths)
			_winreg.SetValueEx(key, dev_tools_env.PATH, 0, _winreg.REG_EXPAND_SZ, envpath)
			return paths, envpath

	def main(self):
		paths, envpath = dev_tools_env.add_path_to_ENV_PATH(self, "c:\\bin");
		paths, envpath = dev_tools_env.add_path_to_ENV_PATH(self, "c:\\cygwin\\bin");
		paths, envpath = dev_tools_env.add_path_to_ENV_PATH(self, "C:\\Ruby192\\bin");

		paths, envpath = dev_tools_env.add_path_to_ENV_PATH(self, "c:\\Perl\\bin");
		paths, envpath = dev_tools_env.add_path_to_ENV_PATH(self, "C:\\Program Files\\Vim\\vim73");

		#C:\Program Files\Wireshark
		paths, envpath = dev_tools_env.add_path_to_ENV_PATH(self, "C:\\Program Files\\Wireshark");

		#C:\\Program Files\\Ext2Fsd
		paths, envpath = dev_tools_env.add_path_to_ENV_PATH(self, "C:\\Program Files\\Ext2Fsd");

		#C:\Program Files\Subversion\bin
		paths, envpath = dev_tools_env.add_path_to_ENV_PATH(self, "C:\\Program Files\\Subversion\\bin");
		#C:\Program Files\Bakefile
		paths, envpath = dev_tools_env.add_path_to_ENV_PATH(self, "C:\\Program Files\\Bakefile");
			
		paths, envpath = dev_tools_env.add_path_to_ENV_PATH(self, "C:\\Bakefile");
		print _winreg.ExpandEnvironmentStrings(envpath)
	#��ӿ������ߵĻ���������ע���
	def add_prog_bin_path_to_ENV_PATH(self):
		if __name__ == '__main__':
			dev_tools_env.main(self)
##############################################################
##############################################################
##############################################################

		
#vc2003�࣬���ڷ�װvc2003��������������
class vc2003_env:
	data={

		"C:\Program Files\Microsoft Visual Studio .NET 2003\SDK\\v1.1\include":"INCLUDE",
		"C:\Program Files\Microsoft Visual Studio .NET 2003\VC7\ATLMFC\INCLUDE": "INCLUDE",
		"C:\Program Files\Microsoft Visual Studio .NET 2003\VC7\INCLUDE": "INCLUDE",
		"C:\Program Files\Microsoft Visual Studio .NET 2003\VC7\PlatformSDK\include": "INCLUDE",
		"C:\Program Files\Microsoft Visual Studio .NET 2003\VC7\PlatformSDK\include\prerelease": "INCLUDE",

		

		"C:\Program Files\Microsoft Visual Studio .NET 2003\SDK\\v1.1\Lib":"LIB",
		"C:\Program Files\Microsoft Visual Studio .NET 2003\SDK\\v1.1\lib": "LIB",
		"C:\Program Files\Microsoft Visual Studio .NET 2003\VC7\ATLMFC\LIB": "LIB",
		"C:\Program Files\Microsoft Visual Studio .NET 2003\VC7\LIB": "LIB",
		"C:\Program Files\Microsoft Visual Studio .NET 2003\VC7\PlatformSDK\lib": "LIB",
		"C:\Program Files\Microsoft Visual Studio .NET 2003\VC7\PlatformSDK\lib\prerelease": "LIB",

	

		"C:\Program Files\Microsoft Visual Studio .NET 2003\Common7\IDE":"PATH",
		"C:\Program Files\Microsoft Visual Studio .NET 2003\Common7\Tools" :"PATH",
		"C:\Program Files\Microsoft Visual Studio .NET 2003\Common7\Tools\\bin" :"PATH",
		"C:\Program Files\Microsoft Visual Studio .NET 2003\Common7\Tools\\bin\prerelease" :"PATH",
		"C:\Program Files\Microsoft Visual Studio .NET 2003\SDK\\v1.1\\bin" :"PATH",
		"C:\Program Files\Microsoft Visual Studio .NET 2003\VC7\\BIN" :"PATH",
		
		};

	HKCU = _winreg.HKEY_CURRENT_USER
	ENV = "Environment"
	PATH = "PATH"
	LIB = "LIB"
	INCLUDE = "INCLUDE"
	DEFAULT = u"%PATH%"

	env={};

	def _change_to_register_pattern(self, data_str):
		vc2003_env.env={};
		for key in data_str.keys():
			value=data_str[key];
			print "%s --> %s" %(key, value);
			if not vc2003_env.env.has_key(value) :
				vc2003_env.env[value]=key;
			else:
				tmp=("%s;%s")% (vc2003_env.env[value], key);
				vc2003_env.env[value]=tmp;
		return vc2003_env.env;
		
	def _modify_env(self, path):
		#with ���÷��� ��������һ������. 
		#��HKEY_CURRENT_USER/Environment/$path �»�ȡ string1;string2;string3���ַ���. 
		#���粻�ٴ� 2003 �ַ��� ����� vc2003_str1;vc2003_str2;vc2003_str3 �������ַ���.  

		with _winreg.CreateKey(vc2003_env.HKCU, vc2003_env.ENV) as key:
			try:
				envpath = _winreg.QueryValueEx(key, path)[0]
			except WindowsError:
				print "queryValueEx error"
				envpath = vc2003_env.DEFAULT
		
			rets=[envpath];
			paths=[envpath];
			if not "2003\\" in envpath:
				rets.append(vc2003_env.env[path]);
			else:
				print "##vc2003 have add ";
			
			reg_string = os.pathsep.join(rets)
			print  "DDD:%s"%reg_string;
			_winreg.SetValueEx(key, path, 0, _winreg.REG_EXPAND_SZ, reg_string)
			return paths, envpath

	def _expand_path(self, envpath):
		print "Expanded:"
		all=_winreg.ExpandEnvironmentStrings(envpath)
		array=all.split(";");
		array.sort();
		for key in array:
			print key;    
            
	def main(self, path):
		paths, envpath = vc2003_env._modify_env(self, path)
		if len(paths) > 1:
			print "Path(s) added:"
			print '\n'.join(paths[1:])
		else:
			print "No path was added"
		print "\nPATH is now:\n%s\n" % envpath
		vc2003_env._expand_path(self, envpath);
	
	#���vc2003����������ע���
	def add_vc2003_dev_env(self): 
		if __name__ == '__main__':
			env=vc2003_env._change_to_register_pattern(self, vc2003_env.data)
			vc2003_env.main(self, vc2003_env.PATH)
			vc2003_env.main(self, vc2003_env.LIB)
			vc2003_env.main(self, vc2003_env.INCLUDE)
##############################################################
##############################################################
##############################################################


class create:
	dir_array=["D:\\usr\\", "D:\\usr\\include\\", "D:\\usr\\include\\mswud\\", "D:\\usr\\include\\cppunit\\", "D:\\usr\\lib\\"]
	#��D:\����usrĿ¼����һϵ����Ŀ¼
	def create_dir(self):
		for dir_path in create.dir_array:
			path="md "+dir_path
			if not os.path.exists(dir_path):
				os.system(path)
##############################################################
##############################################################
##############################################################


class check:
	#���bakefile��vc2003���������Ƿ�����ϵͳ����������
	def check_env(self):
		bake = ('C:\\Bakefile')
		bake_pro = ('C:\\Program Files\\Bakefile')
		vc2003 = ('C:\\Program Files\\Microsoft Visual Studio .NET 2003\\Vc7\\bin')
		vc2003_upper = ('C:\\Program Files\\Microsoft Visual Studio .NET 2003\\VC7\\BIN')
		pathlist=os.environ['PATH'].split(os.pathsep)
		if (bake in pathlist or bake_pro in pathlist) and (vc2003 in pathlist or vc2003_upper in pathlist):		
			return 1
		else:
			return 0
##############################################################
##############################################################
##############################################################


class bakefile:
	#��װBakefile
	def install_bakefile(self):
		print "#########################################################################################"
		print "********************************��ʼ��װbakefile��������*********************************"
		print
		time.sleep(1)
		if not os.path.exists("C:\\Bakefile\\bakefile.exe") and not os.path.exists("C:\\Program Files\\Bakefile\\bakefile.exe"):
			if not os.path.exists("bakefile-0.2.9-setup.exe"):
				print "��⵽Bakefileû�а�װ��C:\\��C:\\Program Files\\Ŀ¼��"
				if os.path.exists("C:\\cygwin\\bin\\wget.exe"):
					os.system("C:\\cygwin\\bin\\wget.exe http://jaist.dl.sourceforge.net/project/bakefile/bakefile/0.2.9/bakefile-0.2.9-setup.exe")
				else:
					print "�뵽������ַȥ����:http://jaist.dl.sourceforge.net/project/bakefile/bakefile/0.2.9/bakefile-0.2.9-setup.exe"
					print "���غ�,�뽫bakefile-0.2.9-setup.exe�ŵ���ǰĿ¼,�벻Ҫ�ֶ���װBakefile"
					print "Ȼ��������д˽ű�,ѡ��װ��C:\\��C:\\Program Files\\Ŀ¼��"
					sys.exit();	
			#��װcppunit��C:\\��C:\\Program Files\\		
			os.system('bakefile-0.2.9-setup.exe')
			dev_tools_class=dev_tools_env()
			dev_tools_class.add_prog_bin_path_to_ENV_PATH()
			print "**************************��ϲ,bakefile�������߰�װ�ɹ�******************************"
		else:
			print "****************************bakefile���������Ѿ���װ��*******************************"
		print
##############################################################
##############################################################
##############################################################


class gtest:
	#����build.bkl�ļ�
	def _create_gtest_bkl(self):
		build_data = '''<?xml version="1.0" ?>
	<!-- $Id: bakefile_quickstart.txt,v 1.5 2006/02/11 18:41:11 KO Exp $ -->
		
	<makefile>
		
			<lib id="gtest">
				<cxxflags>/Od</cxxflags>
				<cxxflags>/D_DEBUG</cxxflags>
				<cxxflags>/D_LIB</cxxflags>
				<cxxflags>/D_MBCS</cxxflags>
				<cxxflags>/Gm</cxxflags>
				<cxxflags>/RTC1</cxxflags>
				<cxxflags>/W3</cxxflags>
				<cxxflags>/TP</cxxflags>
				<cxxflags>/ZI</cxxflags>
				<cxxflags>/MTd</cxxflags>
				<ldflags>/NOLOGO</ldflags>
				<include>include</include>
				<sys-lib>kernel32</sys-lib>
				<sys-lib>user32</sys-lib>
				<sys-lib>gdi32</sys-lib>
				<sys-lib>winspool</sys-lib>
				<sys-lib>comdlg32</sys-lib>
				<sys-lib>advapi32</sys-lib>
				<sys-lib>shell32</sys-lib>
				<sys-lib>ole32</sys-lib>
				<sys-lib>oleaut32</sys-lib>
				<sys-lib>uuid</sys-lib>
				<sys-lib>odbccp32</sys-lib>
				<sys-lib>ws2_32</sys-lib>
				<sources>$(fileList('gtest-all.cc'))</sources>
			</lib>
			
	</makefile>'''
		f = open("build.bkl", "wt")
		f.write(build_data)
		f.close()

	#��������gtest.lib,����gtest.lib��D:\usr\libĿ¼,����include�ļ��е�D:\usr\includeĿ¼
	def _compile_gtest_copy(self):
		if not os.path.exists("C:\\Program Files\\Microsoft Visual Studio .NET 2003\\"):
			print "��⵽vc2003��������û�а�װ��C:\\Program Files\\Ŀ¼��"
			print "�뵽������ַȥ����:ftp://dshare:dshare@61.145.69.100/sc_VS.net_2003_enar.rar"
			print "���ֶ���װvc2003��C:\\Program Files\\,Ȼ��������д˽ű�"
			sys.exit();
		vc2003_class=vc2003_env()
		vc2003_class.add_vc2003_dev_env()
		check_class=check()
		if 0==check_class.check_env():
			print "��ע���������д˽ű�"
			sys.exit();
		os.system("bakefile -f msvc build.bkl")
		os.system("nmake /f makefile.vc")
		os.system("del gtest-all.cc")
		if 0!=os.system("copy /y gtest.lib D:\\usr\\lib\\"):
			print "copy /y gtest.lib D:\\usr\\lib\\ failed, please check"
			sys.exit()
		if 0!=os.system("xcopy /y /S include D:\\usr\\include"):
			print "copy xcopy /y /S include D:\\usr\\include failed, please check"
			sys.exit()
		
	#��װgtest
	def install_gtest(self):
		print "#########################################################################################"
		print "*********************************��ʼ��װgtest��������***********************************"
		print
		time.sleep(1)
		if not os.path.exists("D:\\usr\\include\\gtest\\") or not os.path.exists("D:\\usr\\lib\\gtest.lib"):
			if not os.path.exists("gtest-1.6.0.zip"):
				print "��⵽gtest��������û�а�װ"
				if os.path.exists("C:\\cygwin\\bin\\wget.exe"):
					os.system("C:\\cygwin\\bin\\wget.exe http://googletest.googlecode.com/files/gtest-1.6.0.zip")
				else:
					print "�뵽������ַȥ����:http://googletest.googlecode.com/files/gtest-1.6.0.zip"
					print "���غ�,�뽫gtest.zip�ŵ���ǰĿ¼,Ȼ��������д˽ű�,�벻Ҫ�ֶ���װgtest"
					sys.exit();
			#��ѹgtest.zip
			if not os.path.exists("gtest-1.6.0"):
				if os.path.exists("C:\\Program Files\\WinRAR\\WinRar.exe"): 
					os.system('"C:\\Program Files\\WinRAR\\WinRar.exe" x gtest-1.6.0.zip')
				else:
					print "��⵽WinRARû�а�װ��C:\\Program Files\\Ŀ¼��"
					print "���ֶ���װWinRAR��C:\\Program Files\\,Ȼ�������д˽ű�"
					sys.exit()
		
			os.chdir("gtest-1.6.0")
			os.system("copy /y src\\gtest-all.cc .")
			gtest._create_gtest_bkl(self)
			gtest._compile_gtest_copy(self)
			os.chdir("..")
			print "******************************��ϲ,gtest�������߰�װ�ɹ�********************************"
		else:
			print "*******************************gtest���������Ѿ���װ��**********************************"
		print

##############################################################
##############################################################
##############################################################
		
class cppunit:
	#����build.bkl�ļ�
	def _create_cppunit_bkl(self):
		build_data='''<?xml version="1.0" ?>
	<!-- $Id: bakefile_quickstart.txt,v 1.5 2006/02/11 18:41:11 KO Exp $ -->

	<makefile>
		
			<lib id="cppunitd">
				<cxxflags>/Od</cxxflags>
				<cxxflags>/D_DEBUG</cxxflags>
				<cxxflags>/D_LIB</cxxflags>
				<cxxflags>/D_MBCS</cxxflags>
				<cxxflags>/GR</cxxflags>
				<cxxflags>/RTC1</cxxflags>
				<cxxflags>/W3</cxxflags>
				<cxxflags>/TP</cxxflags>
				<cxxflags>/ZI</cxxflags>
				<cxxflags>/MTd</cxxflags>
				<cxxflags>/nologo</cxxflags>
				<ldflags>/NOLOGO</ldflags>
				<include>../../include</include>
				<sys-lib>kernel32</sys-lib>
				<sys-lib>user32</sys-lib>
				<sys-lib>gdi32</sys-lib>
				<sys-lib>winspool</sys-lib>
				<sys-lib>comdlg32</sys-lib>
				<sys-lib>advapi32</sys-lib>
				<sys-lib>shell32</sys-lib>
				<sys-lib>ole32</sys-lib>
				<sys-lib>oleaut32</sys-lib>
				<sys-lib>uuid</sys-lib>
				<sys-lib>odbccp32</sys-lib>
				<sys-lib>ws2_32</sys-lib>
				<sources>$(fileList('A*.cpp'))</sources>
				<sources>$(fileList('B*.cpp'))</sources>
				<sources>$(fileList('C*.cpp'))</sources>
				<sources>$(fileList('E*.cpp'))</sources>
				<sources>$(fileList('M*.cpp'))</sources>
				<sources>$(fileList('P*.cpp'))</sources>
				<sources>$(fileList('R*.cpp'))</sources>
				<sources>$(fileList('S*.cpp'))</sources>
				<sources>$(fileList('T*.cpp'))</sources>
				<sources>$(fileList('U*.cpp'))</sources>
				<sources>$(fileList('W*.cpp'))</sources>
				<sources>$(fileList('X*.cpp'))</sources>
				<sources>$(fileList('DefaultProtector.cpp'))</sources>
				<sources>$(fileList('DynamicLibraryManager.cpp'))</sources>
				<sources>$(fileList('DynamicLibraryManagerException.cpp'))</sources>
			</lib>
			
	</makefile>'''
		f = open("build.bkl", "wt")
		f.write(build_data)
		f.close();

	#��������cppunitd.lib������cppunitd.lib��D:\usr\libĿ¼������../../include/cppunit�ļ��е�D:\usr\include\cppunitĿ¼
	def _compile_cppunit_copy(self):
		os.system("bakefile -f msvc build.bkl")
		os.system("nmake /f makefile.vc")
		if 0!=os.system("copy /y cppunitd.lib D:\\usr\\lib\\"):
			print "copy /y cppunitd.lib D:\\usr\\lib\\ failed, please check"
			sys.exit()
		if 0!=os.system("xcopy /y /S ..\\..\\include\\cppunit D:\\usr\\include\\cppunit\\"):
			print "xcopy /y /S ..\\..\\include\\cppunit D:\\usr\\include\\cppunit\\ failed, please check"
			sys.exit()
		
	#��װcppUnit
	def install_cppunit(self):
		print "#########################################################################################"
		print "*********************************��ʼ��װcppunit��������*********************************"
		print
		time.sleep(1)
		if not os.path.exists("D:\\usr\\include\\cppunit\\config") or not os.path.exists("D:\\usr\\lib\\cppunitd.lib"):
			if not os.path.exists("cppunit-1.10.2.tar.gz"):
				print "��⵽cppunit��������û�а�װ"
				if os.path.exists("C:\\cygwin\\bin\\wget.exe"):
					os.system("C:\\cygwin\\bin\\wget.exe http://down1.chinaunix.net/distfiles/cppunit-1.10.2.tar.gz")
				else:
					print "�뵽������ַȥ����:http://down1.chinaunix.net/distfiles/cppunit-1.10.2.tar.gz"
					print "���غ�,�뽫cppunit-1.10.2.tar.gz�ŵ���ǰĿ¼,Ȼ��������д˽ű�,�벻Ҫ�ֶ���װ"
					sys.exit();
			
			#��ѹcppunit
			if not os.path.exists("cppunit-1.10.2"):
				os.system('"C:\\Program Files\\WinRAR\\WinRar.exe" x cppunit-1.10.2.tar.gz')
			os.chdir("cppunit-1.10.2\\src\\cppunit\\")
			cppunit._create_cppunit_bkl(self)
			cppunit._compile_cppunit_copy(self)		
			os.chdir("..\\..\\..")
			print "*******************************��ϲ,cppunit�������߰�װ�ɹ�**********************************"
		else:
			print "*******************************cppunit�������߰�װ���**********************************"
		print

##############################################################
##############################################################
##############################################################
		
class wxWidgets:
	wx_array=["C:\\wxWidgets-2.8.10\\",
	"C:\\works\\wxWidgets-2.8.10\\",
	"D:\\works\\wxWidgets-2.8.10\\",
	"D:\\tmp\\wxWidgets-2.8.10\\",
	"D:\\wxWidgets-2.8.10\\",
	"E:\\tmp\\wxWidgets-2.8.10\\",
	"E:\\works\\wxWidgets-2.8.10\\",
	"E:\\wxWidgets-2.8.10\\",
	]
	
	#�޸�setup.h�ļ�
	def _modify_setup(self):
		os.system('rename setup.h tmp.h')
		dll = re.compile('\.\./lib/vc_dll/')
		lib = re.compile('\.\./lib/vc_lib/')
		f = file("tmp.h","rb")
		p = file("setup.h","wb+")
		while True:
			line = f.readline()
			if len(line) == 0: # Zero length indicates EOF
				break
			if dll.search(line):
				line = dll.sub('', line, 1)
			if lib.search(line):
				line = lib.sub('', line, 1)
			p.write(line)
		f.close()
		p.close()
		os.system("del tmp.h")
			
	#�޸�wxWidgets-2.8.10/include/msvc/Ŀ¼�µ�setup.h�ļ�
	def _modify_setup_headfile(self):
		path="include\\msvc\\wx\\"
		find=0
		for tmp_path in wxWidgets.wx_array:
			wx_path=tmp_path+path
			if os.path.exists(wx_path):
				os.chdir(wx_path)
				find=1
				break
		if 0==find:	
			print wx_path+" Ŀ¼������,ȡ����һ����װ,��ɾ��wxWdiegst-2.8.10�ļ��к�,�ټ�����װ"
			sys.exit()
		#ʹ��sed
		if os.path.exists("C:\\cygwin\\bin\\sed.exe"):
			os.system("C:\\cygwin\\bin\\sed.exe -e 's/\.\.\/lib\/vc_dll\///g' -i setup.h") 
			os.system("C:\\cygwin\\bin\\sed.exe -e 's/\.\.\/lib\/vc_lib\///g' -i setup.h")
		else:
			wxWidgets._modify_setup(self)

	#����includeĿ¼��D:\usr\include	
	def _copy_include(self):
		if os.path.exists("..\\..\\..\\"):
			os.chdir("..\\..\\..\\")
		else:
			print os.getcwd()+os.sep+"..\\..\\..\\"+" Ŀ¼������,ȡ����һ����װ,��ɾ��wxWdiegst-2.8.10�ļ��к�,�ټ�����װ"
			sys.exit()
		os.system("xcopy /y /S include D:\\usr\\include\\")

	#����wx.bkl��wx_win32.bkl��BakefileĿ¼�µ�presetsĿ¼
	def _copy_wx_bkl(self):
		if os.path.exists("build\\bakefiles\\wxpresets\\presets\\"):
			os.chdir("build\\bakefiles\\wxpresets\\presets\\")
		else:
			print os.getcwd()+os.sep+"build\\bakefiles\\wxpresets\\presets\\"+" Ŀ¼������,ȡ����һ����װ,��ɾ��wxWdiegst-2.8.10�ļ��к�,�ټ�����װ"
			sys.exit()
		if os.path.exists("C:\\Bakefile\\"):
			os.system("copy /y wx.bkl C:\\Bakefile\\presets\\")
			os.system("copy /y wx_win32.bkl C:\\Bakefile\\presets\\")
		elif  os.path.exists("C:\\Program Files\\Bakefile\\"):
			os.system('copy /y wx.bkl "C:\\Program Files\\Bakefile\\presets\\"')
			os.system('copy /y wx_win32.bkl "C:\\Program Files\\Bakefile\\presets\\"')
	
	#�޸�config.vc�ļ�
	def _modify_config(self):
		os.system("rename config.vc tmp.vc")
		f=file("tmp.vc", "rb")
		p=file("config.vc", "wb+")
		match_shared=re.compile(r'SHARED = 0')
		match_unicode=re.compile(r'UNICODE = 0')
		while True:
			line=f.readline()
			if len(line)==0:
				break
			if match_shared.search(line):
				line=match_shared.sub('SHARED = 1', line, 1)
			if match_unicode.search(line):
				line=match_unicode.sub('UNICODE = 1', line, 1)
			p.write(line)
		f.close()
		p.close()
		os.system("del tmp.vc")
	
	#�޸�config.vc�ļ����������ɶ�̬��
	def _modify_config_dll(self):
		if os.path.exists("..\\..\\..\\msw\\"):
			os.chdir("..\\..\\..\\msw\\")
		else:
			print os.getcwd()+os.sep+"..\\..\\..\\msw\\"+" Ŀ¼������,ȡ����һ����װ,��ɾ��wxWdiegst-2.8.10�ļ��к�,�ټ�����װ"
			sys.exit()
		#����ʹ��sed
		if os.path.exists("C:\\cygwin\\bin\\sed.exe"):
			os.system("sed -e 's/SHARED = 0/SHARED = 1/g' -i config.vc") 
			os.system("sed -e 's/UNICODE = 0/UNICODE = 1/g' -i config.vc")
		else:
			wxWidgets._modify_config(self)	

	#����lib�ļ���D:\usr\lib
	def _copy_lib(self):
		if os.path.exists("..\\..\\lib\\vc_dll\\"):
			os.chdir("..\\..\\lib\\vc_dll\\")
		else:
			print os.getcwd()+os.sep+"..\\..\\lib\\vc_dll\\"+" Ŀ¼������,ȡ����һ����װ,��ɾ��wxWdiegst-2.8.10�ļ��к�,�ټ�����װ"
			sys.exit()
		if 0!=os.system("copy /y *.lib D:\\usr\\lib"):
			print "copy /y *.lib D:\\usr\\lib failed, please check"
			sys.exit()

	#����mswud�ļ��е�D:\usr\include\mswud\������dll�ļ���ϵͳĿ¼�Լ�D:\usr\lib
	def _copy_mswud_dll(self):
		if 0!=os.system("xcopy /y /S mswud D:\\usr\\include\\mswud\\"):
			print "xcopy /y /S mswud D:\\usr\\include\\mswud\\ failed, please check"
			sys.exit()
		if 0!=os.system("copy /y *.dll C:\\WINDOWS\\"):	
			print "copy /y *.dll C:\\WINDOWS\\ failed, please check"
			sys.exit()
		if 0!=os.system("copy /y *.dll D:\\usr\\lib"):	
			print "copy /y *.dll D:\\usr\\lib failed, please check"
			sys.exit()
			
	#��װwxWidgets
	def install_wxWidgets(self,cur_dir):
		print "#########################################################################################"
		print "*******************************��ʼ��װwxWidgets��������*********************************"
		print
		print "wxWidgets���ᱻ����ɶ�̬��"
		print "��ʹ�ñ���wxUniversal�����汾�ض˿�"
		print "ʹ��utf-8����"
		print "ʹ��utf-8����ʱ����ʹ��MSLU��"
		time.sleep(1)
		#��ѹ��wxWidgets��װ��
		find=0
		for path in wxWidgets.wx_array:
			if os.path.exists(path):
				find=1
				break
		if 0==find:
			if os.path.exists("wxWidgets-2.8.10.tar.gz"):
				os.system('"C:\\Program Files\\WinRAR\\WinRar.exe" x wxWidgets-2.8.10.tar.gz C:\\')
			if os.path.exists("wxWidgets-2.8.10.tar.bz2"):
				os.system('"C:\\Program Files\\WinRAR\\WinRar.exe" x wxWidgets-2.8.10.tar.bz2 C:\\')
			if os.path.exists("wxWidgets-2.8.10.zip"):
				os.system('"C:\\Program Files\\WinRAR\\WinRar.exe" x wxWidgets-2.8.10.zip C:\\')
		
		wxWidgets._modify_setup_headfile(self)
		wxWidgets._copy_include(self)
		wxWidgets._copy_wx_bkl(self)
		wxWidgets._modify_config_dll(self)
		#�������ɶ�̬��
		os.system("nmake /f makefile.vc")
		wxWidgets._copy_lib(self)
		wxWidgets._copy_mswud_dll(self)
		os.chdir(cur_dir)
		print "*******************************wxWidgets�������߰�װ���*********************************"
		print

##############################################################
##############################################################
##############################################################
		
class clean:
	def clean_tmp_file(self):
		print "#########################################################################################"
		print "***********************************��ʼ������ʱ�ļ�**************************************"
		print
		time.sleep(1)
		if os.path.exists("cppunit-1.10.2"):
			os.system("rd /s /q cppunit-1.10.2")
		if os.path.exists("gtest-1.6.0"):
			os.system("rd /s /q gtest-1.6.0")
		tmp_py=glob.glob('*.html')
		if len(tmp_py)!=0:
			for tmp in tmp_py:
				os.remove(tmp)
		tmp_py=glob.glob('*.htm')
		if len(tmp_py)!=0:
			for tmp in tmp_py:
				os.remove(tmp)
		tmp_py=glob.glob('*.txt')
		if len(tmp_py)!=0:
			for tmp in tmp_py:
				os.remove(tmp)
		print "*********************************��ʱ�ļ�����������************************************"
		print

##############################################################
##############################################################
##############################################################
		
class cmdhere:
	def reg_cmdhere(self):
		if not os.path.exists("cmdhere.reg"):
			data='''Windows Registry Editor Version 5.00

[HKEY_CLASSES_ROOT\*\shell\cmdhere\command]
@="cmd.exe /c start cmd.exe /k echo  \"%L\\..\""

'''
			f=open("cmdhere.reg","wt")
			f.write(data)
			f.close()
			os.system("cmdhere.reg")
##############################################################
##############################################################
##############################################################

			
create_class=create()
create_class.create_dir()

bakefile_class=bakefile()
bakefile_class.install_bakefile()

gtest_class=gtest()
gtest_class.install_gtest()

cppunit_class=cppunit()
cppunit_class.install_cppunit()

cur_dir=os.getcwd()
wxWidgets_class=wxWidgets()
wxWidgets_class.install_wxWidgets(cur_dir)

cmdhere_class=cmdhere()
cmdhere_class.reg_cmdhere()

clean_class=clean()
clean_class.clean_tmp_file()
