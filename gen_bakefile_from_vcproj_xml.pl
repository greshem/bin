#!/usr/bin/perl
use File::Basename;
use XML::Simple;
use Data::Dumper;

our $g_option;
our $vcproj_file;
$vcproj_file = shift;
if(defined($vcproj_file))
{
	$g_option= shift or die("usage: $0 input Compil-option D(Debug) or R(Release)\n");
}
else
{
	@vcprojs=glob("*.vcproj");
	@tmp=glob("*.VCPROJ");
	push(@vcprojs, @tmp);

	$vcproj_file=shift(@vcprojs);

	if(defined($vcproj_file))
	{
    	$g_option= "D";
	}
	else
	{
    	#获得命令行参数 vcproj类型的文件名
    	$vcproj_file = shift or die("usage: $0 input prams like [vcprogfilename] [D(release)|R(debug)]\n");
    	# 获得命令行参数： D|d 是debug版本 R|r 是release版本
    	$g_option= shift or die("usage: $0 input Compil-option D(Debug) or R(Release)\n");
    }
}

#获得命令行参数 vcproj类型的文件名
#our $vcproj_file = shift or die("usage: $0 input prams like [vcprogfilename] [D(release)|R(debug)]\n"); 

# 获得命令行参数： D|d 是debug版本 R|r 是release版本
#our $g_option= shift or die("usage: $0 input Compil-option D(Debug) or R(Release)\n"); 


our @g_exe;             #目标名字
our @g_lib_path;        #静态库路径
our @g_rc;              #资源文件
our @g_cxx;				#编译选项
our @g_ldf_and_syslib;	#连接选项和lib
our @g_source;			#源文件
our $g_target_file="exe";#目标文件类型
#our $g_option="D";
our $g_charaset;		#字符集选项
our $g_usemfc;			#mfc引用方式
our $g_type_index=0;	#是取Debug的还是Release， 0 debug 1 release
our @g_AllBuf;
deal_with_vcproj($vcproj_file);

sub deal_with_vcproj($)
{
	(my $filename) = @_;
	#print "---------------------------------------------------"."\n";
	my $xml = new  XML::Simple();
	my $userxml = $xml->XMLin($filename);
	#my $userxml = $xml->XMLin($filename,ForceArray =>1);
	#$userxml = $xml->XMLin($filename,KeyAttr =>1);
	#my $userxml = $xml->XMLin($filename,ForceArray =>1,KeyAttr =>1);
    #my (@Compiler)=@{@{$userxml->{"Configurations"}->{"Configuration"}}[0]->{"Tool"}};  
	print Dumper($userxml);
	#print "----------------------------------------------------"."\n";
	#全局选项
	gen_global_option($userxml);
	#编译选项
	my (%cxx_lines)=gen_bkl_cxx_from_vcproj($userxml);
	@g_cxx=create_cxx_line(%cxx_lines);
    #连接选项
	my (%link_lines)=gen_bkl_cl_from_vcproj($userxml);
    @g_ldf_and_syslib=create_clink_line(%link_lines);
    #资源文件
	my(@rc_lines)=gen_bkl_rc_from_vcproj($userxml);
	@g_rc=create_rc_line(@rc_lines);
	#目标文件
	my (%target)=gen_bkl_tar_from_vcproj($userxml);
	@g_exe=create_target_line(%target);
	#原文件
	my(@source_lines)=gen_bkl_cppfiles_vcproj($userxml);
	@g_source=create_source_line(@source_lines);
    my $head_str = gen_bkl_dsp_tag_start();
    gen_bkl_dsp_tag_mid();
    my $end_str = gen_bkl_dsp_tag_end();
	
	(my $name)=($filename=~/(.*)\.[VCPROJ|vcproj]/);
	my $output_bkl=$name.".bkl";
	open(BKL, "> ".$output_bkl) or die("open file $output_bkl 错误, $!\n");
	print BKL $head_str;
	foreach $thisBuf(@g_AllBuf)
    {
		print BKL "\t";
        print BKL $thisBuf;
    }
	print BKL $end_str;
	close(BKL);	
}

