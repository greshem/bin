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
    	#��������в��� vcproj���͵��ļ���
    	$vcproj_file = shift or die("usage: $0 input prams like [vcprogfilename] [D(release)|R(debug)]\n");
    	# ��������в����� D|d ��debug�汾 R|r ��release�汾
    	$g_option= shift or die("usage: $0 input Compil-option D(Debug) or R(Release)\n");
    }
}

#��������в��� vcproj���͵��ļ���
#our $vcproj_file = shift or die("usage: $0 input prams like [vcprogfilename] [D(release)|R(debug)]\n"); 

# ��������в����� D|d ��debug�汾 R|r ��release�汾
#our $g_option= shift or die("usage: $0 input Compil-option D(Debug) or R(Release)\n"); 


our @g_exe;             #Ŀ������
our @g_lib_path;        #��̬��·��
our @g_rc;              #��Դ�ļ�
our @g_cxx;				#����ѡ��
our @g_ldf_and_syslib;	#����ѡ���lib
our @g_source;			#Դ�ļ�
our $g_target_file="exe";#Ŀ���ļ�����
#our $g_option="D";
our $g_charaset;		#�ַ���ѡ��
our $g_usemfc;			#mfc���÷�ʽ
our $g_type_index=0;	#��ȡDebug�Ļ���Release�� 0 debug 1 release
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
	#ȫ��ѡ��
	gen_global_option($userxml);
	#����ѡ��
	my (%cxx_lines)=gen_bkl_cxx_from_vcproj($userxml);
	@g_cxx=create_cxx_line(%cxx_lines);
    #����ѡ��
	my (%link_lines)=gen_bkl_cl_from_vcproj($userxml);
    @g_ldf_and_syslib=create_clink_line(%link_lines);
    #��Դ�ļ�
	my(@rc_lines)=gen_bkl_rc_from_vcproj($userxml);
	@g_rc=create_rc_line(@rc_lines);
	#Ŀ���ļ�
	my (%target)=gen_bkl_tar_from_vcproj($userxml);
	@g_exe=create_target_line(%target);
	#ԭ�ļ�
	my(@source_lines)=gen_bkl_cppfiles_vcproj($userxml);
	@g_source=create_source_line(@source_lines);
    my $head_str = gen_bkl_dsp_tag_start();
    gen_bkl_dsp_tag_mid();
    my $end_str = gen_bkl_dsp_tag_end();
	
	(my $name)=($filename=~/(.*)\.[VCPROJ|vcproj]/);
	my $output_bkl=$name.".bkl";
	open(BKL, "> ".$output_bkl) or die("open file $output_bkl ����, $!\n");
	print BKL $head_str;
	foreach $thisBuf(@g_AllBuf)
    {
		print BKL "\t";
        print BKL $thisBuf;
    }
	print BKL $end_str;
	close(BKL);	
}

#�������ѡ���� ����汾 �ַ��� Ŀ������ mfc���÷�ʽ
sub gen_global_option($)
{
	#���ַ��а汾���ǵ��԰汾
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
	
	#�ַ���ѡ��
    $g_charaset =@{$userxml->{"Configurations"}->{"Configuration"}}[$g_type_index]->{"CharacterSet"};
	#print $g_charaset."\n";
	
	#MFCѡ��
	$g_usemfc =@{$userxml->{"Configurations"}->{"Configuration"}}[$g_type_index]->{"UseOfMFC"};
	#print $g_usemfc."\n";
	
	#��������
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

#��ñ���ѡ��
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
			
			#print "���������".%cxx_map_data."\n";
            #while(($key,$value)=each %cxx_map_data)
			#{
			#	print "$key => $value\n";
			#}
		}
		$index=$index+1;
    }
    return %cxx_map_data;
}

