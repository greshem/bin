#!/bin/bash
cat <<EOF
cpio -ivmd < temp.cpio #��ѹ, �������� �ο� file_type_cmd_dump.pl
cpio -o -c . > output.cpio  #����  cpio �ļ�. 
EOF
