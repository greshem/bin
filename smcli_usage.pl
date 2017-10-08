#!/usr/bin/perl
foreach (<DATA>)
{
    print $_;
}
__DATA__


smcli chfarm                #Availability/chfarm
smcli chvsmfarm             #Availability/chvsmfarm
smcli mkfarm                #Availability/mkfarm
smcli mkrelocatetask        #Availability/mkrelocatetask
smcli mkvsmfarm             #Availability/mkvsmfarm
smcli mkvsmmigratetask      #Availability/mkvsmmigratetask
smcli rmfarm                #Availability/rmfarm

smcli chled                 #LEDCLI/chled
smcli lsled                 #LEDCLI/lsled

smcli getNotificationProfile            #NotificationProfileCli/getNotificationProfile

smcli restartcmm            #RESTARTCLI/restartcmm

smcli getSSOStatus          #SingleSignOnCLI/getSSOStatus
smcli setChassisSSO         #SingleSignOnCLI/setChassisSSO

smcli activatemgrs              #admin/activatemgrs
smcli deactivatemgrs            #admin/deactivatemgrs
smcli lsmgrs                    #admin/lsmgrs
smcli setsvrnonstop             #admin/setsvrnonstop

smcli chaudit               #auditing/chaudit
smcli lsaudit               #auditing/lsaudit
smcli lsauditlogs           #auditing/lsauditlogs
smcli rmauditlogs           #auditing/rmauditlogs

smcli chevtautopln          #automation/chevtautopln
smcli evtacthist            #automation/evtacthist
smcli evtautopln            #automation/evtautopln
smcli evtlog                #automation/evtlog
smcli lsevtact              #automation/lsevtact
smcli lsevtacthist          #automation/lsevtacthist
smcli lsevtautopln          #automation/lsevtautopln
smcli lsevtfltr             #automation/lsevtfltr
smcli lsevtlog              #automation/lsevtlog
smcli lsevttype             #automation/lsevttype
smcli mkevtact              #automation/mkevtact
smcli mkevtactemail         #automation/mkevtactemail
smcli mkevtactstpgm         #automation/mkevtactstpgm
smcli mkevtactsttask        #automation/mkevtactsttask
smcli mkevtautopln          #automation/mkevtautopln
smcli mkevtfltr             #automation/mkevtfltr
smcli rmevtact              #automation/rmevtact
smcli rmevtautopln          #automation/rmevtautopln
smcli rmevtfltr             #automation/rmevtfltr
smcli rmevtlog              #automation/rmevtlog
smcli testevtact            #automation/testevtact

smcli backupcfg             #backupRestoreCfg/backupcfg
smcli resetcfg              #backupRestoreCfg/resetcfg
smcli restorecfg            #backupRestoreCfg/restorecfg

smcli exportcert            #cert/exportcert
smcli importcert            #cert/importcert
smcli lscert                #cert/lscert
smcli revokecert            #cert/revokecert
smcli rmcert                #cert/rmcert
smcli unrevokecert          #cert/unrevokecert

smcli lsbundle              #cli/lsbundle

smcli cfgappcred            #config/cfgappcred
smcli cfgcertpolicy         #config/cfgcertpolicy
smcli cfgpwdpolicy          #config/cfgpwdpolicy
smcli lscfgplan             #configmgrcli/lscfgplan
smcli lscfgtmpl             #configmgrcli/lscfgtmpl
smcli mkcfgplan             #configmgrcli/mkcfgplan
smcli mkcfgtmpl             #configmgrcli/mkcfgtmpl
smcli rmcfgplan             #configmgrcli/rmcfgplan
smcli rmcfgtmpl             #configmgrcli/rmcfgtmpl

smcli cfgaccess             #cts/cfgaccess
smcli cfgcred               #cts/cfgcred
smcli chcred                #cts/chcred
smcli lscred                #cts/lscred
smcli rmcred                #cts/rmcred

smcli simffdc               #esaffdccli/simffdc

smcli mkdatasource          #etpccli/mkdatasource
smcli rmdatasource          #etpccli/rmdatasource

smcli genevent              #events/genevent
smcli help                  #events/help

smcli importextlps          #extmgmtlaunch/importextlps
smcli listextlps            #extmgmtlaunch/listextlps
smcli removeextlps          #extmgmtlaunch/removeextlps

smcli collectProblemData    #ffdcUT/collectProblemData
smcli logFfdc               #ffdcUT/logFfdc
smcli logMsg                #ffdcUT/logMsg

