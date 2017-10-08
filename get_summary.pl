#!/usr/bin/perl
for $each (glob("*todo.txt"))
{
	#aic94xx_firmware_源码_分析_todo.txt
	$name=$each;
	$name=~s/_源码_分析_todo.txt//g;

	$keyword=$name;
	$keyword=~s/_/-/g;

	print(" /bin/rpm_get_summary.sh  $keyword >>  $each \n");
	system(" /bin/rpm_get_summary.sh  $keyword >>  $each ");
}
