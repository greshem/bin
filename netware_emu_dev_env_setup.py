#coding:gbk

import os
import re
import sys
import site
import _winreg
import time
import glob

#开发工具类，用于封装开发工具环境变量的数据
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

			#默认添加的方式.  
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
	#添加开发工具的环境变量到注册表
	def add_prog_bin_path_to_ENV_PATH(self):
		if __name__ == '__main__':
			dev_tools_env.main(self)
##############################################################
##############################################################
##############################################################

		
#vc2003类，用于封装vc2003环境变量的数据
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
		#with 的用法， 用来生成一个对象. 
		#从HKEY_CURRENT_USER/Environment/$path 下获取 string1;string2;string3的字符串. 
		#假如不再存 2003 字符串 就添加 vc2003_str1;vc2003_str2;vc2003_str3 这样的字符串.  

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
	
	#添加vc2003环境变量到注册表
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
	#在D:\创建usr目录及其一系列子目录
	def create_dir(self):
		for dir_path in create.dir_array:
			path="md "+dir_path
			if not os.path.exists(dir_path):
				os.system(path)
##############################################################
##############################################################
##############################################################


class check:
	#检查bakefile和vc2003环境变量是否已在系统环境变量中
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
	#安装Bakefile
	def install_bakefile(self):
		print "#########################################################################################"
		print "********************************开始安装bakefile开发工具*********************************"
		print
		time.sleep(1)
		if not os.path.exists("C:\\Bakefile\\bakefile.exe") and not os.path.exists("C:\\Program Files\\Bakefile\\bakefile.exe"):
			if not os.path.exists("bakefile-0.2.9-setup.exe"):
				print "检测到Bakefile没有安装在C:\\或C:\\Program Files\\目录下"
				if os.path.exists("C:\\cygwin\\bin\\wget.exe"):
					os.system("C:\\cygwin\\bin\\wget.exe http://jaist.dl.sourceforge.net/project/bakefile/bakefile/0.2.9/bakefile-0.2.9-setup.exe")
				else:
					print "请到如下网址去下载:http://jaist.dl.sourceforge.net/project/bakefile/bakefile/0.2.9/bakefile-0.2.9-setup.exe"
					print "下载后,请将bakefile-0.2.9-setup.exe放到当前目录,请不要手动安装Bakefile"
					print "然后接着运行此脚本,选择安装到C:\\或C:\\Program Files\\目录下"
					sys.exit();	
			#安装cppunit到C:\\或C:\\Program Files\\		
			os.system('bakefile-0.2.9-setup.exe')
			dev_tools_class=dev_tools_env()
			dev_tools_class.add_prog_bin_path_to_ENV_PATH()
			print "**************************恭喜,bakefile开发工具安装成功******************************"
		else:
			print "****************************bakefile开发工具已经安装了*******************************"
		print
##############################################################
##############################################################
##############################################################


class gtest:
	#生成build.bkl文件
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

	#编译生成gtest.lib,拷贝gtest.lib到D:\usr\lib目录,拷贝include文件夹到D:\usr\include目录
	def _compile_gtest_copy(self):
		if not os.path.exists("C:\\Program Files\\Microsoft Visual Studio .NET 2003\\"):
			print "检测到vc2003开发工具没有安装在C:\\Program Files\\目录下"
			print "请到如下网址去下载:ftp://dshare:dshare@61.145.69.100/sc_VS.net_2003_enar.rar"
			print "请手动安装vc2003到C:\\Program Files\\,然后接着运行此脚本"
			sys.exit();
		vc2003_class=vc2003_env()
		vc2003_class.add_vc2003_dev_env()
		check_class=check()
		if 0==check_class.check_env():
			print "请注销后，再运行此脚本"
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
		
	#安装gtest
	def install_gtest(self):
		print "#########################################################################################"
		print "*********************************开始安装gtest开发工具***********************************"
		print
		time.sleep(1)
		if not os.path.exists("D:\\usr\\include\\gtest\\") or not os.path.exists("D:\\usr\\lib\\gtest.lib"):
			if not os.path.exists("gtest-1.6.0.zip"):
				print "检测到gtest开发工具没有安装"
				if os.path.exists("C:\\cygwin\\bin\\wget.exe"):
					os.system("C:\\cygwin\\bin\\wget.exe http://googletest.googlecode.com/files/gtest-1.6.0.zip")
				else:
					print "请到如下网址去下载:http://googletest.googlecode.com/files/gtest-1.6.0.zip"
					print "下载后,请将gtest.zip放到当前目录,然后接着运行此脚本,请不要手动安装gtest"
					sys.exit();
			#解压gtest.zip
			if not os.path.exists("gtest-1.6.0"):
				if os.path.exists("C:\\Program Files\\WinRAR\\WinRar.exe"): 
					os.system('"C:\\Program Files\\WinRAR\\WinRar.exe" x gtest-1.6.0.zip')
				else:
					print "检测到WinRAR没有安装在C:\\Program Files\\目录下"
					print "请手动安装WinRAR到C:\\Program Files\\,然后在运行此脚本"
					sys.exit()
		
			os.chdir("gtest-1.6.0")
			os.system("copy /y src\\gtest-all.cc .")
			gtest._create_gtest_bkl(self)
			gtest._compile_gtest_copy(self)
			os.chdir("..")
			print "******************************恭喜,gtest开发工具安装成功********************************"
		else:
			print "*******************************gtest开发工具已经安装了**********************************"
		print

