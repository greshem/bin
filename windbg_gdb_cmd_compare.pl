#!/usr/bin/perl
foreach (<DATA>)
{
	print $_;
}
__DATA__

#2011_01_06_ add by greshem
添加较多的东西. 

bu MyFunction+0x47 ".dump c:\mydump.dmp; g"  

.opendump (Open Dump File)  dump g (Go)  dump-z  dump  

#2010_12_23_ add by greshem
1 生成dump 文件
dbg: generate-core-file 
cdb: .dump bbbbb
cdb: .writemem 和 dump 有些区别， 指定内存块大小 
cdb: dumpcab 把dump 压缩成 cab 文件
cpp: 可以参考这个crashdump.zip  程序的写法. 
cdb:  .dump /ma C:\testdump.dmp 
		#在 Windbg 中可以通过.dump命令保存进程的 dump 文件。比如下面的命令把当前进程
		#的镜像保存为 c:\testdump.dmp 文件： 
Adplus 同样可以抓去转储文件.
 
 
ollgdb: 
  
2. attach 正在运行的进程 
命令行执行
cdb -p 4008 
gdb --pid=4008  
进入 命令行之后
cdb .attach  .detach
gdb attach
gdb 直接退出就可以了.  


2.1 程序的调用函数的统计:
cdb:
wt: 
wt命令 
wt命令的作用是watch and trace data。 它可以跟踪一个函数的所有执行过程，并且给出统计信息。 
gdb: "gcc_代码覆盖率_gcov_统计.txt" 可以gdb  没有这个功能  linux 下可以实现这样的功能. 


3. 查看堆栈, 调用信息
wt 还不算太正确.  
cdb: wt (Trace and Watch Data)
gdb: where  
gdb: bt 
bt 和 where 的用法好像差不多。 
cdb: ! stacks 
gdb: info frames
cdb: ！clrstack -p #来看看调用堆栈和调用参数。但是如果函数的参数中如有泛型参数的时候，这种方法就有问题了

4. 线程 
gdb:  info threads 
cdb:  ~ 
4. 切换线程:
gdb: thread 1  #切换到一号线程.
cdb: ~number   #切换到 number号线程.
5. 进程
gdb: where  或者   info threads 就可以看到主进程是什么了
cdb: |. 当前进程
gdb:  set follow-fork-mode child 
cdb:    .childdbg (Debug Child Processes)


5. 打印数据
gdb: x /10d  addr  
	x /10s  addr   ;打印10个字符串.

gdb: print  
cdb:  dd da dc ...
cdb: .formats 0x33 .formats @eax 

6. 代码文件 src
gdb: 自己加载
cdb: .srvpath

7. 下断点 breakpoint 
cdb: bp winmain bp main
gdb: b main

8. 继续运行
gdb: continue run 
cdb: go 

9. 列出断点
gdb: info breakpoints 
cdb:    .bpcmds
cdb: bl  (breakpoints list)

10

6. 符号表 函数表  
cdb:  x 打印符号表 
cdb:  x ntdll!* 打印出ntdll 所有的函数了  注意格式. 
gdb:  break ntdll 之后按table 键，列出所有的函数了. 

10. 下一行， 下一个指令
gdb: next
cdb: p pr l+t l+s 
cdb: p(step)
cdb: 步入到函数调用的时候， 需要用 pc  (step to next call) 
cdb: t (step into ) 很有用的指令.  

11. enter, 重复上一个指令
gdb: enter 回车键
cdb: enter 回车键 

12. 
  

7. 时间 当前时间
cdb: .time 
cdb: .ttime ; thread 时间
gdb: call time() 

########################################################################
或者: p time 获取 地址 
$3 = {<text variable, no debug info>} 0x7feafaf22820 <time>
call   0x7feafaf22820() ;

8. call
gdb: call
cdb: .call  
.call 的语法和gdb 的有些不同， 需要整理一下. 
cdb: 不能通过 .call time() 来获取时间， 微软提供的符号表， 没有提供参数的信息，  但是如何调用 time  可以参看文档, <<windbg_片段代码_执行_good.txt>> 
cdb: !do 0x01e11da4 #调用对应的函数地址.

8.1  汇编片段执行
cdb: 参看 <<windbg_片段代码_执行_good.txt>> 

13. 加载符号表 
gdb: gdb 启动的时候  --readnever 
	进入gdb 之后:  symbol-file 
cdb:  

14. 列出所有的函数
gdb:  break  再 按 table 就会出现所有的符号了. 
cdb: 

15.  echo 打印
gdb: echo "this is the line \n"
cdb: .echo  

16. shell cmdline 命令行
cdb: .pcmd 
cdb:  .shell "ipconfig"
gdb: shell "ifconfig" 

17.  反汇编 
gdb: disassemble
cdb: a  uf  
cdb: u ;这条命令比较正确. 
cdb: 反汇编一个函数,  uf, ex: uf msvcrt!time
cdb: ln 可以检索一个地址旁边的函数名:  nearest |最近的 
	和 gdb 0x3333333 一样 最后可以确定到一个函数.


