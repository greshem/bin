#!/usr/bin/perl 
#
#hadoop  fs -lsR hdfs://192.168.0.51:8020/user/hive/warehouse/tyd.db/
#hadoop distcp -overwrite   hdfs://192.168.0.51:8020/user/hive/warehouse/tyd.db/tyd_user_pref_sex_ft    hdfs://192.168.1.21:9000/tyd.db

# hadoop  fs -du -h  hdfs://192.168.0.51:8020/user/hive/warehouse/tyd.db/tyd_user_log_market_mt
# hadoop  fs -du -h  hdfs://192.168.0.51:8020/user/hive/warehouse/tyd.db/tyd_user_log_column_mt
# hadoop  fs -du -h  hdfs://192.168.0.51:8020/user/hive/warehouse/tyd.db/tyd_user_log_apk_visit_mt
# hadoop  fs -du -h  hdfs://192.168.0.51:8020/user/hive/warehouse/tyd.db/tyd_user_log_apk_mt

# hadoop  fs -du -h  hdfs://192.168.1.21:9000/tyd.db/tyd_user_log_apk_mt
# hadoop  fs -du -h  hdfs://192.168.1.21:9000/tyd.db/tyd_user_log_column_mt
# hadoop  fs -du -h  hdfs://192.168.1.21:9000/tyd.db/tyd_user_log_apk_visit_mt
# hadoop  fs -du -h  hdfs://192.168.1.21:9000/tyd.db/tyd_user_log_apk_mt



#use Cwd;
use File::Basename;
#our $g_pwd=getcwd();
#our $g_basename=basename($g_pwd);
#our $g_dirname=dirname($g_pwd);

#important_db();

four_important_dir();


#马松玉 给的 4个比较重要的目录. 
sub  four_important_dir()
{
	$dir= "hdfs://192.168.0.51:8020/user/hive/warehouse/tyd.db/tyd_user_log_apk_mt";
	@sub_dirs=get_subdir_from($dir);
	dump_copy_scritps($dir, @sub_dirs);

	$dir= "hdfs://192.168.0.51:8020/user/hive/warehouse/tyd.db/tyd_user_log_column_mt";
	@sub_dirs=get_subdir_from($dir);
	dump_copy_scritps($dir, @sub_dirs);

	$dir="hdfs://192.168.0.51:8020/user/hive/warehouse/tyd.db/tyd_user_log_apk_visit_mt";
	@sub_dirs=get_subdir_from($dir);
	dump_copy_scritps($dir, @sub_dirs);

	$dir="hdfs://192.168.0.51:8020/user/hive/warehouse/tyd.db/tyd_user_log_apk_mt";
	@sub_dirs=get_subdir_from($dir);
	dump_copy_scritps($dir, @sub_dirs);
}


sub  dump_copy_scritps($@)
{
	(my $from , my @sub_dirs)=@_;
	$basename=basename($from);
	for(@sub_dirs)
	{
	chomp();
	$sub_basename=basename($_);
	print <<EOF
	hadoop distcp   -Ddfs.checksum.type=CRC32   -skipcrccheck  -update    $_   hdfs://192.168.1.21:9000/tyd.db/$basename/$sub_basename 
EOF
;
	}
}

