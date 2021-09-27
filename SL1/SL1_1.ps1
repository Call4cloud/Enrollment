#####################################
# Configure Intune Cleanup Rules    #
#####################################
$body = @'
{"DeviceInactivityBeforeRetirementInDays":"60"}
'@

$apiUrl = 'https://graph.microsoft.com/beta/deviceManagement/managedDeviceCleanupSettings'
$Data = Invoke-RestMethod -Headers $headers1b -Uri $apiUrl -Body $body -Method Patch -ContentType 'application/json'

#####################################
# Configure Compliance Threshold   #
#####################################
$body = @'
{"settings":{"secureByDefault":true,"enhancedJailBreak":true,"deviceComplianceCheckinThresholdDays":30}}
'@

$apiUrl = 'https://graph.microsoft.com/beta/deviceManagement'
$Data = Invoke-RestMethod -Headers $headers1b -Uri $apiUrl -Body $body -Method Patch -ContentType 'application/json'


#############################################################################################
# Assinging device join and enterprise roaming permissions to MS365BusinessLicences group    #
##############################################################################################

#Azure Ad Device Settings
$url = "https://main.iam.ad.ext.azure.com/api/DeviceSetting"
$content =  -join ('{"isEnabled":true,"deviceJoinAzureADSetting":1,"additionalAdminsForDevicesSetting":2,"deviceRegisterAzureADSetting":0,"requireMfaSetting":true,"maxDeviceNumberPerUserSetting":10,"deviceJoinAzureADIsAdminConfigurable":true,"additionalAdminsForDevicesIsAdminConfigurable":true,"deviceRegisterAzureADIsAdminConfigurable":false,"deviceJoinAzureADSelectedUsers":[{"id":"',$ms365licensegroupid,'","email":null,"displayName":"ms365businesslicences","type":2,"hasThumbnail":false,"imageUrl":null}],"additionalAdminsForDevicesSelectedUsers":[]}')
Invoke-RestMethod –Uri $url –Headers $headersazurerm –Method PUT -Body $content -ErrorAction Stop

#Enable Enterprise Roaming
$url = "https://main.iam.ad.ext.azure.com/api/RoamingSettings?ESRV2=false”
$contentpart1 = -join ('{"syncSetting":1,"isAdminConfigurable":true,"isRoamingSettingChanged":true,"syncSelectedUsers":[{"id":"',$ms365licensegroupid,'","displayName":"MS365BusinessLicences","email":"","hasThumbnail":false,"imageUrl":null,"type":2}]}')
$content = $contentpart1
Invoke-RestMethod –Uri $url  –Headers $headersazurerm  –Method PUT -Body $content -ErrorAction Stop


#############################################################################################
# Disabling Group creation								   #
##############################################################################################

#Disable: Users can create security groups
$url = "https://main.iam.ad.ext.azure.com/api/Directories/SsgmProperties"
$contentpart1 = '{"usersCanCreateGroups":false}'
$content = $contentpart1
Invoke-RestMethod –Uri $url –Headers $headersazurerm  –Method PUT -Body $content -ErrorAction Stop

#Disable: Users can create unified groups
$url = "https://main.iam.ad.ext.azure.com/api/Directories/SsgmProperties"
$contentpart1 = '{"usersCanCreateUnifiedGroups":false}'
$content = $contentpart1
Invoke-RestMethod –Uri $url –Headers $headersazurerm –Method PUT -Body $content -ErrorAction Stop

#enable: All users group
$url = "https://main.iam.ad.ext.azure.com/api/Directories/SsgmProperties"
$contentpart1 = '{"allUsersGroupEnabled":true}'
$content = $contentpart1
Invoke-RestMethod –Uri $url –Headers $headersazurerm –Method PUT -Body $content -ErrorAction Stop

#Disable: Groups in access panel
$url = "https://main.iam.ad.ext.azure.com/api/Directories/SsgmProperties"
$contentpart1 = '{"groupsInAccessPanelEnabled":false}'
$content = $contentpart1
Invoke-RestMethod –Uri $url –Headers $headersazurerm –Method PUT -Body $content -ErrorAction Stop

#enable: Groep expire Tme
$url = "https://main.iam.ad.ext.azure.com/api/Directories/LcmSettings"
$contentpart1 = '{"expiresAfterInDays":2,"groupLifetimeCustomValueInDays":180,"managedGroupTypesEnum":2,"managedGroupTypes":0,"adminNotificationEmails":"soc@deltacom.nl","groupIdsToMonitorExpirations":[],"policyIdentifier":"00000000-0000-0000-0000-000000000000"}'
$content = $contentpart1
Invoke-RestMethod –Uri $url –Headers $headersazurerm –Method PUT -Body $content -ErrorAction Stop


#############################################################################################
# Securing your ad								  #
##############################################################################################
#disable users can register apps
$url = "https://main.iam.ad.ext.azure.com/api/Directories/Properties"
$contentpart1 = '{"usersCanRegisterApps":false}'
$content = $contentpart1
Invoke-RestMethod –Uri $url –Headers $headersazurerm –Method PUT -Body $content -ErrorAction Stop

#Restrict Admin Portal Users
$url = "https://main.iam.ad.ext.azure.com/api/Directories/Properties"
$contentpart1 = '{"restrictNonAdminUsers":true}'
$content = $contentpart1
Invoke-RestMethod –Uri $url –Headers $headersazurerm –Method PUT -Body $content -ErrorAction Stop

#Disable Linkedin Connections
$url = "https://main.iam.ad.ext.azure.com/api/Directories/Properties"
$contentpart1 = '{"enableLinkedInAppFamily":1}'
$content = $contentpart1
Invoke-RestMethod –Uri $url –Headers $headersazurerm –Method put -Body $content -ErrorAction Stop

# disable users can allow apps to access company data
$url = "https://main.iam.ad.ext.azure.com/api/Directories/Properties"
$contentpart1 ='{"usersCanAllowAppsToAccessData":false}'
$content = $contentpart1
Invoke-RestMethod –Uri $url –Headers $headersazurerm –Method put -Body $content -ErrorAction Stop

#################
$url = "https://main.iam.ad.ext.azure.com/api/Directories/B2BDirectoryProperties"
$contentpart1 = '{"allowInvitations":true,"limitedAccessCanAddExternalUsers":false,"restrictDirectoryAccess":true,"usersCanAddExternalUsers":true}'
$content = $contentpart1
Invoke-RestMethod –Uri $url –Headers $headersazurerm –Method PUT -Body $content -ErrorAction Stop

