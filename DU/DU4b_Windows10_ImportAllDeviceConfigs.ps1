

####################################################


#$authResult = Get-MsalToken -ClientId 'd1ddf0e4-d672-4dae-b554-9d5bdfd93547' -Scopes 'https://graph.microsoft.com/.default'
#$headers1b = @{
#            'Content-Type'='application/json'
#          'Authorization'="Bearer " + $authResult.AccessToken
#           'ExpiresOn'=$authResult.ExpiresOn
#           }

####################################################

Function Add-DeviceConfigurationPolicy(){


[cmdletbinding()]

param
(
    $JSON
)

$graphApiVersion = "Beta"
$DCP_resource = "deviceManagement/deviceConfigurations"
Write-Verbose "Resource: $DCP_resource"

    try {

        if($JSON -eq "" -or $JSON -eq $null){

        write-host "No JSON specified, please specify valid JSON for the Device Configuration Policy..." -f Red

        }

        else {

        Test-JSON -JSON $JSON

        $uri = "https://graph.microsoft.com/$graphApiVersion/$($DCP_resource)"
        Invoke-RestMethod -Uri $uri -Headers $headers1b -Method Post -Body $JSON -ContentType "application/json"

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

<#
.SYNOPSIS
This function is used to test if the JSON passed to a REST Post request is valid
.DESCRIPTION
The function tests if the JSON passed to the REST Post is valid
.EXAMPLE
Test-JSON -JSON $JSON
Test if the JSON is valid before calling the Graph REST interface
.NOTES
NAME: Test-AuthHeader
#>

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

Function Add-DeviceConfigurationPolicyAssignment(){


[cmdletbinding()]

param
(
    $ConfigurationPolicyId,
    $TargetGroupId
)

$graphApiVersion = "Beta"
$Resource = "deviceManagement/deviceConfigurations/$ConfigurationPolicyId/assign"
    
    try {

        if(!$ConfigurationPolicyId){

        write-host "No Configuration Policy Id specified, specify a valid Configuration Policy Id" -f Red
        break

        }

        if(!$TargetGroupId){

        write-host "No Target Group Id specified, specify a valid Target Group Id" -f Red
        break

        }

        $ConfPolAssign = "$ConfigurationPolicyId" + "_" + "$TargetGroupId"

$JSON = @"

{
  "deviceConfigurationGroupAssignments": [
    {
      "@odata.type": "#microsoft.graph.deviceConfigurationGroupAssignment",
      "id": "$ConfPolAssign",
      "targetGroupId": "$TargetGroupId"
    }
  ]
}

"@

    $uri = "https://graph.microsoft.com/$graphApiVersion/$($Resource)"
    Invoke-RestMethod -Uri $uri -Headers $headers1b -Method Post -Body $JSON -ContentType "application/json"

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
#Windows10_Timezone.json
####################################################

$ImportPath = "$jsonpath\Windows10_Timezone.json"

# Replacing quotes for Test-Path
$ImportPath = $ImportPath.replace('"','')

if(!(Test-Path "$ImportPath")){

Write-Host "Import Path for JSON file doesn't exist..." -ForegroundColor Red
Write-Host "Script can't continue..." -ForegroundColor Red
Write-Host
break

}

$JSON_Data = gc "$ImportPath"

# Excluding entries that are not required - id,createdDateTime,lastModifiedDateTime,version
$JSON_Convert = $JSON_Data | ConvertFrom-Json | Select-Object -Property * -ExcludeProperty id,createdDateTime,lastModifiedDateTime,version,supportsScopeTags

$DisplayName = $JSON_Convert.displayName

$JSON_Output = $JSON_Convert | ConvertTo-Json -Depth 5
            
write-host
write-host "Device Configuration Policy '$DisplayName' Found..." -ForegroundColor Yellow
write-host
$JSON_Output
write-host
Write-Host "Adding Device Configuration Policy '$DisplayName'" -ForegroundColor Yellow
$CreateResult = Add-DeviceConfigurationPolicy -JSON $JSON_Output
Write-Host "Device Configuration Policy created as" $CreateResult.id
write-host "Adding Assignments to Device Configuration policy '$DisplayName'" -ForegroundColor Yellow
$Assign = Add-DeviceConfigurationPolicyAssignment -ConfigurationPolicyId $CreateResult.id -TargetGroupId "adadadad-808e-44e2-905a-0b7873a8a531"



####################################################
#Windows10_applocker.json#
####################################################

$ImportPath = "$jsonpath\Windows10_Applocker.json"

# Replacing quotes for Test-Path
$ImportPath = $ImportPath.replace('"','')

if(!(Test-Path "$ImportPath")){

Write-Host "Import Path for JSON file doesn't exist..." -ForegroundColor Red
Write-Host "Script can't continue..." -ForegroundColor Red
Write-Host
break

}

$JSON_Data = gc "$ImportPath"

# Excluding entries that are not required - id,createdDateTime,lastModifiedDateTime,version
$JSON_Convert = $JSON_Data | ConvertFrom-Json | Select-Object -Property * -ExcludeProperty id,createdDateTime,lastModifiedDateTime,version,supportsScopeTags

$DisplayName = $JSON_Convert.displayName

$JSON_Output = $JSON_Convert | ConvertTo-Json -Depth 5
            
write-host
write-host "Device Configuration Policy '$DisplayName' Found..." -ForegroundColor Yellow
write-host
$JSON_Output
write-host
Write-Host "Adding Device Configuration Policy '$DisplayName'" -ForegroundColor Yellow
$CreateResult = Add-DeviceConfigurationPolicy -JSON $JSON_Output
Write-Host "Device Configuration Policy created as" $CreateResult.id
write-host "Adding Assignments to Device Configuration policy '$DisplayName'" -ForegroundColor Yellow
$Assign = Add-DeviceConfigurationPolicyAssignment -ConfigurationPolicyId $CreateResult.id -TargetGroupId "adadadad-808e-44e2-905a-0b7873a8a531"



####################################################
#Windows10_Defender.json#
####################################################

$ImportPath = "$jsonpath\Windows10_Defender.json"

# Replacing quotes for Test-Path
$ImportPath = $ImportPath.replace('"','')

if(!(Test-Path "$ImportPath")){

Write-Host "Import Path for JSON file doesn't exist..." -ForegroundColor Red
Write-Host "Script can't continue..." -ForegroundColor Red
Write-Host
break

}

$JSON_Data = gc "$ImportPath"

# Excluding entries that are not required - id,createdDateTime,lastModifiedDateTime,version
$JSON_Convert = $JSON_Data | ConvertFrom-Json | Select-Object -Property * -ExcludeProperty id,createdDateTime,lastModifiedDateTime,version,supportsScopeTags

$DisplayName = $JSON_Convert.displayName

$JSON_Output = $JSON_Convert | ConvertTo-Json -Depth 5
            
write-host
write-host "Device Configuration Policy '$DisplayName' Found..." -ForegroundColor Yellow
write-host
$JSON_Output
write-host
Write-Host "Adding Device Configuration Policy '$DisplayName'" -ForegroundColor Yellow
$CreateResult = Add-DeviceConfigurationPolicy -JSON $JSON_Output
Write-Host "Device Configuration Policy created as" $CreateResult.id
write-host "Adding Assignments to Device Configuration policy '$DisplayName'" -ForegroundColor Yellow
$Assign = Add-DeviceConfigurationPolicyAssignment -ConfigurationPolicyId $CreateResult.id -TargetGroupId "adadadad-808e-44e2-905a-0b7873a8a531"



####################################################
#Windows10_Storagesense.json#
####################################################

$ImportPath = "$jsonpath\Windows10_Storagesense.json"

# Replacing quotes for Test-Path
$ImportPath = $ImportPath.replace('"','')

if(!(Test-Path "$ImportPath")){

Write-Host "Import Path for JSON file doesn't exist..." -ForegroundColor Red
Write-Host "Script can't continue..." -ForegroundColor Red
Write-Host
break

}

$JSON_Data = gc "$ImportPath"

# Excluding entries that are not required - id,createdDateTime,lastModifiedDateTime,version
$JSON_Convert = $JSON_Data | ConvertFrom-Json | Select-Object -Property * -ExcludeProperty id,createdDateTime,lastModifiedDateTime,version,supportsScopeTags

$DisplayName = $JSON_Convert.displayName

$JSON_Output = $JSON_Convert | ConvertTo-Json -Depth 5
            
write-host
write-host "Device Configuration Policy '$DisplayName' Found..." -ForegroundColor Yellow
write-host
$JSON_Output
write-host
Write-Host "Adding Device Configuration Policy '$DisplayName'" -ForegroundColor Yellow
$CreateResult = Add-DeviceConfigurationPolicy -JSON $JSON_Output
Write-Host "Device Configuration Policy created as" $CreateResult.id
write-host "Adding Assignments to Device Configuration policy '$DisplayName'" -ForegroundColor Yellow
$Assign = Add-DeviceConfigurationPolicyAssignment -ConfigurationPolicyId $CreateResult.id -TargetGroupId "adadadad-808e-44e2-905a-0b7873a8a531"


####################################################
#Windows10_skipuserstatuspage.json#
####################################################

$ImportPath = "$jsonpath\Windows10_skip_user_status_page.json"

# Replacing quotes for Test-Path
$ImportPath = $ImportPath.replace('"','')

if(!(Test-Path "$ImportPath")){

Write-Host "Import Path for JSON file doesn't exist..." -ForegroundColor Red
Write-Host "Script can't continue..." -ForegroundColor Red
Write-Host
break

}

$JSON_Data = gc "$ImportPath"

# Excluding entries that are not required - id,createdDateTime,lastModifiedDateTime,version
$JSON_Convert = $JSON_Data | ConvertFrom-Json | Select-Object -Property * -ExcludeProperty id,createdDateTime,lastModifiedDateTime,version,supportsScopeTags

$DisplayName = $JSON_Convert.displayName

$JSON_Output = $JSON_Convert | ConvertTo-Json -Depth 5
            
write-host
write-host "Device Configuration Policy '$DisplayName' Found..." -ForegroundColor Yellow
write-host
$JSON_Output
write-host
Write-Host "Adding Device Configuration Policy '$DisplayName'" -ForegroundColor Yellow
$CreateResult = Add-DeviceConfigurationPolicy -JSON $JSON_Output
Write-Host "Device Configuration Policy created as" $CreateResult.id
write-host "Adding Assignments to Device Configuration policy '$DisplayName'" -ForegroundColor Yellow
$Assign = Add-DeviceConfigurationPolicyAssignment -ConfigurationPolicyId $CreateResult.id -TargetGroupId "adadadad-808e-44e2-905a-0b7873a8a531"


####################################################
#Windows10_localadminuser.json#
####################################################

$ww = Read-Host "Wat moet het lokale admin wachtwoord worden?"
$wwgoed  = "`"$ww`""
#$contentnieuw =  "`"value`": $wwgoed"
#$file = "C:\Users\rudy.ooms\OneDrive - call4cloud\444 - MS365 Scripted\Uitrol\DeviceconfigurationPolicy\JSON\Windows10_Create_admin_user.json"
#$content = get-content $file 
#$content[21]  = $contentnieuw
#$content | Set-Content $file

$ImportPath = "$jsonpath\Windows10_Create_admin_user.json"

# Replacing quotes for Test-Path
$ImportPath = $ImportPath.replace('"','')

if(!(Test-Path "$ImportPath")){

Write-Host "Import Path for JSON file doesn't exist..." -ForegroundColor Red
Write-Host "Script can't continue..." -ForegroundColor Red
Write-Host
break

}

$JSON_Data = gc "$ImportPath"

$JSON_Data = $JSON_Data -replace("<<<Password>>>",  $ww)

# Excluding entries that are not required - id,createdDateTime,lastModifiedDateTime,version
$JSON_Convert = $JSON_Data | ConvertFrom-Json | Select-Object -Property * -ExcludeProperty id,createdDateTime,lastModifiedDateTime,version,supportsScopeTags

$DisplayName = $JSON_Convert.displayName

$JSON_Output = $JSON_Convert | ConvertTo-Json -Depth 5
            
write-host
write-host "Device Configuration Policy '$DisplayName' Found..." -ForegroundColor Yellow
write-host
$JSON_Output
write-host
Write-Host "Adding Device Configuration Policy '$DisplayName'" -ForegroundColor Yellow
$CreateResult = Add-DeviceConfigurationPolicy -JSON $JSON_Output
Write-Host "Device Configuration Policy created as" $CreateResult.id
write-host "Adding Assignments to Device Configuration policy '$DisplayName'" -ForegroundColor Yellow
$Assign = Add-DeviceConfigurationPolicyAssignment -ConfigurationPolicyId $CreateResult.id -TargetGroupId "adadadad-808e-44e2-905a-0b7873a8a531"


####################################################
#Windows10_defenderasr.json#
####################################################

$ImportPath = "$jsonpath\Windows10_Defender_ASR.json"

# Replacing quotes for Test-Path
$ImportPath = $ImportPath.replace('"','')

if(!(Test-Path "$ImportPath")){

Write-Host "Import Path for JSON file doesn't exist..." -ForegroundColor Red
Write-Host "Script can't continue..." -ForegroundColor Red
Write-Host
break

}

$JSON_Data = gc "$ImportPath"

# Excluding entries that are not required - id,createdDateTime,lastModifiedDateTime,version
$JSON_Convert = $JSON_Data | ConvertFrom-Json | Select-Object -Property * -ExcludeProperty id,createdDateTime,lastModifiedDateTime,version,supportsScopeTags

$DisplayName = $JSON_Convert.displayName

$JSON_Output = $JSON_Convert | ConvertTo-Json -Depth 5
            
write-host
write-host "Device Configuration Policy '$DisplayName' Found..." -ForegroundColor Yellow
write-host
$JSON_Output
write-host
Write-Host "Adding Device Configuration Policy '$DisplayName'" -ForegroundColor Yellow
$CreateResult = Add-DeviceConfigurationPolicy -JSON $JSON_Output
Write-Host "Device Configuration Policy created as" $CreateResult.id
write-host "Adding Assignments to Device Configuration policy '$DisplayName'" -ForegroundColor Yellow
$Assign = Add-DeviceConfigurationPolicyAssignment -ConfigurationPolicyId $CreateResult.id -TargetGroupId "adadadad-808e-44e2-905a-0b7873a8a531"



####################################################
#Windows10_DeliveryOptimization.json#
####################################################

$ImportPath = "$jsonpath\Windows10_DeliveryOptimization.json"

# Replacing quotes for Test-Path
$ImportPath = $ImportPath.replace('"','')

if(!(Test-Path "$ImportPath")){

Write-Host "Import Path for JSON file doesn't exist..." -ForegroundColor Red
Write-Host "Script can't continue..." -ForegroundColor Red
Write-Host
break

}

$JSON_Data = gc "$ImportPath"

# Excluding entries that are not required - id,createdDateTime,lastModifiedDateTime,version
$JSON_Convert = $JSON_Data | ConvertFrom-Json | Select-Object -Property * -ExcludeProperty id,createdDateTime,lastModifiedDateTime,version,supportsScopeTags

$DisplayName = $JSON_Convert.displayName

$JSON_Output = $JSON_Convert | ConvertTo-Json -Depth 5
            
write-host
write-host "Device Configuration Policy '$DisplayName' Found..." -ForegroundColor Yellow
write-host
$JSON_Output
write-host
Write-Host "Adding Device Configuration Policy '$DisplayName'" -ForegroundColor Yellow
$CreateResult = Add-DeviceConfigurationPolicy -JSON $JSON_Output
Write-Host "Device Configuration Policy created as" $CreateResult.id
write-host "Adding Assignments to Device Configuration policy '$DisplayName'" -ForegroundColor Yellow
$Assign = Add-DeviceConfigurationPolicyAssignment -ConfigurationPolicyId $CreateResult.id -TargetGroupId "adadadad-808e-44e2-905a-0b7873a8a531"


####################################################
#Windows10_PowerSettings.json#
####################################################

$ImportPath = "$jsonpath\Windows10_PowerSettings.json"

# Replacing quotes for Test-Path
$ImportPath = $ImportPath.replace('"','')

if(!(Test-Path "$ImportPath")){

Write-Host "Import Path for JSON file doesn't exist..." -ForegroundColor Red
Write-Host "Script can't continue..." -ForegroundColor Red
Write-Host
break

}

$JSON_Data = gc "$ImportPath"

# Excluding entries that are not required - id,createdDateTime,lastModifiedDateTime,version
$JSON_Convert = $JSON_Data | ConvertFrom-Json | Select-Object -Property * -ExcludeProperty id,createdDateTime,lastModifiedDateTime,version,supportsScopeTags

$DisplayName = $JSON_Convert.displayName

$JSON_Output = $JSON_Convert | ConvertTo-Json -Depth 5
            
write-host
write-host "Device Configuration Policy '$DisplayName' Found..." -ForegroundColor Yellow
write-host
$JSON_Output
write-host
Write-Host "Adding Device Configuration Policy '$DisplayName'" -ForegroundColor Yellow
$CreateResult = Add-DeviceConfigurationPolicy -JSON $JSON_Output
Write-Host "Device Configuration Policy created as" $CreateResult.id
write-host "Adding Assignments to Device Configuration policy '$DisplayName'" -ForegroundColor Yellow
$Assign = Add-DeviceConfigurationPolicyAssignment -ConfigurationPolicyId $CreateResult.id -TargetGroupId "adadadad-808e-44e2-905a-0b7873a8a531"


####################################################
#Windows10_RequireBitlockerKey_10FailedLogins.json#
####################################################

$ImportPath = "$jsonpath\Windows10_RequireBitlockerKey_10FailedLogins.json"

# Replacing quotes for Test-Path
$ImportPath = $ImportPath.replace('"','')

if(!(Test-Path "$ImportPath")){

Write-Host "Import Path for JSON file doesn't exist..." -ForegroundColor Red
Write-Host "Script can't continue..." -ForegroundColor Red
Write-Host
break

}

$JSON_Data = gc "$ImportPath"

# Excluding entries that are not required - id,createdDateTime,lastModifiedDateTime,version
$JSON_Convert = $JSON_Data | ConvertFrom-Json | Select-Object -Property * -ExcludeProperty id,createdDateTime,lastModifiedDateTime,version,supportsScopeTags

$DisplayName = $JSON_Convert.displayName

$JSON_Output = $JSON_Convert | ConvertTo-Json -Depth 5
            
write-host
write-host "Device Configuration Policy '$DisplayName' Found..." -ForegroundColor Yellow
write-host
$JSON_Output
write-host
Write-Host "Adding Device Configuration Policy '$DisplayName'" -ForegroundColor Yellow
$CreateResult = Add-DeviceConfigurationPolicy -JSON $JSON_Output
Write-Host "Device Configuration Policy created as" $CreateResult.id
write-host "Adding Assignments to Device Configuration policy '$DisplayName'" -ForegroundColor Yellow
$Assign = Add-DeviceConfigurationPolicyAssignment -ConfigurationPolicyId $CreateResult.id -TargetGroupId "adadadad-808e-44e2-905a-0b7873a8a531"


####################################################
#Windows10_SettingsMenu.json#
####################################################

$ImportPath = "$jsonpath\Windows10_SettingsMenu.json"

# Replacing quotes for Test-Path
$ImportPath = $ImportPath.replace('"','')

if(!(Test-Path "$ImportPath")){

Write-Host "Import Path for JSON file doesn't exist..." -ForegroundColor Red
Write-Host "Script can't continue..." -ForegroundColor Red
Write-Host
break

}

$JSON_Data = gc "$ImportPath"

# Excluding entries that are not required - id,createdDateTime,lastModifiedDateTime,version
$JSON_Convert = $JSON_Data | ConvertFrom-Json | Select-Object -Property * -ExcludeProperty id,createdDateTime,lastModifiedDateTime,version,supportsScopeTags

$DisplayName = $JSON_Convert.displayName

$JSON_Output = $JSON_Convert | ConvertTo-Json -Depth 5
            
write-host
write-host "Device Configuration Policy '$DisplayName' Found..." -ForegroundColor Yellow
write-host
$JSON_Output
write-host
Write-Host "Adding Device Configuration Policy '$DisplayName'" -ForegroundColor Yellow
$CreateResult = Add-DeviceConfigurationPolicy -JSON $JSON_Output
Write-Host "Device Configuration Policy created as" $CreateResult.id
write-host "Adding Assignments to Device Configuration policy '$DisplayName'" -ForegroundColor Yellow
$Assign = Add-DeviceConfigurationPolicyAssignment -ConfigurationPolicyId $CreateResult.id -TargetGroupId "adadadad-808e-44e2-905a-0b7873a8a531"


####################################################
#Windows10_Audit#
####################################################

$ImportPath = "$jsonpath\Windows10_Audit.json"

# Replacing quotes for Test-Path
$ImportPath = $ImportPath.replace('"','')

if(!(Test-Path "$ImportPath")){

Write-Host "Import Path for JSON file doesn't exist..." -ForegroundColor Red
Write-Host "Script can't continue..." -ForegroundColor Red
Write-Host
break

}

$JSON_Data = gc "$ImportPath"

# Excluding entries that are not required - id,createdDateTime,lastModifiedDateTime,version
$JSON_Convert = $JSON_Data | ConvertFrom-Json | Select-Object -Property * -ExcludeProperty id,createdDateTime,lastModifiedDateTime,version,supportsScopeTags

$DisplayName = $JSON_Convert.displayName

$JSON_Output = $JSON_Convert | ConvertTo-Json -Depth 5
            
write-host
write-host "Device Configuration Policy '$DisplayName' Found..." -ForegroundColor Yellow
write-host
$JSON_Output
write-host
Write-Host "Adding Device Configuration Policy '$DisplayName'" -ForegroundColor Yellow
$CreateResult = Add-DeviceConfigurationPolicy -JSON $JSON_Output
Write-Host "Device Configuration Policy created as" $CreateResult.id
write-host "Adding Assignments to Device Configuration policy '$DisplayName'" -ForegroundColor Yellow
$Assign = Add-DeviceConfigurationPolicyAssignment -ConfigurationPolicyId $CreateResult.id -TargetGroupId "adadadad-808e-44e2-905a-0b7873a8a531"


####################################################
#AzureAd_AllowPasswordreset.json#
####################################################

$ImportPath = "$jsonpath\AzureAd_AllowPasswordreset.json"

# Replacing quotes for Test-Path
$ImportPath = $ImportPath.replace('"','')

if(!(Test-Path "$ImportPath")){

Write-Host "Import Path for JSON file doesn't exist..." -ForegroundColor Red
Write-Host "Script can't continue..." -ForegroundColor Red
Write-Host
break

}

$JSON_Data = gc "$ImportPath"

# Excluding entries that are not required - id,createdDateTime,lastModifiedDateTime,version
$JSON_Convert = $JSON_Data | ConvertFrom-Json | Select-Object -Property * -ExcludeProperty id,createdDateTime,lastModifiedDateTime,version,supportsScopeTags

$DisplayName = $JSON_Convert.displayName

$JSON_Output = $JSON_Convert | ConvertTo-Json -Depth 5
            
write-host
write-host "Device Configuration Policy '$DisplayName' Found..." -ForegroundColor Yellow
write-host
$JSON_Output
write-host
Write-Host "Adding Device Configuration Policy '$DisplayName'" -ForegroundColor Yellow
$CreateResult = Add-DeviceConfigurationPolicy -JSON $JSON_Output
Write-Host "Device Configuration Policy created as" $CreateResult.id
write-host "Adding Assignments to Device Configuration policy '$DisplayName'" -ForegroundColor Yellow
$Assign = Add-DeviceConfigurationPolicyAssignment -ConfigurationPolicyId $CreateResult.id -TargetGroupId "adadadad-808e-44e2-905a-0b7873a8a531"

####################################################
#Windows10_ChromeSettings.json
#
####################################################

$ImportPath = "$jsonpath\Windows10_ChromeSettings.json"

# Replacing quotes for Test-Path
$ImportPath = $ImportPath.replace('"','')

if(!(Test-Path "$ImportPath")){

Write-Host "Import Path for JSON file doesn't exist..." -ForegroundColor Red
Write-Host "Script can't continue..." -ForegroundColor Red
Write-Host
break

}

$JSON_Data = gc "$ImportPath"

# Excluding entries that are not required - id,createdDateTime,lastModifiedDateTime,version
$JSON_Convert = $JSON_Data | ConvertFrom-Json | Select-Object -Property * -ExcludeProperty id,createdDateTime,lastModifiedDateTime,version,supportsScopeTags

$DisplayName = $JSON_Convert.displayName

$JSON_Output = $JSON_Convert | ConvertTo-Json -Depth 5
            
write-host
write-host "Device Configuration Policy '$DisplayName' Found..." -ForegroundColor Yellow
write-host
$JSON_Output
write-host
Write-Host "Adding Device Configuration Policy '$DisplayName'" -ForegroundColor Yellow
$CreateResult = Add-DeviceConfigurationPolicy -JSON $JSON_Output
Write-Host "Device Configuration Policy created as" $CreateResult.id
write-host "Adding Assignments to Device Configuration policy '$DisplayName'" -ForegroundColor Yellow
$Assign = Add-DeviceConfigurationPolicyAssignment -ConfigurationPolicyId $CreateResult.id -TargetGroupId "adadadad-808e-44e2-905a-0b7873a8a531"




####################################################
#Windows10_DisableInternetExplorer.json
#
####################################################

$ImportPath = "$jsonpath\Windows10_DisableInternetExplorer.json"

# Replacing quotes for Test-Path
$ImportPath = $ImportPath.replace('"','')

if(!(Test-Path "$ImportPath")){

Write-Host "Import Path for JSON file doesn't exist..." -ForegroundColor Red
Write-Host "Script can't continue..." -ForegroundColor Red
Write-Host
break

}

$JSON_Data = gc "$ImportPath"

# Excluding entries that are not required - id,createdDateTime,lastModifiedDateTime,version
$JSON_Convert = $JSON_Data | ConvertFrom-Json | Select-Object -Property * -ExcludeProperty id,createdDateTime,lastModifiedDateTime,version,supportsScopeTags

$DisplayName = $JSON_Convert.displayName

$JSON_Output = $JSON_Convert | ConvertTo-Json -Depth 5
            
write-host
write-host "Device Configuration Policy '$DisplayName' Found..." -ForegroundColor Yellow
write-host
$JSON_Output
write-host
Write-Host "Adding Device Configuration Policy '$DisplayName'" -ForegroundColor Yellow
$CreateResult = Add-DeviceConfigurationPolicy -JSON $JSON_Output
Write-Host "Device Configuration Policy created as" $CreateResult.id
write-host "Adding Assignments to Device Configuration policy '$DisplayName'" -ForegroundColor Yellow
$Assign = Add-DeviceConfigurationPolicyAssignment -ConfigurationPolicyId $CreateResult.id -TargetGroupId "adadadad-808e-44e2-905a-0b7873a8a531"



















