#获得总体选项如 编译版本 字符集 目标类型 mfc引用方式
sub gen_global_option($)
{
	#区分发行版本还是调试版本
	if(($g_option eq "R")||($g_option eq "r"))
	{
		$g_type_index=1;
	}
	elsif(($g_option eq "D")||($g_option eq "d"))
	{
		$g_type_index=0;
	}
	else
	{
		print "warming:input Compil-option D(Debug) or R(Release)\n";	
		exit 0;
	}
	print $g_type_index."\n";
	my ($userxml)=@_;
    my %global_data;
	
	#字符集选项
    $g_charaset =@{$userxml->{"Configurations"}->{"Configuration"}}[$g_type_index]->{"CharacterSet"};
	#print $g_charaset."\n";
	
	#MFC选项
	$g_usemfc =@{$userxml->{"Configurations"}->{"Configuration"}}[$g_type_index]->{"UseOfMFC"};
	#print $g_usemfc."\n";
	
	#编译类型
	my ($config_type)=@{$userxml->{"Configurations"}->{"Configuration"}}[$g_type_index]->{"ConfigurationType"};
	if($config_type==1)
	{
		$g_target_file="exe";
	}
	elsif($config_type==2)
    {
        $g_target_file="dll";
    }
	elsif($config_type==3||$config_type==4)
    {
        $g_target_file="lib";
    }
	#print $g_target_file."\n";
}

#获得编译选项
sub gen_bkl_cxx_from_vcproj($)
{
    my ($userxml)=@_;
    my %cxx_map_data;
    my (@Compiler)=@{@{$userxml->{"Configurations"}->{"Configuration"}}[$g_type_index]->{"Tool"}};

    my $index=0;
	foreach my $each (@Compiler)
    { 
        #print $Compiler->{"Name"}."\n";
        if($each->{"Name"}=~/.*(VCCLCompilerTool).*/)
        {
            $cxx_map_data{"UsePrecompiledHeader"}=$Compiler[$index]->{"UsePrecompiledHeader"};
			$cxx_map_data{"Optimization"}=$Compiler[$index]->{"Optimization"};
			$cxx_map_data{"PreprocessorDefinitions"}=$Compiler[$index]->{"PreprocessorDefinitions"};
			$cxx_map_data{"MinimalRebuild"}=$Compiler[$index]->{"MinimalRebuild"};
			$cxx_map_data{"WarningLevel"}=$Compiler[$index]->{"WarningLevel"};
			$cxx_map_data{"BasicRuntimeChecks"}=$Compiler[$index]->{"BasicRuntimeChecks"};
			$cxx_map_data{"DebugInformationFormat"}=$Compiler[$index]->{"DebugInformationFormat"};
			$cxx_map_data{"RuntimeLibrary"}=$Compiler[$index]->{"RuntimeLibrary"};
			$cxx_map_data{"Name"}=$Compiler[$index]->{"Name"};
			#release
            $cxx_map_data{"WholeProgramOptimization"}=$Compiler[$index]->{"WholeProgramOptimization"};
			$cxx_map_data{"AdditionalIncludeDirectories"}=$Compiler[$index]->{"AdditionalIncludeDirectories"};
			$cxx_map_data{"EnableEnhancedInstructionSet"}=$Compiler[$index]->{"EnableEnhancedInstructionSet"};
			$cxx_map_data{"FloatingPointModel"}=$Compiler[$index]->{"FloatingPointModel"};
			$cxx_map_data{"FloatingPointExceptions"}=$Compiler[$index]->{"FloatingPointExceptions"};
			$cxx_map_data{"GenerateXMLDocumentationFiles"}=$Compiler[$index]->{"GenerateXMLDocumentationFiles"};
			$cxx_map_data{"Detect64BitPortabilityProblems"}=$Compiler[$index]->{"Detect64BitPortabilityProblems"};
			$cxx_map_data{"ExceptionHandling"}=$Compiler[$index]->{"ExceptionHandling"};
			$cxx_map_data{"CallingConvention"}=$Compiler[$index]->{"CallingConvention"};
			
			#print "编译参数：".%cxx_map_data."\n";
            #while(($key,$value)=each %cxx_map_data)
			#{
			#	print "$key => $value\n";
			#}
		}
		$index=$index+1;
    }
    return %cxx_map_data;
}

