#!/bin/bash
#20100707 qzj. 

genConfig()
{
	file=$1;
	if [ -z $file ];then
		echo "Usage: $0 $1"
		exit 1;
	fi
	#cat > /usr/share/perl5/CPAN/Config.pm <<EOFQIANQIAN
	cat > $file  <<EOFQIANQIAN
	#cat > /usr/share/perl5/CPAN/Config.pm_bbbbb <<EOFQIANQIAN
	# This is CPAN.pm's systemwide configuration file. This file provides
	# defaults for users, and the values can be changed in a per-user
	# configuration file. The user-config file is being looked for as
	# /root/.cpan/CPAN/MyConfig.pm.

	\$CPAN::Config = {
	  'applypatch' => q[],
	  'auto_commit' => q[0],
	  'build_cache' => q[100],
	  'build_dir' => q[/root/.cpan/build],
	  'build_dir_reuse' => q[0],
	  'build_requires_install_policy' => q[ask/yes],
	  'bzip2' => q[/usr/bin/bzip2],
	  'cache_metadata' => q[1],
	  'check_sigs' => q[0],
	  'commandnumber_in_prompt' => q[1],
	  'connect_to_internet_ok' => q[1],
	  'cpan_home' => q[/root/.cpan],
	  'curl' => q[/usr/bin/curl],
	  'ftp' => q[/usr/bin/ftp],
	  'ftp_passive' => q[1],
	  'ftp_proxy' => q[],
	  'getcwd' => q[cwd],
	  'gpg' => q[/usr/bin/gpg],
	  'gzip' => q[/bin/gzip],
	  'halt_on_failure' => q[0],
	  'histfile' => q[/root/.cpan/histfile],
	  'histsize' => q[100],
	  'http_proxy' => q[],
	  'inactivity_timeout' => q[0],
	  'index_expire' => q[1],
	  'inhibit_startup_message' => q[0],
	  'keep_source_where' => q[/root/.cpan/sources],
	  'load_module_verbosity' => q[v],
	  'lynx' => q[],
	  'make' => q[/usr/bin/make],
	  'make_arg' => q[],
	  'make_install_arg' => q[],
	  'make_install_make_command' => q[/usr/bin/make],
	  'makepl_arg' => q[],
	  'mbuild_arg' => q[],
	  'mbuild_install_arg' => q[],
	  'mbuild_install_build_command' => q[./Build],
	  'mbuildpl_arg' => q[],
	  'ncftpget' => q[/usr/bin/ncftpget],
	  'no_proxy' => q[],
	  'pager' => q[/usr/bin/less],
	  'patch' => q[/usr/bin/patch],
	  'perl5lib_verbosity' => q[v],
	  'prefer_installer' => q[MB],
	  'prefs_dir' => q[/root/.cpan/prefs],
	  'prerequisites_policy' => q[ask],
	  'scan_cache' => q[atstart],
	  'shell' => q[/bin/bash],
	  'show_unparsable_versions' => q[0],
	  'show_upload_date' => q[0],
	  'show_zero_versions' => q[0],
	  'tar' => q[/bin/tar],
	  'tar_verbosity' => q[v],
	  'term_is_latin' => q[1],
	  'term_ornaments' => q[1],
	  'test_report' => q[0],
	  'trust_test_report_history' => q[0],
	  'unzip' => q[/usr/bin/unzip],
	  'urllist' => [q[ftp://ftp.cuhk.edu.hk/pub/packages/perl/CPAN/], q[http://mirrors.geoexpat.com/cpan/]],
	  'use_sqlite' => q[0],
	  'wget' => q[/usr/bin/wget],
	  'yaml_load_code' => q[0],
	  'yaml_module' => q[YAML],
	};
	1;
	__END__

EOFQIANQIAN
}

genConfig /usr/lib/perl5/5.10.0/CPAN/Config.pm
genConfig /usr/share/perl5/CPAN/Config.pm
