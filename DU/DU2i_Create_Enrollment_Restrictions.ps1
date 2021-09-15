
####################################################

#$authResult = Get-MsalToken -ClientId 'd1ddf0e4-d672-4dae-b554-9d5bdfd93547' -Scopes 'https://graph.microsoft.com/.default'
#$authtoken = @{
#            'Content-Type'='application/json'
##            'Authorization'="Bearer " + $authResult.AccessToken
 #           'ExpiresOn'=$authResult.ExpiresOn
 #           }

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

####################################################

$JSON = @"

{
    "@odata.type":"#microsoft.graph.deviceEnrollmentPlatformRestrictionsConfiguration",
    "displayName":"All Users",
    "description":"This is the default Device Type Restriction applied with the lowest priority to all users regardless of group membership.",

    "iosRestriction":  {
                           "platformBlocked":  false,
                           "personalDeviceEnrollmentBlocked":  false,
                           "osMinimumVersion":  null,
                           "osMaximumVersion":  null,
                           "blockedManufacturers":  [

                                                    ]
                       },
    "windowsRestriction":  {
                               "platformBlocked":  false,
                               "personalDeviceEnrollmentBlocked":  true,
                               "osMinimumVersion":  null,
                               "osMaximumVersion":  null,
                               "blockedManufacturers":  [

                                                        ]
                           },
    "windowsMobileRestriction":  {
                                     "platformBlocked":  true,
                                     "personalDeviceEnrollmentBlocked":  false,
                                     "osMinimumVersion":  null,
                                     "osMaximumVersion":  null,
                                     "blockedManufacturers":  [

                                                              ]
                                 },
    "androidRestriction":  {
                               "platformBlocked":  true,
                               "personalDeviceEnrollmentBlocked":  false,
                               "osMinimumVersion":  null,
                               "osMaximumVersion":  null,
                               "blockedManufacturers":  [

                                                        ]
                           },
    "androidForWorkRestriction":  {
                                      "platformBlocked":  false,
                                      "personalDeviceEnrollmentBlocked":  false,
                                      "osMinimumVersion":  null,
                                      "osMaximumVersion":  null,
                                      "blockedManufacturers":  [

                                                               ]
                                  },
    "macRestriction":  {
                           "platformBlocked":  true,
                           "personalDeviceEnrollmentBlocked":  false,
                           "osMinimumVersion":  null,
                           "osMaximumVersion":  null,
                           "blockedManufacturers":  [

                                                    ]
                       },
    "macOSRestriction":  {
                             "platformBlocked":  true,
                             "personalDeviceEnrollmentBlocked":  false,
                             "osMinimumVersion":  null,
                             "osMaximumVersion":  null,
                             "blockedManufacturers":  [

                                                      ]
                         }
}

"@

####################################################

$DeviceEnrollmentConfigurations = Get-DeviceEnrollmentConfigurations

$PlatformRestrictions = ($DeviceEnrollmentConfigurations | Where-Object { ($_.id).contains("DefaultPlatformRestrictions") }).id

Set-DeviceEnrollmentConfiguration -DEC_Id $PlatformRestrictions -JSON $JSON
