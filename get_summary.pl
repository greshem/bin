#!/usr/bin/perl
for $each (glob("*todo.txt"))
{
	#aic94xx_firmware_Դ��_����_todo.txt
	$name=$each;
	$name=~s/_Դ��_����_todo.txt//g;

	$keyword=$name;
	$keyword=~s/_/-/g;

	print(" /bin/rpm_get_summary.sh  $keyword >>  $each \n");
	system(" /bin/rpm_get_summary.sh  $keyword >>  $each ");
}
