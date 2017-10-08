#!/usr/bin/perl
foreach (<DATA>)
{
	print $_;
}
__DATA__

cd /home/git/gitlab-shell/bin gitlab-projects
 ./gitlab-projects import-project     cloud/keystone  http://gitlab:10080/cloud/keystone.git   

# 刷新 导入到 postgresql 数据库中
cd /home/git/gitlab
cd bundle exec rake gitlab:import:repos RAILS_ENV=production