##############################################################
##############################################################
##############################################################
		
class cppunit:
	#生成build.bkl文件
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

	#编译生成cppunitd.lib、拷贝cppunitd.lib到D:\usr\lib目录、拷贝../../include/cppunit文件夹到D:\usr\include\cppunit目录
	def _compile_cppunit_copy(self):
		os.system("bakefile -f msvc build.bkl")
		os.system("nmake /f makefile.vc")
		if 0!=os.system("copy /y cppunitd.lib D:\\usr\\lib\\"):
			print "copy /y cppunitd.lib D:\\usr\\lib\\ failed, please check"
			sys.exit()
		if 0!=os.system("xcopy /y /S ..\\..\\include\\cppunit D:\\usr\\include\\cppunit\\"):
			print "xcopy /y /S ..\\..\\include\\cppunit D:\\usr\\include\\cppunit\\ failed, please check"
			sys.exit()
		
	#安装cppUnit
	def install_cppunit(self):
		print "#########################################################################################"
		print "*********************************开始安装cppunit开发工具*********************************"
		print
		time.sleep(1)
		if not os.path.exists("D:\\usr\\include\\cppunit\\config") or not os.path.exists("D:\\usr\\lib\\cppunitd.lib"):
			if not os.path.exists("cppunit-1.10.2.tar.gz"):
				print "检测到cppunit开发工具没有安装"
				if os.path.exists("C:\\cygwin\\bin\\wget.exe"):
					os.system("C:\\cygwin\\bin\\wget.exe http://down1.chinaunix.net/distfiles/cppunit-1.10.2.tar.gz")
				else:
					print "请到如下网址去下载:http://down1.chinaunix.net/distfiles/cppunit-1.10.2.tar.gz"
					print "下载后,请将cppunit-1.10.2.tar.gz放到当前目录,然后接着运行此脚本,请不要手动安装"
					sys.exit();
			
			#解压cppunit
			if not os.path.exists("cppunit-1.10.2"):
				os.system('"C:\\Program Files\\WinRAR\\WinRar.exe" x cppunit-1.10.2.tar.gz')
			os.chdir("cppunit-1.10.2\\src\\cppunit\\")
			cppunit._create_cppunit_bkl(self)
			cppunit._compile_cppunit_copy(self)		
			os.chdir("..\\..\\..")
			print "*******************************恭喜,cppunit开发工具安装成功**********************************"
		else:
			print "*******************************cppunit开发工具安装完成**********************************"
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
	
	#修改setup.h文件
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
			
	#修改wxWidgets-2.8.10/include/msvc/目录下的setup.h文件
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
			print wx_path+" 目录不存在,取消进一步安装,请删除wxWdiegst-2.8.10文件夹后,再继续安装"
			sys.exit()
		#使用sed
		if os.path.exists("C:\\cygwin\\bin\\sed.exe"):
			os.system("C:\\cygwin\\bin\\sed.exe -e 's/\.\.\/lib\/vc_dll\///g' -i setup.h") 
			os.system("C:\\cygwin\\bin\\sed.exe -e 's/\.\.\/lib\/vc_lib\///g' -i setup.h")
		else:
			wxWidgets._modify_setup(self)

	#拷贝include目录到D:\usr\include	
	def _copy_include(self):
		if os.path.exists("..\\..\\..\\"):
			os.chdir("..\\..\\..\\")
		else:
			print os.getcwd()+os.sep+"..\\..\\..\\"+" 目录不存在,取消进一步安装,请删除wxWdiegst-2.8.10文件夹后,再继续安装"
			sys.exit()
		os.system("xcopy /y /S include D:\\usr\\include\\")

	#拷贝wx.bkl和wx_win32.bkl到Bakefile目录下的presets目录
	def _copy_wx_bkl(self):
		if os.path.exists("build\\bakefiles\\wxpresets\\presets\\"):
			os.chdir("build\\bakefiles\\wxpresets\\presets\\")
		else:
			print os.getcwd()+os.sep+"build\\bakefiles\\wxpresets\\presets\\"+" 目录不存在,取消进一步安装,请删除wxWdiegst-2.8.10文件夹后,再继续安装"
			sys.exit()
		if os.path.exists("C:\\Bakefile\\"):
			os.system("copy /y wx.bkl C:\\Bakefile\\presets\\")
			os.system("copy /y wx_win32.bkl C:\\Bakefile\\presets\\")
		elif  os.path.exists("C:\\Program Files\\Bakefile\\"):
			os.system('copy /y wx.bkl "C:\\Program Files\\Bakefile\\presets\\"')
			os.system('copy /y wx_win32.bkl "C:\\Program Files\\Bakefile\\presets\\"')
	
	#修改config.vc文件
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
	
	#修改config.vc文件，编译生成动态库
	def _modify_config_dll(self):
		if os.path.exists("..\\..\\..\\msw\\"):
			os.chdir("..\\..\\..\\msw\\")
		else:
			print os.getcwd()+os.sep+"..\\..\\..\\msw\\"+" 目录不存在,取消进一步安装,请删除wxWdiegst-2.8.10文件夹后,再继续安装"
			sys.exit()
		#考虑使用sed
		if os.path.exists("C:\\cygwin\\bin\\sed.exe"):
			os.system("sed -e 's/SHARED = 0/SHARED = 1/g' -i config.vc") 
			os.system("sed -e 's/UNICODE = 0/UNICODE = 1/g' -i config.vc")
		else:
			wxWidgets._modify_config(self)	

	#拷贝lib文件到D:\usr\lib
	def _copy_lib(self):
		if os.path.exists("..\\..\\lib\\vc_dll\\"):
			os.chdir("..\\..\\lib\\vc_dll\\")
		else:
			print os.getcwd()+os.sep+"..\\..\\lib\\vc_dll\\"+" 目录不存在,取消进一步安装,请删除wxWdiegst-2.8.10文件夹后,再继续安装"
			sys.exit()
		if 0!=os.system("copy /y *.lib D:\\usr\\lib"):
			print "copy /y *.lib D:\\usr\\lib failed, please check"
			sys.exit()

	#拷贝mswud文件夹到D:\usr\include\mswud\、拷贝dll文件到系统目录以及D:\usr\lib
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
			
	#安装wxWidgets
	def install_wxWidgets(self,cur_dir):
		print "#########################################################################################"
		print "*******************************开始安装wxWidgets开发工具*********************************"
		print
		print "wxWidgets将会被编译成动态库"
		print "不使用编译wxUniversal来代替本地端口"
		print "使用utf-8编码"
		print "使用utf-8编码时，不使用MSLU库"
		time.sleep(1)
		#解压缩wxWidgets安装包
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
		#编译生成动态库
		os.system("nmake /f makefile.vc")
		wxWidgets._copy_lib(self)
		wxWidgets._copy_mswud_dll(self)
		os.chdir(cur_dir)
		print "*******************************wxWidgets开发工具安装完成*********************************"
		print

##############################################################
##############################################################
##############################################################
		
class clean:
	def clean_tmp_file(self):
		print "#########################################################################################"
		print "***********************************开始清理临时文件**************************************"
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
		print "*********************************临时文件清理完成完成************************************"
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