#翻译编译选项 生成bkl相应的选项行
sub create_cxx_line(%)
{
	my (%org_cxx_map_data)=@_;
    my @cxx_lines;	
    #UsePrecompiledHeader指示编译器创建预编译头文件 (.pch)，该文件表示在某一时刻的编译状态。
    if($org_cxx_map_data{"UsePrecompiledHeader"}==0)
	{
		push(@cxx_lines,"<cxxflags>/Y-</cxxflags>\n"); 
	}	
    elsif($org_cxx_map_data{"UsePrecompiledHeader"}==1||$org_cxx_map_data{"UsePrecompiledHeader"}==2)
	{
        push(@cxx_lines,"<cxxflags>/Yc</cxxflags>\n");	
    }   
    elsif($org_cxx_map_data{"UsePrecompiledHeader"}==3)
	{
        push(@cxx_lines,"<cxxflags>/Yu</cxxflags>\n");
    }
    
	#Optimization
    if($org_cxx_map_data{"Optimization"}==0)
 	{
    	push(@cxx_lines,"<cxxflags>/Od</cxxflags>\n");
	}
	elsif($org_cxx_map_data{"Optimization"}==1)
	{
        push(@cxx_lines,"<cxxflags>/O1</cxxflags>\n");
	}
	elsif($org_cxx_map_data{"Optimization"}==2)
	{
    	push(@cxx_lines,"<cxxflags>/O2</cxxflags>\n");
	}
	elsif($org_cxx_map_data{"Optimization"}>=3)
	{
    	push(@cxx_lines,"<cxxflags>/Ox</cxxflags>\n");
	}
   
	#PreprocessorDefinitions 一些选项
    my @array=split(/;/,$org_cxx_map_data{"PreprocessorDefinitions"});
	for(@array)
	{
		push(@cxx_lines,"<cxxflags>/D$_ </cxxflags>\n");
	} 
	#字符集宏
	if($g_charaset==1)
	{
		push(@cxx_lines,"<cxxflags>/D_UNICODE</cxxflags>\n");
	    push(@cxx_lines,"<cxxflags>/DUNICODE</cxxflags>\n");
	}
	elsif($g_charaset==2)
	{
		push(@cxx_lines,"<cxxflags>/D_MBCS</cxxflags>\n")
	}
	#mfc选项
	if($g_usemfc==2)
    {
        push(@cxx_lines,"<cxxflags>/D_AFXDLL</cxxflags>\n");
    }

	#MinimalRebuild 最小化编译
	if($org_cxx_map_data{"Optimization"} eq true)
	{
        push(@cxx_lines,"<cxxflags>/Gm</cxxflags>\n");
    }

	#WarningLevel 警告级别
	if($org_cxx_map_data{"WarningLevel"}>=1)
	{
		push(@cxx_lines,"<cxxflags>/W$org_cxx_map_data{WarningLevel}</cxxflags>\n");
	}
	
	#BasicRuntimeChecks 运行时检测，包括栈和未初始化变量等
    
	#DebugInformationFormat调试信息格式 不准确
    if($org_cxx_map_data{"DebugInformationFormat"}==0)
	{
    	push(@cxx_lines,"<cxxflags>/Za</cxxflags>\n");
	}
	elsif($org_cxx_map_data{"DebugInformationFormat"}==1)
	{
    	push(@cxx_lines,"<cxxflags>/Zd</cxxflags>\n");
	}
	elsif($org_cxx_map_data{"DebugInformationFormat"}==2)
	{
    	push(@cxx_lines,"<cxxflags>/Z7</cxxflags>\n");
	}
	elsif($org_cxx_map_data{"DebugInformationFormat"}==3)
	{
    	push(@cxx_lines,"<cxxflags>/Zi</cxxflags>\n");
	}
	elsif($org_cxx_map_data{"DebugInformationFormat"}==4)
    {
        push(@cxx_lines,"<cxxflags>/ZI</cxxflags>\n");
    }

	#RuntimeLibrary 2005调试出来的
    if($org_cxx_map_data{"RuntimeLibrary"}==0)
	{
    	push(@cxx_lines,"<cxxflags>/MT</cxxflags>\n");
	}
	elsif($org_cxx_map_data{"RuntimeLibrary"}==1)
	{
    	push(@cxx_lines,"<cxxflags>/MTd</cxxflags>\n");
	}
	elsif($org_cxx_map_data{"RuntimeLibrary"}==2)
	{
    	push(@cxx_lines,"<cxxflags>/MD</cxxflags>\n");
	}
	elsif($org_cxx_map_data{"RuntimeLibrary"}==3)
	{
    	push(@cxx_lines,"<cxxflags>/MDd</cxxflags>\n");
	}	

	#WholeProgramOptimization如果为 true，将启用全程序优化
	if($org_cxx_map_data{"WholeProgramOptimization"} eq "true")
    {
        push(@cxx_lines,"<cxxflags>/GL</cxxflags>\n");
    }
	
	#AdditionalIncludeDirectories将目录添加到要在其中搜索包含文件的目录列表中。还要修改
	my($incpath)=$org_cxx_map_data{"AdditionalIncludeDirectories"}; 
	if(defined($incpath))
	{
		my(@incpaths)=split(/;/, $incpath );
 		foreach $incp(@incpaths)
 		{
    		push(@cxx_lines,"<include>$incp</include>\n");
		}
		#push(@cxx_lines,"<include>$incpath</include>\n");
	}

	#ExceptionHandling异常选项
	 my($ExceptExit)=$org_cxx_map_data{"ExceptionHandling"};
	if(defined($ExceptExit))
	{
		if($org_cxx_map_data{"ExceptionHandling"}==0)
		{
		}
		elsif($org_cxx_map_data{"ExceptionHandling"}==1||$org_cxx_map_data{"ExceptionHandling"}==3)
		{
			push(@cxx_lines,"<cxxflags>/EHsc</cxxflags>\n");
		}
		elsif($org_cxx_map_data{"ExceptionHandling"}==2)
		{
			push(@cxx_lines,"<cxxflags>/EHa</cxxflags>\n");
		}
	}	
	else
	{
		push(@cxx_lines,"<cxxflags>/EHsc</cxxflags>\n");
	}




	my($callmean)=$cxx_map_data{"CallingConvention"};
    if(defined($callmean))
    {
        if($org_cxx_map_data{"CallingConvention"}==0)
        {
			push(@cxx_lines,"<cxxflags>/Gd</cxxflags>\n");
        }
        elsif($org_cxx_map_data{"CallingConvention"}==1)
        {
            push(@cxx_lines,"<cxxflags>/Gr</cxxflags>\n");
		}
		elsif($org_cxx_map_data{"CallingConvention"}==2)
		{
			push(@cxx_lines,"<cxxflags>/Gz</cxxflags>\n");
		}
	}
	else
	{
		
	}

	#EnableEnhancedInstructionSet 值命令行选项
	
	#FloatingPointModel值命令行选项
	
	#GenerateXMLDocumentationFiles如果为 true，编译器将对源代码文件中的文档注释进行处理，并为每个具有文档注释的源代码文件创建一个 .xdc 文件
	
	#Detect64BitPortabilityProblems检测是否兼容64位程序
	
	#print @cxx_lines;   
    #print "UsePrecompiledHeader"."::".$org_cxx_map_data{"UsePrecompiledHeader"}."\n";
    
	return @cxx_lines;
}

