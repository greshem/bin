echo off
if "%1"=="" (
  echo  %0  input_keyword 
) else (



iso_copy_out_to_desktop.pl "sdb1:\sdb1\_xfile\2013_all_iso\_xfile_2013_07_3of4.iso\\windows_kb2\\windows_dll_all_desc"

echo findstr /I %1  P:\windows_kb2\windows_dll_all_desc\*.txt
findstr /I %1 P:\windows_kb2\windows_dll_all_desc\*.txt


)