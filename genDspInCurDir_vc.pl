#!/usr/bin/perl	 
use Template;
use Cwd;
use File::Basename;
use File::Find;

use vars qw(*name);
*name=*File::Find::name;

#文件列表。 
our @globalFileList;
sub wanted()
{
	if ( -f $_)
	{
		push(@globalFileList, $name);
	}
}

sub getAllFileFromDir($)
{
	(my $in)=@_;
	File::Find::find({wanted=>\&wanted}, $in);
	#map{print $_,"\n"} @globalFileList;
	return @globalFileList;
}

sub changeUnixPath2Win($)
{
	($in)=@_;
	$winPath=$in;
	$winPath=~s/\//\\/g; 
	return $winPath;
}

$pwd= cwd();
$name=basename($pwd);
@tmp=getAllFileFromDir(".");
#@tmpWin=map{$win=changeUnixPath2Win($_);$win} @tmp;
@tmpWin= grep { -f && /\.cpp$|\.cc$|\.hpp$|\.h$|\.c$/} @tmp;
@fileList=map{$win=changeUnixPath2Win($_);$win} @tmpWin;

 my $config = {
	 INTERPOLATE  => 1,		      # 展开变量
	 POST_CHOMP	  => 1,		      # 清理空白符号
	 EVAL_PERL	  => 1,		      # eval perl 块。 
 };

 my $template = Template->new();

 # define template variables for replacement
 my $vars = {
	 name => $name,
	 fileList  => \@fileList,
 };
 
my $tplFile="dsp.tpl";

 # process input template, substituting variables
 $template->process(\*DATA, $vars)
	 || die $template->error();


__DATA__
# Microsoft Developer Studio Project File - Name="[% name %]" - Package Owner=<4>
# Microsoft Developer Studio Generated Build File, Format Version 6.00
# ** DO NOT EDIT **

# TARGTYPE "Win32 (x86) Console Application" 0x0103

CFG=[% name %] - Win32 Debug
!MESSAGE This is not a valid makefile. To build this project using NMAKE,
!MESSAGE use the Export Makefile command and run
!MESSAGE 
!MESSAGE NMAKE /f "[% name %].mak".
!MESSAGE 
!MESSAGE You can specify a configuration when running NMAKE
!MESSAGE by defining the macro CFG on the command line. For example:
!MESSAGE 
!MESSAGE NMAKE /f "[% name %].mak" CFG="[% name %] - Win32 Debug"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "[% name %] - Win32 Release" (based on "Win32 (x86) Console Application")
!MESSAGE "[% name %] - Win32 Debug" (based on "Win32 (x86) Console Application")
!MESSAGE 

# Begin Project
# PROP AllowPerConfigDependencies 0
# PROP Scc_ProjName ""
# PROP Scc_LocalPath ""
CPP=cl.exe
RSC=rc.exe

!IF  "$(CFG)" == "[% name %] - Win32 Release"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 0
# PROP BASE Output_Dir "Release"
# PROP BASE Intermediate_Dir "Release"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 0
# PROP Output_Dir "Release"
# PROP Intermediate_Dir "Release"
# PROP Target_Dir ""
# ADD BASE CPP /nologo /W3 /GX /O2 /D "WIN32" /D "NDEBUG" /D "_CONSOLE" /D "_MBCS" /YX /FD /c
# ADD CPP /nologo /W3 /GX /O2 /D "WIN32" /D "NDEBUG" /D "_CONSOLE" /D "_MBCS" /YX /FD /c
# ADD BASE RSC /l 0x804 /d "NDEBUG"
# ADD RSC /l 0x804 /d "NDEBUG"
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LINK32=link.exe
# ADD BASE LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:console /machine:I386
# ADD LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:console /machine:I386

!ELSEIF  "$(CFG)" == "[% name %] - Win32 Debug"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 1
# PROP BASE Output_Dir "Debug"
# PROP BASE Intermediate_Dir "Debug"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 1
# PROP Output_Dir "Debug"
# PROP Intermediate_Dir "Debug"
# PROP Target_Dir ""
# ADD BASE CPP /nologo /W3 /Gm /GX /ZI /Od /D "WIN32" /D "_DEBUG" /D "_CONSOLE" /D "_MBCS" /YX /FD /GZ /c
# ADD CPP /nologo /W3 /Gm /GX /ZI /Od /D "WIN32" /D "_DEBUG" /D "_CONSOLE" /D "_MBCS" /YX /FD /GZ /c
# ADD BASE RSC /l 0x804 /d "_DEBUG"
# ADD RSC /l 0x804 /d "_DEBUG"
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LINK32=link.exe
# ADD BASE LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:console /debug /machine:I386 /pdbtype:sept
# ADD LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:console /debug /machine:I386 /pdbtype:sept

!ENDIF 

# Begin Target

# Name "[% name %] - Win32 Release"
# Name "[% name %] - Win32 Debug"
[% FOREACH file IN fileList %]
# Begin Source File

SOURCE=[%file%]
# End Source File
[% END %] 

# End Target
# End Project
