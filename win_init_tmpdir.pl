#!/usr/bin/perl
#2011_06_24_13:46:43   ������   add by greshem
#���� ÿ��Ŀ¼����� tmpĿ¼.

mkdir("C:\\Documents and Settings\\Administrator\\����\\��ݷ�ʽ_all");

for(a..z)
{

		if (  -d $_.":\\"  && ! -d $_."\\tmp")
		{
			printf $_."��Ҫ���� tmpĿ¼\n";
			mkdir("$_:\\tmp");
			if(!  -d  "$_:\\tmp" )
			{
				print "$_:\\tmp û������tmpĿ¼, ������ֻ������.\n"
			}
		}

		# if( ! -d $_.":\\")
		# {
		# 	print $_."�̲�����\n";
		# }
}
