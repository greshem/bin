echo off
if "%1"=="" (
  echo  %0  input_keyword 
) else (


iso_copy_out_to_desktop.pl "sdb1:\sdb1\software_iso\aix_targz_iso.iso\\filelist\" 

echo batchmnt /unmount q:
echo  batchmnt.exe P:\_xfile_2013_04\exploit-db\2013_04_10_archive.iso       q /wait

echo findstr /I %1 p:\\filelist\\*pathlist
findstr /I %1 p:\\filelist\\*pathlist

)