#!/usr/bin/perl
foreach (<DATA>)
{
    print $_;
}
__DATA__

./rally/install_rally.sh -v
rally-manage db recreate

rally deployment create --filename=existing.json --name=existing
rally deployment list
rally deployment check

#--------------------------------------------------------------------------
#创建  用户 删除用户
rally -v task start rally/doc/samples/tasks/scenarios/keystone/create-and-delete-user.json
rally -v task start rally/doc/samples/tasks/scenarios/nova/boot-and-delete.json

#--------------------------------------------------------------------------
#report 报告.
rally task list 
rally task report 0dae2041-11df-4d19-ae7c-6d4a31da7786      --out output.html 

#--------------------------------------------------------------------------
#所有的case 跑起来.
for each in $( find /home/git_linux_src/rally/samples/ )
do
rally -v task  start   $each 
done

#
#--------------------------------------------------------------------------
rally task list 
for each in $(  rally task list |awk -F\|  '{print $2}'  )
do
rally  task  report    $each  --output   $each.html 
done

