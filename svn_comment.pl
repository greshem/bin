#!/usr/bin/perl
foreach (<DATA>)
{
	print $_;
}
__DATA__
	一个svn 的提交带有多种 属性的花 通过  add_bug_release 的方式提交, 但是把 级别最高的放在前面.
    Add_1m: something
    Bug_1h: [fix|found]: describe the bug or fix.
    Chg_2h: something 
    Del_30h: something
    Enh_20m: some treatment
    New_3h: something
    Tmp_4h: for some 
    Tst_10m:  单元测试: some descirbtion 	
	Refact_1h: 重构.
	Review_1h: 代码评审. 
	Design_1h: 设计. 
	wiki_10m: 对代码的修改 同时也是一个 知识点.
	release_3m: 发布一个版本.
	
########################################################################
#简写意义
Chg Change
Enh Enhancement
Tst: 单元测试.
Refact: 重构
Review: 代码评审