#�������ѡ�� ����bkl��Ӧ��ѡ����
sub create_cxx_line(%)
{
	my (%org_cxx_map_data)=@_;
    my @cxx_lines;	
    #UsePrecompiledHeaderָʾ����������Ԥ����ͷ�ļ� (.pch)�����ļ���ʾ��ĳһʱ�̵ı���״̬��
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
   
	#PreprocessorDefinitions һЩѡ��
    my @array=split(/;/,$org_cxx_map_data{"PreprocessorDefinitions"});
	for(@array)
	{
		push(@cxx_lines,"<cxxflags>/D$_ </cxxflags>\n");
	} 
	#�ַ�����
	if($g_charaset==1)
	{
		push(@cxx_lines,"<cxxflags>/D_UNICODE</cxxflags>\n");
	    push(@cxx_lines,"<cxxflags>/DUNICODE</cxxflags>\n");
	}
	elsif($g_charaset==2)
	{
		push(@cxx_lines,"<cxxflags>/D_MBCS</cxxflags>\n")
	}
	#mfcѡ��
	if($g_usemfc==2)
    {
        push(@cxx_lines,"<cxxflags>/D_AFXDLL</cxxflags>\n");
    }

	#MinimalRebuild ��С������
	if($org_cxx_map_data{"Optimization"} eq true)
	{
        push(@cxx_lines,"<cxxflags>/Gm</cxxflags>\n");
    }

	#WarningLevel ���漶��
	if($org_cxx_map_data{"WarningLevel"}>=1)
	{
		push(@cxx_lines,"<cxxflags>/W$org_cxx_map_data{WarningLevel}</cxxflags>\n");
	}
	
	#BasicRuntimeChecks ����ʱ��⣬����ջ��δ��ʼ��������
    
	#DebugInformationFormat������Ϣ��ʽ ��׼ȷ
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

	#RuntimeLibrary 2005���Գ�����
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

	#WholeProgramOptimization���Ϊ true��������ȫ�����Ż�
	if($org_cxx_map_data{"WholeProgramOptimization"} eq "true")
    {
        push(@cxx_lines,"<cxxflags>/GL</cxxflags>\n");
    }
	
	#AdditionalIncludeDirectories��Ŀ¼��ӵ�Ҫ���������������ļ���Ŀ¼�б��С���Ҫ�޸�
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

	#ExceptionHandling�쳣ѡ��
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

	#EnableEnhancedInstructionSet ֵ������ѡ��
	
	#FloatingPointModelֵ������ѡ��
	
	#GenerateXMLDocumentationFiles���Ϊ true������������Դ�����ļ��е��ĵ�ע�ͽ��д�����Ϊÿ�������ĵ�ע�͵�Դ�����ļ�����һ�� .xdc �ļ�
	
	#Detect64BitPortabilityProblems����Ƿ����64λ����
	
	#print @cxx_lines;   
    #print "UsePrecompiledHeader"."::".$org_cxx_map_data{"UsePrecompiledHeader"}."\n";
    
	return @cxx_lines;
}

#�������ѡ��
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
			#print "���Ӳ�����".%cxx_map_data."\n";
            #while(($key,$value)=each %cxx_map_data)
            #{
            #    print "$key => $value\n";
            #}
         }
         $index=$index+1;
     }
	return %cxx_map_data;
}

