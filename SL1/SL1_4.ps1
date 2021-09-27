
### Configuring TEAMS and Commerce Settings

##### PLEASE CHANGE THE GROUP CREATORS TO YOUR LIKING!!#############


###############################################
# limited the group creaters for teams       #
#############################################

$GroupName = “Group_creators”
$AllowGroupCreation = "False"

#Connect-AzureAD

$settingsObjectID = (Get-AzureADDirectorySetting | Where-object -Property Displayname -Value "Group.Unified" -EQ).id
if(!$settingsObjectID)
{
      $template = Get-AzureADDirectorySettingTemplate | Where-object {$_.displayname -eq "group.unified"}
    $settingsCopy = $template.CreateDirectorySetting()
    New-AzureADDirectorySetting -DirectorySetting $settingsCopy
    $settingsObjectID = (Get-AzureADDirectorySetting | Where-object -Property Displayname -Value "Group.Unified" -EQ).id
}

$settingsCopy = Get-AzureADDirectorySetting -Id $settingsObjectID
$settingsCopy["EnableGroupCreation"] = $AllowGroupCreation

if($GroupName)
{
    $settingsCopy["GroupCreationAllowedGroupId"] = (Get-AzureADGroup -SearchString $GroupName).objectid
}

Set-AzureADDirectorySetting -Id $settingsObjectID -DirectorySetting $settingsCopy

(Get-AzureADDirectorySetting -Id $settingsObjectID).Values

#####################
#Install-module MicrosoftTeams
import-module MicrosoftTeams
Connect-MicrosoftTeams
Set-CsTeamsClientConfiguration -AllowEgnyte $false
set-CsTeamsClientConfiguration -allowbox $false
set-CsTeamsClientConfiguration -allowdropbox $false
set-CsTeamsClientConfiguration -allowgoogledrive $false
set-CsTeamsClientConfiguration -allowsharefile $false
set-CsTeamsClientConfiguration -AllowEmailIntoChannel $true
set-CsTeamsClientConfiguration -AllowGuestUser $true
set-CsTeamsAppPermissionPolicy -GlobalCatalogAppsType blockedapplist
 
###################
Import-Module -Name MSCommerce 
Connect-MSCommerce
Get-MSCommerceProductPolicies -PolicyId AllowSelfServicePurchase | Where { $_.PolicyValue -eq “Enabled”} | forEach { 
Update-MSCommerceProductPolicy -PolicyId AllowSelfServicePurchase -ProductId $_.ProductID -Enabled $false  }