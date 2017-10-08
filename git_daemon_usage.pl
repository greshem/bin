#!/usr/bin/perl 
print <<EOF
yum install git-daemon 
git daemon --reuseaddr --base-path=. --export-all --verbose --enable=receive-pack

/usr/libexec/git-core/git-daemon --base-path=\$(pwd) --export-all --user-path=public_git  --verbose


EOF
;


my $ip=`hostname -I |awk   '{print \$1}'  `;
chomp($ip);

for $each   (grep { -d }  (glob("*")) )
{
	print <<EOF
	git clone  git://$ip/$each 
EOF
;
}
