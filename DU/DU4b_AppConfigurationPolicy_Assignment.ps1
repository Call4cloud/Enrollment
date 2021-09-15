
####################################################

#$authResult = Get-MsalToken -ClientId 'd1ddf0e4-d672-4dae-b554-9d5bdfd93547' -Scopes 'https://graph.microsoft.com/.default'
#$headers1b = @{
#            'Content-Type'='application/json'
##            'Authorization'="Bearer " + $authResult.AccessToken
 #           'ExpiresOn'=$authResult.ExpiresOn
 #           }

####################################################

Function Get-IntuneApplication(){

[cmdletbinding()]

$graphApiVersion = "Beta"
$Resource = "deviceAppManagement/MobileAppConfigurations"
$uri = "https://graph.microsoft.com/$graphApiVersion/$($resource)"
(Invoke-RestMethod -Uri $uri -Headers $headers1b -Method Get).Value


}




####################################################
####IOS_IntuneMAMUpn_Outlook		####
####################################################
$ApplicationName = "IOS_IntuneMAMUpn_Outlook"
$Application = Get-IntuneApplication | ? { $_.displayName -eq "$ApplicationName" }
$solarwindsid = $application.id
$solarwindsuri = "https://graph.microsoft.com/beta/deviceappmanagement/MobileAppConfigurations/$solarwindsid/microsoft.graph.managedDeviceMobileAppConfiguration/assign"
$contentpart1 = '{"assignments":[{"id":"","target":{"@odata.type":"#microsoft.graph.allDevicesAssignmentTarget"}}]}'
$content = $contentpart1
Invoke-RestMethod –Uri $solarwindsuri –Headers $headers1b –Method Post -Body $content -ErrorAction Stop -ContentType 'application/json'


####################################################
####IOS_IntuneMAMUpn_Onedrive		####
####################################################
$ApplicationName = "IOS_IntuneMAMUpn_Onedrive"
$Application = Get-IntuneApplication | ? { $_.displayName -eq "$ApplicationName" }
$solarwindsid = $application.id
$solarwindsuri = "https://graph.microsoft.com/beta/deviceappmanagement/MobileAppConfigurations/$solarwindsid/microsoft.graph.managedDeviceMobileAppConfiguration/assign"
$contentpart1 = '{"assignments":[{"id":"","target":{"@odata.type":"#microsoft.graph.allDevicesAssignmentTarget"}}]}'
$content = $contentpart1
Invoke-RestMethod –Uri $solarwindsuri –Headers $headers1b –Method Post -Body $content -ErrorAction Stop -ContentType 'application/json'

####################################################
####IOS_IntuneMAMUpn_Word	####
####################################################
$ApplicationName = "IOS_IntuneMAMUpn_Word"
$Application = Get-IntuneApplication | ? { $_.displayName -eq "$ApplicationName" }
$solarwindsid = $application.id
$solarwindsuri = "https://graph.microsoft.com/beta/deviceappmanagement/MobileAppConfigurations/$solarwindsid/microsoft.graph.managedDeviceMobileAppConfiguration/assign"
$contentpart1 = '{"assignments":[{"id":"","target":{"@odata.type":"#microsoft.graph.allDevicesAssignmentTarget"}}]}'
$content = $contentpart1
Invoke-RestMethod –Uri $solarwindsuri –Headers $headers1b –Method Post -Body $content -ErrorAction Stop -ContentType 'application/json'

####################################################
####IOS_IntuneMAMUpn_Office	####
####################################################
$ApplicationName = "IOS_IntuneMAMUpn_Office"
$Application = Get-IntuneApplication | ? { $_.displayName -eq "$ApplicationName" }
$solarwindsid = $application.id
$solarwindsuri = "https://graph.microsoft.com/beta/deviceappmanagement/MobileAppConfigurations/$solarwindsid/microsoft.graph.managedDeviceMobileAppConfiguration/assign"
$contentpart1 = '{"assignments":[{"id":"","target":{"@odata.type":"#microsoft.graph.allDevicesAssignmentTarget"}}]}'
$content = $contentpart1
Invoke-RestMethod –Uri $solarwindsuri –Headers $headers1b –Method Post -Body $content -ErrorAction Stop -ContentType 'application/json'

####################################################
####IOS_IntuneMAMUpn_Teams	####
####################################################
$ApplicationName = "IOS_IntuneMAMUpn_Teams"
$Application = Get-IntuneApplication | ? { $_.displayName -eq "$ApplicationName" }
$solarwindsid = $application.id
$solarwindsuri = "https://graph.microsoft.com/beta/deviceappmanagement/MobileAppConfigurations/$solarwindsid/microsoft.graph.managedDeviceMobileAppConfiguration/assign"
$contentpart1 = '{"assignments":[{"id":"","target":{"@odata.type":"#microsoft.graph.allDevicesAssignmentTarget"}}]}'
$content = $contentpart1
Invoke-RestMethod –Uri $solarwindsuri –Headers $headers1b –Method Post -Body $content -ErrorAction Stop -ContentType 'application/json'

####################################################
####IOS_IntuneMAMUpn_Excel	####
####################################################
$ApplicationName = "IOS_IntuneMAMUpn_Excel"
$Application = Get-IntuneApplication | ? { $_.displayName -eq "$ApplicationName" }
$solarwindsid = $application.id
$solarwindsuri = "https://graph.microsoft.com/beta/deviceappmanagement/MobileAppConfigurations/$solarwindsid/microsoft.graph.managedDeviceMobileAppConfiguration/assign"
$contentpart1 = '{"assignments":[{"id":"","target":{"@odata.type":"#microsoft.graph.allDevicesAssignmentTarget"}}]}'
$content = $contentpart1
Invoke-RestMethod –Uri $solarwindsuri –Headers $headers1b –Method Post -Body $content -ErrorAction Stop -ContentType 'application/json'
