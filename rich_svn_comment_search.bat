if "%1"=="" (
  echo  %0  input_keyword 
) else (

iso_copy_out_to_desktop.pl "sdb1:\\sdb1\_xfile\2013_all_iso\\_xfile_2013_06.iso\\"



echo batchmnt /unmount q:
echo  batchmnt.exe P:\_xfile_2013_04\exploit-db\2013_04_10_archive.iso       q /wait

findstr /I  %1  J:\sdb1\_xfile\2013_all_iso\_xfile_2013_06\rich_svn_log_search\gb2312\*.txt 
findstr /I  %1  J:\sdb1\_xfile\2013_all_iso\_xfile_2013_06\rich_svn_log_search\*.txt 

findstr /I  %1  p:\\rich_svn_log_search\\gb2312\\*.txt 
findstr /I  %1  p:\\rich_svn_log_search\\*.txt 
)