#��������ѡ�� ����bkl��Ӧ��ѡ����
sub create_clink_line(%)
{
	my (%org_cxx_map_data)=@_;
    my @link_lines;
	
	#fixme:  TargetMachine/MACHINE ѡ��ָ�������Ŀ��ƽ̨�������Ļ�û�е��ԣ�����
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
    #fixme: SubSystemָ����ִ���ļ��Ļ��� ����û�е��ԣ�����
    if($org_cxx_map_data{"SubSystem"}==1)
    {
        push(@link_lines,"<ldflags>/SUBSYSTEM:CONSOLE</ldflags>\n");
    }
	elsif($org_cxx_map_data{"SubSystem"}==2)
	{
		push(@link_lines,"<ldflags>/SUBSYSTEM:WINDOWS</ldflags>\n");
	}
 
    #GenerateDebugInformation/DEBUG ѡ��� .exe �ļ��� DLL �ĵ�����Ϣ��
    if($org_cxx_map_data{"GenerateDebugInformation"} eq "true")
    {
        push(@link_lines,"<ldflags>/DEBUG</ldflags>\n");
    }
 
    #LinkIncremental/INCREMENTAL ѡ�������������δ����������ӡ�
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

	#AdditionalDependencies���������ṩ�������󡢵����ͱ�׼�⡢��Դ��ģ�鶨�������������ļ��� 
    my @array=split(/ /,$org_cxx_map_data{"AdditionalDependencies"});
    for(@array)
    {
		$_=~s/\.lib//;
        push(@link_lines,"<sys-lib>$_</sys-lib>\n");
    }
	
	#AssemblyDebug���Ϊ true�������� DebuggableAttribute �����Լ�������Ϣ���٣������� JIT �Ż� �Լ����Գ�����
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
	
	#OptimizeReferences���Ϊ true����������Զ�������õĺ�����/�����ݣ�����
	if($org_cxx_map_data{"OptimizeReferences"}==1)
	{
		push(@link_lines,"<ldflags>/OPT:NOREF</ldflags>\n");
	}
	elsif($org_cxx_map_data{"OptimizeReferences"}==2)
	{
		push(@link_lines,"<ldflags>/OPT:REF</ldflags>\n");
	}

	#EnableCOMDATFolding���Ϊ true����������ͬ�� COMDAT �۵� �Լ����Ե� ������
	if($org_cxx_map_data{"EnableCOMDATFolding"}==1)
	{
		push(@link_lines,"<ldflags>/OPT:NOICF</ldflags>\n");
	}
	elsif($org_cxx_map_data{"EnableCOMDATFolding"}==2)
	{
		push(@link_lines,"<ldflags>/OPT:ICF</ldflags>\n");
	}
	
	#GenerateMapFile���Ϊ true���򴴽�ӳ���ļ��� ӳ���ļ����ļ���չ��Ϊ .map
	if($org_cxx_map_data{"GenerateMapFile"} eq "true")
	{
		push(@link_lines,"<ldflags>/MAP</ldflags>\n");
	}
    
	#MapFileName��Ĭ��ӳ���ļ�������Ϊָ�����ļ�����
    
	#MapExports���Ϊ true����֪ͨ��������Ӱ���ļ��а�������������
	
	#���Կ�
	my @arrayigno=split(/;/,$org_cxx_map_data{"IgnoreDefaultLibraryNames"});
	for(@arrayigno)
	{
		push(@link_lines,"<ldflags>/NODEFAULTLIB:$_</ldflags>\n");
	}	
	#/DEF:"CopyFileWrapper.def"ģ�鶨���ļ�
	my $def_file = $org_cx_map_data{"ModuleDefinitionFile"};
	if(defined($def_file)&&!($def_file eq ""))
    {
       push(@link_lines,"<ldflags>/DEF:\"$def_file\"</ldflags>\n");
    }

	#/DEF:"RandomizedBaseAddress"��������ַ
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

#Դ�ļ� Ŀǰֻ��.cpp���͵� ����׷��.c ...����
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

#����cpp�б� ����bkl��Ӧ��ѡ����
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

#�����Դ�ļ�
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

#������Դ�ļ� ����bkl��Ӧ��ѡ����
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

#���Ŀ������
sub gen_bkl_tar_from_vcproj($)
{
    my ($userxml)=@_;
    my %target;
    $target{"tar"}=$userxml->{"Name"};
	#print $userxml->{"Name"}."\n";
	#print $target{"tar"};
    return %target; 
 }

#����Ŀ������ ����bkl��Ӧ��ѡ����
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


