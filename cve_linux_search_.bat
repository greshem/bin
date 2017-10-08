
 
 if "%1"=="" (
  echo  %0  input_keyword 
) else (
batchmnt /unmount q:
batchmnt /unmount p:
iso_copy_out_to_desktop.pl "sdb1:\sdb1\_xfile\2013_all_iso\_xfile_2013_08.iso\\"


echo  cve_search_linux
findstr /I  %1 p:\\cve_search_linux\\*.txt

)
