function import-ADMX
{
	
	Param (
		
		[Parameter(Mandatory = $true)]
		[string]$ImportPath
		
	)
	
####################################################

#$authResult = Get-MsalToken -ClientId 'd1ddf0e4-d672-4dae-b554-9d5bdfd93547' -Scopes 'https://graph.microsoft.com/.default'
#$headers1b = @{
#            'Content-Type'='application/json'
#            'Authorization'="Bearer " + $authResult.AccessToken
#            'ExpiresOn'=$authResult.ExpiresOn
#            }

$URL = "https://graph.microsoft.com/v1.0/organization"
$tenant = (Invoke-RestMethod -Headers $headers1b -Uri $URL -Method GET).value
$tenantid = $tenant.id

####################################################
# Change the tenant id 
####################################################

$Tenantidgoed  = "`"$tenantid`""
$contentnieuw =  "`"value`":  $Tenantidgoed,"
$file = "$admxpath\Windows10_Onedrive\_OneDrive_Silently move Windows known folders to OneDrive.json"
$content = get-content $file 
$content[6]  = $contentnieuw
$content | Set-Content $file

	
####################################################
	
Function Create-GroupPolicyConfigurations()
{
		
		[cmdletbinding()]
		param
		(
			$DisplayName
		)
		
		$jsonCode = @"
{
    "description":"",
    "displayName":"$($DisplayName)"
}
"@
		
		$graphApiVersion = "Beta"
		$DCP_resource = "deviceManagement/groupPolicyConfigurations"
		Write-Verbose "Resource: $DCP_resource"
		
		try
		{
			
			$uri = "https://graph.microsoft.com/$graphApiVersion/$($DCP_resource)"
			$responseBody = Invoke-RestMethod -Uri $uri -Headers $headers1b -Method Post -Body $jsonCode -ContentType "application/json"
			
			
		}
		
		catch
		{
			
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
		$responseBody.id
	}
	
		
####################################################
Function Create-GroupPolicyConfigurationsDefinitionValues()

{
 
		
		[cmdletbinding()]
		Param (
			
			[string]$GroupPolicyConfigurationID,
			$JSON
			
		)
		
		$graphApiVersion = "Beta"
		
		$DCP_resource = "deviceManagement/groupPolicyConfigurations/$($GroupPolicyConfigurationID)/definitionValues"
		write-host $DCP_resource
		try
		{
			if ($JSON -eq "" -or $JSON -eq $null)
			{
				
				write-host "No JSON specified, please specify valid JSON for the Device Configuration Policy..." -f Red
				
			}
			
			else
			{
				
				Test-JSON -JSON $JSON
				
				$uri = "https://graph.microsoft.com/$graphApiVersion/$($DCP_resource)"
				Invoke-RestMethod -Uri $uri -Headers $headers1b -Method Post -Body $JSON -ContentType "application/json"
			}
			
		}
		
		catch
		{
			
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
	
Function Test-JSON()
{
		
	
		param (
			
			$JSON
			
		)
		
		try
		{
			
			$TestJSON = ConvertFrom-Json $JSON -ErrorAction Stop
			$validJson = $true
			
		}
		
		catch
		{
			
			$validJson = $false
			$_.Exception
			
		}
		
		if (!$validJson)
		{
			
			Write-Host "Provided JSON isn't in valid JSON format" -f Red
			break
			
		}
		
	}
	




####################################################
	
	$ImportPath = $ImportPath.replace('"', '')
	
	if (!(Test-Path "$ImportPath"))
	{
		
		Write-Host "Import Path doesn't exist..." -ForegroundColor Red
		Write-Host "Script can't continue..." -ForegroundColor Red
		break
		
	}
	$PolicyName = (Get-Item $ImportPath).Name
	Write-Host "Adding ADMX Configuration Policy '$PolicyName'" -ForegroundColor Yellow
	$GroupPolicyConfigurationID = Create-GroupPolicyConfigurations -DisplayName $PolicyName
	
	$JsonFiles = Get-ChildItem $ImportPath
	
	foreach ($JsonFile in $JsonFiles)
	{
		
		Write-Host "Adding ADMX Configuration setting $($JsonFile.Name)" -ForegroundColor Yellow
		$JSON_Data = Get-Content "$($JsonFile.FullName)"
		
		# Excluding entries that are not required - id,createdDateTime,lastModifiedDateTime,version
		$JSON_Convert = $JSON_Data | ConvertFrom-Json | Select-Object -Property * -ExcludeProperty id, createdDateTime, lastModifiedDateTime, version, supportsScopeTags
		$JSON_Output = $JSON_Convert | ConvertTo-Json -Depth 5
		Create-GroupPolicyConfigurationsDefinitionValues -JSON $JSON_Output -GroupPolicyConfigurationID $GroupPolicyConfigurationID
	}
}

############################################################################

$ImportPath = "$admxpath"
$ImportPath = $ImportPath.replace('"', '')
# If the directory path doesn't exist prompt user to create the directory

if (!(Test-Path "$ImportPath"))
{
	Write-Host "Path '$ImportPath' doesn't exist" -ForegroundColor Yellow
	break
}

Get-ChildItem "$ImportPath" | Where-Object { $_.PSIsContainer -eq $True } | ForEach-Object { import-ADMX $_.FullName }
