#!/bin/bash
cat <<EOF
cpio -ivmd < temp.cpio #解压, 更多命令 参考 file_type_cmd_dump.pl
cpio -o -c . > output.cpio  #生成  cpio 文件. 
EOF
