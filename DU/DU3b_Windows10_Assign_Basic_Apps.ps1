

####################################################
#$authResult = Get-MsalToken -ClientId 'd1ddf0e4-d672-4dae-b554-9d5bdfd93547' -Scopes 'https://graph.microsoft.com/.default'
#$headers1b = @{
#            'Content-Type'='application/json'
##            'Authorization'="Bearer " + $authResult.AccessToken
#            'ExpiresOn'=$authResult.ExpiresOn
#            }


####################################################

Function Get-IntuneApplication(){


[cmdletbinding()]

$graphApiVersion = "Beta"
$Resource = "deviceAppManagement/mobileApps"
    
    try {
        
    $uri = "https://graph.microsoft.com/$graphApiVersion/$($Resource)"
    (Invoke-RestMethod -Uri $uri -Headers $headers1b -Method Get).Value | ? { (!($_.'@odata.type').Contains("managed")) }

    }
    
    catch {

    $ex = $_.Exception
    Write-Host "Request to $Uri failed with HTTP Status $([int]$ex.Response.StatusCode) $($ex.Response.StatusDescription)" -f Red
    $errorResponse = $ex.Response.GetResponseStream()
    $reader = New-Object System.IO.StreamReader($errorResponse)
    $reader.BaseStream.Position = 0
    $reader.DiscardBufferedData()
    $responseBody = $reader.ReadToEnd();
    Write-Host "Response content:`n$responseBody" -f Red
    Write-Error "Request to $Uri failed with HTTP Status $($ex.Response.StatusCode) $($ex.Response.StatusDescription)"
    write-host
    break

    }

}

####################################################
####Get solarwinds ID
####################################################

$ApplicationName = "Solarwinds Agent"
$Application = Get-IntuneApplication | ? { $_.displayName -eq "$ApplicationName" }
$solarwindsid = $application.id
$solarwindsuri = "https://graph.microsoft.com/beta/deviceAppManagement/mobileApps/$solarwindsid/assignments"
Invoke-RestMethod -Uri $solarwindsuri -Headers $headers1b -Method Get
$contentpart1 = '{"intent":"required","source": "direct","sourceId": null,"target": {"@odata.type": "#microsoft.graph.allDevicesAssignmentTarget"}}'
$content = $contentpart1
Invoke-RestMethod -Uri $solarwindsuri -Headers $headers1b -Method Post -Body $content -ErrorAction Stop -ContentType 'application/json'


####################################################
####Get onedrive id
####################################################

$ApplicationName = "Onedrive"
$Application = Get-IntuneApplication | ? { $_.displayName -eq "$ApplicationName" }
$solarwindsid = $application.id
$solarwindsuri = "https://graph.microsoft.com/beta/deviceAppManagement/mobileApps/$solarwindsid/assignments"
Invoke-RestMethod -Uri $solarwindsuri -Headers $headers1b -Method Get
$contentpart1 = '{"intent":"required","source": "direct","sourceId": null,"target": {"@odata.type": "#microsoft.graph.allDevicesAssignmentTarget"}}'
$content = $contentpart1
Invoke-RestMethod -Uri $solarwindsuri -Headers $headers1b -Method Post -Body $content -ErrorAction Stop -ContentType 'application/json'



####################################################
####Get office365 id
####################################################

$ApplicationName = "Office 365 ProPlus"
$Application = Get-IntuneApplication | ? { $_.displayName -eq "$ApplicationName" }
$solarwindsid = $application.id
$solarwindsuri = "https://graph.microsoft.com/beta/deviceAppManagement/mobileApps/$solarwindsid/assignments"
Invoke-RestMethod -Uri $solarwindsuri -Headers $headers1b -Method Get
$contentpart1 = '{"intent":"required","source": "direct","sourceId": null,"target": {"@odata.type": "#microsoft.graph.allDevicesAssignmentTarget"}}'
$content = $contentpart1
Invoke-RestMethod -Uri $solarwindsuri -Headers $headers1b -Method Post -Body $content -ErrorAction Stop -ContentType 'application/json'

####################################################
####Get edge id
####################################################

