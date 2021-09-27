#################
#install-module MSOnline
#Uninstall-module azuread
#Uninstall-module azureadpreview
#install-module AzureAD
#install-module AzureADPreview
#import-module AzureADPreview
import-module msonline

connect-msolservice
Set-MsolCompanySettings -UsersPermissionToReadOtherUsersEnabled $false
Set-MsolCompanySettings -AllowAdHocSubscriptions $false 
Set-MsolCompanySettings -SelfServePasswordResetEnabled $true



######################################
# Change Sharepoint Settings         #
######################################

$name = get-azureaddomain | where {($_.name -like '*.onmicrosoft.com') -and ($_.name -notlike '*.mail.onmicrosoft.com')} | select name
$name.name
$ShortName = $name.Name.Replace(".onmicrosoft.com","")
$sharepointadmincenter = "https://"+$shortname+"-admin.sharepoint.com"

Connect-SPOService -url $sharepointadmincenter
Set-SPOTenantSyncClientRestriction  -ExcludedFileExtensions "exe;bat;msi;dll;vbs;vbe"
set-spotenant -sharingcapability externalusersharingonly
set-spotenant -defaultsharinglinktype direct
set-spotenant -LegacyAuthProtocolsEnabled $false
set-spotenant -RequireAcceptingAccountMatchInvitedAccount $true
Set-SPOBrowserIdleSignOut -Enabled $true -WarnAfter (New-TimeSpan -Seconds 2700) -SignOutAfter (New-TimeSpan -Seconds 3600)
set-spotenant -PreventExternalUsersFromResharing $true
set-spotenant -DisplayStartASiteOption $False
set-spotenant -DisallowInfectedFileDownload  $true
set-spotenant -NotifyOwnersWhenItemsReshared $True
set-spotenant -NotifyOwnersWhenInvitationsAccepted $True
set-spotenant -OwnerAnonymousNotification $True
set-spotenant -OneDriveForGuestsEnabled $false


get-AzureADMSAuthorizationPolicy | Set-AzureADMSAuthorizationPolicy -GuestUserRoleId '2af84b1e-32c8-42b7-82bc-daa82404023b'

Connect-IPPSSession
Set-PolicyConfig -EnableLabelCoauth $True –EnableSpoAipMigration $True


####################
New-AzureADPolicy -Type AuthenticatorAppSignInPolicy -Definition '{"AuthenticatorAppSignInPolicy":{"Enabled":true}}' -isOrganizationDefault $true -DisplayName AuthenticatorAppSignIn


