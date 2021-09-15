

####################################################

#$authResult = Get-MsalToken -ClientId 'd1ddf0e4-d672-4dae-b554-9d5bdfd93547' -Scopes 'https://graph.microsoft.com/.default'
#$headers1b = @{
#            'Content-Type'='application/json'
#            'Authorization'="Bearer " + $authResult.AccessToken
#            'ExpiresOn'=$authResult.ExpiresOn
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

Function Test-AppBundleId(){


param (

$bundleId

)

$graphApiVersion = "Beta"
$Resource = "deviceAppManagement/mobileApps?`$filter=(microsoft.graph.managedApp/appAvailability eq null or microsoft.graph.managedApp/appAvailability eq 'lineOfBusiness' or isAssigned eq true) and (isof('microsoft.graph.iosLobApp') or isof('microsoft.graph.iosStoreApp') or isof('microsoft.graph.iosVppApp') or isof('microsoft.graph.managedIOSStoreApp') or isof('microsoft.graph.managedIOSLobApp'))"

   try {
        
        $uri = "https://graph.microsoft.com/$graphApiVersion/$($Resource)"
        $mobileApps = Invoke-RestMethod -Uri $uri -Headers $headers1b -Method Get
             
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
    Write-Host
    break

    }

    $app = $mobileApps.value | where {$_.bundleId -eq $bundleId}
    
    If($app){
    
        return $app.id

    }
    
    Else{

        return $false

    }
       
}

####################################################

Function Test-AppPackageId(){


param (

$packageId

)

$graphApiVersion = "Beta"
$Resource = "deviceAppManagement/mobileApps?`$filter=(isof('microsoft.graph.androidForWorkApp') or microsoft.graph.androidManagedStoreApp/supportsOemConfig eq false)"

   try {
        
        $uri = "https://graph.microsoft.com/$graphApiVersion/$($Resource)"
        $mobileApps = Invoke-RestMethod -Uri $uri -Headers $headers1b -Method Get
        
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
    Write-Host
    break

    }

    $app = $mobileApps.value | where {$_.packageId -eq $packageId}
    
    If($app){
    
        return $app.id

    }
    
    Else{

        return $false

    }

}

####################################################