$ApplicationName = "Microsoft Edge for Windows 10"
$Application = Get-IntuneApplication | ? { $_.displayName -eq "$ApplicationName" }
$solarwindsid = $application.id
$solarwindsuri = "https://graph.microsoft.com/beta/deviceAppManagement/mobileApps/$solarwindsid/assignments"
Invoke-RestMethod -Uri $solarwindsuri -Headers $headers1b -Method Get
$contentpart1 = '{"intent":"required","source": "direct","sourceId": null,"target": {"@odata.type": "#microsoft.graph.allDevicesAssignmentTarget"}}'
$content = $contentpart1
Invoke-RestMethod -Uri $solarwindsuri -Headers $headers1b -Method Post -Body $content -ErrorAction Stop -ContentType 'application/json'

####################################################
####Get Windows 10 PowerOptions ID
####################################################

$ApplicationName = "Windows 10 PowerOptions"
$Application = Get-IntuneApplication | ? { $_.displayName -eq "$ApplicationName" }
$solarwindsid = $application.id
$solarwindsuri = "https://graph.microsoft.com/beta/deviceAppManagement/mobileApps/$solarwindsid/assignments"
Invoke-RestMethod -Uri $solarwindsuri -Headers $headers1b -Method Get
$contentpart1 = '{"intent":"required","source": "direct","sourceId": null,"target": {"@odata.type": "#microsoft.graph.allDevicesAssignmentTarget"}}'
$content = $contentpart1
Invoke-RestMethod -Uri $solarwindsuri -Headers $headers1b -Method Post -Body $content -ErrorAction Stop -ContentType 'application/json'


####################################################
####Get Windows 10 Removeadmin ID
####################################################

$ApplicationName = "Windows10_removeadmin"
$Application = Get-IntuneApplication | ? { $_.displayName -eq "$ApplicationName" }
$solarwindsid = $application.id
$solarwindsuri = "https://graph.microsoft.com/beta/deviceAppManagement/mobileApps/$solarwindsid/assignments"
Invoke-RestMethod -Uri $solarwindsuri -Headers $headers1b -Method Get
$contentpart1 = '{"intent":"required","settings":{"@odata.type":"#microsoft.graph.win32LobAppAssignmentSettings","notifications":"hideAll","installTimeSettings":null,"restartSettings":null,"deliveryOptimizationPriority":"notConfigured"},"source": "direct","sourceId": null,"target": {"@odata.type": "#microsoft.graph.allDevicesAssignmentTarget"}}'
$content = $contentpart1
Invoke-RestMethod -Uri $solarwindsuri -Headers $headers1b -Method Post -Body $content -ErrorAction Stop -ContentType 'application/json'

####################################################
####Get Windows 10 Disableeula ID
####################################################

$ApplicationName = "Windows10_disableeula"
$Application = Get-IntuneApplication | ? { $_.displayName -eq "$ApplicationName" }
$solarwindsid = $application.id
$solarwindsuri = "https://graph.microsoft.com/beta/deviceAppManagement/mobileApps/$solarwindsid/assignments"
Invoke-RestMethod -Uri $solarwindsuri -Headers $headers1b -Method Get
$contentpart1 = '{"intent":"required","settings":{"@odata.type":"#microsoft.graph.win32LobAppAssignmentSettings","notifications":"hideAll","installTimeSettings":null,"restartSettings":null,"deliveryOptimizationPriority":"notConfigured"},"source": "direct","sourceId": null,"target": {"@odata.type": "#microsoft.graph.allDevicesAssignmentTarget"}}'
$content = $contentpart1
Invoke-RestMethod -Uri $solarwindsuri -Headers $headers1b -Method Post -Body $content -ErrorAction Stop -ContentType 'application/json'

####################################################
####Get Windows 10 chocolatey ID
####################################################

$ApplicationName = "Windows10_Chocolatey"
$Application = Get-IntuneApplication | ? { $_.displayName -eq "$ApplicationName" }
$solarwindsid = $application.id
$solarwindsuri = "https://graph.microsoft.com/beta/deviceAppManagement/mobileApps/$solarwindsid/assignments"
Invoke-RestMethod -Uri $solarwindsuri -Headers $headers1b -Method Get
$contentpart1 = '{"intent":"required","settings":{"@odata.type":"#microsoft.graph.win32LobAppAssignmentSettings","notifications":"hideAll","installTimeSettings":null,"restartSettings":null,"deliveryOptimizationPriority":"notConfigured"},"source": "direct","sourceId": null,"target": {"@odata.type": "#microsoft.graph.allDevicesAssignmentTarget"}}'
$content = $contentpart1
Invoke-RestMethod -Uri $solarwindsuri -Headers $headers1b -Method Post -Body $content -ErrorAction Stop -ContentType 'application/json'


####################################################
####Get Windows 10 Bitlocker ID
####################################################

$ApplicationName = "Windows10_Enablebitlocker"
$Application = Get-IntuneApplication | ? { $_.displayName -eq "$ApplicationName" }
$solarwindsid = $application.id
$solarwindsuri = "https://graph.microsoft.com/beta/deviceAppManagement/mobileApps/$solarwindsid/assignments"
Invoke-RestMethod -Uri $solarwindsuri -Headers $headers1b -Method Get
$contentpart1 = '{"intent":"required","settings":{"@odata.type":"#microsoft.graph.win32LobAppAssignmentSettings","notifications":"hideAll","installTimeSettings":null,"restartSettings":null,"deliveryOptimizationPriority":"notConfigured"},"source": "direct","sourceId": null,"target": {"@odata.type": "#microsoft.graph.allDevicesAssignmentTarget"}}'
$content = $contentpart1
Invoke-RestMethod -Uri $solarwindsuri -Headers $headers1b -Method Post -Body $content -ErrorAction Stop -ContentType 'application/json'

####################################################
####Get Windows 10 Onedriveconfig ID
####################################################

$ApplicationName = "Windows10_OnedriveConfig"
$Application = Get-IntuneApplication | ? { $_.displayName -eq "$ApplicationName" }
$solarwindsid = $application.id
$solarwindsuri = "https://graph.microsoft.com/beta/deviceAppManagement/mobileApps/$solarwindsid/assignments"
Invoke-RestMethod -Uri $solarwindsuri -Headers $headers1b -Method Get
$contentpart1 = '{"intent":"required","settings":{"@odata.type":"#microsoft.graph.win32LobAppAssignmentSettings","notifications":"hideAll","installTimeSettings":null,"restartSettings":null,"deliveryOptimizationPriority":"notConfigured"},"source": "direct","sourceId": null,"target": {"@odata.type": "#microsoft.graph.allDevicesAssignmentTarget"}}'
$content = $contentpart1
Invoke-RestMethod -Uri $solarwindsuri -Headers $headers1b -Method Post -Body $content -ErrorAction Stop -ContentType 'application/json'


####################################################
####Get Windows 10 defender ID
####################################################

$ApplicationName = "Windows10_defender"
$Application = Get-IntuneApplication | ? { $_.displayName -eq "$ApplicationName" }
$solarwindsid = $application.id
$solarwindsuri = "https://graph.microsoft.com/beta/deviceAppManagement/mobileApps/$solarwindsid/assignments"
Invoke-RestMethod -Uri $solarwindsuri -Headers $headers1b -Method Get
$contentpart1 = '{"intent":"required","settings":{"@odata.type":"#microsoft.graph.win32LobAppAssignmentSettings","notifications":"hideAll","installTimeSettings":null,"restartSettings":null,"deliveryOptimizationPriority":"notConfigured"},"source": "direct","sourceId": null,"target": {"@odata.type": "#microsoft.graph.allDevicesAssignmentTarget"}}'
$content = $contentpart1
Invoke-RestMethod -Uri $solarwindsuri -Headers $headers1b -Method Post -Body $content -ErrorAction Stop -ContentType 'application/json'

####################################################
####Get Windows 10 onedrive silent ID
####################################################

$ApplicationName = "Windows10_onedrivesilent"
$Application = Get-IntuneApplication | ? { $_.displayName -eq "$ApplicationName" }
$solarwindsid = $application.id
$solarwindsuri = "https://graph.microsoft.com/beta/deviceAppManagement/mobileApps/$solarwindsid/assignments"
Invoke-RestMethod -Uri $solarwindsuri -Headers $headers1b -Method Get
$contentpart1 = '{"intent":"required","settings":{"@odata.type":"#microsoft.graph.win32LobAppAssignmentSettings","notifications":"hideAll","installTimeSettings":null,"restartSettings":null,"deliveryOptimizationPriority":"notConfigured"},"source": "direct","sourceId": null,"target": {"@odata.type": "#microsoft.graph.allDevicesAssignmentTarget"}}'
$content = $contentpart1
Invoke-RestMethod -Uri $solarwindsuri -Headers $headers1b -Method Post -Body $content -ErrorAction Stop -ContentType 'application/json'

####################################################
####Get Windows 10 ChocolatyAppUpgrade ID
####################################################

$ApplicationName = "Windows10_ChocolateyAppUpgrade"
$Application = Get-IntuneApplication | ? { $_.displayName -eq "$ApplicationName" }
$solarwindsid = $application.id
$solarwindsuri = "https://graph.microsoft.com/beta/deviceAppManagement/mobileApps/$solarwindsid/assignments"
Invoke-RestMethod -Uri $solarwindsuri -Headers $headers1b -Method Get
$contentpart1 = '{"intent":"required","settings":{"@odata.type":"#microsoft.graph.win32LobAppAssignmentSettings","notifications":"hideAll","installTimeSettings":null,"restartSettings":null,"deliveryOptimizationPriority":"notConfigured"},"source": "direct","sourceId": null,"target": {"@odata.type": "#microsoft.graph.allDevicesAssignmentTarget"}}'
$content = $contentpart1
Invoke-RestMethod -Uri $solarwindsuri -Headers $headers1b -Method Post -Body $content -ErrorAction Stop -ContentType 'application/json'



####################################################
####Get Windows 10 Dclaps ID
####################################################

$ApplicationName = "Windows10_DClaps"
$Application = Get-IntuneApplication | ? { $_.displayName -eq "$ApplicationName" }
$solarwindsid = $application.id
$solarwindsuri = "https://graph.microsoft.com/beta/deviceAppManagement/mobileApps/$solarwindsid/assignments"
Invoke-RestMethod -Uri $solarwindsuri -Headers $headers1b -Method Get
$contentpart1 = '{"intent":"required","settings":{"@odata.type":"#microsoft.graph.win32LobAppAssignmentSettings","notifications":"hideAll","installTimeSettings":null,"restartSettings":null,"deliveryOptimizationPriority":"notConfigured"},"source": "direct","sourceId": null,"target": {"@odata.type": "#microsoft.graph.allDevicesAssignmentTarget"}}'
$content = $contentpart1
Invoke-RestMethod -Uri $solarwindsuri -Headers $headers1b -Method Post -Body $content -ErrorAction Stop -ContentType 'application/json'

####################################################
####Get Windows 10 ScheduleIntuneServiceRestart
####################################################

$ApplicationName = "Windows10_ScheduleIntuneServiceRestart"
$Application = Get-IntuneApplication | ? { $_.displayName -eq "$ApplicationName" }
$solarwindsid = $application.id
$solarwindsuri = "https://graph.microsoft.com/beta/deviceAppManagement/mobileApps/$solarwindsid/assignments"
Invoke-RestMethod -Uri $solarwindsuri -Headers $headers1b -Method Get
$contentpart1 = '{"intent":"required","settings":{"@odata.type":"#microsoft.graph.win32LobAppAssignmentSettings","notifications":"hideAll","installTimeSettings":null,"restartSettings":null,"deliveryOptimizationPriority":"notConfigured"},"source": "direct","sourceId": null,"target": {"@odata.type": "#microsoft.graph.allDevicesAssignmentTarget"}}'
$content = $contentpart1
Invoke-RestMethod -Uri $solarwindsuri -Headers $headers1b -Method Post -Body $content -ErrorAction Stop -ContentType 'application/json'

####################################################
####Get Windows 10 AllowPrinterInstall
####################################################

$ApplicationName = "Windows10_AllowPrinterInstall"
$Application = Get-IntuneApplication | ? { $_.displayName -eq "$ApplicationName" }
$solarwindsid = $application.id
$solarwindsuri = "https://graph.microsoft.com/beta/deviceAppManagement/mobileApps/$solarwindsid/assignments"
Invoke-RestMethod -Uri $solarwindsuri -Headers $headers1b -Method Get
$contentpart1 = '{"intent":"required","settings":{"@odata.type":"#microsoft.graph.win32LobAppAssignmentSettings","notifications":"hideAll","installTimeSettings":null,"restartSettings":null,"deliveryOptimizationPriority":"notConfigured"},"source": "direct","sourceId": null,"target": {"@odata.type": "#microsoft.graph.allDevicesAssignmentTarget"}}'
$content = $contentpart1
Invoke-RestMethod -Uri $solarwindsuri -Headers $headers1b -Method Post -Body $content -ErrorAction Stop -ContentType 'application/json'
