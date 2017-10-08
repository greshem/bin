use File::Basename;
use Archive::Zip qw( :ERROR_CODES :CONSTANTS );
use Win32::File::VersionInfo;
use ActiveState::Path qw(path_list);

use Data::Dumper;

#getFileDesc("c:\\bin_exe\\depeneds.exe");
#for (glob("C:\\Windows\\System32\\*.exe"))
#for (glob("C:\\Windows\\System32\\*.dll"))

my @tmp=glob("*.dll");
push(@tmp, glob("*.exe"));
push(@tmp, glob("*.sys"));

for(@tmp)
{
	my $desc=getFileDesc($_);
	my $filename=$_;
	
	print $_."|\t".$desc."\n";
	#print $desc."|\t".$_."\n";
}

#==========================================================================
#ProductVersion
sub getFileDesc
{
    my $file = shift;
    my $ver = GetFileVersionInfo($file);
    return 0 if(!$ver);

	#print Data::Dumper->Dump([$ver]);

    my $lang = ( keys %{$ver->{Lang}} )[0] ;
    if($lang){
        $copyright = $ver->{Lang}{$lang}{LegalCopyright};
		$desc=       $ver->{Lang}{$lang}{FileDescription};
		$version=    $ver->{Lang}{$lang}{ProductVersion};
		$fileVersion =  $ver->{Lang}{$lang}{FileVersion};
		$desc=  $ver->{Lang}{$lang}{FileDescription};
        #print $copyright,"\n";
		#print $version."\t";
		#print $fileVersion."\t";
		#print $desc."\t\t\t\t|";
        if($copyright =~
        /^((Copyright)|(°æÈ¨ËùÓÐ))?.{0,5}(\d{4}( ?- ?\d{4})? )?Microsoft/){
            return $desc;
        }
    }
    return 0;
}
__DATA__
$VAR1 = {
          'Flags' => {
                       'Patched' => 0,
                       'InfoInferred' => 0,
                       'SpecialBuild' => 0,
                       'Debug' => 0,
                       'PrivateBuild' => 0,
                       'Prerelease' => 0
                     },
          'FileVersion' => '6.1.7601.17725',
          'Lang' => {
                      'English (United States)' => {
                                                     'FileDescription' => 'LSA Server DLL',
                                                     'LegalCopyright' => '? Microsoft Corporation. All rights reserved.',
                                                     'FileVersion' => '6.1.7601.17514 (win7sp1_rtm.101119-1850)',
                                                     'CompanyName' => 'Microsoft Corporation',
                                                     'ProductVersion' => '6.1.7601.17514',
                                                     'ProductName' => 'Microsoft? Windows? Operating System',
                                                     'OriginalFilename' => 'lsasrv.dll.mui',
                                                     'InternalName' => 'lsasrv.dll'
                                                   }
                    },
          'ProductVersion' => '6.1.7601.17725',
          'Date' => '0000000000000000',
          'Type' => 'DLL',
          'OS' => 'NT/Win32',
          'Raw' => {
                     'FlagMask' => '0000003F',
                     'Type' => '00000002',
                     'Flags' => '00000000',
                     'OS' => '00040004',
                     'FileVersion' => '000600011DB1453D',
                     'SubType' => '00000000',
                     'ProductVersion' => '000600011DB1453D',
                     'Date' => '0000000000000000'
                   }
        };
