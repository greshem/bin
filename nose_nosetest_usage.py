#!/usr/bin/python
#coding=utf-8
DATA="""
nosetests --collect-only -v :不运行程序，只是搜集并输出各个case的名称

nosetests -x  :一旦case失败立即停止，不执行后续case
-w ，指定一个目录运行测试。目录可以是相对路径或绝对路径

nosetest    a.py                   运行test_a.py中所有用例
nosetest    test_a.py:testfunc     运行test_a.py中的testfunc用例
nosetests   --with-coverage执行即可

"""
print DATA;
