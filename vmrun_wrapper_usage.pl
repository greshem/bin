#!/usr/bin/perl
sub Usage()
{
my $pattern=shift;
for(<DATA>)
{
	if($_=~/$pattern/)
	{
		print $_;
	}
}
}


sub hook_start 
{
} ; 
sub hook_stop 
{
} ; 
sub hook_reset 
{
} ; 
sub hook_suspend 
{
} ; 
sub hook_pause 
{
} ; 
sub hook_unpause 
{
} ; 
sub hook_listSnapshots 
{
} ; 
sub hook_snapshot 
{
} ; 
sub hook_deleteSnapshot 
{
} ; 
sub hook_revertToSnapshot 
{
} ; 
sub hook_beginRecording 
{
} ; 
sub hook_endRecording 
{
} ; 
sub hook_beginReplay 
{
} ; 
sub hook_endReplay 
{
} ; 
sub hook_runProgramInGuest 
{
} ; 
sub hook_fileExistsInGuest 
{
} ; 
sub hook_setSharedFolderState 
{
} ; 
sub hook_addSharedFolder 
{
} ; 
sub hook_removeSharedFolder 
{
} ; 
sub hook_enableSharedFolders 
{
} ; 
sub hook_disableSharedFolders 
{
} ; 
sub hook_listProcessesInGuest 
{
} ; 
sub hook_killProcessInGuest 
{
} ; 
sub hook_runScriptInGuest 
{
} ; 
sub hook_deleteFileInGuest 
{
} ; 
sub hook_createDirectoryInGuest 
{
} ; 
sub hook_deleteDirectoryInGuest 
{
} ; 
sub hook_listDirectoryInGuest 
{
} ; 
sub hook_CopyFileFromHostToGuest 
{
} ; 
sub hook_CopyFileFromGuestToHost 
{
} ; 
sub hook_renameFileInGuest 
{
} ; 
sub hook_captureScreen 
{
} ; 
sub hook_writeVariable 
{
} ; 
sub hook_readVariable 
{
} ; 
sub hook_vprobeVersion 
{
} ; 
sub hook_vprobeLoad 
{
} ; 
sub hook_vprobeLoadFile 
{
} ; 
sub hook_vprobeReset 
{
} ; 
sub hook_vprobeListProbes 
{
} ; 
sub hook_vprobeListGlobals 
{
} ; 
sub hook_list 
{
	my @ret;
	open(PIPE, "vmrun.exe list|");
	for(<PIPE>)
	{
		chomp;
		if($_=~/vmx/)
		{
			#print $_;
			push(@ret, $_);
		}
	}
	close(PIPE);
	return @ret;
} ; 
sub hook_upgradevm 
{
} ; 
sub hook_installTools 
{
} ; 
sub hook_register 
{
} ; 
sub hook_unregister 
{
} ; 
sub hook_listRegisteredVM 
{
} ; 
sub hook_deleteVM 
{
} ; 

#C:\home_work\vmware_app\dlxp_5\dlxp_5.vmx
sub hook_clone 
{
	(my @vmxs)=@_;	
	for $each (@vmxs)
	{
			print "vmrun clone  $each   C:\\home_work\\vmware_app\\clone  full \n";
	}
} ; 


#==========================================================================
#mainloop 
my $action=shift or Usage();
#hook_start (); 
my @vmxs=hook_list();
hook_clone(@vmxs);



__DATA__
power/start
power/stop
power/reset
power/suspend
power/pause
power/unpause
snapshot/listSnapshots
snapshot/snapshot
snapshot/deleteSnapshot
snapshot/revertToSnapshot
record_replay/beginRecording
record_replay/endRecording
record_replay/beginReplay
record_replay/endReplay
guest/runProgramInGuest
guest/fileExistsInGuest
guest/setSharedFolderState
guest/addSharedFolder
guest/removeSharedFolder
guest/enableSharedFolders
guest/disableSharedFolders
guest/listProcessesInGuest
guest/killProcessInGuest
guest/runScriptInGuest
guest/deleteFileInGuest
guest/createDirectoryInGuest
guest/deleteDirectoryInGuest
guest/listDirectoryInGuest
guest/CopyFileFromHostToGuest
guest/CopyFileFromGuestToHost
guest/renameFileInGuest
guest/captureScreen
guest/writeVariable
guest/readVariable
vprobe/vprobeVersion
vprobe/vprobeLoad
vprobe/vprobeLoadFile
vprobe/vprobeReset
vprobe/vprobeListProbes
vprobe/vprobeListGlobals
general/list
general/upgradevm
general/installTools
general/register
general/unregister
general/listRegisteredVM
general/deleteVM
general/clone

