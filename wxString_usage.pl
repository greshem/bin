#!/usr/bin/perl
foreach (<DATA>)
{
	print $_;
}
__DATA__

#2011_04_27_ ������ add by greshem

#==========================================================================
#format ��ʽ��.
wxString msg;
msg.Printf(_("Can not write image header information for disk \"%s\""), DiskName.c_str());
ȥ�����������, ����ֱ����.
msg.Printf(_("Can not write image header information for disk %s"), DiskName.c_str());
wxMessageBox(msg, _("Error"));
#==========================================================================
ת��.
 wxString        strServiceName( _("Richtech Diskless XP IO Service"), *wxConvCurrent ) ;
#==========================================================================
lower
 wxString strMode = wxString(sMode, *wxConvCurrent).MakeLower();
#==========================================================================
���ַ��� 
wxString tmp=wxEmptyString
#==========================================================================
#���뵽char *
wxString strDiskName;
strcpy( RtwxCommPacket.Parameters.AddRestorePoint.tszVDiskName, strDiskName.mb_str());
#==========================================================================
std::string ת wxString 
        //1. std::string -> wxString
        string   strstring = "string";
        wxString  wxstr = wxString( strstring.c_str(), wxConvUTF8);
#==========================================================================
char * ת wxString 
 wxString  wxstr = wxString( "test", wxConvUTF8);
#==========================================================================
//2.  wxString -> std::string
string tmp(wxstr.mb_str());
cout<< tmp <<endl;
#==========================================================================
wxString->char*
       wxString wx_string=_T("wx string");
       char ansi_string[30];
       strcpy(ansi_string,wx_string.mb_str());
#==========================================================================
char*->wxString
       char *ansii_string = "some text";
       wxString wx_string(ansii_string,wxConvUTF8);
#==========================================================================


