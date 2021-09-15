

####################################################

#$authResult = Get-MsalToken -ClientId 'd1ddf0e4-d672-4dae-b554-9d5bdfd93547' -Scopes 'https://graph.microsoft.com/.default'
#$headers1b = @{
#            'Content-Type'='application/json'
#            'Authorization'="Bearer " + $authResult.AccessToken
#            'ExpiresOn'=$authResult.ExpiresOn
#            }

####################################################

Function Get-DeviceEnrollmentConfigurations(){
    
[cmdletbinding()]
    
$graphApiVersion = "Beta"
$Resource = "deviceManagement/deviceEnrollmentConfigurations"
        
    try {
            
    $uri = "https://graph.microsoft.com/$graphApiVersion/$($Resource)"
    (Invoke-RestMethod -Uri $uri -Headers $headers1b -Method Get).Value
    
    }
        
    catch {
    
    $ex = $_.Exception
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
    
Function Set-DeviceEnrollmentConfiguration(){
    
    
[cmdletbinding()]
    
param
(
    $JSON,
    $DEC_Id
)
    
$graphApiVersion = "Beta"
$App_resource = "deviceManagement/deviceEnrollmentConfigurations"
        
    try {
    
        if(!$JSON){
    
        write-host "No JSON was passed to the function, provide a JSON variable" -f Red
        break
    
        }
    
        elseif(!$DEC_Id){
    
        write-host "No Device Enrollment Configuration ID was passed to the function, provide a Device Enrollment Configuration ID" -f Red
        break
    
        }
    
        else {
    
        Test-JSON -JSON $JSON
        
        $uri = "https://graph.microsoft.com/$graphApiVersion/$($App_resource)/$DEC_Id"
        Invoke-RestMethod -Uri $uri -Method Patch -ContentType "application/json" -Body $JSON -Headers $headers1b
    
        }
        
    }
        
    catch {
    
    $ex = $_.Exception
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

Function Test-JSON(){

param (

$JSON

)

    try {

    $TestJSON = ConvertFrom-Json $JSON -ErrorAction Stop
    $validJson = $true

    }

    catch {

    $validJson = $false
    $_.Exception

    }

    if (!$validJson){

    Write-Host "Provided JSON isn't in valid JSON format" -f Red
    break

    }

}


####################################################

$JSON = @"

{
    "@odata.context":  "https://graph.microsoft.com/beta/$metadata#deviceManagement/deviceEnrollmentConfigurations/$entity",
    "@odata.type":  "#microsoft.graph.windows10EnrollmentCompletionPageConfiguration",
    "id":  "942bf267-8ce1-4d12-8691-163ea8c6b54b_DefaultWindows10EnrollmentCompletionPageConfiguration",
    "displayName":  "All users and all devices",
    "description":  "This is the default enrollment status screen configuration applied with the lowest priority to all users and all devices regardless of group membership.",
    "priority":  0,
    "createdDateTime":  "2020-03-12T19:50:28.1782346Z",
    "lastModifiedDateTime":  "2020-03-12T19:50:28.1782346Z",
    "version":  0,
    "showInstallationProgress":  true,
    "blockDeviceSetupRetryByUser":  false,
    "allowDeviceResetOnInstallFailure":  true,
    "allowLogCollectionOnInstallFailure":  true,
    "customErrorMessage":  "",
    "installProgressTimeoutInMinutes":  90,
    "allowDeviceUseOnInstallFailure":  true,
    "selectedMobileAppIds":  [
                                 "cd961d45-9f46-42e8-ae06-9a430387863c",
                                 "8a042df1-da0b-435f-ab1b-1640e629d5bf",
                                 "322879a6-3864-4d94-a6de-88a577c9d3fd"
                             ],
    "trackInstallProgressForAutopilotOnly":  true,
    "disableUserStatusTrackingAfterFirstUser":  true
}

"@

####################################################

$DeviceEnrollmentConfigurations = Get-DeviceEnrollmentConfigurations

$PlatformRestrictions = ($DeviceEnrollmentConfigurations | Where-Object { ($_.id).contains("DefaultWindows10EnrollmentCompletionPageConfiguration") }).id

Set-DeviceEnrollmentConfiguration -DEC_Id $PlatformRestrictions -JSON $JSON
