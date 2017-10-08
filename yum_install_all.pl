#!/usr/bin/perl
for $each  (a..z)
{
	print "yum -y install $each\* --skip-broken\n";
	system( "yum -y install $each\* --skip-broken\n");
}
#==========================================================================
#It is much simpler than last implementing, with perl syntax (aa..zz)
for $each1  (aa..zz)
{
	print "yum -y install ${each}${each1}*   --skip-broken \n";
	system( "yum -y install ${each}${each1}*   --skip-broken \n");
}