#获得连接选项
sub gen_bkl_cl_from_vcproj($)
{
    my ($userxml)=@_;
    my %cxx_map_data;
    my (@Compiler)=@{@{$userxml->{"Configurations"}->{"Configuration"}}[$g_type_index]->{"Tool"}};
 
    my $index=0;
    foreach my $each(@Compiler)
    {
        #print $Compiler->{"Name"}."\n";
        if($each->{"Name"}=~/.*(VCLinkerTool).*/)
        {
            $cxx_map_data{"TargetMachine"}=$Compiler[$index]->{"TargetMachine"};
            $cxx_map_data{"SubSystem"}=$Compiler[$index]->{"SubSystem"};
            $cxx_map_data{"GenerateDebugInformation"}=$Compiler[$index]->{"GenerateDebugInformation"};
            $cxx_map_data{"LinkIncremental"}=$Compiler[$index]->{"LinkIncremental"};
			$cxx_map_data{"AdditionalLibraryDirectories"}=$Compiler[$index]->{"AdditionalLibraryDirectories"};#lib_path
            $cxx_map_data{"AdditionalDependencies"}=$Compiler[$index]->{"AdditionalDependencies"};#lib
            $cxx_map_data{"Name"}=$Compiler[$index]->{"Name"};
			#release
			$cxx_map_data{"AssemblyDebug"}=$Compiler[$index]->{"AssemblyDebug"};
			$cxx_map_data{"OptimizeReferences"}=$Compiler[$index]->{"OptimizeReferences"};
 			$cxx_map_data{"EnableCOMDATFolding"}=$Compiler[$index]->{"EnableCOMDATFolding"};

			$cxx_map_data{"IgnoreDefaultLibraryNames"}=$Compiler[$index]->{"IgnoreDefaultLibraryNames"};
		    $cxx_map_data{"GenerateMapFile"}=$Compiler[$index]->{"GenerateMapFile"};
			$cxx_map_data{"MapFileName"}=$Compiler[$index]->{"MapFileName"};
			$cxx_map_data{"MapExports"}=$Compiler[$index]->{"MapExports"};
			$cxx_map_data{"ModuleDefinitionFile"}=$Compiler[$index]->{"ModuleDefinitionFile"};
			$cxx_map_data{"RandomizedBaseAddress"}=$Compiler[$index]->{"RandomizedBaseAddress"};
			#print "连接参数：".%cxx_map_data."\n";
            #while(($key,$value)=each %cxx_map_data)
            #{
            #    print "$key => $value\n";
            #}
         }
         $index=$index+1;
     }
	return %cxx_map_data;
}

