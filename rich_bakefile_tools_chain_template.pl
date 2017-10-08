#!/usr/bin/perl

#if($^O=~/windows/)
{
	gen_bake_bat_4_windows();
	gen_bake_4_linux();
	gen_build_bkl();
}
########################################################################
sub gen_bake_4_linux()
{
	open (BAKE_SH, ">bake") or die("create ./bake error \n");
print  BAKE_SH <<EOF
if [ \$# -ne 1 ]; then
   echo "Usage: \$0 [debug | release]"
   exit 0
else
   type="\$1"
fi

WX_DEFINES="-I/usr/local/share/bakefile -DWX_UNICODE=1"

if [ "\$type" = "debug" ]; then
    bakefile build.bkl -f gnu -o Makefile.gnu -DBUILD=debug -DBUILDDIR=Debug -DWX_SHARED=0 \$WX_DEFINES
else
    bakefile build.bkl -f gnu -o Makefile.gnu -DBUILD=release -DBUILDDIR=Release -DWWX_SHARED=0 \$WX_DEFINES
fi
EOF
;

	close(BAKE_SH);

}

sub gen_bake_bat_4_windows()
{
	open (BAKE_BAT, ">bake.bat") or die("create ./bake.bat error \n");
print  BAKE_BAT <<EOF
	
\@echo on

set WX_WIDGETS=wxWidgets-2.8.10
set WX_DEFINES=-IC:\\works\\%WX_WIDGETS%\\build\\bakefiles\\wxpresets -DWX_DIR=C:\\works\\%WX_WIDGETS% -DWX_UNICODE=1

if "%1"=="" goto DEBUG
if not "%2"=="" goto ERROR

if "%1"=="release" goto RELEASE

:DEBUG
bakefile build.bkl -f msvc -o makefile.vc -DWX_DEBUG=1 -DWX_SHARED=1 -DBUILD=debug -DBUILDDIR=Debug %WX_DEFINES%
goto END

:RELEASE
bakefile build.bkl -f msvc -o makefile.vc -DWX_DEBUG=0 -DWX_SHARED=0 -DBUILD=release -DBUILDDIR=Release %WX_DEFINES%
goto END

:ERROR
echo Usage: bake [debug / release]

:END
nmake /f makefile.vc
EOF
;
	close(BAKE_BAT);
}

sub gen_build_bkl()
{

	open (BUILD_BKL, ">build.bkl") or die("create ./bake error \n");
print  BUILD_BKL <<EOF
<?xml version="1.0" ?>
<!-- \$Id: bakefile_quickstart.txt,v 1.5 2006/02/11 18:41:11 KO Exp \$ -->

<makefile>

    <include file="presets/wx.bkl"/>

    <set var="DEBUGINFO">
        <if cond="BUILD=='debug'">on</if>
        <if cond="BUILD=='release'">off</if>
    </set>

    <set var="DEBUGRUNTIME">
        <if cond="BUILD=='debug'">on</if>
        <if cond="BUILD=='release'">off</if>
    </set>

    <set var="OPTIMIZEFLAG">
        <if cond="BUILD=='debug'">off</if>
        <if cond="BUILD=='release'">speed</if>
    </set>

    <set var="WARNINGS">
        <if cond="BUILD=='debug'">max</if>
        <if cond="BUILD=='release'">no</if>
    </set>

    <set var="RUNTIMELIBRARY">
        <if cond="BUILD=='debug'">dynamic</if>
        <if cond="BUILD=='release'">static</if>
    </set>

    <exe id="test" template="wx">
	<app-type>gui</app-type>
        <debug-info>\$(DEBUGINFO)</debug-info>
        <debug-runtime-libs>\$(DEBUGRUNTIME)</debug-runtime-libs>
        <optimize>\$(OPTIMIZEFLAG)</optimize>
        <warnings>\$(WARNINGS)</warnings>
        <runtime-libs>\$(RUNTIMELIBRARY)</runtime-libs>
        
        <sources>\$(fileList('*.cpp'))</sources>
        
        <if cond="FORMAT=='msvc'">


			<!-- <lib-path>D:\\svn_working_path\\diskplat\\trunk\\diskplat\\Debug\\</lib-path> -->
			<!-- <sys-lib>libdiskplat</sys-lib> -->
			<!-- <library>libnetclone</library> --> 
			<!-- <include>D:\\svn_working_path\\diskplat\\</include> -->
			<!-- <sys-lib>crypt2</sys-lib> -->

            <if cond="WX_SHARED=='1'">
                <cxxflags>/DWXUSINGDLL</cxxflags>
            </if>
            <if cond="BUILD=='release'">
                <threading>multi</threading>
                <define>COMPILE_SERVICE</define>
            </if>
            <define>__WIN32__</define>
        </if>

        <if cond="BUILD=='debug'">
            <define>ENABLE_DBG_MESSAGE</define>
        </if>

        <wx-lib>xml</wx-lib>
        <wx-lib>net</wx-lib>
        <wx-lib>core</wx-lib>
        <wx-lib>base</wx-lib>
		<wx-lib>xrc</wx-lib>
        <wx-lib>html</wx-lib>
        <wx-lib>adv</wx-lib>
        <wx-lib>net</wx-lib>
        <wx-lib>core</wx-lib>
        <wx-lib>xml</wx-lib>
        <wx-lib>base</wx-lib>

    </exe>
    
</makefile>
EOF
;
	close(BUILD_BKL);
}