smcli chgp                  #group/chgp
smcli lsgp                  #group/lsgp
smcli mkgp                  #group/mkgp
smcli rmgp                  #group/rmgp

smcli confighms                     #hms/confighms
smcli enablehierarchicalmgmt        #hms/enablehierarchicalmgmt
smcli isglobalserver                #hms/isglobalserver

smcli rpower                    #hwcontrol/rpower

smcli addhosttopool             #imagemgrcli/addhosttopool
smcli captureva                 #imagemgrcli/captureva
smcli chsyspool                 #imagemgrcli/chsyspool
smcli chtpmfisrv                #imagemgrcli/chtpmfisrv
smcli chworkload                #imagemgrcli/chworkload
smcli deployva                  #imagemgrcli/deployva
smcli entermaintenancemode      #imagemgrcli/entermaintenancemode
smcli exitmaintenancemode       #imagemgrcli/exitmaintenancemode
smcli importva                  #imagemgrcli/importva
smcli lscandidatehost           #imagemgrcli/lscandidatehost
smcli lscandidatensp            #imagemgrcli/lscandidatensp
smcli lscandidateserver         #imagemgrcli/lscandidateserver
smcli lscandidatestorage        #imagemgrcli/lscandidatestorage
smcli lscapsrv                  #imagemgrcli/lscapsrv
smcli lscustomization           #imagemgrcli/lscustomization
smcli lsdeploytargets           #imagemgrcli/lsdeploytargets
smcli lsmigsrv                  #imagemgrcli/lsmigsrv
smcli lsrepos                   #imagemgrcli/lsrepos
smcli lssyspool                 #imagemgrcli/lssyspool
smcli lstpmfisrv                #imagemgrcli/lstpmfisrv
smcli lsva                      #imagemgrcli/lsva
smcli lsvaforreplace            #imagemgrcli/lsvaforreplace
smcli lsvaquery                 #imagemgrcli/lsvaquery
smcli lsvsforreplace            #imagemgrcli/lsvsforreplace
smcli lsworkloads               #imagemgrcli/lsworkloads
smcli migratesys                #imagemgrcli/migratesys
smcli mkrepos                   #imagemgrcli/mkrepos
smcli mksyspool                 #imagemgrcli/mksyspool
smcli mkvaquery                 #imagemgrcli/mkvaquery
smcli mkworkload                #imagemgrcli/mkworkload
smcli replaceversion            #imagemgrcli/replaceversion
smcli resumeworkload            #imagemgrcli/resumeworkload
smcli rmhostfrompool            #imagemgrcli/rmhostfrompool
smcli rmrepos                   #imagemgrcli/rmrepos
smcli rmsyspool                 #imagemgrcli/rmsyspool
smcli rmva                      #imagemgrcli/rmva
smcli rmvaquery                 #imagemgrcli/rmvaquery
smcli rmworkload                #imagemgrcli/rmworkload
smcli startworkload             #imagemgrcli/startworkload
smcli stopworkload              #imagemgrcli/stopworkload
smcli suspendworkload           #imagemgrcli/suspendworkload
smcli vmcrelocate               #imagemgrcli/vmcrelocate

smcli collectinv                #inventory/collectinv
smcli lsinv                     #inventory/lsinv

smcli licensestatus             #licensemgmt/licensestatus
smcli updatelicense             #licensemgmt/updatelicense

smcli chgloginmsg               #loginMsg/chgloginmsg

smcli accessmo                  #managedobject/accessmo
smcli chmo                      #managedobject/chmo
smcli lsmo                      #managedobject/lsmo
smcli mkmo                      #managedobject/mkmo
smcli pingmo                    #managedobject/pingmo
smcli rmmo                      #managedobject/rmmo

smcli lsps                      #processmanagement/lsps
smcli mkpmtask                  #processmanagement/mkpmtask
smcli rmpmtask                  #processmanagement/rmpmtask
smcli dconsole                  #remoteaccess/dconsole

smcli dsh                       #remoteaccess/dsh

smcli chresmonthresh            #resourcemonitor/chresmonthresh
smcli lsresmon                  #resourcemonitor/lsresmon
smcli lsresmonrec               #resourcemonitor/lsresmonrec
smcli lsresmonthresh            #resourcemonitor/lsresmonthresh
smcli mkresmonrec               #resourcemonitor/mkresmonrec
smcli mkresmonthresh            #resourcemonitor/mkresmonthresh
smcli rmresmonrec               #resourcemonitor/rmresmonrec
smcli rmresmonthresh            #resourcemonitor/rmresmonthresh
smcli runresmon                 #resourcemonitor/runresmon
smcli stopresmonrec             #resourcemonitor/stopresmonrec