#翻译连接选项 生成bkl相应的选项行
sub create_clink_line(%)
{
	my (%org_cxx_map_data)=@_;
    my @link_lines;
	
	#fixme:  TargetMachine/MACHINE 选项指定程序的目标平台。其他的还没有调试？？？
    my $f_mach = $org_cx_map_data{"TargetMachine"};
	if(defined($f_mach))
	{
		if($org_cxx_map_data{"TargetMachine"}==1)
    	{
        	push(@link_lines,"<ldflags>/MACHINE:X86</ldflags>\n");
    	}
		else
		{
			push(@link_lines,"<ldflags>/MACHINE:X86</ldflags>\n");
		}
 	}
    #fixme: SubSystem指定可执行文件的环境 其他没有调试？？？
    if($org_cxx_map_data{"SubSystem"}==1)
    {
        push(@link_lines,"<ldflags>/SUBSYSTEM:CONSOLE</ldflags>\n");
    }
	elsif($org_cxx_map_data{"SubSystem"}==2)
	{
		push(@link_lines,"<ldflags>/SUBSYSTEM:WINDOWS</ldflags>\n");
	}
 
    #GenerateDebugInformation/DEBUG 选项创建 .exe 文件或 DLL 的调试信息。
    if($org_cxx_map_data{"GenerateDebugInformation"} eq "true")
    {
        push(@link_lines,"<ldflags>/DEBUG</ldflags>\n");
    }
 
    #LinkIncremental/INCREMENTAL 选项控制链接器如何处理增量链接。
    my $f_link = $org_cx_map_data{"LinkIncremental"};
	if(defined($f_link))
	{
		if($org_cxx_map_data{"LinkIncremental"} eq "true")
    	{
        	push(@link_lines,"<ldflags>/INCREMENTAL</ldflags>\n");
    	}
    	else
    	{
        	 push(@link_lines,"<ldflags>/INCREMENTAL:NO</ldflags>\n");
    	}
    }
	#AdditionalLibraryDirectories lib_path
	my @patharray=split(/;/,$org_cxx_map_data{"AdditionalLibraryDirectories"});
    foreach $pathitem(@patharray)
    {
        push(@link_lines,"<lib-path>$pathitem</lib-path>\n");
    }

	#AdditionalDependencies向链接器提供包含对象、导入库和标准库、资源、模块定义和命令输入的文件。 
    my @array=split(/ /,$org_cxx_map_data{"AdditionalDependencies"});
    for(@array)
    {
		$_=~s/\.lib//;
        push(@link_lines,"<sys-lib>$_</sys-lib>\n");
    }
	
	#AssemblyDebug如果为 true，将发出 DebuggableAttribute 特性以及调试信息跟踪，但禁用 JIT 优化 自己调试出来的
	if($org_cxx_map_data{"AssemblyDebug"}==0)
    {
		#push(@link_lines,"<ldflags></ldflags>\n");
    }
    elsif($org_cxx_map_data{"AssemblyDebug"}==1)
    {
        push(@link_lines,"<ldflags>/ASSEMBLYDEBUG</ldflags>\n");
    }
	elsif($org_cxx_map_data{"AssemblyDebug"}==2)
    {
        push(@link_lines,"<ldflags>/ASSEMBLYDEBUG:DISABLE</ldflags>\n");
    }
	
	#OptimizeReferences如果为 true，则消除永远不再引用的函数和/或数据？？？
	if($org_cxx_map_data{"OptimizeReferences"}==1)
	{
		push(@link_lines,"<ldflags>/OPT:NOREF</ldflags>\n");
	}
	elsif($org_cxx_map_data{"OptimizeReferences"}==2)
	{
		push(@link_lines,"<ldflags>/OPT:REF</ldflags>\n");
	}

	#EnableCOMDATFolding如果为 true，则启用相同的 COMDAT 折叠 自己调试的 ？？？
	if($org_cxx_map_data{"EnableCOMDATFolding"}==1)
	{
		push(@link_lines,"<ldflags>/OPT:NOICF</ldflags>\n");
	}
	elsif($org_cxx_map_data{"EnableCOMDATFolding"}==2)
	{
		push(@link_lines,"<ldflags>/OPT:ICF</ldflags>\n");
	}
	
	#GenerateMapFile如果为 true，则创建映射文件。 映射文件的文件扩展名为 .map
	if($org_cxx_map_data{"GenerateMapFile"} eq "true")
	{
		push(@link_lines,"<ldflags>/MAP</ldflags>\n");
	}
    
	#MapFileName将默认映射文件名更改为指定的文件名。
    
	#MapExports如果为 true，则通知链接器在影射文件中包含导出函数。
	
	#忽略库
	my @arrayigno=split(/;/,$org_cxx_map_data{"IgnoreDefaultLibraryNames"});
	for(@arrayigno)
	{
		push(@link_lines,"<ldflags>/NODEFAULTLIB:$_</ldflags>\n");
	}	
	#/DEF:"CopyFileWrapper.def"模块定义文件
	my $def_file = $org_cx_map_data{"ModuleDefinitionFile"};
	if(defined($def_file)&&!($def_file eq ""))
    {
       push(@link_lines,"<ldflags>/DEF:\"$def_file\"</ldflags>\n");
    }

	#/DEF:"RandomizedBaseAddress"随机镜像地址
	if($org_cxx_map_data{"RandomizedBaseAddress"}==1)
    {
		push(@link_lines,"<ldflags>/DYNAMICBASE:NO</ldflags>\n");
    }
    elsif($org_cxx_map_data{"RandomizedBaseAddress"}==2)
    {
		push(@link_lines,"<ldflags>/DYNAMICBASE</ldflags>\n");
    }

	#push(@link_lines,"<ldflags>/NODEFAULTLIB:LIBCMTD.lib</ldflags>\n");
	#push(@link_lines,"<ldflags>/NODEFAULTLIB:nafxcwd.lib</ldflags>\n");

	return @link_lines;
}

