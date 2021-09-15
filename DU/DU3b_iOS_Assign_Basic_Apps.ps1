
####################################################
#$authResult = Get-MsalToken -ClientId 'd1ddf0e4-d672-4dae-b554-9d5bdfd93547' -Scopes 'https://graph.microsoft.com/.default'
#$headers1b = @{
#            'Content-Type'='application/json'
#            'Authorization'="Bearer " + $authResult.AccessToken
#            'ExpiresOn'=$authResult.ExpiresOn
#            }

####################################################

Function Get-IntuneApplication(){

[cmdletbinding()]

$graphApiVersion = "Beta"
$Resource = "deviceAppManagement/mobileApps"
    
    try {
        
    $uri = "https://graph.microsoft.com/$graphApiVersion/$($Resource)"
    (Invoke-RestMethod -Uri $uri –Headers $headers1b –Method Get).Value | ? { (!($_.'@odata.type').Contains("managed")) }

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

#


########################
# get all ios apps # 
###########################

$mobileApps = Get-IntuneApplication -All | Select-Object displayName, id, '@odata.type' | ? { $_.'@odata.type' -eq "#microsoft.graph.iosStoreApp" }
foreach ($mobileApp in $mobileApps) {
$applicationid = $mobileapp.id
$applicationuri = "https://graph.microsoft.com/beta/deviceAppManagement/mobileApps/$applicationid/assignments"
Invoke-RestMethod -Uri $applicationuri –Headers @{Authorization = "Bearer $($accessToken1b)"} –Method Get
$contentpart1 = '{"intent":"required","source": "direct","sourceId": null,"target": {"@odata.type": "#microsoft.graph.allDevicesAssignmentTarget"}}'
$content = $contentpart1
Invoke-RestMethod -Headers @{Authorization = "Bearer $($accessToken1b)"} -Uri $applicationuri -Body $content -Method Post -ContentType 'application/json'
} 

