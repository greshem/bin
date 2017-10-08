if "%1"=="" (
  echo  %0  input_keyword 
) else (

iso_copy_out_to_desktop.pl "sdb1:\\sdb1\\jianpu.cn\\WWW.JIANPU.CN_3_ISO.iso\\"



echo batchmnt /unmount q:
echo  batchmnt.exe P:\_xfile_2013_04\exploit-db\2013_04_10_archive.iso       q /wait

echo findstr /I %1 p:\\output.txt
findstr /I %1 p:\\output.txt

)