Function Add-ManagedAppAppConfigPolicy(){


[cmdletbinding()]

param
(
    $JSON
)

$graphApiVersion = "Beta"
$Resource = "deviceAppManagement/targetedManagedAppConfigurations"
    
    try {

        if($JSON -eq "" -or $JSON -eq $null){

        Write-Host "No JSON specified, please specify valid JSON for the App Configuration Policy..." -f Red

        }

        else {

        Test-JSON -JSON $JSON

        $uri = "https://graph.microsoft.com/$graphApiVersion/$($Resource)"
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
    Write-Host
    break

    }

}

####################################################

Function Add-ManagedDeviceAppConfigPolicy(){


[cmdletbinding()]

param
(
    $JSON
)

$graphApiVersion = "Beta"
$Resource = "deviceAppManagement/mobileAppConfigurations"
    
    try {

        if($JSON -eq "" -or $JSON -eq $null){

        Write-Host "No JSON specified, please specify valid JSON for the App Configuration Policy..." -f Red

        }

        else {

        Test-JSON -JSON $JSON

        $uri = "https://graph.microsoft.com/$graphApiVersion/$($Resource)"
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
    Write-Host
    break

    }

}

####################################################


####################################################

#######################
##teams app config####
#######################

$ImportPath = "$jsonpath\IOS_IntuneMAMUpn_Teams_10-03-2021-16-42-561.json"

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
$JSON_Convert = $JSON_Data | ConvertFrom-Json | Select-Object -Property * -ExcludeProperty id,createdDateTime,lastModifiedDateTime,version,isAssigned,roleScopeTagIds

$DisplayName = $JSON_Convert.displayName

Write-Host
Write-Host "App Configuration Policy '$DisplayName' Found..." -ForegroundColor Yellow


# Check if the JSON is for Managed Apps or Managed Devices
If(($JSON_Convert.'@odata.type' -eq "#microsoft.graph.iosMobileAppConfiguration") -or ($JSON_Convert.'@odata.type' -eq "#microsoft.graph.androidManagedStoreAppConfiguration")){

    Write-Host "App Configuration JSON is for Managed Devices" -ForegroundColor Yellow

    If($JSON_Convert.'@odata.type' -eq "#microsoft.graph.iosMobileAppConfiguration"){

        # Check if the client app is present 
        $targetedMobileApp = Test-AppBundleId -bundleId $JSON_Convert.bundleId
           
        If($targetedMobileApp){

            Write-Host
            Write-Host "Targeted app $($JSON_Convert.bundleId) has already been added from the App Store" -ForegroundColor Yellow
            Write-Host "The App Configuration Policy will be created" -ForegroundColor Yellow
            Write-Host

            # Update the targetedMobileApps GUID if required
            If(!($targetedMobileApp -eq $JSON_Convert.targetedMobileApps)){

                $JSON_Convert.targetedMobileApps.SetValue($targetedMobileApp,0)

            }

            $JSON_Output = $JSON_Convert | ConvertTo-Json -Depth 5
            $JSON_Output
            Write-Host
            Write-Host "Adding App Configuration Policy '$DisplayName'" -ForegroundColor Yellow
            Add-ManagedDeviceAppConfigPolicy -JSON $JSON_Output

        }

        Else
        {

            Write-Host
            Write-Host "Targeted app bundle id '$($JSON_Convert.bundleId)' has not been added from the App Store" -ForegroundColor Red
            Write-Host "The App Configuration Policy can't be created" -ForegroundColor Red

        }


    }

    ElseIf($JSON_Convert.'@odata.type' -eq "#microsoft.graph.androidManagedStoreAppConfiguration"){

        # Check if the client app is present 
        $targetedMobileApp = Test-AppPackageId -packageId $JSON_Convert.packageId
        
        If($targetedMobileApp){

            Write-Host
            Write-Host "Targeted app $($JSON_Convert.packageId) has already been added from Managed Google Play" -ForegroundColor Yellow
            Write-Host "The App Configuration Policy will be created" -ForegroundColor Yellow
            Write-Host
            
            # Update the targetedMobileApps GUID if required           
            If(!($targetedMobileApp -eq $JSON_Convert.targetedMobileApps)){
               
                $JSON_Convert.targetedMobileApps.SetValue($targetedMobileApp,0)

            }

            $JSON_Output = $JSON_Convert | ConvertTo-Json -Depth 5
            $JSON_Output
            Write-Host   
            Write-Host "Adding App Configuration Policy '$DisplayName'" -ForegroundColor Yellow                                                      
            Add-ManagedDeviceAppConfigPolicy -JSON $JSON_Output

        }

        Else
        {

            Write-Host
            Write-Host "Targeted app package id '$($JSON_Convert.packageId)' has not been added from Managed Google Play" -ForegroundColor Red
            Write-Host "The App Configuration Policy can't be created" -ForegroundColor Red

        }
    
    }

}

Else
{

    Write-Host "App Configuration JSON is for Managed Apps" -ForegroundColor Yellow
    $JSON_Output = $JSON_Convert | ConvertTo-Json -Depth 5
    $JSON_Output
    Write-Host
    Write-Host "Adding App Configuration Policy '$DisplayName'" -ForegroundColor Yellow
    Add-ManagedAppAppConfigPolicy -JSON $JSON_Output   

}
 


#######################
##Outlook app config####
#######################

$ImportPath = "$jsonpath\IOS_IntuneMAMUpn_Outlook_10-03-2021-16-42-531.json"

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
$JSON_Convert = $JSON_Data | ConvertFrom-Json | Select-Object -Property * -ExcludeProperty id,createdDateTime,lastModifiedDateTime,version,isAssigned,roleScopeTagIds

$DisplayName = $JSON_Convert.displayName

Write-Host
Write-Host "App Configuration Policy '$DisplayName' Found..." -ForegroundColor Yellow


# Check if the JSON is for Managed Apps or Managed Devices
If(($JSON_Convert.'@odata.type' -eq "#microsoft.graph.iosMobileAppConfiguration") -or ($JSON_Convert.'@odata.type' -eq "#microsoft.graph.androidManagedStoreAppConfiguration")){

    Write-Host "App Configuration JSON is for Managed Devices" -ForegroundColor Yellow

    If($JSON_Convert.'@odata.type' -eq "#microsoft.graph.iosMobileAppConfiguration"){

        # Check if the client app is present 
        $targetedMobileApp = Test-AppBundleId -bundleId $JSON_Convert.bundleId
           
        If($targetedMobileApp){

            Write-Host
            Write-Host "Targeted app $($JSON_Convert.bundleId) has already been added from the App Store" -ForegroundColor Yellow
            Write-Host "The App Configuration Policy will be created" -ForegroundColor Yellow
            Write-Host

            # Update the targetedMobileApps GUID if required
            If(!($targetedMobileApp -eq $JSON_Convert.targetedMobileApps)){

                $JSON_Convert.targetedMobileApps.SetValue($targetedMobileApp,0)

            }

            $JSON_Output = $JSON_Convert | ConvertTo-Json -Depth 5
            $JSON_Output
            Write-Host
            Write-Host "Adding App Configuration Policy '$DisplayName'" -ForegroundColor Yellow
            Add-ManagedDeviceAppConfigPolicy -JSON $JSON_Output

        }

        Else
        {

            Write-Host
            Write-Host "Targeted app bundle id '$($JSON_Convert.bundleId)' has not been added from the App Store" -ForegroundColor Red
            Write-Host "The App Configuration Policy can't be created" -ForegroundColor Red

        }


    }

    ElseIf($JSON_Convert.'@odata.type' -eq "#microsoft.graph.androidManagedStoreAppConfiguration"){

        # Check if the client app is present 
        $targetedMobileApp = Test-AppPackageId -packageId $JSON_Convert.packageId
        
        If($targetedMobileApp){

            Write-Host
            Write-Host "Targeted app $($JSON_Convert.packageId) has already been added from Managed Google Play" -ForegroundColor Yellow
            Write-Host "The App Configuration Policy will be created" -ForegroundColor Yellow
            Write-Host
            
            # Update the targetedMobileApps GUID if required           
            If(!($targetedMobileApp -eq $JSON_Convert.targetedMobileApps)){
               
                $JSON_Convert.targetedMobileApps.SetValue($targetedMobileApp,0)

            }

            $JSON_Output = $JSON_Convert | ConvertTo-Json -Depth 5
            $JSON_Output
            Write-Host   
            Write-Host "Adding App Configuration Policy '$DisplayName'" -ForegroundColor Yellow                                                      
            Add-ManagedDeviceAppConfigPolicy -JSON $JSON_Output

        }

        Else
        {

            Write-Host
            Write-Host "Targeted app package id '$($JSON_Convert.packageId)' has not been added from Managed Google Play" -ForegroundColor Red
            Write-Host "The App Configuration Policy can't be created" -ForegroundColor Red

        }
    
    }

}

Else
{

    Write-Host "App Configuration JSON is for Managed Apps" -ForegroundColor Yellow
    $JSON_Output = $JSON_Convert | ConvertTo-Json -Depth 5
    $JSON_Output
    Write-Host
    Write-Host "Adding App Configuration Policy '$DisplayName'" -ForegroundColor Yellow
    Add-ManagedAppAppConfigPolicy -JSON $JSON_Output   

}
 


#######################
##Onedrive app config####
#######################

$ImportPath = "$jsonpath\IOS_IntuneMAMUpn_Onedrive_10-03-2021-16-42-521.json"

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
$JSON_Convert = $JSON_Data | ConvertFrom-Json | Select-Object -Property * -ExcludeProperty id,createdDateTime,lastModifiedDateTime,version,isAssigned,roleScopeTagIds

$DisplayName = $JSON_Convert.displayName

Write-Host
Write-Host "App Configuration Policy '$DisplayName' Found..." -ForegroundColor Yellow


# Check if the JSON is for Managed Apps or Managed Devices
If(($JSON_Convert.'@odata.type' -eq "#microsoft.graph.iosMobileAppConfiguration") -or ($JSON_Convert.'@odata.type' -eq "#microsoft.graph.androidManagedStoreAppConfiguration")){

    Write-Host "App Configuration JSON is for Managed Devices" -ForegroundColor Yellow

    If($JSON_Convert.'@odata.type' -eq "#microsoft.graph.iosMobileAppConfiguration"){

        # Check if the client app is present 
        $targetedMobileApp = Test-AppBundleId -bundleId $JSON_Convert.bundleId
           
        If($targetedMobileApp){

            Write-Host
            Write-Host "Targeted app $($JSON_Convert.bundleId) has already been added from the App Store" -ForegroundColor Yellow
            Write-Host "The App Configuration Policy will be created" -ForegroundColor Yellow
            Write-Host

            # Update the targetedMobileApps GUID if required
            If(!($targetedMobileApp -eq $JSON_Convert.targetedMobileApps)){

                $JSON_Convert.targetedMobileApps.SetValue($targetedMobileApp,0)

            }

            $JSON_Output = $JSON_Convert | ConvertTo-Json -Depth 5
            $JSON_Output
            Write-Host
            Write-Host "Adding App Configuration Policy '$DisplayName'" -ForegroundColor Yellow
            Add-ManagedDeviceAppConfigPolicy -JSON $JSON_Output

        }

        Else
        {

            Write-Host
            Write-Host "Targeted app bundle id '$($JSON_Convert.bundleId)' has not been added from the App Store" -ForegroundColor Red
            Write-Host "The App Configuration Policy can't be created" -ForegroundColor Red

        }


    }

    ElseIf($JSON_Convert.'@odata.type' -eq "#microsoft.graph.androidManagedStoreAppConfiguration"){

        # Check if the client app is present 
        $targetedMobileApp = Test-AppPackageId -packageId $JSON_Convert.packageId
        
        If($targetedMobileApp){

            Write-Host
            Write-Host "Targeted app $($JSON_Convert.packageId) has already been added from Managed Google Play" -ForegroundColor Yellow
            Write-Host "The App Configuration Policy will be created" -ForegroundColor Yellow
            Write-Host
            
            # Update the targetedMobileApps GUID if required           
            If(!($targetedMobileApp -eq $JSON_Convert.targetedMobileApps)){
               
                $JSON_Convert.targetedMobileApps.SetValue($targetedMobileApp,0)

            }

            $JSON_Output = $JSON_Convert | ConvertTo-Json -Depth 5
            $JSON_Output
            Write-Host   
            Write-Host "Adding App Configuration Policy '$DisplayName'" -ForegroundColor Yellow                                                      
            Add-ManagedDeviceAppConfigPolicy -JSON $JSON_Output

        }

        Else
        {

            Write-Host
            Write-Host "Targeted app package id '$($JSON_Convert.packageId)' has not been added from Managed Google Play" -ForegroundColor Red
            Write-Host "The App Configuration Policy can't be created" -ForegroundColor Red

        }
    
    }

}

Else
{

    Write-Host "App Configuration JSON is for Managed Apps" -ForegroundColor Yellow
    $JSON_Output = $JSON_Convert | ConvertTo-Json -Depth 5
    $JSON_Output
    Write-Host
    Write-Host "Adding App Configuration Policy '$DisplayName'" -ForegroundColor Yellow
    Add-ManagedAppAppConfigPolicy -JSON $JSON_Output   

}
 



#######################
##Excel app config####
#######################

$ImportPath = "$jsonpath\IOS_IntuneMAMUpn_Excel_11-03-2021-9-51-461.json"

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
$JSON_Convert = $JSON_Data | ConvertFrom-Json | Select-Object -Property * -ExcludeProperty id,createdDateTime,lastModifiedDateTime,version,isAssigned,roleScopeTagIds

$DisplayName = $JSON_Convert.displayName

Write-Host
Write-Host "App Configuration Policy '$DisplayName' Found..." -ForegroundColor Yellow


# Check if the JSON is for Managed Apps or Managed Devices
If(($JSON_Convert.'@odata.type' -eq "#microsoft.graph.iosMobileAppConfiguration") -or ($JSON_Convert.'@odata.type' -eq "#microsoft.graph.androidManagedStoreAppConfiguration")){

    Write-Host "App Configuration JSON is for Managed Devices" -ForegroundColor Yellow

    If($JSON_Convert.'@odata.type' -eq "#microsoft.graph.iosMobileAppConfiguration"){

        # Check if the client app is present 
        $targetedMobileApp = Test-AppBundleId -bundleId $JSON_Convert.bundleId
           
        If($targetedMobileApp){

            Write-Host
            Write-Host "Targeted app $($JSON_Convert.bundleId) has already been added from the App Store" -ForegroundColor Yellow
            Write-Host "The App Configuration Policy will be created" -ForegroundColor Yellow
            Write-Host

            # Update the targetedMobileApps GUID if required
            If(!($targetedMobileApp -eq $JSON_Convert.targetedMobileApps)){

                $JSON_Convert.targetedMobileApps.SetValue($targetedMobileApp,0)

            }

            $JSON_Output = $JSON_Convert | ConvertTo-Json -Depth 5
            $JSON_Output
            Write-Host
            Write-Host "Adding App Configuration Policy '$DisplayName'" -ForegroundColor Yellow
            Add-ManagedDeviceAppConfigPolicy -JSON $JSON_Output

        }

        Else
        {

            Write-Host
            Write-Host "Targeted app bundle id '$($JSON_Convert.bundleId)' has not been added from the App Store" -ForegroundColor Red
            Write-Host "The App Configuration Policy can't be created" -ForegroundColor Red

        }


    }

    ElseIf($JSON_Convert.'@odata.type' -eq "#microsoft.graph.androidManagedStoreAppConfiguration"){

        # Check if the client app is present 
        $targetedMobileApp = Test-AppPackageId -packageId $JSON_Convert.packageId
        
        If($targetedMobileApp){

            Write-Host
            Write-Host "Targeted app $($JSON_Convert.packageId) has already been added from Managed Google Play" -ForegroundColor Yellow
            Write-Host "The App Configuration Policy will be created" -ForegroundColor Yellow
            Write-Host
            
            # Update the targetedMobileApps GUID if required           
            If(!($targetedMobileApp -eq $JSON_Convert.targetedMobileApps)){
               
                $JSON_Convert.targetedMobileApps.SetValue($targetedMobileApp,0)

            }

            $JSON_Output = $JSON_Convert | ConvertTo-Json -Depth 5
            $JSON_Output
            Write-Host   
            Write-Host "Adding App Configuration Policy '$DisplayName'" -ForegroundColor Yellow                                                      
            Add-ManagedDeviceAppConfigPolicy -JSON $JSON_Output

        }

        Else
        {

            Write-Host
            Write-Host "Targeted app package id '$($JSON_Convert.packageId)' has not been added from Managed Google Play" -ForegroundColor Red
            Write-Host "The App Configuration Policy can't be created" -ForegroundColor Red

        }
    
    }

}

Else
{

    Write-Host "App Configuration JSON is for Managed Apps" -ForegroundColor Yellow
    $JSON_Output = $JSON_Convert | ConvertTo-Json -Depth 5
    $JSON_Output
    Write-Host
    Write-Host "Adding App Configuration Policy '$DisplayName'" -ForegroundColor Yellow
    Add-ManagedAppAppConfigPolicy -JSON $JSON_Output   

}
 

#######################
##Office app config####
#######################

$ImportPath = "$jsonpath\IOS_IntuneMAMUpn_Office_11-03-2021-9-51-481.json"

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
$JSON_Convert = $JSON_Data | ConvertFrom-Json | Select-Object -Property * -ExcludeProperty id,createdDateTime,lastModifiedDateTime,version,isAssigned,roleScopeTagIds

$DisplayName = $JSON_Convert.displayName

Write-Host
Write-Host "App Configuration Policy '$DisplayName' Found..." -ForegroundColor Yellow


# Check if the JSON is for Managed Apps or Managed Devices
If(($JSON_Convert.'@odata.type' -eq "#microsoft.graph.iosMobileAppConfiguration") -or ($JSON_Convert.'@odata.type' -eq "#microsoft.graph.androidManagedStoreAppConfiguration")){

    Write-Host "App Configuration JSON is for Managed Devices" -ForegroundColor Yellow

    If($JSON_Convert.'@odata.type' -eq "#microsoft.graph.iosMobileAppConfiguration"){

        # Check if the client app is present 
        $targetedMobileApp = Test-AppBundleId -bundleId $JSON_Convert.bundleId
           
        If($targetedMobileApp){

            Write-Host
            Write-Host "Targeted app $($JSON_Convert.bundleId) has already been added from the App Store" -ForegroundColor Yellow
            Write-Host "The App Configuration Policy will be created" -ForegroundColor Yellow
            Write-Host

            # Update the targetedMobileApps GUID if required
            If(!($targetedMobileApp -eq $JSON_Convert.targetedMobileApps)){

                $JSON_Convert.targetedMobileApps.SetValue($targetedMobileApp,0)

            }

            $JSON_Output = $JSON_Convert | ConvertTo-Json -Depth 5
            $JSON_Output
            Write-Host
            Write-Host "Adding App Configuration Policy '$DisplayName'" -ForegroundColor Yellow
            Add-ManagedDeviceAppConfigPolicy -JSON $JSON_Output

        }

        Else
        {

            Write-Host
            Write-Host "Targeted app bundle id '$($JSON_Convert.bundleId)' has not been added from the App Store" -ForegroundColor Red
            Write-Host "The App Configuration Policy can't be created" -ForegroundColor Red

        }


    }

    ElseIf($JSON_Convert.'@odata.type' -eq "#microsoft.graph.androidManagedStoreAppConfiguration"){

        # Check if the client app is present 
        $targetedMobileApp = Test-AppPackageId -packageId $JSON_Convert.packageId
        
        If($targetedMobileApp){

            Write-Host
            Write-Host "Targeted app $($JSON_Convert.packageId) has already been added from Managed Google Play" -ForegroundColor Yellow
            Write-Host "The App Configuration Policy will be created" -ForegroundColor Yellow
            Write-Host
            
            # Update the targetedMobileApps GUID if required           
            If(!($targetedMobileApp -eq $JSON_Convert.targetedMobileApps)){
               
                $JSON_Convert.targetedMobileApps.SetValue($targetedMobileApp,0)

            }

            $JSON_Output = $JSON_Convert | ConvertTo-Json -Depth 5
            $JSON_Output
            Write-Host   
            Write-Host "Adding App Configuration Policy '$DisplayName'" -ForegroundColor Yellow                                                      
            Add-ManagedDeviceAppConfigPolicy -JSON $JSON_Output

        }

        Else
        {

            Write-Host
            Write-Host "Targeted app package id '$($JSON_Convert.packageId)' has not been added from Managed Google Play" -ForegroundColor Red
            Write-Host "The App Configuration Policy can't be created" -ForegroundColor Red

        }
    
    }

}

Else
{

    Write-Host "App Configuration JSON is for Managed Apps" -ForegroundColor Yellow
    $JSON_Output = $JSON_Convert | ConvertTo-Json -Depth 5
    $JSON_Output
    Write-Host
    Write-Host "Adding App Configuration Policy '$DisplayName'" -ForegroundColor Yellow
    Add-ManagedAppAppConfigPolicy -JSON $JSON_Output   

}
 

#######################
##word app config####
#######################

$ImportPath = "$jsonpath\IOS_IntuneMAMUpn_Word_10-03-2021-16-42-551.json"

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
$JSON_Convert = $JSON_Data | ConvertFrom-Json | Select-Object -Property * -ExcludeProperty id,createdDateTime,lastModifiedDateTime,version,isAssigned,roleScopeTagIds

$DisplayName = $JSON_Convert.displayName

Write-Host
Write-Host "App Configuration Policy '$DisplayName' Found..." -ForegroundColor Yellow


# Check if the JSON is for Managed Apps or Managed Devices
If(($JSON_Convert.'@odata.type' -eq "#microsoft.graph.iosMobileAppConfiguration") -or ($JSON_Convert.'@odata.type' -eq "#microsoft.graph.androidManagedStoreAppConfiguration")){

    Write-Host "App Configuration JSON is for Managed Devices" -ForegroundColor Yellow

    If($JSON_Convert.'@odata.type' -eq "#microsoft.graph.iosMobileAppConfiguration"){

        # Check if the client app is present 
        $targetedMobileApp = Test-AppBundleId -bundleId $JSON_Convert.bundleId
           
        If($targetedMobileApp){

            Write-Host
            Write-Host "Targeted app $($JSON_Convert.bundleId) has already been added from the App Store" -ForegroundColor Yellow
            Write-Host "The App Configuration Policy will be created" -ForegroundColor Yellow
            Write-Host

            # Update the targetedMobileApps GUID if required
            If(!($targetedMobileApp -eq $JSON_Convert.targetedMobileApps)){

                $JSON_Convert.targetedMobileApps.SetValue($targetedMobileApp,0)

            }

            $JSON_Output = $JSON_Convert | ConvertTo-Json -Depth 5
            $JSON_Output
            Write-Host
            Write-Host "Adding App Configuration Policy '$DisplayName'" -ForegroundColor Yellow
            Add-ManagedDeviceAppConfigPolicy -JSON $JSON_Output

        }

        Else
        {

            Write-Host
            Write-Host "Targeted app bundle id '$($JSON_Convert.bundleId)' has not been added from the App Store" -ForegroundColor Red
            Write-Host "The App Configuration Policy can't be created" -ForegroundColor Red

        }


    }

    ElseIf($JSON_Convert.'@odata.type' -eq "#microsoft.graph.androidManagedStoreAppConfiguration"){

        # Check if the client app is present 
        $targetedMobileApp = Test-AppPackageId -packageId $JSON_Convert.packageId
        
        If($targetedMobileApp){

            Write-Host
            Write-Host "Targeted app $($JSON_Convert.packageId) has already been added from Managed Google Play" -ForegroundColor Yellow
            Write-Host "The App Configuration Policy will be created" -ForegroundColor Yellow
            Write-Host
            
            # Update the targetedMobileApps GUID if required           
            If(!($targetedMobileApp -eq $JSON_Convert.targetedMobileApps)){
               
                $JSON_Convert.targetedMobileApps.SetValue($targetedMobileApp,0)

            }

            $JSON_Output = $JSON_Convert | ConvertTo-Json -Depth 5
            $JSON_Output
            Write-Host   
            Write-Host "Adding App Configuration Policy '$DisplayName'" -ForegroundColor Yellow                                                      
            Add-ManagedDeviceAppConfigPolicy -JSON $JSON_Output

        }

        Else
        {

            Write-Host
            Write-Host "Targeted app package id '$($JSON_Convert.packageId)' has not been added from Managed Google Play" -ForegroundColor Red
            Write-Host "The App Configuration Policy can't be created" -ForegroundColor Red

        }
    
    }

}

Else
{

    Write-Host "App Configuration JSON is for Managed Apps" -ForegroundColor Yellow
    $JSON_Output = $JSON_Convert | ConvertTo-Json -Depth 5
    $JSON_Output
    Write-Host
    Write-Host "Adding App Configuration Policy '$DisplayName'" -ForegroundColor Yellow
    Add-ManagedAppAppConfigPolicy -JSON $JSON_Output   

}





