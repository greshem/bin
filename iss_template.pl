#!/usr/bin/perl
my $guid;
use String::Random;
$foo = new String::Random;
$guid= $foo->randregex("[0-9A-F]{8}-[0-9A-F]{4}-[0-9A-F]{4}-[0-9A-F]{12}");

#my $soft_name="randName".int(rand(1024));
use Cwd;
my $pwd=getcwd();
use File::Basename;
my $soft_name= basename($pwd);
logger("输出的项目名是 $soft_name\n");

my @exes=glob("*.exe");
my $first_exe=shift(@exes) or logger("PANIC: 本地目录下没有exe 程序\n");


sub logger($)
{
	(my $log_str)=@_;
	open(FILE, ">>iss_template.log") or warn("open log error, $!\n");
	print FILE $log_str;
	close(FILE);
}



print <<EOF 
; Script generated by the Inno Setup Script Wizard.
; SEE THE DOCUMENTATION FOR DETAILS ON CREATING INNO SETUP SCRIPT FILES!

[Setup]
; NOTE: The value of AppId uniquely identifies this application.
; Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
AppId={{$guid}
AppName=${soft_name}_v1.0Build1916
AppVerName= v1.0Build1916
VersionInfoTextVersion=v1.0Build1916
AppPublisher=
AppPublisherURL=
AppSupportURL=
AppUpdatesURL=
DefaultDirName={pf}/Richtech/$soft_name
DefaultGroupName=$soft_name
OutputDir=output_iss_package
;VersionInfoProductVersion=sf_win_explorer.exe
;VersionInfoVersion=2.3.SVN_BUILD_NO1
OutputBaseFilename=$soft_name
SourceDir=     .
Compression=lzma
SolidCompression=yes
AlwaysRestart=no
UninstallRestartComputer=no


[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"
Name: "quicklaunchicon"; Description: "{cm:CreateQuickLaunchIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Files]
Source: "*.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "*.pdb"; DestDir: "{app}"; Flags: ignoreversion
Source: "版本说明.txt"; DestDir: "{app}"; Flags: ignoreversion
Source: "bug*.txt"; DestDir: "{app}"; Flags: ignoreversion


Source: "D:\\usr\\lib\\wxbase28ud_net_vc_custom.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "D:\\usr\\lib\\wxbase28ud_vc_custom.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "D:\\usr\\lib\\wxbase28ud_xml_vc_custom.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "D:\\usr\\lib\\wxmsw28ud_adv_vc_custom.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "D:\\usr\\lib\\wxmsw28ud_aui_vc_custom.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "D:\\usr\\lib\\wxmsw28ud_core_vc_custom.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "D:\\usr\\lib\\wxmsw28ud_html_vc_custom.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "D:\\usr\\lib\\wxmsw28ud_media_vc_custom.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "D:\\usr\\lib\\wxmsw28ud_qa_vc_custom.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "D:\\usr\\lib\\wxmsw28ud_richtext_vc_custom.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "D:\\usr\\lib\\wxmsw28ud_xrc_vc_custom.dll"; DestDir: "{app}"; Flags: ignoreversion

Source: "E:\\svn_working_path\\system_initialization_win\\vc_2003_dll\\*.dll"; DestDir: "C:\\WINDOWS\\"; Flags: ignoreversion


[Registry]
Root: HKLM; Subkey: "Software\\Microsoft\\Windows\\CurrentVersion\\Run"; ValueType: string; ValueName: "$first_exe"; ValueData: """{app}\\$first_exe"""


[Icons]
Name: "{commondesktop}\\$soft_name"; Filename: "{app}\\$first_exe"; Tasks: desktopicon ;WorkingDir:"{app}";  Flags:closeonexit
Name: "{group}\\$soft_name"; Filename: "{app}\\$first_exe" ; WorkingDir:"{app}"; Flags:closeonexit
Name: "{group}\\卸载"; Filename: "{uninstallexe}"

[Run]
Filename: "{app}\\install_cli.bat"; StatusMsg: "安装服务";

[UninstallRun]
Filename: "{app}\\uninstall_cli.bat"; StatusMsg: "卸载服务";


EOF
;
