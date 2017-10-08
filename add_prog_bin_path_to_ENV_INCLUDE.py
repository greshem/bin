#coding:gbk
#2011_02_21_05:56:49 add by greshem lib 目录 都是库文件. 
import sys
import site
import os
import _winreg

HKCU = _winreg.HKEY_CURRENT_USER
ENV = "Environment"
PATH = "INCLUDE"
DEFAULT = u"%INCLUDE%"

def add_path_to_ENV_INCLUDE(add_path):
    with _winreg.CreateKey(HKCU, ENV) as key:
        try:
            envpath = _winreg.QueryValueEx(key, PATH)[0]
        except WindowsError:
            envpath = DEFAULT
        #默认添加的方式.  
        paths = [envpath]
        if add_path and add_path not in envpath and os.path.isdir(add_path):
            paths.append(add_path)

        envpath = os.pathsep.join(paths)
        _winreg.SetValueEx(key, PATH, 0, _winreg.REG_EXPAND_SZ, envpath)
        return paths, envpath

def main():
    paths, envpath = add_path_to_ENV_INCLUDE("D:\\works\\wxWidgets-2.8.10\\include");
	#I:\svn_working_path\rich_netclone2\trunk\Baselib
    paths, envpath = add_path_to_ENV_INCLUDE("I:\\svn_working_path\\rich_netclone2\\trunk\\Baselib");
    
    print _winreg.ExpandEnvironmentStrings(envpath)

if __name__ == '__main__':
    main()
    print "input any keys to quit  \n";
    if sys.platform =='win32':
        print sys.stdin.readline()[:-1];

