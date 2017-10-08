#!/usr/bin/perl
$pattern=shift;;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__
########################################################################
#不是太常用的tags
arch 		|
cflags 		|
command 	|<command>wxrc -c -v -o res/resources.cpp res/
cppflags	|
cxx-exceptions  |<cxx-exceptions>off</cxx-exceptions>
cxxflags  	|<cxxflags>/DWIN32</cxxflags>
cxx-rtti   	|<cxx-rtti>on</cxx-rtti>
debug-info 	|<debug-info>on</debug-info>
debug-info-edit-and|
debug-runtime-libs |
define   	| <define>_UNICODE</define>
dependency-of	| 
depends-on-file | <depends-on-file>lib/querydef.pl</depends-on-file>
depends		|<depends>setup</depends>
dirname 	|
headers		| 
install-headers-to <install-to>d:\\usr\\include</install-to> 
install-if 	|
ldflags   	|  	<ldflags>/NOLOGO</ldflags>
ldlibs		| 
mac-res		| 
msvc-guid 	|
objects-depend 	|
optimize 	|<set var="OPTIMIZE_FLAG"> <if cond="BUILD=='release'">speed</if> <if cond="BUILD=='debug'">off</if> </set> <optimize>$(OPTIMIZE_FLAG)</optimize>
pic 	|
postlink-command 	|
precomp-headers 	|
precomp-headers-file|
precomp-headers-file|
precomp-headers-gen	| 
res-define 	|
res-include |
symbian-res |
threading  	|  <threading>multi</threading>
uid 		|	
warnings   	| <warnings>on</warnings>

########################################################################
#常用的tags
clean-files |<clean-files> *.ncb *.plg *.opt *.positions UpgradeLog.XML MakeFile.aps *.suo *.aps *.suo.old *.sln.old *.7.10.old *.ilk *.clw *.obj *.res *.pch *.pdb *.scc *.sbr *idb </clean-files>
exe 		| <exe id="app" template="wxwidgets">
lib-path 	| 	<lib-path>/usr/lib/mysql</lib-path>
library  	| 	<library>libnetclone</library>
install-to 	|	<install-to>d:\\usr\\lib</install-to>
sys-lib  	| <sys-lib>png z</sys-lib>   <sys-lib>advapi32</sys-lib>
include  |<include>../share/mysql/include</include>
include  |<include>d:\\usr\\include\\</include>
win32-res	|  <win32-res>NcAssistant.rc</win32-res> 
注释 		|	<!--INCORRECT -->
ldflags   	|  	<ldflags>/verbose:lib</ldflags>
ldflags 	|<ldflags> /NODEFAULTLIB:nafxcwd.lib</ldflags> 
sources 	|<sources>app.c</sources> |<sources>\$(fileList('*.cpp'))</sources> 
ldflags		|<ldflags> /map:"outputfile_map"</ldflags>
########################################################################
#链接错误: new 重定义, 解决方式:  rich_addvalue3\BalanceDownLoad  r1185  
			<sys-lib>nafxcwd</sys-lib>
			<sys-lib>libcmtd</sys-lib>
			<ldflags>/verbose:lib</ldflags> #用这个方式解决.
