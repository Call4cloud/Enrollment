#### Install required PowerShell Modules #####
$PSModules = @("AzureADPreview","AzureAD","msonline","WindowsAutopilotIntune","MSAL.PS")

Foreach ($PSModule in $PSModules){
    if (Get-Module -ListAvailable -Name $PSModule) {
        Write-Host "$PSModule Module exists"
    } 
    else {
        Write-Host "$PSModule Module does not exist yet"
        try {
            Install-Module $PSModule -AllowClobber
            Write-Host "$PSModule installed now"
        }
        catch {
            Write-Host "$PSModule cannot be installed"
        }
    }
    
    #### Import PowerShell Modules #####

    if (Get-Module -Name $PSModule) {
        Write-Host "$PSModule Module loaded"
    } 
    else {
        Write-Host "$PSModule Module not loaded yet"
        try {
            Import-Module $PSModule
            Write-Host "$PSModule loaded now"
        }
        catch {
            Write-Host "$PSModule cannot be loaded"
        }
        
    }

}

Install-PackageProvider -Name NuGet -Force
install-Module -Name PowerShellGet -Force -AllowClobber

$ScriptPath = $PSScriptRoot
if($ScriptPath -eq ""){
    #$ScriptPath = "C:\Users\rudy.ooms\OneDrive - call4cloud\555 - MS365 Beta\Default Uitrol"
    $ScriptPath = "C:\klant uitrollen"
}

Set-Location $ScriptPath

Import-Module ".\DU\functions\Test-JSON.ps1"

$JSONPath = "$ScriptPath\DU\JSON\"
$ADMXPath = "$ScriptPath\DU\ADMX"
$FunctionPath = "$ScriptPath\DU\functions"

if (Test-Path "$ScriptPath\DU\Packages"){
    $PackagePath = "$ScriptPath\DU\Packages"
}
else{
    $PackagePath = "C:\Packages"
}

$ChocoPackagePath = "$ScriptPath\DU\Packages\ChocolateyAppsInstall"
$Powershellscripts = "$ScriptPath\DU\scripts"

# Replacing quotes for Test-Path
$JSONPath = $JSONPath.replace('"','')

if(!(Test-Path "$JSONPath")){

Write-Host "Import Path for JSON file doesn't exist..." -ForegroundColor Red
Write-Host "Script can't continue..." -ForegroundColor Red
Write-Host
break
}

#### Ask Credentials ####
Write-Host "Gebruikersnaam AzureAD van $klant " -ForegroundColor "Yellow" -NoNewline
$user = Read-Host
$Cred = Get-Credential $user

connect-msgraph -AdminConsent | Out-Null

#### Tokens opvragen ####


login-azurermaccount -Credential $Cred
$context = Get-AzureRmContext
$tenantId = $context.Tenant.Id

#token Intune Powershell
$RedirectUri = "urn:ietf:wg:oauth:2.0:oob"

$authResult = Get-MsalToken -ClientId 'd1ddf0e4-d672-4dae-b554-9d5bdfd93547' -Scopes 'https://graph.microsoft.com/.default' -RedirectUri $RedirectUri
$accesstoken1b = $authresult.accesstoken

$headers1b = @{
            'Content-Type'='application/json'
            'Authorization'="Bearer " + $accesstoken1b
            'ExpiresOn'=$authResult.ExpiresOn
            }

#token Azure PowerShell
$authResult = Get-MsalToken -ClientId '1950a258-227b-4e31-a9cf-717495945fc2' -Scopes 'https://graph.microsoft.com/.default'
$accesstoken1e = $authresult.accesstoken

$headers1e = @{
            'Content-Type'='application/json'
            'Authorization'="Bearer " + $accesstoken1e
            'ExpiresOn'=$authResult.ExpiresOn
            }

#token AzureRm



$SubscriptionId = $context.Subscription
$cache = $context.TokenCache
$cacheItem = $cache.ReadItems()
$refreshtoken=$cacheItem[$cacheItem.Count -1].refreshtoken
$body = "grant_type=refresh_token&refresh_token=$($refreshToken)&resource=74658136-14ec-4630-ad9b-26e160ff0fc6"
$apiToken = Invoke-RestMethod "https://login.microsoftonline.com/$tenantId/oauth2/token" -Method POST -Body $body -ContentType 'application/x-www-form-urlencoded'

$headersazurerm = @{
'Authorization' = 'Bearer ' + $apiToken.access_token
'Content-Type' = 'application/json'
    'X-Requested-With'= 'XMLHttpRequest'
    'x-ms-client-request-id'= [guid]::NewGuid()
   'x-ms-correlation-id' = [guid]::NewGuid()
    }

#Connect to graph and azuread

 connect-azuread -Credential $Cred
  $id = get-AzureADTenantDetail
 $klant = $id.DisplayName


##################
#### Part 2 ####
##################
.\DU\DU2a_Create_Dynamic_Groups.ps1

###################
$URL = "https://graph.microsoft.com/v1.0/groups?"
$Allgroups = (Invoke-RestMethod -Headers $headers1b -Uri $URL -Method GET).value 
$group= $Allgroups | Where-Object -Property Displayname -Value "All windows devices" -eq
$allwindowsdevicesgroupid = $group.id

$group= $Allgroups | Where-Object -Property Displayname -Value "MS365BusinessLicences" -eq
$ms365licensegroupid = $group.id

