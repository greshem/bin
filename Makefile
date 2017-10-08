all:
	yes |cp *.sh /bin/
	yes |cp *.pl /bin/
	yes |cp *.php /bin/
	yes |cp *.py /bin/
	yes |cp *.bat /bin/
	chmod +x *.pl *.sh *.php *.py
	chmod +x /bin/*.pl /bin/*.sh /bin/*.php /bin/*.py 
#	yes |cp *.exe /bin/
	cp ./filename_increase_copy.pm /usr/lib/perl5/
	rm -f /bin/Makefile
