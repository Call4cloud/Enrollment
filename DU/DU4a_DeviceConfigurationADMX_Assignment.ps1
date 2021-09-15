
####################################################

#$authResult = Get-MsalToken -ClientId 'd1ddf0e4-d672-4dae-b554-9d5bdfd93547' -Scopes 'https://graph.microsoft.com/.default'
#$headers1b = @{
#            'Content-Type'='application/json'
#           'Authorization'="Bearer " + $authResult.AccessToken
 #           'ExpiresOn'=$authResult.ExpiresOn
#            }

####################################################

Function Get-IntuneApplication(){

[cmdletbinding()]

$graphApiVersion = "Beta"
$Resource = "deviceManagement/groupPolicyConfigurations"
$uri = "https://graph.microsoft.com/$graphApiVersion/$($resource)"
(Invoke-RestMethod -Uri $uri -Headers $headers1b -Method Get).Value


}

#

####################################################

####################################################
####Windows10_Onedrive_assignments		####
####################################################
$ApplicationName = "Windows10_Onedrive"
$Application = Get-IntuneApplication | ? { $_.displayName -eq "$ApplicationName" }
$solarwindsid = $application.id
$solarwindsuri = "https://graph.microsoft.com/beta/deviceManagement/groupPolicyConfigurations('$solarwindsid')/assign"
$contentpart1 = '{"assignments":[{"id":"","target":{"@odata.type":"#microsoft.graph.allLicensedUsersAssignmentTarget"}},{"id":"","target":{"@odata.type":"#microsoft.graph.allDevicesAssignmentTarget"}}]}'
$content = $contentpart1
Invoke-RestMethod -Uri $solarwindsuri -Headers $headers1b -Method Post -Body $content -ErrorAction Stop -ContentType 'application/json'

####################################################
####Office_OutlookSSO_assignments		####
####################################################
$ApplicationName = "Office_outlooksso"
$Application = Get-IntuneApplication | ? { $_.displayName -eq "$ApplicationName" }
$solarwindsid = $application.id
$solarwindsuri = "https://graph.microsoft.com/beta/deviceManagement/groupPolicyConfigurations('$solarwindsid')/assign"
$contentpart1 = '{"assignments":[{"id":"","target":{"@odata.type":"#microsoft.graph.allLicensedUsersAssignmentTarget"}},{"id":"","target":{"@odata.type":"#microsoft.graph.allDevicesAssignmentTarget"}}]}'
$content = $contentpart1
Invoke-RestMethod -Uri $solarwindsuri -Headers $headers1b -Method Post -Body $content -ErrorAction Stop -ContentType 'application/json'

####################################################
####Office_security_assignments			####
####################################################
$ApplicationName = "Office_Security"
$Application = Get-IntuneApplication | ? { $_.displayName -eq "$ApplicationName" }
$solarwindsid = $application.id
$solarwindsuri = "https://graph.microsoft.com/beta/deviceManagement/groupPolicyConfigurations('$solarwindsid')/assign"
$contentpart1 = '{"assignments":[{"id":"","target":{"@odata.type":"#microsoft.graph.allLicensedUsersAssignmentTarget"}},{"id":"","target":{"@odata.type":"#microsoft.graph.allDevicesAssignmentTarget"}}]}'
$content = $contentpart1
Invoke-RestMethod -Uri $solarwindsuri -Headers $headers1b -Method Post -Body $content -ErrorAction Stop -ContentType 'application/json'

####################################################
####Windows10_Edge_Settings1_assignments	####
####################################################
$ApplicationName = "Windows10_Edge_Settings"
$Application = Get-IntuneApplication | ? { $_.displayName -eq "$ApplicationName" }
$solarwindsid = $application.id
$solarwindsuri = "https://graph.microsoft.com/beta/deviceManagement/groupPolicyConfigurations('$solarwindsid')/assign"
$contentpart1 = '{"assignments":[{"id":"","target":{"@odata.type":"#microsoft.graph.allLicensedUsersAssignmentTarget"}},{"id":"","target":{"@odata.type":"#microsoft.graph.allDevicesAssignmentTarget"}}]}'
$content = $contentpart1
Invoke-RestMethod -Uri $solarwindsuri -Headers $headers1b -Method Post -Body $content -ErrorAction Stop -ContentType 'application/json'
####################################################
####Windows10_Eventlog_assignments	####
####################################################
$ApplicationName = "Windows10_Eventlog"
$Application = Get-IntuneApplication | ? { $_.displayName -eq "$ApplicationName" }
$solarwindsid = $application.id
$solarwindsuri = "https://graph.microsoft.com/beta/deviceManagement/groupPolicyConfigurations('$solarwindsid')/assign"
$contentpart1 = '{"assignments":[{"id":"","target":{"@odata.type":"#microsoft.graph.allLicensedUsersAssignmentTarget"}},{"id":"","target":{"@odata.type":"#microsoft.graph.allDevicesAssignmentTarget"}}]}'
$content = $contentpart1
Invoke-RestMethod -Uri $solarwindsuri -Headers $headers1b -Method Post -Body $content -ErrorAction Stop -ContentType 'application/json'