smcli addsttopool           #sccli/addsttopool
smcli dumpstcfg             #sccli/dumpstcfg
smcli help                  #sccli/help
smcli list                  #sccli/list
smcli mkclusstforhost       #sccli/mkclusstforhost
smcli mkstsyspool           #sccli/mkstsyspool
smcli mksvcsshrsap          #sccli/mksvcsshrsap
smcli mktpcrrsap            #sccli/mktpcrrsap
smcli rmstfrompool          #sccli/rmstfrompool
smcli rmstsyspool           #sccli/rmstsyspool
smcli rmsvcsshrsap          #sccli/rmsvcsshrsap
smcli rmtpcrrsap            #sccli/rmtpcrrsap
smcli svsrelationships      #sccli/svsrelationships
smcli svsresources          #sccli/svsresources
smcli testluncreate         #sccli/testluncreate
smcli chkssmconfig          #ssmcli/chkssmconfig
smcli collectsptfile        #ssmcli/collectsptfile
smcli cpsptfile             #ssmcli/cpsptfile
smcli lssptfile             #ssmcli/lssptfile
smcli lssptfiletypes        #ssmcli/lssptfiletypes
smcli lssvcproblem          #ssmcli/lssvcproblem
smcli rmsptfile             #ssmcli/rmsptfile
smcli ssmimport             #ssmcli/ssmimport
smcli submitsptfile         #ssmcli/submitsptfile

smcli chnshost          #ssptcli/chnshost
smcli chnspath          #ssptcli/chnspath
smcli chnssys           #ssptcli/chnssys
smcli chnsvol           #ssptcli/chnsvol
smcli lsnshost          #ssptcli/lsnshost
smcli lsnspath          #ssptcli/lsnspath
smcli lsnspool          #ssptcli/lsnspool
smcli lsnssys           #ssptcli/lsnssys
smcli lsnsvol           #ssptcli/lsnsvol
smcli mknspath          #ssptcli/mknspath
smcli mknsvol           #ssptcli/mknsvol
smcli rmnspath          #ssptcli/rmnspath
smcli rmnsvol           #ssptcli/rmnsvol

smcli lsstatus          #status/lsstatus

smcli accesssys         #system/accesssys
smcli chsys             #system/chsys
smcli discover          #system/discover
smcli lssys             #system/lssys
smcli lsver             #system/lsver
smcli pingsys           #system/pingsys
smcli revokeaccesssys   #system/revokeaccesssys
smcli rmsys             #system/rmsys

smcli lstask            #task/lstask
smcli runtask           #task/runtask
smcli lsjob             #taskscheduler/lsjob
smcli lsjobhistory      #taskscheduler/lsjobhistory
smcli rmjob             #taskscheduler/rmjob
smcli rmjobhistory      #taskscheduler/rmjobhistory
smcli runjob            #taskscheduler/runjob

smcli checkupd              #updates/checkupd
smcli cleanupd              #updates/cleanupd
smcli importupd             #updates/importupd
smcli installneeded         #updates/installneeded
smcli installupd            #updates/installupd
smcli lsupd                 #updates/lsupd
smcli uninstallupd          #updates/uninstallupd

smcli authusergp            #user/authusergp

smcli chrole            #user/chrole
smcli chuser            #user/chuser
smcli chusergp          #user/chusergp
smcli endSession        #user/endSession
smcli lsperm            #user/lsperm
smcli lsrole            #user/lsrole
smcli lsuser            #user/lsuser
smcli lsusergp          #user/lsusergp
smcli mkrole            #user/mkrole
smcli rmrole            #user/rmrole
smcli rmusergp          #user/rmusergp

smcli chvrtauth         #vsm/chvrtauth
smcli chvrthost         #vsm/chvrthost
smcli chvs              #vsm/chvs
smcli chvsmauth         #vsm/chvsmauth
smcli chvsmhost         #vsm/chvsmhost
smcli chvsmvs           #vsm/chvsmvs
smcli lsvrtcap          #vsm/lsvrtcap
smcli lsvrtsys          #vsm/lsvrtsys
smcli lsvsm             #vsm/lsvsm
smcli mkvs              #vsm/mkvs
smcli mkvsmvs           #vsm/mkvsmvs
smcli rmvs              #vsm/rmvs

smcli chvrtauth         #vsmsecurity/chvrtauth
smcli chvsmauth         #vsmsecurity/chvsmauth
