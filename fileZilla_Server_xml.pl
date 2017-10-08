#!/usr/bin/perl
if($^O=~/linux/)
{
	print "root/q***********n 				sdb1://  \n";	
	print "q**************n/q**********n         	P:// 				  \n";
	print "xfile/xfile            			sdb1://.*//2013/ \n";
	print "isodownload/isodownload            			P:// \n";
	print "#========================================================================== \n";
}

do("c:\\bin\\iso_get_mobile_disk_label.pl");
my $disk=change_mobile_path_to_win_path('sdb1');
print "eden sdb1:\\  ->  $disk \n";

if(! defined($disk))
{
	die("#create  sdb1 ,  \n");
}

if($disk=~/\s+/)
{
	die("disk is space \n");
}
if($^O=~/win/i)
{
	create_fz_xml_config($disk);
	printf ( "FileZilla\ Server.xml, create ok  \n ");
}

##############################################################################
#my $sdb1="G";
sub create_fz_xml_config($)
{	
	(my $disk)=@_;
	my $sdb1=$disk;

open ("XML", ">"."FileZilla\ Server.xml" ) or die("create fz xml error \n");

print XML <<EOF
<FileZillaServer>
    <Settings>
        <Item name="Serverports" type="string">21</Item>
        <Item name="Number of Threads" type="numeric">2</Item>
        <Item name="Maximum user count" type="numeric">0</Item>
        <Item name="Timeout" type="numeric">120</Item>
        <Item name="No Transfer Timeout" type="numeric">600</Item>
        <Item name="Allow Incoming FXP" type="numeric">0</Item>
        <Item name="Allow outgoing FXP" type="numeric">0</Item>
        <Item name="No Strict In FXP" type="numeric">0</Item>
        <Item name="No Strict Out FXP" type="numeric">0</Item>
        <Item name="Login Timeout" type="numeric">60</Item>
        <Item name="Show Pass in Log" type="numeric">0</Item>
        <Item name="Custom PASV IP type" type="numeric">0</Item>
        <Item name="Custom PASV IP" type="string" />
        <Item name="Custom PASV min port" type="numeric">0</Item>
        <Item name="Custom PASV max port" type="numeric">0</Item>
        <Item name="Initial Welcome Message" type="string">Please visit http://sourceforge.net/projects/filezilla/</Item>
        <Item name="Admin port" type="numeric">14147</Item>
        <Item name="Admin Password" type="string" />
        <Item name="Admin IP Bindings" type="string" />
        <Item name="Admin IP Addresses" type="string" />
        <Item name="Enable logging" type="numeric">0</Item>
        <Item name="Logsize limit" type="numeric">0</Item>
        <Item name="Logfile type" type="numeric">0</Item>
        <Item name="Logfile delete time" type="numeric">0</Item>
        <Item name="Use GSS Support" type="numeric">0</Item>
        <Item name="GSS Prompt for Password" type="numeric">0</Item>
        <Item name="Download Speedlimit Type" type="numeric">0</Item>
        <Item name="Upload Speedlimit Type" type="numeric">0</Item>
        <Item name="Download Speedlimit" type="numeric">10</Item>
        <Item name="Upload Speedlimit" type="numeric">10</Item>
        <Item name="Buffer Size" type="numeric">32768</Item>
        <Item name="Custom PASV IP server" type="string">http://ip.filezilla-project.org/ip.php</Item>
        <Item name="Use custom PASV ports" type="numeric">0</Item>
        <Item name="Mode Z Use" type="numeric">0</Item>
        <Item name="Mode Z min level" type="numeric">1</Item>
        <Item name="Mode Z max level" type="numeric">9</Item>
        <Item name="Mode Z allow local" type="numeric">0</Item>
        <Item name="Mode Z disallowed IPs" type="string" />
        <Item name="IP Bindings" type="string">*</Item>
        <Item name="IP Filter Allowed" type="string" />
        <Item name="IP Filter Disallowed" type="string" />
        <Item name="Hide Welcome Message" type="numeric">0</Item>
        <Item name="Enable SSL" type="numeric">0</Item>
        <Item name="Allow explicit SSL" type="numeric">1</Item>
        <Item name="SSL Key file" type="string" />
        <Item name="SSL Certificate file" type="string" />
        <Item name="Implicit SSL ports" type="string">990</Item>
        <Item name="Force explicit SSL" type="numeric">0</Item>
        <Item name="Network Buffer Size" type="numeric">65536</Item>
        <Item name="Force PROT P" type="numeric">0</Item>
        <Item name="SSL Key Password" type="string" />
        <Item name="Allow shared write" type="numeric">0</Item>
        <Item name="No External IP On Local" type="numeric">1</Item>
        <Item name="Active ignore local" type="numeric">1</Item>
        <Item name="Autoban enable" type="numeric">0</Item>
        <Item name="Autoban attempts" type="numeric">10</Item>
        <Item name="Autoban type" type="numeric">0</Item>
        <Item name="Autoban time" type="numeric">1</Item>
        <Item name="Service name" type="string" />
        <Item name="Service display name" type="string" />
        <Item name="Enable HASH" type="numeric">0</Item>
        <Item name="Disable IPv6" type="numeric">0</Item>
        <SpeedLimits>
            <Download />
            <Upload />
        </SpeedLimits>
    </Settings>
    <Groups />
    <Users>
        <User Name="root">
            <Option Name="Pass"></Option>
            <Option Name="Group"></Option>
            <Option Name="Bypass server userlimit">0</Option>
            <Option Name="User Limit">0</Option>
            <Option Name="IP Limit">0</Option>
            <Option Name="Enabled">1</Option>
            <Option Name="Comments"></Option>
            <Option Name="ForceSsl">0</Option>
            <IpFilter>
                <Disallowed />
                <Allowed />
            </IpFilter>
            <Permissions>
                <Permission Dir="$sdb1:">
                    <Option Name="FileRead">1</Option>
                    <Option Name="FileWrite">0</Option>
                    <Option Name="FileDelete">0</Option>
                    <Option Name="FileAppend">0</Option>
                    <Option Name="DirCreate">0</Option>
                    <Option Name="DirDelete">0</Option>
                    <Option Name="DirList">1</Option>
                    <Option Name="DirSubdirs">1</Option>
                    <Option Name="IsHome">1</Option>
                    <Option Name="AutoCreate">0</Option>
                </Permission>
            </Permissions>
            <SpeedLimits DlType="0" DlLimit="10" ServerDlLimitBypass="0" UlType="0" UlLimit="10" ServerUlLimitBypass="0">
                <Download />
                <Upload />
            </SpeedLimits>
        </User>
        <User Name="q**************n">
            <Option Name="Pass">0b50b02fd0d73a9c4c8c3a781c30845f</Option>
            <Option Name="Group"></Option>
            <Option Name="Bypass server userlimit">0</Option>
            <Option Name="User Limit">0</Option>
            <Option Name="IP Limit">0</Option>
            <Option Name="Enabled">1</Option>
            <Option Name="Comments"></Option>
            <Option Name="ForceSsl">0</Option>
            <IpFilter>
                <Disallowed />
                <Allowed />
            </IpFilter>
            <Permissions>
                <Permission Dir="P:">
                    <Option Name="FileRead">1</Option>
                    <Option Name="FileWrite">0</Option>
                    <Option Name="FileDelete">0</Option>
                    <Option Name="FileAppend">0</Option>
                    <Option Name="DirCreate">0</Option>
                    <Option Name="DirDelete">0</Option>
                    <Option Name="DirList">1</Option>
                    <Option Name="DirSubdirs">1</Option>
                    <Option Name="IsHome">1</Option>
                    <Option Name="AutoCreate">0</Option>
                </Permission>
            </Permissions>
            <SpeedLimits DlType="0" DlLimit="10" ServerDlLimitBypass="0" UlType="0" UlLimit="10" ServerUlLimitBypass="0">
                <Download />
                <Upload />
            </SpeedLimits>
        </User>
        <User Name="xfile">
            <Option Name="Pass">0b50b02fd0d73a9c4c8c3a781c30845f</Option>
            <Option Name="Group"></Option>
            <Option Name="Bypass server userlimit">0</Option>
            <Option Name="User Limit">0</Option>
            <Option Name="IP Limit">0</Option>
            <Option Name="Enabled">1</Option>
            <Option Name="Comments"></Option>
            <Option Name="ForceSsl">0</Option>
            <IpFilter>
                <Disallowed />
                <Allowed />
            </IpFilter>
            <Permissions>
                <Permission Dir="$sdb1:\\sdb1\\_xfile\\2013_all_iso">
                    <Option Name="FileRead">1</Option>
                    <Option Name="FileWrite">0</Option>
                    <Option Name="FileDelete">0</Option>
                    <Option Name="FileAppend">0</Option>
                    <Option Name="DirCreate">0</Option>
                    <Option Name="DirDelete">0</Option>
                    <Option Name="DirList">1</Option>
                    <Option Name="DirSubdirs">1</Option>
                    <Option Name="IsHome">1</Option>
                    <Option Name="AutoCreate">0</Option>
                </Permission>
            </Permissions>
            <SpeedLimits DlType="0" DlLimit="10" ServerDlLimitBypass="0" UlType="0" UlLimit="10" ServerUlLimitBypass="0">
                <Download />
                <Upload />
            </SpeedLimits>
        </User>
    </Users>
</FileZillaServer>
EOF
;

	close(XML);
}