sub get_subdir_from()
{
	(my $input_dir)=@_;

	my @ret;
	open(PIPE, "  hadoop fs  -ls   $input_dir |") or die("open hadoop fs error \n");
	for(<PIPE>)
	{
		#print $_;
		@array=split(/\s+/, $_);
		$path= $array[$#array]."\n";
		push(@ret, $path);
	}
	close(PIPE);
	return @ret;
}

sub  important_db()
{

	#最重要的表
		@importants= qw(
	/user/hive/warehouse/tyd.db/tyd_user_log_market_mt
	/user/hive/warehouse/tyd.db/tyd_user_log_column_mt
	/user/hive/warehouse/tyd.db/tyd_user_log_apk_visit_mt
	/user/hive/warehouse/tyd.db/tyd_user_log_apk_mt
	); 

	for  (@importants) 
	{

	$basename= basename($_);

print <<EOF
hadoop fs  -mkdir    hdfs://192.168.1.21:9000/tyd.db/$basename
hadoop distcp -overwrite   hdfs://192.168.0.51:8020/$_   hdfs://192.168.1.21:9000/tyd.db/$basename
EOF
;

		
	}
}

sub   import_all_db()
{

	for(<DATA>)
	{
	chomp;	
	#$array=split(/\//$_);

print <<EOF
hadoop distcp -overwrite   $_   hdfs://192.168.1.21:9000/tyd.db
EOF
;

	print <<EOF
	hadoop  fs -ls  $_
EOF
;

	}

}

__DATA__
hdfs://192.168.0.51:8020/user/hive/warehouse/tyd.db/360_apk_classifly
hdfs://192.168.0.51:8020/user/hive/warehouse/tyd.db/360_apk_info
hdfs://192.168.0.51:8020/user/hive/warehouse/tyd.db/360_dict_apktolabel
hdfs://192.168.0.51:8020/user/hive/warehouse/tyd.db/360_label_info
hdfs://192.168.0.51:8020/user/hive/warehouse/tyd.db/360_label_two
hdfs://192.168.0.51:8020/user/hive/warehouse/tyd.db/360_oz_label
hdfs://192.168.0.51:8020/user/hive/warehouse/tyd.db/bbjdkwl04
hdfs://192.168.0.51:8020/user/hive/warehouse/tyd.db/bothviewuser
hdfs://192.168.0.51:8020/user/hive/warehouse/tyd.db/ch_test
hdfs://192.168.0.51:8020/user/hive/warehouse/tyd.db/droimarkettotalstatus_mt
hdfs://192.168.0.51:8020/user/hive/warehouse/tyd.db/droipaytotalstatus_mt
hdfs://192.168.0.51:8020/user/hive/warehouse/tyd.db/droipushtotalstatus_mt
hdfs://192.168.0.51:8020/user/hive/warehouse/tyd.db/droitotalstatus_mt
hdfs://192.168.0.51:8020/user/hive/warehouse/tyd.db/hbase_tyd_user_act_mt_front
hdfs://192.168.0.51:8020/user/hive/warehouse/tyd.db/hbase_tyd_user_down_info
hdfs://192.168.0.51:8020/user/hive/warehouse/tyd.db/imei_pt_test
hdfs://192.168.0.51:8020/user/hive/warehouse/tyd.db/imsi_pt_test
hdfs://192.168.0.51:8020/user/hive/warehouse/tyd.db/manage_info
hdfs://192.168.0.51:8020/user/hive/warehouse/tyd.db/month_apkcount_counts
hdfs://192.168.0.51:8020/user/hive/warehouse/tyd.db/onecalluser
hdfs://192.168.0.51:8020/user/hive/warehouse/tyd.db/onlyviewuser
hdfs://192.168.0.51:8020/user/hive/warehouse/tyd.db/province_city_info
hdfs://192.168.0.51:8020/user/hive/warehouse/tyd.db/recallagainusertable
hdfs://192.168.0.51:8020/user/hive/warehouse/tyd.db/recallusertable
hdfs://192.168.0.51:8020/user/hive/warehouse/tyd.db/test_ims_count_flogin
hdfs://192.168.0.51:8020/user/hive/warehouse/tyd.db/test_imsi_visit_info
hdfs://192.168.0.51:8020/user/hive/warehouse/tyd.db/test_imsi_visit_info_counts
hdfs://192.168.0.51:8020/user/hive/warehouse/tyd.db/test_table_oz
hdfs://192.168.0.51:8020/user/hive/warehouse/tyd.db/test_tyd_user_apk_mt
hdfs://192.168.0.51:8020/user/hive/warehouse/tyd.db/tyd_apk_dict
hdfs://192.168.0.51:8020/user/hive/warehouse/tyd.db/tyd_apk_download_count
hdfs://192.168.0.51:8020/user/hive/warehouse/tyd.db/tyd_apk_download_login_info
hdfs://192.168.0.51:8020/user/hive/warehouse/tyd.db/tyd_apk_download_login_info_all
hdfs://192.168.0.51:8020/user/hive/warehouse/tyd.db/tyd_apk_login_down_info
hdfs://192.168.0.51:8020/user/hive/warehouse/tyd.db/tyd_apk_login_down_info_mt
hdfs://192.168.0.51:8020/user/hive/warehouse/tyd.db/tyd_apk_tag_pref_ft
hdfs://192.168.0.51:8020/user/hive/warehouse/tyd.db/tyd_check_ch_data_ft
hdfs://192.168.0.51:8020/user/hive/warehouse/tyd.db/tyd_check_ch_data_ft_t
hdfs://192.168.0.51:8020/user/hive/warehouse/tyd.db/tyd_check_ch_data_mt
hdfs://192.168.0.51:8020/user/hive/warehouse/tyd.db/tyd_day_user_remain
hdfs://192.168.0.51:8020/user/hive/warehouse/tyd.db/tyd_dict_apktolabel
hdfs://192.168.0.51:8020/user/hive/warehouse/tyd.db/tyd_dict_topapk
hdfs://192.168.0.51:8020/user/hive/warehouse/tyd.db/tyd_dict_topapk_total_ft
hdfs://192.168.0.51:8020/user/hive/warehouse/tyd.db/tyd_f_login_imei_mt
hdfs://192.168.0.51:8020/user/hive/warehouse/tyd.db/tyd_imsi_download_info
hdfs://192.168.0.51:8020/user/hive/warehouse/tyd.db/tyd_imsi_offdays_info
hdfs://192.168.0.51:8020/user/hive/warehouse/tyd.db/tyd_ip_info_detail_mt
hdfs://192.168.0.51:8020/user/hive/warehouse/tyd.db/tyd_oz_label_classisly
hdfs://192.168.0.51:8020/user/hive/warehouse/tyd.db/tyd_oz_label_push
hdfs://192.168.0.51:8020/user/hive/warehouse/tyd.db/tyd_push_one_session_user_counts
hdfs://192.168.0.51:8020/user/hive/warehouse/tyd.db/tyd_push_oz_dict
hdfs://192.168.0.51:8020/user/hive/warehouse/tyd.db/tyd_push_recall_user_counts
hdfs://192.168.0.51:8020/user/hive/warehouse/tyd.db/tyd_push_recall_user_imsi
hdfs://192.168.0.51:8020/user/hive/warehouse/tyd.db/tyd_push_recall_user_visit_counts
hdfs://192.168.0.51:8020/user/hive/warehouse/tyd.db/tyd_push_users_counts
hdfs://192.168.0.51:8020/user/hive/warehouse/tyd.db/tyd_sex_pref
hdfs://192.168.0.51:8020/user/hive/warehouse/tyd.db/tyd_tags_apk_ft
hdfs://192.168.0.51:8020/user/hive/warehouse/tyd.db/tyd_user_360_user_profile_mt
hdfs://192.168.0.51:8020/user/hive/warehouse/tyd.db/tyd_user_act_mt
hdfs://192.168.0.51:8020/user/hive/warehouse/tyd.db/tyd_user_down_flow_ft
hdfs://192.168.0.51:8020/user/hive/warehouse/tyd.db/tyd_user_downinfo_index_mt
hdfs://192.168.0.51:8020/user/hive/warehouse/tyd.db/tyd_user_frequent_daily_report
hdfs://192.168.0.51:8020/user/hive/warehouse/tyd.db/tyd_user_habit_ft
hdfs://192.168.0.51:8020/user/hive/warehouse/tyd.db/tyd_user_habit_ft_game
hdfs://192.168.0.51:8020/user/hive/warehouse/tyd.db/tyd_user_habit_mt
hdfs://192.168.0.51:8020/user/hive/warehouse/tyd.db/tyd_user_habit_mt_game
hdfs://192.168.0.51:8020/user/hive/warehouse/tyd.db/tyd_user_info_ft
hdfs://192.168.0.51:8020/user/hive/warehouse/tyd.db/tyd_user_info_min_id_mt
hdfs://192.168.0.51:8020/user/hive/warehouse/tyd.db/tyd_user_info_mt
hdfs://192.168.0.51:8020/user/hive/warehouse/tyd.db/tyd_user_info_mt_index
hdfs://192.168.0.51:8020/user/hive/warehouse/tyd.db/tyd_user_log_apk_ft
hdfs://192.168.0.51:8020/user/hive/warehouse/tyd.db/tyd_user_log_apk_mt
hdfs://192.168.0.51:8020/user/hive/warehouse/tyd.db/tyd_user_log_apk_visit_ft
hdfs://192.168.0.51:8020/user/hive/warehouse/tyd.db/tyd_user_log_apk_visit_mt
hdfs://192.168.0.51:8020/user/hive/warehouse/tyd.db/tyd_user_log_column_ft
hdfs://192.168.0.51:8020/user/hive/warehouse/tyd.db/tyd_user_log_column_mt
hdfs://192.168.0.51:8020/user/hive/warehouse/tyd.db/tyd_user_log_market_ft
hdfs://192.168.0.51:8020/user/hive/warehouse/tyd.db/tyd_user_log_market_ft_min
hdfs://192.168.0.51:8020/user/hive/warehouse/tyd.db/tyd_user_log_market_mt
hdfs://192.168.0.51:8020/user/hive/warehouse/tyd.db/tyd_user_log_oldmarket
hdfs://192.168.0.51:8020/user/hive/warehouse/tyd.db/tyd_user_pref_sex_ft
hdfs://192.168.0.51:8020/user/hive/warehouse/tyd.db/tyd_user_pref_sex_mt
hdfs://192.168.0.51:8020/user/hive/warehouse/tyd.db/tyd_user_recommend_input_ft
hdfs://192.168.0.51:8020/user/hive/warehouse/tyd.db/tyd_week_user_remain_report
hdfs://192.168.0.51:8020/user/hive/warehouse/tyd.db/tyd_weekly_retained_report
hdfs://192.168.0.51:8020/user/hive/warehouse/tyd.db/tydmtk003
hdfs://192.168.0.51:8020/user/hive/warehouse/tyd.db/user_num_info
hdfs://192.168.0.51:8020/user/hive/warehouse/tyd.db/userclassifly
hdfs://192.168.0.51:8020/user/hive/warehouse/tyd.db/version_info
hdfs://192.168.0.51:8020/user/hive/warehouse/tyd.db/week_user_remain
hdfs://192.168.0.51:8020/user/hive/warehouse/tyd.db/xiaotong
hdfs://192.168.0.51:8020/user/hive/warehouse/tyd.db/xiaotong_v2
hdfs://192.168.0.51:8020/user/hive/warehouse/tyd.db/xiaotong_v3
