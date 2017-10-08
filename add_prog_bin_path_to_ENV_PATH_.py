#coding:gbk
#2011_02_20 add by greshem
#把常见的目录都添加进去了.
#添加java 的一些东西 classpath JAVA_HOME 等. 
import sys
import site
import os
import _winreg

HKCU = _winreg.HKEY_CURRENT_USER
ENV = "Environment"
PATH = "PATH"
DEFAULT = u"%PATH%"

def add_path_to_ENV_PATH(add_path):
	
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
    paths, envpath = add_path_to_ENV_PATH("c:\\bin");
    paths, envpath = add_path_to_ENV_PATH("c:\\cygwin\\bin");
    paths, envpath = add_path_to_ENV_PATH("C:\\Ruby192\\bin");

    paths, envpath = add_path_to_ENV_PATH("c:\\Perl\\bin");
    paths, envpath = add_path_to_ENV_PATH("C:\\q******************************n_bin");
    paths, envpath = add_path_to_ENV_PATH("C:\\Program Files\\Vim\\vim72");

	#C:\Program Files\Bakefile
    paths, envpath = add_path_to_ENV_PATH("C:\\Program Files\\Bakefile");

	#C:\Program Files\Wireshark
    paths, envpath = add_path_to_ENV_PATH("C:\\Program Files\\Wireshark");

	#C:\\Program Files\\Ext2Fsd
    paths, envpath = add_path_to_ENV_PATH("C:\\Program Files\\Ext2Fsd");


    #C:\Program Files\Subversion\bin
    paths, envpath = add_path_to_ENV_PATH("C:\\Program Files\\Subversion\\bin");
    print _winreg.ExpandEnvironmentStrings(envpath)

if __name__ == '__main__':
    main()
    print "input any keys to quit  \n";
    if sys.platform =='win32':
        print sys.stdin.readline()[:-1];

