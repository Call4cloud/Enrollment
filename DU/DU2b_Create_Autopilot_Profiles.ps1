###########################################################################
#        Versie:  1.0 (07-04-2021)
#        Script:  DU.1B
#        Autopilot profielen aanmaken  #
###########################################################################


$Body = @{
    "@odata.type"                          = "#microsoft.graph.azureADWindowsAutopilotDeploymentProfile"
    displayName                            = "Autopilot Default Profile"
    description                            = "Autopilot Default Profile"
    language                               = 'os-default'
    extractHardwareHash                    = $false
    enableWhiteGlove                       = $true
    outOfBoxExperienceSettings             = @{
        "@odata.type"             = "microsoft.graph.outOfBoxExperienceSettings"
        hidePrivacySettings       = $true
        hideEULA                  = $true
        userType                  = 'Standard'
        deviceUsageType           = 'singleuser'
        skipKeyboardSelectionPage = $false
        hideEscapeLink            = $true
    }
    enrollmentStatusScreenSettings         = @{
        '@odata.type'                                    = "microsoft.graph.windowsEnrollmentStatusScreenSettings"
        hideInstallationProgress                         = $true
        allowDeviceUseBeforeProfileAndAppInstallComplete = $true
        blockDeviceSetupRetryByUser                      = $false
        allowLogCollectionOnInstallFailure               = $true
        customErrorMessage                               = "An error has occured. Please contact your IT Administrator"
        installProgressTimeoutInMinutes                  = "45"
        allowDeviceUseOnInstallFailure                   = $true
    }
} | ConvertTo-Json
 

$apiurl = "https://graph.microsoft.com/beta/deviceManagement/windowsAutopilotDeploymentProfiles"
$Data = Invoke-RestMethod -Headers @{Authorization = "Bearer $($accessToken1b)"} -Uri $apiUrl -Body $body -Method Post -ContentType 'application/json'
