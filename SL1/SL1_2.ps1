######################################
###Configure Exchange Online        #
#####################################
#Office365 Powershell sessie opbouwen
Set-ExecutionPolicy RemoteSigned
$UserCredential = Get-Credential
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $UserCredential -Authentication  Basic -AllowRedirection

Import-PSSession $Session -AllowClobber

#Enable Organization Customization
Enable-OrganizationCustomization

#Default Sharing Policy Calendar
Set-SharingPolicy -Identity "Default Sharing Policy" -Domains @{Remove="Anonymous:CalendarSharingFreeBusyReviewer", "Anonymous:CalendarSharingFreeBusySimple", "Anonymous:CalendarSharingFreeBusyDetail"}
Set-SharingPolicy -Identity "Default Sharing Policy" -Domains "*:CalendarSharingFreeBusySimple"


#Spamfiltersettings Office365
Set-HostedContentFilterPolicy -Identity "Default" -SpamAction MoveToJmf -BulkSpamAction MoveToJmf -HighConfidenceSpamAction MoveToJmf -BulkThreshold 5 -IncreaseScoreWithBizOrInfoUrls On `
 -IncreaseScoreWithImageLinks On -IncreaseScoreWithNumericIps On -IncreaseScoreWithRedirectToOtherPort On -MarkAsSpamBulkMail On -MarkAsSpamEmbedTagsInHtml On -MarkAsSpamEmptyMessages On `
 -MarkAsSpamFormTagsInHtml On -MarkAsSpamFramesInHtml On -MarkAsSpamFromAddressAuthFail On -MarkAsSpamJavaScriptInHtml On -MarkAsSpamNdrBackscatter On -MarkAsSpamObjectTagsInHtml On `
 -MarkAsSpamSpfRecordHardFail On -MarkAsSpamWebBugsInHtml On -MarkAsSpamSensitiveWordList On -TestModeAction AddXHeader

#End user Spam Notificatie office365 
Set-HostedContentFilterPolicy -Identity "Default" -EnableEndUserSpamNotifications $true -endUserSpamNotificationLanguage dutch –EndUserSpamNotificationFrequency 1

#Malwarefiltersettings Office365
Set-MalwareFilterPolicy -Identity "Default" -Action DeleteAttachmentAndUseDefaultAlertText -EnableFileFilter $true -FileTypes ".cpl", ".ace", ".app",".docm",".exe",".jar",".reg",".scr",".vbe",".vbs",".bat",".msi", `
".ani", ".dll", ".lnf", ".mdb", ".ws", ".cmd", ".com", ".crt", ".dos", ".lns", ".ps1", ".wsh", ".wsc" -EnableExternalSenderNotifications $true -EnableInternalSenderNotifications $true

#######################

#Audit log aanzetten voor alle users
Set-AdminAuditLogConfig -UnifiedAuditLogIngestionEnabled $true

Get-Mailbox -ResultSize Unlimited -Filter {RecipientTypeDetails -eq "UserMailbox" -or RecipientTypeDetails -eq "SharedMailbox" -or RecipientTypeDetails -eq "RoomMailbox" -or RecipientTypeDetails -eq "DiscoveryMailbox"} `
 | Set-Mailbox -AuditEnabled $true -AuditLogAgeLimit 180 -AuditAdmin Update, MoveToDeletedItems, SoftDelete, HardDelete, SendAs, SendOnBehalf, Create, UpdateFolderPermission `
 -AuditDelegate Update, SoftDelete, HardDelete, SendAs, Create, UpdateFolderPermissions, MoveToDeletedItems, SendOnBehalf `
 -AuditOwner UpdateFolderPermission, MailboxLogin, Create, SoftDelete, HardDelete, Update, MoveToDeletedItems 

Get-Mailbox -ResultSize Unlimited | Select Name, AuditEnabled, AuditLogAgeLimit | Out-Gridview

Get-MailboxPlan | Set-MailboxPlan -RetainDeletedItemsFor 30
Get-mailbox | set-mailbox -retaindeleteditems 30
Get-mailbox | Set-Mailbox -SingleItemRecoveryEnabled $true 

#Imap en Pop uitschakelen (check van te voren in de sign in logging of dit gebruikt wordt!!)
Get-CASMailboxPlan | Set-CASMailboxPlan -ImapEnabled $false -PopEnabled $false

#Block Client Forwarding Rules

$rejectMessageText= "Client Forwarding Rules To External Domains Are Not Permitted."
New-TransportRule -name "Client Rules To External Block" -Priority 0 -SentToScope NotInOrganization -FromScope InOrganization -MessageTypeMatches AutoForward -RejectMessageEnhancedStatusCode 5.7.1 `
 -RejectMessageReasonText $rejectMessageText
Get-RemoteDomain | Set-RemoteDomain –AutoForwardEnabled $false

#Mailboxen Nederlands taal
Get-mailbox -ResultSize unlimited | Set-MailboxRegionalConfiguration -Language nl-NL -DateFormat “d-M-yyyy” -timezone “W. Europe Standard Time” -timeformat “HH:mm” -LocalizeDefaultFolderName:$true






