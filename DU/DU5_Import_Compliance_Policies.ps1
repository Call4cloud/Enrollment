
#################################################
#Token opvragen	en header aanmaken       	#
#################################################

#$authResult = Get-MsalToken -ClientId 'd1ddf0e4-d672-4dae-b554-9d5bdfd93547' -Scopes 'https://graph.microsoft.com/.default'
#$headers1b = @{
 #           'Content-Type'='application/json'
 #           'Authorization'="Bearer " + $authResult.AccessToken
 #           'ExpiresOn'=$authResult.ExpiresOn
#            }

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

Function Add-DeviceCompliancePolicy(){

[cmdletbinding()]

param
(
    $JSON
)

$graphApiVersion = "Beta"
$Resource = "deviceManagement/deviceCompliancePolicies"

$uri = "https://graph.microsoft.com/$graphApiVersion/$($Resource)"
Invoke-RestMethod -Uri $uri -Headers $headers1b -Method Post -Body $JSON -ContentType "application/json"


}

####################################################

Function Add-DeviceCompliancePolicyAssignment(){


[cmdletbinding()]

param
(
    $CompliancePolicyId,
    $TargetGroupId
)

$graphApiVersion = "v1.0"
$Resource = "deviceManagement/deviceCompliancePolicies/$CompliancePolicyId/assign"
    
    try {

        if(!$CompliancePolicyId){

        write-host "No Compliance Policy Id specified, specify a valid Compliance Policy Id" -f Red
        break

        }

  

$JSON = @"

    {
        "assignments": [
        {
            "target":  {
                                           "@odata.type":  "#microsoft.graph.allLicensedUsersAssignmentTarget"
                                       }
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

Function Get-AADGroup(){


[cmdletbinding()]

param
(
    $GroupName,
    $id,
    [switch]$Members
)

# Defining Variables
$graphApiVersion = "v1.0"
$Group_resource = "groups"
    
    try {

        if($id){

        $uri = "https://graph.microsoft.com/$graphApiVersion/$($Group_resource)?`$filter=id eq '$id'"
        (Invoke-RestMethod -Uri $uri -Headers $headers1b -Method Get).Value

        }
        
        elseif($GroupName -eq "" -or $GroupName -eq $null){
        
        $uri = "https://graph.microsoft.com/$graphApiVersion/$($Group_resource)"
        (Invoke-RestMethod -Uri $uri -Headers $headers1b -Method Get).Value
        
        }

        else {
            
            if(!$Members){

            $uri = "https://graph.microsoft.com/$graphApiVersion/$($Group_resource)?`$filter=displayname eq '$GroupName'"
            (Invoke-RestMethod -Uri $uri -Headers $headers1b -Method Get).Value
            
            }
            
            elseif($Members){
            
            $uri = "https://graph.microsoft.com/$graphApiVersion/$($Group_resource)?`$filter=displayname eq '$GroupName'"
            $Group = (Invoke-RestMethod -Uri $uri -Headers $headers1b -Method Get).Value
            
                if($Group){

                $GID = $Group.id

                $Group.displayName
                write-host

                $uri = "https://graph.microsoft.com/$graphApiVersion/$($Group_resource)/$GID/Members"
                (Invoke-RestMethod -Uri $uri -Headers $headers1b -Method Get).Value

                }

            }
        
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

Connect-MSGraph
$id = (New-IntuneNotificationMessageTemplate -brandingOptions includeCompanyLogo -displayName "Notification").id
New-IntuneLocalizedNotificationMessage -notificationMessageTemplateId $id -locale en-us -subject "Compliance Melding" -messageTemplate "Uw device voldoet niet meer aan de eisen die gesteld zijn door uw bedrijf om uw device als veilig te markeren. Uw device zal dus binnen 3 dagen als non-compliant worden aangemerkt, waardoor u niet meer bij uw bestanden kunt komen."

#endregion
connect-msgraph
#ID opvragen van de notificatie template 
$id= get-IntuneNotificationMessageTemplate
$notid = $id.id

####################################################
##Windows compliance require device health inlezen		  #
####################################################
$ImportPath = "$jsonpath\Windows_Compliance_RequireDeviceHealth.json"
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
$JSON_Convert = $JSON_Data | ConvertFrom-Json | Select-Object -Property * -ExcludeProperty id,createdDateTime,lastModifiedDateTime,version
$DisplayName = $JSON_Convert.displayName
$JSON_Output = $JSON_Convert | ConvertTo-Json -Depth 5
# Adding Scheduled Actions Rule to JSON
$scheduledActionsForRule = '"scheduledActionsForRule":[{"ruleName":"PasswordRequired","scheduledActionConfigurations":[{"actionType":"block","gracePeriodHours":72,"notificationTemplateId":"","notificationMessageCCList":[]},{"actionType":"notification","gracePeriodHours":0,"notificationTemplateId":"$notid","notificationMessageCCList":[]},{"actionType":"retire","gracePeriodHours":336,"notificationTemplateId":"","notificationMessageCCList":[]}]}]'        
$JSON_Output = $JSON_Output.trimend("}")
$JSON_Output = $JSON_Output.TrimEnd() + "," + "`r`n"
# Joining the JSON together
$JSON_Output += @"
   "scheduledActionsForRule":[{"ruleName":"PasswordRequired","scheduledActionConfigurations":[{"actionType":"block","gracePeriodHours":120,"notificationTemplateId":"","notificationMessageCCList":[]},{"actionType":"notification","gracePeriodHours":0,"notificationTemplateId":"$notid","notificationMessageCCList":[]},{"actionType":"retire","gracePeriodHours":720,"notificationTemplateId":"","notificationMessageCCList":[]}]}]
}
"@
write-host
write-host "Compliance Policy '$DisplayName' Found..." -ForegroundColor Yellow
write-host
$JSON_Output
write-host
Write-Host "Adding Compliance Policy '$DisplayName'" -ForegroundColor Yellow
$CreateResult_Windows = Add-DeviceCompliancePolicy -JSON $JSON_Output
Write-Host "Compliance Policy created as" $CreateResult_Windows.id
write-host
write-host "Assigning Compliance Policy to AAD Group '$AADGroup'" -f Cyan
$Assign_Windows = Add-DeviceCompliancePolicyAssignment -CompliancePolicyId $CreateResult_Windows.id 
Write-Host "Assigned '$AADGroup' to $($CreateResult_Windows.displayName)/$($CreateResult_Windows.id)"
Write-Host

####################################################
##Windows compliance require device security inlezen		  #
####################################################
$ImportPath = "$jsonpath\WIndows_Compliance_RequireDEviceSecurity.json"
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
$JSON_Convert = $JSON_Data | ConvertFrom-Json | Select-Object -Property * -ExcludeProperty id,createdDateTime,lastModifiedDateTime,version
$DisplayName = $JSON_Convert.displayName
$JSON_Output = $JSON_Convert | ConvertTo-Json -Depth 5
# Adding Scheduled Actions Rule to JSON
$scheduledActionsForRule = '"scheduledActionsForRule":[{"ruleName":"PasswordRequired","scheduledActionConfigurations":[{"actionType":"block","gracePeriodHours":72,"notificationTemplateId":"","notificationMessageCCList":[]},{"actionType":"notification","gracePeriodHours":0,"notificationTemplateId":"$notid","notificationMessageCCList":[]},{"actionType":"retire","gracePeriodHours":336,"notificationTemplateId":"","notificationMessageCCList":[]}]}]'        
$JSON_Output = $JSON_Output.trimend("}")
$JSON_Output = $JSON_Output.TrimEnd() + "," + "`r`n"
# Joining the JSON together
$JSON_Output += @"
   "scheduledActionsForRule":[{"ruleName":"PasswordRequired","scheduledActionConfigurations":[{"actionType":"block","gracePeriodHours":72,"notificationTemplateId":"","notificationMessageCCList":[]},{"actionType":"notification","gracePeriodHours":0,"notificationTemplateId":"$notid","notificationMessageCCList":[]},{"actionType":"retire","gracePeriodHours":720,"notificationTemplateId":"","notificationMessageCCList":[]}]}]
}
"@
write-host
write-host "Compliance Policy '$DisplayName' Found..." -ForegroundColor Yellow
write-host
$JSON_Output
write-host
Write-Host "Adding Compliance Policy '$DisplayName'" -ForegroundColor Yellow
$CreateResult_Windows = Add-DeviceCompliancePolicy -JSON $JSON_Output
Write-Host "Compliance Policy created as" $CreateResult_Windows.id
write-host
write-host "Assigning Compliance Policy to AAD Group '$AADGroup'" -f Cyan
$Assign_Windows = Add-DeviceCompliancePolicyAssignment -CompliancePolicyId $CreateResult_Windows.id 
Write-Host "Assigned '$AADGroup' to $($CreateResult_Windows.displayName)/$($CreateResult_Windows.id)"
Write-Host


####################################################
##Windows compliance require os version		  #
####################################################
$ImportPath = "$jsonpath\WIndows_Compliance_RequireOsversion.json"
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
$JSON_Convert = $JSON_Data | ConvertFrom-Json | Select-Object -Property * -ExcludeProperty id,createdDateTime,lastModifiedDateTime,version
$DisplayName = $JSON_Convert.displayName
$JSON_Output = $JSON_Convert | ConvertTo-Json -Depth 5
# Adding Scheduled Actions Rule to JSON
$scheduledActionsForRule = '"scheduledActionsForRule":[{"ruleName":"PasswordRequired","scheduledActionConfigurations":[{"actionType":"block","gracePeriodHours":72,"notificationTemplateId":"","notificationMessageCCList":[]},{"actionType":"notification","gracePeriodHours":0,"notificationTemplateId":"$notid","notificationMessageCCList":[]},{"actionType":"retire","gracePeriodHours":336,"notificationTemplateId":"","notificationMessageCCList":[]}]}]'        
$JSON_Output = $JSON_Output.trimend("}")
$JSON_Output = $JSON_Output.TrimEnd() + "," + "`r`n"
# Joining the JSON together
$JSON_Output += @"
   "scheduledActionsForRule":[{"ruleName":"PasswordRequired","scheduledActionConfigurations":[{"actionType":"block","gracePeriodHours":72,"notificationTemplateId":"","notificationMessageCCList":[]},{"actionType":"notification","gracePeriodHours":0,"notificationTemplateId":"$notid","notificationMessageCCList":[]},{"actionType":"retire","gracePeriodHours":720,"notificationTemplateId":"","notificationMessageCCList":[]}]}]
}
"@
write-host
write-host "Compliance Policy '$DisplayName' Found..." -ForegroundColor Yellow
write-host
$JSON_Output
write-host
Write-Host "Adding Compliance Policy '$DisplayName'" -ForegroundColor Yellow
$CreateResult_Windows = Add-DeviceCompliancePolicy -JSON $JSON_Output
Write-Host "Compliance Policy created as" $CreateResult_Windows.id
write-host
write-host "Assigning Compliance Policy to AAD Group '$AADGroup'" -f Cyan
$Assign_Windows = Add-DeviceCompliancePolicyAssignment -CompliancePolicyId $CreateResult_Windows.id 
Write-Host "Assigned '$AADGroup' to $($CreateResult_Windows.displayName)/$($CreateResult_Windows.id)"
Write-Host
####################################################
##mac compliance inlezen		  #
####################################################
$ImportPath = "$jsonpath\Mac_Compliance.json"
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
$JSON_Convert = $JSON_Data | ConvertFrom-Json | Select-Object -Property * -ExcludeProperty id,createdDateTime,lastModifiedDateTime,version
$DisplayName = $JSON_Convert.displayName
$JSON_Output = $JSON_Convert | ConvertTo-Json -Depth 5
# Adding Scheduled Actions Rule to JSON
$JSON_Output = $JSON_Output.trimend("}")
$JSON_Output = $JSON_Output.TrimEnd() + "," + "`r`n"
# Joining the JSON together
$JSON_Output += @"
   "scheduledActionsForRule":[{"ruleName":"PasswordRequired","scheduledActionConfigurations":[{"actionType":"block","gracePeriodHours":72,"notificationTemplateId":"","notificationMessageCCList":[]},{"actionType":"notification","gracePeriodHours":0,"notificationTemplateId":"$notid","notificationMessageCCList":[]},{"actionType":"retire","gracePeriodHours":720,"notificationTemplateId":"","notificationMessageCCList":[]}]}]
}
"@
write-host "Compliance Policy '$DisplayName' Found..." -ForegroundColor Yellow
write-host
$JSON_Output
write-host
Write-Host "Adding Compliance Policy '$DisplayName'" -ForegroundColor Yellow
$CreateResult_Windows = Add-DeviceCompliancePolicy -JSON $JSON_Output
Write-Host "Compliance Policy created as" $CreateResult_Windows.id
write-host
write-host "Assigning Compliance Policy to AAD Group '$AADGroup'" -f Cyan
$Assign_Windows = Add-DeviceCompliancePolicyAssignment -CompliancePolicyId $CreateResult_Windows.id 
Write-Host "Assigned '$AADGroup' to $($CreateResult_Windows.displayName)/$($CreateResult_Windows.id)"
Write-Host

####################################################
##Android compliance require device health inlezen		  #
####################################################
$ImportPath = "$jsonpath\Android_compliance_Requiredevicehealth.json"
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
$JSON_Convert = $JSON_Data | ConvertFrom-Json | Select-Object -Property * -ExcludeProperty id,createdDateTime,lastModifiedDateTime,version
$DisplayName = $JSON_Convert.displayName
$JSON_Output = $JSON_Convert | ConvertTo-Json -Depth 5
# Adding Scheduled Actions Rule to JSON
$JSON_Output = $JSON_Output.trimend("}")
$JSON_Output = $JSON_Output.TrimEnd() + "," + "`r`n"
# Joining the JSON together
$JSON_Output += @"
   "scheduledActionsForRule":[{"ruleName":"PasswordRequired","scheduledActionConfigurations":[{"actionType":"block","gracePeriodHours":72,"notificationTemplateId":"","notificationMessageCCList":[]},{"actionType":"notification","gracePeriodHours":0,"notificationTemplateId":"$notid","notificationMessageCCList":[]},{"actionType":"pushNotification","gracePeriodHours":0,"notificationTemplateId":"00000000-0000-0000-0000-000000000000","notificationMessageCCList":[]},{"actionType":"retire","gracePeriodHours":720,"notificationTemplateId":"","notificationMessageCCList":[]}]}]
}
"@    
write-host
write-host "Compliance Policy '$DisplayName' Found..." -ForegroundColor Yellow
write-host
$JSON_Output
write-host
Write-Host "Adding Compliance Policy '$DisplayName'" -ForegroundColor Yellow
$CreateResult_Windows = Add-DeviceCompliancePolicy -JSON $JSON_Output
Write-Host "Compliance Policy created as" $CreateResult_Windows.id
write-host
write-host "Assigning Compliance Policy to AAD Group '$AADGroup'" -f Cyan
$Assign_Windows = Add-DeviceCompliancePolicyAssignment -CompliancePolicyId $CreateResult_Windows.id 
Write-Host "Assigned '$AADGroup' to $($CreateResult_Windows.displayName)/$($CreateResult_Windows.id)"
Write-Host


####################################################
##Android compliance require os version inlezen		  #
####################################################
$ImportPath = "$jsonpath\Android_compliance_RequireOSVersion.json"
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
$JSON_Convert = $JSON_Data | ConvertFrom-Json | Select-Object -Property * -ExcludeProperty id,createdDateTime,lastModifiedDateTime,version
$DisplayName = $JSON_Convert.displayName
$JSON_Output = $JSON_Convert | ConvertTo-Json -Depth 5
# Adding Scheduled Actions Rule to JSON
$JSON_Output = $JSON_Output.trimend("}")
$JSON_Output = $JSON_Output.TrimEnd() + "," + "`r`n"
# Joining the JSON together
$JSON_Output += @"
   "scheduledActionsForRule":[{"ruleName":"PasswordRequired","scheduledActionConfigurations":[{"actionType":"block","gracePeriodHours":72,"notificationTemplateId":"","notificationMessageCCList":[]},{"actionType":"notification","gracePeriodHours":0,"notificationTemplateId":"$notid","notificationMessageCCList":[]},{"actionType":"pushNotification","gracePeriodHours":0,"notificationTemplateId":"00000000-0000-0000-0000-000000000000","notificationMessageCCList":[]},{"actionType":"retire","gracePeriodHours":720,"notificationTemplateId":"","notificationMessageCCList":[]}]}]
}
"@    
write-host
write-host "Compliance Policy '$DisplayName' Found..." -ForegroundColor Yellow
write-host
$JSON_Output
write-host
Write-Host "Adding Compliance Policy '$DisplayName'" -ForegroundColor Yellow
$CreateResult_Windows = Add-DeviceCompliancePolicy -JSON $JSON_Output
Write-Host "Compliance Policy created as" $CreateResult_Windows.id
write-host
write-host "Assigning Compliance Policy to AAD Group '$AADGroup'" -f Cyan
$Assign_Windows = Add-DeviceCompliancePolicyAssignment -CompliancePolicyId $CreateResult_Windows.id 
Write-Host "Assigned '$AADGroup' to $($CreateResult_Windows.displayName)/$($CreateResult_Windows.id)"
Write-Host

####################################################
##Android compliance require device security		  #
####################################################
$ImportPath = "$jsonpath\Android_compliance_Requiredevicesecurity.json"
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
$JSON_Convert = $JSON_Data | ConvertFrom-Json | Select-Object -Property * -ExcludeProperty id,createdDateTime,lastModifiedDateTime,version
$DisplayName = $JSON_Convert.displayName
$JSON_Output = $JSON_Convert | ConvertTo-Json -Depth 5
# Adding Scheduled Actions Rule to JSON
$JSON_Output = $JSON_Output.trimend("}")
$JSON_Output = $JSON_Output.TrimEnd() + "," + "`r`n"
# Joining the JSON together
$JSON_Output += @"
   "scheduledActionsForRule":[{"ruleName":"PasswordRequired","scheduledActionConfigurations":[{"actionType":"block","gracePeriodHours":72,"notificationTemplateId":"","notificationMessageCCList":[]},{"actionType":"notification","gracePeriodHours":0,"notificationTemplateId":"$notid","notificationMessageCCList":[]},{"actionType":"pushNotification","gracePeriodHours":0,"notificationTemplateId":"00000000-0000-0000-0000-000000000000","notificationMessageCCList":[]},{"actionType":"retire","gracePeriodHours":720,"notificationTemplateId":"","notificationMessageCCList":[]}]}]
}
"@    
write-host
write-host "Compliance Policy '$DisplayName' Found..." -ForegroundColor Yellow
write-host
$JSON_Output
write-host
Write-Host "Adding Compliance Policy '$DisplayName'" -ForegroundColor Yellow
$CreateResult_Windows = Add-DeviceCompliancePolicy -JSON $JSON_Output
Write-Host "Compliance Policy created as" $CreateResult_Windows.id
write-host
write-host "Assigning Compliance Policy to AAD Group '$AADGroup'" -f Cyan
$Assign_Windows = Add-DeviceCompliancePolicyAssignment -CompliancePolicyId $CreateResult_Windows.id 
Write-Host "Assigned '$AADGroup' to $($CreateResult_Windows.displayName)/$($CreateResult_Windows.id)"
Write-Host
####################################################
##IOS compliance require device security inlezen		  #
####################################################
$ImportPath = "$jsonpath\Ios_Compliance_RequireDeviceSecurity.json"
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
$JSON_Convert = $JSON_Data | ConvertFrom-Json | Select-Object -Property * -ExcludeProperty id,createdDateTime,lastModifiedDateTime,version
$DisplayName = $JSON_Convert.displayName
$JSON_Output = $JSON_Convert | ConvertTo-Json -Depth 5
# Adding Scheduled Actions Rule to JSON
$JSON_Output = $JSON_Output.trimend("}")
$JSON_Output = $JSON_Output.TrimEnd() + "," + "`r`n"
$JSON_Output += @"
   "scheduledActionsForRule":[{"ruleName":"PasswordRequired","scheduledActionConfigurations":[{"actionType":"block","gracePeriodHours":72,"notificationTemplateId":"","notificationMessageCCList":[]},{"actionType":"notification","gracePeriodHours":0,"notificationTemplateId":"$notid","notificationMessageCCList":[]},{"actionType":"pushNotification","gracePeriodHours":0,"notificationTemplateId":"00000000-0000-0000-0000-000000000000","notificationMessageCCList":[]},{"actionType":"retire","gracePeriodHours":720,"notificationTemplateId":"","notificationMessageCCList":[]}]}]
}
"@   
write-host
write-host "Compliance Policy '$DisplayName' Found..." -ForegroundColor Yellow
write-host
$JSON_Output
write-host
Write-Host "Adding Compliance Policy '$DisplayName'" -ForegroundColor Yellow
$CreateResult_Windows = Add-DeviceCompliancePolicy -JSON $JSON_Output
Write-Host "Compliance Policy created as" $CreateResult_Windows.id
write-host
write-host "Assigning Compliance Policy to AAD Group '$AADGroup'" -f Cyan
$Assign_Windows = Add-DeviceCompliancePolicyAssignment -CompliancePolicyId $CreateResult_Windows.id 
Write-Host "Assigned '$AADGroup' to $($CreateResult_Windows.displayName)/$($CreateResult_Windows.id)"
Write-Host