$group= $Allgroups | Where-Object -Property Displayname -Value "autopilotstaticgroup" -eq
$autopilotstaticgroupid = $group.id

$group= $Allgroups | Where-Object -Property Displayname -Value "Exclude_Require_MDM_Managed_devices_Windows_Mac" -eq
$excluderequiremdmwindowsid = $group.id

$group= $Allgroups | Where-Object -Property Displayname -Value "Exclude_Require_MDM_Managed_devices_mobile_access" -eq
$excluderequiremdmmobileid = $group.id

$group= $Allgroups | Where-Object -Property Displayname -Value "Exclude_Require_MFA_Weblogin_Nonmanaged_devices" -eq
$exlcuderequiremfaid = $group.id

$group= $Allgroups | Where-Object -Property Displayname -Value "Exclude_Require_MAM_Approved_app_Exceptexchange" -eq
$excluderequireapprovedappexceptexchangepid = $group.id

$group= $Allgroups | Where-Object -Property Displayname -Value "Exclude_Require_MAM_Approved_app_Onlyexchange" -eq
$excludereapprovedapponlyexchangeid = $group.id

$group= $Allgroups | Where-Object -Property Displayname -Value "Exclude_Block_exchangeDownloads_Nonmanaged_devices" -eq
$excluderequiredownloadsexchangeid = $group.id

$group= $Allgroups | Where-Object -Property Displayname -Value "Exclude_Block_Legacy_Authenticatie" -eq
$excludeblocklegacyauthid = $group.id

$group= $Allgroups | Where-Object -Property Displayname -Value "Exclude_Block_Require_Trusted_Countries" -eq
$excludeblockcountriesid = $group.id

###################
# "ALL Users" groepID ophalen
###################
$group= $Allgroups | Where-Object -Property Displayname -Value "Alle gebruikers" -eq
if ($group -eq ""){
    $group= $Allgroups | Where-Object -Property Displayname -Value "all users" -eq
}
$allusersgroupid = $group.id


###################
.\DU\DU2b_Create_Autopilot_Profiles.ps1
.\DU\DU2c_Autopilot_profile_assignment.ps1
.\DU\DU2d_Link_license_to_Group.ps1




#### Klantgegevens ####
$PackagePathCust = "$PackagePath\$klant"

#### Map Solarwinds aanmaken ####
New-Item -Path $PackagePathCust -Name "Solarwinds" -ItemType "directory" -force
#Make sure the Solarwinds Intune Win file exist in that folder!

.\DU\DU2e_Set_Intune_As_MDMAuthority.ps1
.\DU\DU2f_Config_Apple_MDM.ps1
.\DU\DU2g_Assign_Google_Apps.ps1

#### Android en IOS App Beveiligings/Configuratie beleid maken ####
.\DU\DU2h_AppProtectionPolicyUnmanagedDevices.ps1
.\DU\DU2h_AppProtectionPolicymanagedDevices.ps1
.\DU\DU2i_Create_Enrollment_Restrictions.ps1

##################
#### Part 3 ####
#################
#### Apps uploaden ######
# Windows10 Apps
.\DU\DU3b_Windows10_Upload_Basic_Apps.ps1
# iOS Apps
.\DU\DU3b_iOS_Upload_Basic_Apps.ps1
# Office365 Apps
.\DU\DU3b_Office365_Upload_Apps.ps1
# Edge App
.\DU\DU3b_Edge_Upload_App.ps1
# Chocolatey Apps
.\DU\DU3b_Chocolatey_Upload_Basic_Apps.ps1


#### Apps assignment ######
# Windows10 Apps
.\DU\DU3b_Windows10_Assign_Basic_Apps.ps1
# iOS Apps
.\DU\DU3b_iOS_Assign_Basic_Apps.ps1
# Chocolatey Apps 
.\DU\DU3b_Chocolatey_Assign_Basic_Apps.ps1
.\DU\DU3b_Chocolatey_Assign_Large_Icons.ps1

#### Configure Enrollment Status page  #####
.\DU\DU3c_Config_Enrollment_Status_Page.ps1


##################
#### Part 4 ####
##################
# Administratieve Configuraties importeren
.\DU\DU4a_DeviceConfigurationADMX_Import_FromJSON.ps1
.\DU\Du4a_DeviceConfigurationADMX_Assignment.ps1
# Apparaat Configuraties importeren
.\DU\Du4b_Windows10_ImportAllDeviceConfigs.ps1
.\DU\DU4b_AppConfigurationPolicy_ImportFromJSON.ps1
.\DU\DU4b_AppConfigurationPolicy_Assignment.ps1
# Powershellscripts importeren
.\DU\DU4c_Enroll_Windows10_Powershellscripts.ps1
 # FireWallregels instellen
.\DU\DU4d_Windows10_firewallRules.ps1

##################
#### Part 5 ####
##################
.\DU\DU5_Import_Compliance_Policies.ps1

##################
#### Part 6 ####
##################
.\DU\DU6_Config_WindowsUpdate.ps1

##################
#### Part 7 ####
##################
.\DU\DU7_Config_WindowsHello.ps1

##################
#### Part 8 ####
##################
.\CA\DU8_Deploy_ConditionalAccessRules.ps1

##################
#### Part 9 ####
##################
.\SL1\SL1_1_Totaal.ps1
