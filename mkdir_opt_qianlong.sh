 #!/bin/sh 
current=$(pwd)
 ql_mkdir()
 {
 [[  -d $1 ]] || mkdir -p $1
 }
ql_mkdir opt/qianlong/
ql_mkdir opt/qianlong/right
ql_mkdir opt/qianlong/syscfg
ql_mkdir opt/qianlong/syscfg/cfg
ql_mkdir opt/qianlong/syscfg/user2
ql_mkdir opt/qianlong/syscfg/user1
ql_mkdir opt/qianlong/logs
ql_mkdir opt/qianlong/logs/qlserver
ql_mkdir opt/qianlong/logs/lxclient
ql_mkdir opt/qianlong/logs/market
ql_mkdir opt/qianlong/logs/rttool
ql_mkdir opt/qianlong/service
ql_mkdir opt/qianlong/service/qlserver
ql_mkdir opt/qianlong/service/lxclient
ql_mkdir opt/qianlong/service/market
ql_mkdir opt/qianlong/service/market/cfg
ql_mkdir opt/qianlong/client
ql_mkdir opt/qianlong/client/lonld
ql_mkdir opt/qianlong/client/lonld/data
ql_mkdir opt/qianlong/client/lonld/data/ml45
ql_mkdir opt/qianlong/client/lonld/cfg
ql_mkdir opt/qianlong/client/lonld/lib
ql_mkdir opt/qianlong/client/lonld/temp
ql_mkdir opt/qianlong/client/lonld/usrcfg
ql_mkdir opt/qianlong/client/tmp
ql_mkdir opt/qianlong/client/tmp/data
ql_mkdir opt/qianlong/client/tmp/data/ml45
ql_mkdir opt/qianlong/client/tmp/data/qlzx
ql_mkdir opt/qianlong/client/tmp/data/qlzx/hdbb
ql_mkdir opt/qianlong/client/tmp/usrcfg
ql_mkdir opt/qianlong/client/tmp/usrcfg/block
ql_mkdir opt/qianlong/tools
ql_mkdir opt/qianlong/tools/rttool
ql_mkdir opt/qianlong/tools/srvcontrol
ql_mkdir opt/qianlong/sysdata
ql_mkdir opt/qianlong/sysdata/realtime
ql_mkdir opt/qianlong/sysdata/realtime/shase
ql_mkdir opt/qianlong/sysdata/realtime/sznse
ql_mkdir opt/qianlong/sysdata/lxinfo
ql_mkdir opt/qianlong/sysdata/lxinfo/shase
ql_mkdir opt/qianlong/sysdata/lxinfo/shase/info2
ql_mkdir opt/qianlong/sysdata/lxinfo/shase/info3
ql_mkdir opt/qianlong/sysdata/lxinfo/shase/info1
ql_mkdir opt/qianlong/sysdata/lxinfo/sznse
ql_mkdir opt/qianlong/sysdata/lxinfo/sznse/info2
ql_mkdir opt/qianlong/sysdata/lxinfo/sznse/info3
ql_mkdir opt/qianlong/sysdata/lxinfo/sznse/info1
ql_mkdir opt/qianlong/sysdata/news
ql_mkdir opt/qianlong/sysdata/qlzx
ql_mkdir opt/qianlong/sysdata/qlzx/shase
ql_mkdir opt/qianlong/sysdata/qlzx/shase/info2
ql_mkdir opt/qianlong/sysdata/qlzx/shase/info3
ql_mkdir opt/qianlong/sysdata/qlzx/shase/info3/601099
ql_mkdir opt/qianlong/sysdata/qlzx/shase/info1
ql_mkdir opt/qianlong/sysdata/qlzx/sznse
ql_mkdir opt/qianlong/sysdata/qlzx/sznse/info2
ql_mkdir opt/qianlong/sysdata/qlzx/sznse/info3
ql_mkdir opt/qianlong/sysdata/qlzx/sznse/info3/430025
ql_mkdir opt/qianlong/sysdata/qlzx/sznse/info3/002204
ql_mkdir opt/qianlong/sysdata/qlzx/sznse/info3/002203
ql_mkdir opt/qianlong/sysdata/qlzx/sznse/info3/430024
ql_mkdir opt/qianlong/sysdata/qlzx/sznse/info1
ql_mkdir opt/qianlong/sysdata/qlzx/hdbb2
ql_mkdir opt/qianlong/sysdata/qlzx/hdbb
ql_mkdir opt/qianlong/sysdata/history
ql_mkdir opt/qianlong/sysdata/history/shase
ql_mkdir opt/qianlong/sysdata/history/shase/base
ql_mkdir opt/qianlong/sysdata/history/shase/base/base
ql_mkdir opt/qianlong/sysdata/history/sznse
ql_mkdir opt/qianlong/sysdata/history/sznse/base
ql_mkdir opt/qianlong/sysdata/history/sznse/base/base
ql_mkdir opt/qianlong/sysdata/remote
ql_mkdir opt/qianlong/sysdata/remote/shhq
ql_mkdir opt/qianlong/sysdata/remote/msg
ql_mkdir opt/qianlong/sysdata/remote/szhq