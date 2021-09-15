

####################################################
#
#$authResult = Get-MsalToken -ClientId 'd1ddf0e4-d672-4dae-b554-9d5bdfd93547' -Scopes 'https://graph.microsoft.com/.default'
#$headers1b = @{
#            'Content-Type'='application/json'
##            'Authorization'="Bearer " + $authResult.AccessToken
#            'ExpiresOn'=$authResult.ExpiresOn
#            }

####################################################

Function Add-DeviceManagementScript() {

    [cmdletbinding()]
    Param (
        # Path or URL to Powershell-script to add to Intune
        [Parameter(Mandatory = $true)]
        [string]$File,
        # PowerShell description in Intune
        [Parameter(Mandatory = $false)]
        [string]$Description,
        # Set to true if it is a URL
        [Parameter(Mandatory = $false)]
        [switch][bool]$URL = $false
    )
    if ($URL -eq $true) {
        $FileName = $File -split "/"
        $FileName = $FileName[-1]
        $OutFile = "$env:TEMP\$FileName"
        try {
            Invoke-WebRequest -Uri $File -UseBasicParsing -OutFile $OutFile
        }
        catch {
            Write-Host "Could not download file from URL: $File" -ForegroundColor Red
            break
        }
        $File = $OutFile
        if (!(Test-Path $File)) {
            Write-Host "$File could not be located." -ForegroundColor Red
            break
        }
    }
    elseif ($URL -eq $false) {
        if (!(Test-Path $File)) {
            Write-Host "$File could not be located." -ForegroundColor Red
            break
        }
        $FileName = Get-Item $File | Select-Object -ExpandProperty Name
    }
    $B64File = [System.Convert]::ToBase64String([System.IO.File]::ReadAllBytes("$File"));

    if ($URL -eq $true) {
        Remove-Item $File -Force
    }

    $JSON = @"
{
    "@odata.type": "#microsoft.graph.deviceManagementScript",
    "displayName": "$FileName",
    "description": "$Description",
    "runSchedule": {
    "@odata.type": "microsoft.graph.runSchedule"
},
    "scriptContent": "$B64File",
    "runAsAccount": "system",
    "enforceSignatureCheck": "false",
    "fileName": "$FileName"
}
"@

    $graphApiVersion = "Beta"
    $DMS_resource = "deviceManagement/deviceManagementScripts"
    Write-Verbose "Resource: $DMS_resource"

    try {
        $uri = "https://graph.microsoft.com/$graphApiVersion/$DMS_resource"
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

Function Add-DeviceManagementScriptAssignment() {


    [cmdletbinding()]

    param
    (
        $ScriptId,
        $TargetGroupId
    )

    $graphApiVersion = "Beta"
    $Resource = "deviceManagement/deviceManagementScripts/$ScriptId/assign"

    try {

        if (!$ScriptId) {

            write-host "No Script Policy Id specified, specify a valid Script Policy Id" -f Red
            break

        }

        if (!$TargetGroupId) {

            write-host "No Target Group Id specified, specify a valid Target Group Id" -f Red
            break

        }

        $JSON = @"
{
    "deviceManagementScriptGroupAssignments":  [
        {
            "@odata.type":  "#microsoft.graph.deviceManagementScriptGroupAssignment",
            "targetGroupId": "$TargetGroupId",
            "id": "$ScriptId"
        }
    ]
}
"@

        $uri = "https://graph.microsoft.com/$graphApiVersion/$Resource"
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

Function Get-AADGroup() {



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

        if ($id) {

            $uri = "https://graph.microsoft.com/$graphApiVersion/$($Group_resource)?`$filter=id eq '$id'"
            (Invoke-RestMethod -Uri $uri -Headers $headers1b -Method Get).Value

        }

        elseif ($GroupName -eq "" -or $GroupName -eq $null) {

            $uri = "https://graph.microsoft.com/$graphApiVersion/$($Group_resource)"
            (Invoke-RestMethod -Uri $uri -Headers $headers1b -Method Get).Value

        }

        else {

            if (!$Members) {

                $uri = "https://graph.microsoft.com/$graphApiVersion/$($Group_resource)?`$filter=displayname eq '$GroupName'"
                (Invoke-RestMethod -Uri $uri -Headers $headers1b -Method Get).Value

            }

            elseif ($Members) {

                $uri = "https://graph.microsoft.com/$graphApiVersion/$($Group_resource)?`$filter=displayname eq '$GroupName'"
                $Group = (Invoke-RestMethod -Uri $uri -Headers $headers1b -Method Get).Value

                if ($Group) {

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



####################################################
$ImportPath = "$Powershellscripts\Windows10_Hardening.ps1"


$Create_Local_Script = Add-DeviceManagementScript -File $importpath -Description "Windows10_Hardening" 

Write-Host "Device Management Script created as" $Create_Local_Script.id
write-host
write-host "Assigning Device Management Script to AAD Group '$AADGroup'" -f Cyan

$Assign_Local_Script = Add-DeviceManagementScriptAssignment -ScriptId $Create_Local_Script.id -TargetGroupId "adadadad-808e-44e2-905a-0b7873a8a531"

Write-Host "Assigned '$AADGroup' to $($Create_Local_Script.displayName)/$($Create_Local_Script.id)"
Write-Host

####################################################


$ImportPath = "$Powershellscripts\Windows10_ChangePublicDesktopPermissions.ps1"


$Create_Local_Script = Add-DeviceManagementScript -File $importpath -Description "Windows10_ChangePublicDesktopPermissions" 

Write-Host "Device Management Script created as" $Create_Local_Script.id
write-host
write-host "Assigning Device Management Script to AAD Group '$AADGroup'" -f Cyan

$Assign_Local_Script = Add-DeviceManagementScriptAssignment -ScriptId $Create_Local_Script.id -TargetGroupId "adadadad-808e-44e2-905a-0b7873a8a531"

Write-Host "Assigned '$AADGroup' to $($Create_Local_Script.displayName)/$($Create_Local_Script.id)"
Write-Host

####################################################

####################################################


$ImportPath = "$Powershellscripts\Windows10_Hiberboot.ps1"


$Create_Local_Script = Add-DeviceManagementScript -File $importpath -Description "Windows10_Hiberboot" 

Write-Host "Device Management Script created as" $Create_Local_Script.id
write-host
write-host "Assigning Device Management Script to AAD Group '$AADGroup'" -f Cyan

$Assign_Local_Script = Add-DeviceManagementScriptAssignment -ScriptId $Create_Local_Script.id -TargetGroupId "adadadad-808e-44e2-905a-0b7873a8a531"

Write-Host "Assigned '$AADGroup' to $($Create_Local_Script.displayName)/$($Create_Local_Script.id)"
Write-Host


####################################################

$ImportPath = "$Powershellscripts\Windows10_TimeService.ps1"


$Create_Local_Script = Add-DeviceManagementScript -File $importpath -Description "Windows10_TimeService" 

Write-Host "Device Management Script created as" $Create_Local_Script.id
write-host
write-host "Assigning Device Management Script to AAD Group '$AADGroup'" -f Cyan

$Assign_Local_Script = Add-DeviceManagementScriptAssignment -ScriptId $Create_Local_Script.id -TargetGroupId "adadadad-808e-44e2-905a-0b7873a8a531"

Write-Host "Assigned '$AADGroup' to $($Create_Local_Script.displayName)/$($Create_Local_Script.id)"
Write-Host