#源文件 目前只有.cpp类型的 可以追加.c ...类型
sub gen_bkl_cppfiles_vcproj($)
{
	my ($userxml)=@_;
	my @source_file;
	my (@filters)=@{$userxml->{"Files"}->{"Filter"}};
	my($i,$fbreak);
    $i=0;  
    $fbreak=0;
	foreach my $each(@filters)
	{
		if($each->{"Filter"}=~/.*(cpp).*/)
		{
			while($fbreak==0)
			{
				#print %{$files->{"File"}[$i]}->{"RelativePath"};
				my ($checkbuf)=%{$each->{"File"}[$i]}->{"RelativePath"};
				if(defined($checkbuf))
				{
					push(@source_file, $checkbuf);
                    $fbreak=0;
				}	
				else
				{
					$fbreak=1;
					last;
				}
				$i=$i+1;
			}			
		}
	}
    #foreach $sourcefile(@source_file)
	#{
	#	print $sourcefile."\n";
	#}
	return @source_file;
}

#根据cpp列表 生成bkl相应的选项行
sub create_source_line(@)
{
	my (@org_source_map_data)=@_;
    my @source_lines;
	#print @org_source_map_data;
    foreach $org_source_data(@org_source_map_data)
    {
    	if($org_source_data=~/.*.cpp(\s*)$/)
        {
             push(@source_lines,"<sources>$org_source_data</sources>\n");
        }
    }
    #print @source_lines;
    return @source_lines;
}