18.   显示代码
gdb: list
cdb: ls lsa lsc

19. 退出
gdb: exit
gdb: qq

20. trace
cdb: t
gdb: trace
gdb: trace 有写限制， 现在的版本， 不呢通过本地来执行， 需要两个进程， 一个服务， 一个客户端. 

21.   条件断点
cdb:   chm 里面的搜索里面， 输入"Conditional Breakpoint" 可以找到对应的信息
cdb:  对于gui 的程序如何下界面元素上的断点？ 
gdb:   

22. 清空断点, disable断点
cdb: bc
cdb: db(breakpoint disable)
gdb: delete

23.   死锁检测 deadlock
cdb: !deadlock 
gdb: 

24. 行号信息符号 
cdb: .lines 加载行号信息. 
gdb: 

25.  扩展模块
cdb: .load kdext.dll 
	dlls lmi lm 
gdb: gdb 没有扩展模块的概念

26 stl
cdb:  !stl 
gdb: 本来就支持 stl 的, "gdb_stl_容器打印.txt"

27. ptype  类型信息 
gdb: ptype (print type) 
cdb: dt (display type)

28. 局部变量 
cdb: dv (display local vairables)
cdb: !for_each_local 
gdb: info locals
gdb: x 打印地址.
cdb: x (examine symbols)

29.  内存填充 memset
gdb:  call memset()
cdb: f fp (fill memory)

30. 列出所有进程
把 windbg 的目录，放到 PATH变量里面去， 
cdb:  .shell(tlist)
cdb: .tlist
gdb:  shell ps -el
gdb:	file pid 
gdb: 	attach pid 
gdb: 就可以attach 上去了， 否则 进程和他的 exec-file 文件不对应. 

31.  函数 function 
cdb: .fnent 77f9f9e7
gdb: ptype funptr_addr

32. 列出加载模块
gdb:  info files 
cdb: lm  
cdb: lm v 更加详细

33. watch 内存断点 硬件断点
cdb: ga
cdb: ba  #breakpoint where memory is access.
gdb: wwatch watchw  watch

34. stack 栈 frame  stack
cdb: k kv kp kP 
cdb: dv 也是查看堆栈空间的内容
cdb: .frame n 也可以切换上下文. 
gdb: info frames, frame n 
gdb: where
gdb: backtrace
cdb: .frame 2 通过 k  来显示 堆栈空间， 但是注意 堆栈的 number 没有显示.

35.  清屏 cls
cdb:.cls
gdb:cls 

36 帮助
gdb: help
gdb: apropos, #模糊查找
cdb: 
!Ext.help
!Exts.help
!Uext.help
!Ntsdexts.help
!logexts.help
!clr10\sos.help
!wow64exts.help
!Wdfkd.help
!Gdikdx.help .

37. 符号表
cdb: !sym ld ln .sympath .symopt .symfix .reload 
gdb: 
cdb: x (eximine symbols)

38.代码 源代码.
cdb: .srcpath .srcnoisy .lines  

39. thread 线程
cdb: ~  ~e ~f ~u  !tls .ttime
gdb: info threads;  thread 1 ; 

40. hook, 多语句
cdb: bu MyFunction+0x47 ".dump c:\mydump.dmp; g"  
gdb: 需要用到 gdb 里面的hook 的功能. 

41. 搜索符号搜索
cdb: ln
gdb: a 然后tab 按键 

42. 符号不完全匹配符号 不匹配
cdb: reload /i    
gdb:  gdb 一旦发现CRC 文件不对就不会 加载符号文件了 

43. 查看宏
gdb: 
默认情况下，在GDB中是不能查看宏的值及定义的，但通过如下方法，则可以达到目的：
编译源代码时，加上“-g3 -gdwarf-2”选项，请注意不是“-g”，必须为“-g3”，查看宏的值使用命令p，这和查看变量的值的方法相同，如果想查看宏的定义，使用 “-macro expand”命令即可 

43 批处理 批命令 一连串命令
gdb: source 这个借助命令“source”即可，“source”的参数为一个存有一串命令的文件名 

44. 给多个函数打断点 , 
gdb: 
使用“rb”命令，如果执行“rb”时不带参数，则表示在所有函数处打一个断点，“rb”后面可以接一个符合正则表达式的参数，用来对符合正则表达式的所有函数打断点 

45. hook print
gdb: 
钩子用来在执行某个命令前或命令后，先执行某个或某些命令。假如想在print命令前显示一段 “----------”，则：
define hook-print
echo ----------\n
end


46. 列出符号， 列出当前模块
cdb: lm  
cdb: x *!  

47 分析转储文件
windows:  kd -y SymbolPath -i ImagePath -z DumpFileName
cdb: cdb -y SymbolPaht -i ImagePath -z DumpFileName 
cmdline: .opendump g
gdb: core-file  core.2233
cdb: .dump (Create Dump File)  #产生转储文件.