####################################################
##IOS compliance require os version inlezen		  #
####################################################
$ImportPath = "$jsonpath\Ios_Compliance_RequireOSVersion.json"
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
$JSON_Convert = $JSON_Data | ConvertFrom-Json | Select-Object -Property * -ExcludeProperty id,createdDateTime,lastModifiedDateTime,version
$DisplayName = $JSON_Convert.displayName
$JSON_Output = $JSON_Convert | ConvertTo-Json -Depth 5
# Adding Scheduled Actions Rule to JSON
$JSON_Output = $JSON_Output.trimend("}")
$JSON_Output = $JSON_Output.TrimEnd() + "," + "`r`n"
$JSON_Output += @"
   "scheduledActionsForRule":[{"ruleName":"PasswordRequired","scheduledActionConfigurations":[{"actionType":"block","gracePeriodHours":72,"notificationTemplateId":"","notificationMessageCCList":[]},{"actionType":"notification","gracePeriodHours":0,"notificationTemplateId":"$notid","notificationMessageCCList":[]},{"actionType":"pushNotification","gracePeriodHours":0,"notificationTemplateId":"00000000-0000-0000-0000-000000000000","notificationMessageCCList":[]},{"actionType":"retire","gracePeriodHours":720,"notificationTemplateId":"","notificationMessageCCList":[]}]}]
}
"@   
write-host
write-host "Compliance Policy '$DisplayName' Found..." -ForegroundColor Yellow
write-host
$JSON_Output
write-host
Write-Host "Adding Compliance Policy '$DisplayName'" -ForegroundColor Yellow
$CreateResult_Windows = Add-DeviceCompliancePolicy -JSON $JSON_Output
Write-Host "Compliance Policy created as" $CreateResult_Windows.id
write-host
write-host "Assigning Compliance Policy to AAD Group '$AADGroup'" -f Cyan
$Assign_Windows = Add-DeviceCompliancePolicyAssignment -CompliancePolicyId $CreateResult_Windows.id 
Write-Host "Assigned '$AADGroup' to $($CreateResult_Windows.displayName)/$($CreateResult_Windows.id)"
Write-Host