#获得资源文件
sub gen_bkl_rc_from_vcproj($)
{
	my ($userxml)=@_;
    my @rc_file;
    my (@filters)=@{$userxml->{"Files"}->{"Filter"}};

    my $index=0;
    my (@filerc);

	my($i,$fbreak);
    $i=0;  
    $fbreak=0;

    foreach my $each(@filters)
    {
    	if($each->{"Filter"}=~/.*(rc).*/)
        {	
			while($fbreak==0)
			{
				if(ref($each->{"File"}) eq "ARRAY")
				{
					print "gen_bkl_rc_from_vcproj ARRAY\n";
					my ($checkbuf)= %{$each->{"File"}[$i]};

					if(defined($checkbuf))
					{    
   
  						 push(@rc_file, values %{$each->{"File"}[$i]});
   						$fbreak=0;
					}
					else
					{             
   						$fbreak=1;
   						last;
					}
					$i=$i+1;
				}
				elsif(ref($each->{"File"}) eq "HASH")
                {
                    print "gen_bkl_rc_from_vcproj HASH\n";					
					print $each->{"File"}->{"RelativePath"};
					push(@rc_file,$each->{"File"}->{"RelativePath"});
					$fbreak=1;
					last;
               }
				else
				{
					$fbreak = 1;
					last;
				}
				#my ($checkbuf)= %{$each->{"File"}[$i]};
				#if($checkbuf!=undef)
				#if(defined($checkbuf))
				#{
				#	 #print (values %{$files->{"File"}[$i]})."\n";
				#	 push(@rc_file, values %{$each->{"File"}[$i]});
				#     $fbreak=0;
				#}
				#else
				#{				
				#	$fbreak=1;
				#	last;
				#}
				#$i=$i+1;
			}
        }
        $index=$index+1;
    }
	return @rc_file;
}