48.  循环结束, 跳出循环
gdb: finish until  return  
cdb: z  !for_each_xxx 扩展命令. 
cdb: gu (go up), 运行直到当前的函数返回. 
cdb: 一开始的时候才使用go  一般使用 step
cdb: pc  (step 到 next call) 比step 的间隔大多了.  

48. 源代码下断点, vc,界面上下断点. 
windbg: 
加入源代码调试 file->source file path
设置符号文件 file->symbol file path
给驱动程序下断点 设置好symbol file path和source file path
然后file->open source file打开调试驱动程序的源代码。
在对应的代码上按f9 下断点后，程序对应的行会变成红色。
cdb:  

49. restart 重新开始 Restart
cdb: .restart
gdb: R 就可以重新开始了. 

50.  符号查找，模糊查找 
cdb:  slimftpd 里面ex:  dt  *!sai*
					ex: x *!sai*
			004c45f4 SlimFTPd31!saiListen = struct sockaddr_in 
				ex: d SlimFTPd31!saiListen
				   +0x000 sin_family       : 0
				   +0x002 sin_port         : 0
				   +0x004 sin_addr         : in_addr
				   +0x008 sin_zero         : [8]  ""
gdb: 里面暂时没有用到. 

51. new 构造函数上下断点
gdb: tab 就可以找出来了
cdb:  用x *!pattern*  找出类的一些函数， 然后用 bm 下断点. 
cdb: 到new 的函数之后，  t 一直step into 下去. 

51.1  设置多个断点, 匹配 
gdb:  b mem*
cdb: bm ipconfig!*

52. 扩展 模块
cdb: .chains 
gdb: 没有模块的概念, 但是对应响应的脚本 source

53. lastError
cdb: !gle  //get last error 
gdb: call perror("last"); 

54. fork 子进程调试 
gdb:  set follow-fork-mode child 
cdb:    .childdbg (Debug Child Processes)

55. detach
gdb: quit 就可以detach
cdb: quit 并不可以detach  qd(quit and detach) 

56. 线程断点
cdb:  设置针对线程的断点：
	1. 用户程序，在bp前加入线程编号，如“~0 bp dbgee!main+4
	2. 内核程序，使用上面介绍的/p /t 选项来指定进程和线程
gdb: thread n 

57. 断点 disable enable
cdb: be (breakpoint enable ) bc (bp cancl);  bd(bp  disable);

58. 重新加载符号表  全部加载.
#前提是 在windbg 里面添加
"D:\symbols;SRV*D:\symbols*http://msdl.microsoft.com/download/symbols"
win: .reload /s /f   
	/s  加载全部modules
	/f forces 
	之前为了保证正确性，可以再用 !sym noisy  保证模糊性, 运行完之后用lm 就可以显示所有的 符号表了。 
#临时用的话 用下面的命令.
Set _NT_SYMBOL_PATH=symsrv*symsrv.dll*d:\\symbols*http://msdl.microsoft.com/download/symbols

59. 
cdb: .hh
gdb: help topic

60.  寄存器 register
cdb: r  
gdb: info register

61.  反汇编 
gdb: disassemble
cdb: 

62. 显示字符串  strings
cdb: ds   address 
gdb: x/10s address 

63. search  内存里面search find 搜索 确定界面上的数据究竟来自于什么地方还是挺有用的.
cdb: s 
gdb: find -- Search memory for a sequence of bytes

64. 地址统计
cdb: !address
gdb:
65. source file
cdb: lsf
cdb: ls 
gdb: file
gdb: list  

66:
cdb: 打印每个帧的每个变量
	! for_each_frame ! for_each_local dt@#Local 
	ebook9 windbg用法详解里面.

67 cpu消耗信息 运行信息
cdb:
	!runaway 检查线程的 CPU 消耗 
	!runaway可以显示每一个线程所耗费 usermode CPU 时间的统计信息： 
gdb: 
########################################################################
68. 符号匹配 模糊匹配 
cdb:   dds 对应二进制地址的符号 
dds 打印内存地址上的二进制值，同时自动搜索二进制值对应的符号。比如要看看当
前 stack  中保存了哪些函数地址，就可以检查 ebp指向的内存：
gdb:  

69.
异常处理:  exception
cdb: .ecxr  , !analyze -v, 分析转储文件. 程序生成转储文件. 

70. 脚本
gdb: source ~/.stl-views.gdb
windbg: 写扩展  制作成dll 

71.日志 
gdb:  
	set logging on    打开记录功能。
	set logging off   关闭记录功能。
	set logging file file   改变当前日志文件的名称。默认的日志文件是`gdb.txt'。
	set logging overwrite [on|off
windbg: 
	界面上对应的日志文件的保存的菜单.
	Edit->open/close log file..

72 翻页: <return> quit 
gdb: 	set height 0 
		set pagination off
windbg:

