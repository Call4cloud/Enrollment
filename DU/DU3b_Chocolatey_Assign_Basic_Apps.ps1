

####################################################
#$authResult = Get-MsalToken -ClientId 'd1ddf0e4-d672-4dae-b554-9d5bdfd93547' -Scopes 'https://graph.microsoft.com/.default'
#$headers1b = @{
#            'Content-Type'='application/json'
 #           'Authorization'="Bearer " + $authResult.AccessToken
  #          'ExpiresOn'=$authResult.ExpiresOn
  #          }

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
####7zip
####################################################

$ApplicationName = "7zip"
$Application = Get-IntuneApplication | ? { $_.displayName -eq "$ApplicationName" }
$solarwindsid = $application.id
$solarwindsuri = "https://graph.microsoft.com/beta/deviceAppManagement/mobileApps/$solarwindsid/assignments"
Invoke-RestMethod -Uri $solarwindsuri -Headers $headers1b -Method Get
$contentpart1 = '{"intent":"available","source": "direct","sourceId": null,"target": {"@odata.type": "#microsoft.graph.allLicensedUsersAssignmentTarget"}}'
$content = $contentpart1
Invoke-RestMethod -Uri $solarwindsuri -Headers $headers1b -Method Post -Body $content -ErrorAction Stop -ContentType 'application/json'


####################################################
####citrix
####################################################

$ApplicationName = "Citrix"
$Application = Get-IntuneApplication | ? { $_.displayName -eq "$ApplicationName" }
$solarwindsid = $application.id
$solarwindsuri = "https://graph.microsoft.com/beta/deviceAppManagement/mobileApps/$solarwindsid/assignments"
Invoke-RestMethod -Uri $solarwindsuri -Headers $headers1b -Method Get
$contentpart1 = '{"intent":"available","source": "direct","sourceId": null,"target": {"@odata.type": "#microsoft.graph.allLicensedUsersAssignmentTarget"}}'
$content = $contentpart1
Invoke-RestMethod -Uri $solarwindsuri -Headers $headers1b -Method Post -Body $content -ErrorAction Stop -ContentType 'application/json'

####################################################
####cutepdf
####################################################

$ApplicationName = "Cutepdf"
$Application = Get-IntuneApplication | ? { $_.displayName -eq "$ApplicationName" }
$solarwindsid = $application.id
$solarwindsuri = "https://graph.microsoft.com/beta/deviceAppManagement/mobileApps/$solarwindsid/assignments"
Invoke-RestMethod -Uri $solarwindsuri -Headers $headers1b -Method Get
$contentpart1 = '{"intent":"available","source": "direct","sourceId": null,"target": {"@odata.type": "#microsoft.graph.allLicensedUsersAssignmentTarget"}}'
$content = $contentpart1
Invoke-RestMethod -Uri $solarwindsuri -Headers $headers1b -Method Post -Body $content -ErrorAction Stop -ContentType 'application/json'

####################################################
####filezilla
####################################################

$ApplicationName = "filezilla"
$Application = Get-IntuneApplication | ? { $_.displayName -eq "$ApplicationName" }
$solarwindsid = $application.id
$solarwindsuri = "https://graph.microsoft.com/beta/deviceAppManagement/mobileApps/$solarwindsid/assignments"
Invoke-RestMethod -Uri $solarwindsuri -Headers $headers1b -Method Get
$contentpart1 = '{"intent":"available","source": "direct","sourceId": null,"target": {"@odata.type": "#microsoft.graph.allLicensedUsersAssignmentTarget"}}'
$content = $contentpart1
Invoke-RestMethod -Uri $solarwindsuri -Headers $headers1b -Method Post -Body $content -ErrorAction Stop -ContentType 'application/json'

####################################################
####firefox
####################################################

$ApplicationName = "firefox"
$Application = Get-IntuneApplication | ? { $_.displayName -eq "$ApplicationName" }
$solarwindsid = $application.id
$solarwindsuri = "https://graph.microsoft.com/beta/deviceAppManagement/mobileApps/$solarwindsid/assignments"
Invoke-RestMethod -Uri $solarwindsuri -Headers $headers1b -Method Get
$contentpart1 = '{"intent":"available","source": "direct","sourceId": null,"target": {"@odata.type": "#microsoft.graph.allLicensedUsersAssignmentTarget"}}'
$content = $contentpart1
Invoke-RestMethod -Uri $solarwindsuri -Headers $headers1b -Method Post -Body $content -ErrorAction Stop -ContentType 'application/json'


####################################################
####gotomeeting
####################################################

$ApplicationName = "Gotomeeting"
$Application = Get-IntuneApplication | ? { $_.displayName -eq "$ApplicationName" }
$solarwindsid = $application.id
$solarwindsuri = "https://graph.microsoft.com/beta/deviceAppManagement/mobileApps/$solarwindsid/assignments"
Invoke-RestMethod -Uri $solarwindsuri -Headers $headers1b -Method Get
$contentpart1 = '{"intent":"available","source": "direct","sourceId": null,"target": {"@odata.type": "#microsoft.graph.allLicensedUsersAssignmentTarget"}}'
$content = $contentpart1

Invoke-RestMethod -Uri $solarwindsuri -Headers $headers1b -Method Post -Body $content -ErrorAction Stop -ContentType 'application/json'

####################################################
####java
####################################################

$ApplicationName = "Java"
$Application = Get-IntuneApplication | ? { $_.displayName -eq "$ApplicationName" }
$solarwindsid = $application.id
$solarwindsuri = "https://graph.microsoft.com/beta/deviceAppManagement/mobileApps/$solarwindsid/assignments"
Invoke-RestMethod -Uri $solarwindsuri -Headers $headers1b -Method Get
$contentpart1 = '{"intent":"available","source": "direct","sourceId": null,"target": {"@odata.type": "#microsoft.graph.allLicensedUsersAssignmentTarget"}}'
$content = $contentpart1
Invoke-RestMethod -Uri $solarwindsuri -Headers $headers1b -Method Post -Body $content -ErrorAction Stop -ContentType 'application/json'



####################################################
####notepad++
####################################################

$ApplicationName = "Notepad++"
$Application = Get-IntuneApplication | ? { $_.displayName -eq "$ApplicationName" }
$solarwindsid = $application.id
$solarwindsuri = "https://graph.microsoft.com/beta/deviceAppManagement/mobileApps/$solarwindsid/assignments"
Invoke-RestMethod -Uri $solarwindsuri -Headers $headers1b -Method Get
$contentpart1 = '{"intent":"available","source": "direct","sourceId": null,"target": {"@odata.type": "#microsoft.graph.allLicensedUsersAssignmentTarget"}}'
$content = $contentpart1
Invoke-RestMethod -Uri $solarwindsuri -Headers $headers1b -Method Post -Body $content -ErrorAction Stop -ContentType 'application/json'


####################################################
####silverlight
####################################################

$ApplicationName = "silverlight"
$Application = Get-IntuneApplication | ? { $_.displayName -eq "$ApplicationName" }
$solarwindsid = $application.id
$solarwindsuri = "https://graph.microsoft.com/beta/deviceAppManagement/mobileApps/$solarwindsid/assignments"
Invoke-RestMethod -Uri $solarwindsuri -Headers $headers1b -Method Get
$contentpart1 = '{"intent":"available","source": "direct","sourceId": null,"target": {"@odata.type": "#microsoft.graph.allLicensedUsersAssignmentTarget"}}'
$content = $contentpart1
Invoke-RestMethod -Uri $solarwindsuri -Headers $headers1b -Method Post -Body $content -ErrorAction Stop -ContentType 'application/json'



####################################################
####skype
####################################################

$ApplicationName = "skype"
$Application = Get-IntuneApplication | ? { $_.displayName -eq "$ApplicationName" }
$solarwindsid = $application.id
$solarwindsuri = "https://graph.microsoft.com/beta/deviceAppManagement/mobileApps/$solarwindsid/assignments"
Invoke-RestMethod -Uri $solarwindsuri -Headers $headers1b -Method Get
$contentpart1 = '{"intent":"available","source": "direct","sourceId": null,"target": {"@odata.type": "#microsoft.graph.allLicensedUsersAssignmentTarget"}}'
$content = $contentpart1
Invoke-RestMethod -Uri $solarwindsuri -Headers $headers1b -Method Post -Body $content -ErrorAction Stop -ContentType 'application/json'

####################################################
####visualc++
####################################################

$ApplicationName = "Visualc++"
$Application = Get-IntuneApplication | ? { $_.displayName -eq "$ApplicationName" }
$solarwindsid = $application.id
$solarwindsuri = "https://graph.microsoft.com/beta/deviceAppManagement/mobileApps/$solarwindsid/assignments"
Invoke-RestMethod -Uri $solarwindsuri -Headers $headers1b -Method Get
$contentpart1 = '{"intent":"available","source": "direct","sourceId": null,"target": {"@odata.type": "#microsoft.graph.allLicensedUsersAssignmentTarget"}}'
$content = $contentpart1
Invoke-RestMethod -Uri $solarwindsuri -Headers $headers1b -Method Post -Body $content -ErrorAction Stop -ContentType 'application/json'

####################################################
####vlc
####################################################

$ApplicationName = "Vlc"
$Application = Get-IntuneApplication | ? { $_.displayName -eq "$ApplicationName" }
$solarwindsid = $application.id
$solarwindsuri = "https://graph.microsoft.com/beta/deviceAppManagement/mobileApps/$solarwindsid/assignments"
Invoke-RestMethod -Uri $solarwindsuri -Headers $headers1b -Method Get
$contentpart1 = '{"intent":"available","source": "direct","sourceId": null,"target": {"@odata.type": "#microsoft.graph.allLicensedUsersAssignmentTarget"}}'
$content = $contentpart1
Invoke-RestMethod -Uri $solarwindsuri -Headers $headers1b -Method Post -Body $content -ErrorAction Stop -ContentType 'application/json'


####################################################
####zoom
####################################################

$ApplicationName = "zoom"
$Application = Get-IntuneApplication | ? { $_.displayName -eq "$ApplicationName" }
$solarwindsid = $application.id
$solarwindsuri = "https://graph.microsoft.com/beta/deviceAppManagement/mobileApps/$solarwindsid/assignments"
Invoke-RestMethod -Uri $solarwindsuri -Headers $headers1b -Method Get
$contentpart1 = '{"intent":"available","source": "direct","sourceId": null,"target": {"@odata.type": "#microsoft.graph.allLicensedUsersAssignmentTarget"}}'
$content = $contentpart1
Invoke-RestMethod -Uri $solarwindsuri -Headers $headers1b -Method Post -Body $content -ErrorAction Stop -ContentType 'application/json'

####################################################
####synolgy
####################################################

$ApplicationName = "SynologyDrive"
$Application = Get-IntuneApplication | ? { $_.displayName -eq "$ApplicationName" }
$solarwindsid = $application.id
$solarwindsuri = "https://graph.microsoft.com/beta/deviceAppManagement/mobileApps/$solarwindsid/assignments"
Invoke-RestMethod -Uri $solarwindsuri -Headers $headers1b -Method Get
$contentpart1 = '{"intent":"available","source": "direct","sourceId": null,"target": {"@odata.type": "#microsoft.graph.allLicensedUsersAssignmentTarget"}}'
$content = $contentpart1
Invoke-RestMethod -Uri $solarwindsuri -Headers $headers1b -Method Post -Body $content -ErrorAction Stop -ContentType 'application/json'

####################################################
####keepass
####################################################

$ApplicationName = "Keepass"
$Application = Get-IntuneApplication | ? { $_.displayName -eq "$ApplicationName" }
$solarwindsid = $application.id
$solarwindsuri = "https://graph.microsoft.com/beta/deviceAppManagement/mobileApps/$solarwindsid/assignments"
Invoke-RestMethod -Uri $solarwindsuri -Headers $headers1b -Method Get
$contentpart1 = '{"intent":"available","source": "direct","sourceId": null,"target": {"@odata.type": "#microsoft.graph.allLicensedUsersAssignmentTarget"}}'
$content = $contentpart1
Invoke-RestMethod -Uri $solarwindsuri -Headers $headers1b -Method Post -Body $content -ErrorAction Stop -ContentType 'application/json'

####################################################
####Dymo
####################################################

$ApplicationName = "dymo"
$Application = Get-IntuneApplication | ? { $_.displayName -eq "$ApplicationName" }
$solarwindsid = $application.id
$solarwindsuri = "https://graph.microsoft.com/beta/deviceAppManagement/mobileApps/$solarwindsid/assignments"
Invoke-RestMethod -Uri $solarwindsuri -Headers $headers1b -Method Get
$contentpart1 = '{"intent":"available","source": "direct","sourceId": null,"target": {"@odata.type": "#microsoft.graph.allLicensedUsersAssignmentTarget"}}'
$content = $contentpart1
Invoke-RestMethod -Uri $solarwindsuri -Headers $headers1b -Method Post -Body $content -ErrorAction Stop -ContentType 'application/json'
