#!/usr/bin/perl

open(PIPE, " git branch -a |") or die(" git branch  error \n");
for $each (<PIPE>)
{
    chomp($each);
    if($each=~/remotes\/origin/ &&  $each!~/-\>/)
    {
        print "#".$each."\n";;
        $to=$each;
        $to=~s/remotes\/origin/local/g;
        print "git   checkout   $each  -b   $to \n";  
    }
}

__DATA__
[root@petty5 devstack]# git branch -a
* （分离自 origin/stable/kilo）
  master
  remotes/origin/HEAD -> origin/master
  remotes/origin/master
  remotes/origin/stable/kilo
  remotes/origin/stable/liberty
  remotes/origin/stable/mitaka

