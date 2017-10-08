#!/bin/bash
if uname -a |grep _64;then
echo "64bit systen"
echo ./one_step_qianlong-scirpts_x64.sh
else
echo "32bit system"
echo ./qianlong-scirpts.sh
fi
