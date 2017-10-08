#!/usr/bin/perl

gen_samba_pass_conf();
print "smbpasswd -a root "  ;
system("smbpasswd -a root "  );
print ("cp   smb.conf_passwd  /etc/samba/smb.conf \n");


sub  gen_samba_pass_conf()
{

    open(FILE, ">./smb.conf_passwd")  or die("open file error \n");
    print FILE <<EOF
[global]
	workgroup = MYGROUP
	server string = Samba Server Version %v
	log file = /var/log/samba/log.%m
	max log size = 50
	security = user
	passdb backend = tdbsam

	load printers = yes
	cups options = raw

[homes]
	comment = Home Directories
	browseable = no
	writable = yes

[_tmp_]
path= /tmp/
        writeable  = yes 
        browseable = yes 
        guest ok   = yes 
        public     = yes 
		case sensitive = yes 


[_home_]
path= /home/
        writeable  = yes 
        browseable = yes 
        guest ok   = yes 
        public     = yes 
		case sensitive = yes 

EOF
;
    close(FILE);
    print ("OK: generated ./smb.conf_passwd");
}