#根据资源文件 生成bkl相应的选项行
sub create_rc_line(@)
{
	my (@org_rc_map_data)=@_;
    my @rc_lines;
	foreach $org_rc_data(@org_rc_map_data)
	{
		if($org_rc_data=~/.*.rc(\s*)$/)
		{
			push(@rc_lines,"<win32-res>$org_rc_data</win32-res>\n");
		}
		#push(@rc_lines,"<win32-res>$org_rc_data</win32-res>\n");
	}
	print @rc_lines;
	return @rc_lines;
}

#获得目标名字
sub gen_bkl_tar_from_vcproj($)
{
    my ($userxml)=@_;
    my %target;
    $target{"tar"}=$userxml->{"Name"};
	#print $userxml->{"Name"}."\n";
	#print $target{"tar"};
    return %target; 
 }

#根据目标名字 生成bkl相应的选项行
sub create_target_line(%)
{
	my (%target)=@_;
	my (@ret_str);
	my $targetfile = $target{"tar"};
	push(@ret_str,"<$g_target_file id=\"$targetfile\">\n");

    #my $targetfile = "<$g_target id="."\"".$target{"tar"}."\"".">\n";
    #push(@ret_str,$targetfile);

	return @ret_str;
}

sub gen_bkl_dsp_tag_start()
{
	my $head_str=  <<EOF
<?xml version="1.0" ?>
<!-- \$Id: bakefile_quickstart.txt,v 1.5 2006/02/11 18:41:11 KO Exp \$ -->
<makefile>
EOF
; 
	print $head_str;
	return $head_str;
} 

sub gen_bkl_dsp_tag_mid()
{
	foreach $g_exe(@g_exe)
	{
		print "\t";
	    print $g_exe;
	}
	foreach $g_rc(@g_rc)
	{
		print "\t";     
		print $g_rc;
	} 
	foreach $g_cxx(@g_cxx)
	{
		print "\t";     
		print $g_cxx;
	} 

	#print "\t";
	#print "<include>D:\\usr\\include</include>\n";

	#print "\t";
    #print "<lib-path>D:\\usr\\lib</lib-path>\n";

	foreach $g_ldf_and_syslib(@g_ldf_and_syslib)
	{
		print "\t";     
		print $g_ldf_and_syslib;
	}
	foreach $g_source(@g_source)
    {
        print "\t";
        print $g_source;
    }
	push(@g_AllBuf,@g_exe);
	push(@g_AllBuf,@g_rc);
	push(@g_AllBuf,@g_cxx);
	#push(@g_AllBuf,"<include>D:\\usr\\include</include>\n");
	#push(@g_AllBuf,"<lib-path>D:\\usr\\lib</lib-path>\n");
	push(@g_AllBuf,@g_ldf_and_syslib);
	push(@g_AllBuf,@g_source);   
}

sub gen_bkl_dsp_tag_end()
{
	my $end_str= <<EOF
	</$g_target_file>
</makefile>
EOF
;
	print $end_str;
	return $end_str;
}

sub gen_bkl_dsp_tag_enduu()
{
    print <<EOF
    <sources>\$(fileList('*.cpp'))</sources>
    </$g_target_file>
</makefile>
EOF
;
}