####################################################
##IOS compliance device health inlezen		  #
####################################################
$ImportPath = "$jsonpath\Ios_Compliance_Requiredevicehealth.json"
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
$JSON_Convert = $JSON_Data | ConvertFrom-Json | Select-Object -Property * -ExcludeProperty id,createdDateTime,lastModifiedDateTime,version
$DisplayName = $JSON_Convert.displayName
$JSON_Output = $JSON_Convert | ConvertTo-Json -Depth 5
# Adding Scheduled Actions Rule to JSON
$JSON_Output = $JSON_Output.trimend("}")
$JSON_Output = $JSON_Output.TrimEnd() + "," + "`r`n"
$JSON_Output += @"
   "scheduledActionsForRule":[{"ruleName":"PasswordRequired","scheduledActionConfigurations":[{"actionType":"block","gracePeriodHours":72,"notificationTemplateId":"","notificationMessageCCList":[]},{"actionType":"notification","gracePeriodHours":0,"notificationTemplateId":"$notid","notificationMessageCCList":[]},{"actionType":"pushNotification","gracePeriodHours":0,"notificationTemplateId":"00000000-0000-0000-0000-000000000000","notificationMessageCCList":[]},{"actionType":"retire","gracePeriodHours":720,"notificationTemplateId":"","notificationMessageCCList":[]}]}]
}
"@   
write-host
write-host "Compliance Policy '$DisplayName' Found..." -ForegroundColor Yellow
write-host
$JSON_Output
write-host
Write-Host "Adding Compliance Policy '$DisplayName'" -ForegroundColor Yellow
$CreateResult_Windows = Add-DeviceCompliancePolicy -JSON $JSON_Output
Write-Host "Compliance Policy created as" $CreateResult_Windows.id
write-host
write-host "Assigning Compliance Policy to AAD Group '$AADGroup'" -f Cyan
$Assign_Windows = Add-DeviceCompliancePolicyAssignment -CompliancePolicyId $CreateResult_Windows.id 
Write-Host "Assigned '$AADGroup' to $($CreateResult_Windows.displayName)/$($CreateResult_Windows.id)"
Write-Host