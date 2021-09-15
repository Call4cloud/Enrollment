######################
#$authResult = Get-MsalToken -ClientId 'd1ddf0e4-d672-4dae-b554-9d5bdfd93547' -Scopes 'https://graph.microsoft.com/.default'
#$authtoken = @{
#            'Content-Type'='application/json'
#            'Authorization'="Bearer " + $authResult.AccessToken
#            'ExpiresOn'=$authResult.ExpiresOn
#            }

#$URL = "https://graph.microsoft.com/v1.0/groups?"
#$Allgroups = (Invoke-RestMethod -Headers $headers1b -Uri $URL -Method GET).value 
#$group= $Allgroups | Where-Object -Property Displayname -Value "all users" -eq
#$allusersgroupid = $group.id

####################################################

Function Add-ManagedAppPolicy(){

[cmdletbinding()]

param
(
    $JSON
)

$graphApiVersion = "Beta"
$Resource = "deviceAppManagement/managedAppPolicies"

    try {

        if($JSON -eq "" -or $JSON -eq $null){

        write-host "No JSON specified, please specify valid JSON for a Managed App Policy..." -f Red

        }

        else {

        Test-JSON -JSON $JSON

        $uri = "https://graph.microsoft.com/$graphApiVersion/$($Resource)"
        Invoke-RestMethod -Uri $uri -Headers $headers1b -Method Post -Body $JSON -ContentType "application/json"

        }

    }

    catch {

    Write-Host
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

$iOS = @"

{
  "@odata.type": "#microsoft.graph.iosManagedAppProtection",
   "displayName":  "IOS - Unmanaged_Devices_App_Protection_Policy",
    "description":  "",
    "createdDateTime":  "2020-04-06T06:20:36Z",
    "lastModifiedDateTime":  "2020-04-06T06:20:36Z",
    "roleScopeTagIds":  [
                            "0"
                        ],
    "id":  "T_2c8160fa-dfa6-4e01-8e7b-0f80f1f389df",
    "version":  "\"199e75e0-c88c-4a66-86a3-b5c01e47cd8a\"",
    "periodOfflineBeforeAccessCheck":  "PT12H",
    "periodOnlineBeforeAccessCheck":  "PT30M",
    "allowedInboundDataTransferSources":  "ManagedApps",
    "allowedOutboundDataTransferDestinations":  "managedApps",
    "organizationalCredentialsRequired":  false,
    "allowedOutboundClipboardSharingLevel":  "managedApps",
    "dataBackupBlocked":  true,
    "deviceComplianceRequired":  true,
    "managedBrowserToOpenLinksRequired":  false,
    "saveAsBlocked":  true,
    "periodOfflineBeforeWipeIsEnforced":  "P90D",
    "pinRequired":  true,
    "maximumPinRetries":  5,
    "simplePinBlocked":  false,
    "minimumPinLength":  4,
    "pinCharacterSet":  "numeric",
    "periodBeforePinReset":  "PT0S",
    "allowedDataStorageLocations":  [
                                        "oneDriveForBusiness",
                                        "sharePoint"
                                    ],
    "contactSyncBlocked":  true,
    "printBlocked":  true,
    "fingerprintBlocked":  false,
    "disableAppPinIfDevicePinIsSet":  false,
    "minimumRequiredOsVersion":  null,
    "minimumWarningOsVersion":  null,
    "minimumRequiredAppVersion":  null,
    "minimumWarningAppVersion":  null,
    "minimumWipeOsVersion":  null,
    "minimumWipeAppVersion":  null,
    "appActionIfDeviceComplianceRequired":  "block",
    "appActionIfMaximumPinRetriesExceeded":  "block",
    "pinRequiredInsteadOfBiometricTimeout":  "PT30M",
    "allowedOutboundClipboardSharingExceptionLength":  0,
    "notificationRestriction":  "block",
    "previousPinBlockCount":  0,
    "managedBrowser":  "notConfigured",
    "maximumAllowedDeviceThreatLevel":  "notConfigured",
    "mobileThreatDefenseRemediationAction":  "block",
    "blockDataIngestionIntoOrganizationDocuments":  false,
    "allowedDataIngestionLocations":  [

                                      ],
    "appActionIfUnableToAuthenticateUser":  "wipe", 
    "dialerRestrictionLevel":  "allApps",
    "isAssigned":  true,
    "targetedAppManagementLevels":  "Unmanaged",
    "appDataEncryptionType":  "whenDeviceLocked",
    "minimumRequiredSdkVersion":  null,
    "deployedAppCount":  12,
    "faceIdBlocked":  false,
    "minimumWipeSdkVersion":  null,
    "allowedIosDeviceModels":  null,
    "appActionIfIosDeviceModelNotAllowed":  "block",
    "thirdPartyKeyboardsBlocked":  true,
    "filterOpenInToOnlyManagedApps":  false,
    "disableProtectionOfManagedOutboundOpenInData":  false,
    "protectInboundDataFromUnknownSources":  false,
    "customBrowserProtocol":  "",
    "exemptedAppProtocols":  [
                                 {
                                     "name":  "Default",
                                     "value":  "tel;telprompt;skype;app-settings;calshow;itms;itmss;itms-apps;itms-appss;itms-services;"
                                 }
                             ],
"apps@odata.context":  "https://graph.microsoft.com/Beta/$metadata#deviceAppManagement/iosManagedAppProtections(\u0027T_2c8160fa-dfa6-4e01-8e7b-0f80f1f389df\u0027)/apps",
    "apps":  [
                 {
                     "id":  "com.microsoft.intune.managedbrowser.ios",
                     "version":  "-1480721402",
                     "mobileAppIdentifier":  {
                                                 "@odata.type":  "#microsoft.graph.iosMobileAppIdentifier",
                                                 "bundleId":  "com.microsoft.intune.managedbrowser"
                                             }
                 },
                 {
                     "id":  "com.microsoft.msedge.ios",
                     "version":  "-2135752869",
                     "mobileAppIdentifier":  {
                                                 "@odata.type":  "#microsoft.graph.iosMobileAppIdentifier",
                                                 "bundleId":  "com.microsoft.msedge"
                                             }
                 },
                 {
                     "id":  "com.microsoft.office.excel.ios",
                     "version":  "-1255026913",
                     "mobileAppIdentifier":  {
                                                 "@odata.type":  "#microsoft.graph.iosMobileAppIdentifier",
                                                 "bundleId":  "com.microsoft.office.excel"
                                             }
                 },
                 {
                     "id":  "com.microsoft.office.outlook.ios",
                     "version":  "-518090279",
                     "mobileAppIdentifier":  {
                                                 "@odata.type":  "#microsoft.graph.iosMobileAppIdentifier",
                                                 "bundleId":  "com.microsoft.office.outlook"
                                             }
                 },
                 {
                     "id":  "com.microsoft.office.powerpoint.ios",
                     "version":  "-740777841",
                     "mobileAppIdentifier":  {
                                                 "@odata.type":  "#microsoft.graph.iosMobileAppIdentifier",
                                                 "bundleId":  "com.microsoft.office.powerpoint"
                                             }
                 },
                 {
                     "id":  "com.microsoft.office.word.ios",
                     "version":  "922692278",
                     "mobileAppIdentifier":  {
                                                 "@odata.type":  "#microsoft.graph.iosMobileAppIdentifier",
                                                 "bundleId":  "com.microsoft.office.word"
                                             }
                 },
                 {
                     "id":  "com.microsoft.officemobile.ios",
                     "version":  "-803819540",
                     "mobileAppIdentifier":  {
                                                 "@odata.type":  "#microsoft.graph.iosMobileAppIdentifier",
                                                 "bundleId":  "com.microsoft.officemobile"
                                             }
                 },
                 {
                     "id":  "com.microsoft.onenote.ios",
                     "version":  "107156768",
                     "mobileAppIdentifier":  {
                                                 "@odata.type":  "#microsoft.graph.iosMobileAppIdentifier",
                                                 "bundleId":  "com.microsoft.onenote"
                                             }
                 },
                 {
                     "id":  "com.microsoft.sharepoint.ios",
                     "version":  "-585639021",
                     "mobileAppIdentifier":  {
                                                 "@odata.type":  "#microsoft.graph.iosMobileAppIdentifier",
                                                 "bundleId":  "com.microsoft.sharepoint"
                                             }
                 },
                 {
                     "id":  "com.microsoft.skydrive.ios",
                     "version":  "-108719121",
                     "mobileAppIdentifier":  {
                                                 "@odata.type":  "#microsoft.graph.iosMobileAppIdentifier",
                                                 "bundleId":  "com.microsoft.skydrive"
                                             }
                 },
                 {
                     "id":  "com.microsoft.skype.teams.ios",
                     "version":  "-1040529574",
                     "mobileAppIdentifier":  {
                                                 "@odata.type":  "#microsoft.graph.iosMobileAppIdentifier",
                                                 "bundleId":  "com.microsoft.skype.teams"
                                             }
                 },
                 {
                     "id":  "com.microsoft.visio.ios",
                     "version":  "-387333446",
                     "mobileAppIdentifier":  {
                                                 "@odata.type":  "#microsoft.graph.iosMobileAppIdentifier",
                                                 "bundleId":  "com.microsoft.visio"
                                             }
                 }
             ],
    "assignments@odata.context":  "https://graph.microsoft.com/beta/$metadata#deviceAppManagement/iosManagedAppProtections(\u0027T_2c8160fa-dfa6-4e01-8e7b-0f80f1f389df\u0027)/assignments",
    "assignments":  [
                        {
                            "id":  "53ef18b6-d9fe-4c32-85c1-395a03297805_incl",
                            "source":  "direct",
                            "sourceId":  "00000000-0000-0000-0000-000000000000",
                            "target":  {
                                           "@odata.type":  "#microsoft.graph.groupAssignmentTarget",
                                           "groupId":  "$allusersgroupid"
                                       }
                        }
                    ]
}
"@

####################################################

$Android = @"

{
  "@odata.type": "#microsoft.graph.androidManagedAppProtection",
     "displayName":  "ANDROID - Unmanaged_Devices_App_Protection_Policy",
    "description":  "",
     "periodOnlineBeforeAccessCheck":  "PT30M",
    "allowedInboundDataTransferSources":  "allApps",
    "allowedOutboundDataTransferDestinations":  "managedApps",
    "organizationalCredentialsRequired":  false,
    "allowedOutboundClipboardSharingLevel":  "managedAppsWithPasteIn",
    "dataBackupBlocked":  true,
    "deviceComplianceRequired":  true,
    "managedBrowserToOpenLinksRequired":  false,
    "saveAsBlocked":  true,
    "periodOfflineBeforeWipeIsEnforced":  "P90D",
    "pinRequired":  true,
    "maximumPinRetries":  5,
    "simplePinBlocked":  false,
    "minimumPinLength":  4,
    "pinCharacterSet":  "numeric",
    "periodBeforePinReset":  "PT0S",
    "allowedDataStorageLocations":  [
                                        "oneDriveForBusiness",
                                        "sharePoint"
                                    ],
    "contactSyncBlocked":  true,
    "printBlocked":  true,
    "fingerprintBlocked":  false,
    "disableAppPinIfDevicePinIsSet":  true,
    "minimumRequiredOsVersion":  null,
    "minimumWarningOsVersion":  null,
    "minimumRequiredAppVersion":  null,
    "minimumWarningAppVersion":  null,
    "minimumWipeOsVersion":  null,
    "minimumWipeAppVersion":  null,
    "appActionIfDeviceComplianceRequired":  "block",
    "appActionIfMaximumPinRetriesExceeded":  "block",
    "pinRequiredInsteadOfBiometricTimeout":  "PT30M",
    "allowedOutboundClipboardSharingExceptionLength":  0,
    "notificationRestriction":  "block",
    "previousPinBlockCount":  0,
    "managedBrowser":  "notConfigured",
    "maximumAllowedDeviceThreatLevel":  "notConfigured",
    "mobileThreatDefenseRemediationAction":  "block",
    "blockDataIngestionIntoOrganizationDocuments":  false,
    "allowedDataIngestionLocations":  [

                                      ],
    "appActionIfUnableToAuthenticateUser":  "wipe",
    "isAssigned":  true,
    "targetedAppManagementLevels":  "Unmanaged",
    "dialerRestrictionLevel":  "allApps",
    "screenCaptureBlocked":  false,
    "disableAppEncryptionIfDeviceEncryptionIsEnabled":  false,
    "encryptAppData":  true,
    "deployedAppCount":  11,
    "minimumRequiredPatchVersion":  "0000-00-00",
    "minimumWarningPatchVersion":  "0000-00-00",
    "minimumWipePatchVersion":  "0000-00-00",
    "allowedAndroidDeviceManufacturers":  null,
    "appActionIfAndroidDeviceManufacturerNotAllowed":  "block",
    "requiredAndroidSafetyNetDeviceAttestationType":  "none",
    "appActionIfAndroidSafetyNetDeviceAttestationFailed":  "block",
    "requiredAndroidSafetyNetAppsVerificationType":  "none",
    "appActionIfAndroidSafetyNetAppsVerificationFailed":  "block",
    "customBrowserPackageId":  "",
    "customBrowserDisplayName":  "",
    "minimumRequiredCompanyPortalVersion":  null,
    "minimumWarningCompanyPortalVersion":  null,
    "minimumWipeCompanyPortalVersion":  null,
    "keyboardsRestricted":  false,
    "allowedAndroidDeviceModels":  [

                                   ],
    "appActionIfAndroidDeviceModelNotAllowed":  "block",
    "exemptedAppPackages":  [

                            ],
    "approvedKeyboards":  [

                          ],
    "apps@odata.context":  "https://graph.microsoft.com/Beta/$metadata#deviceAppManagement/androidManagedAppProtections(\u0027T_ee27cb4c-682e-4fbc-9d18-533fea805735\u0027)/apps",
    "apps":  [
                 {
                     "id":  "com.adobe.reader.android",
                     "version":  "267816930",
                     "mobileAppIdentifier":  {
                                                 "@odata.type":  "#microsoft.graph.androidMobileAppIdentifier",
                                                 "packageId":  "com.adobe.reader"
                                             }
                 },
                 {
                     "id":  "com.microsoft.emmx.android",
                     "version":  "-725393251",
                     "mobileAppIdentifier":  {
                                                 "@odata.type":  "#microsoft.graph.androidMobileAppIdentifier",
                                                 "packageId":  "com.microsoft.emmx"
                                             }
                 },
                 {
                     "id":  "com.microsoft.intune.mam.managedbrowser.android",
                     "version":  "1356606505",
                     "mobileAppIdentifier":  {
                                                 "@odata.type":  "#microsoft.graph.androidMobileAppIdentifier",
                                                 "packageId":  "com.microsoft.intune.mam.managedbrowser"
                                             }
                 },
                 {
                     "id":  "com.microsoft.office.excel.android",
                     "version":  "-1789826587",
                     "mobileAppIdentifier":  {
                                                 "@odata.type":  "#microsoft.graph.androidMobileAppIdentifier",
                                                 "packageId":  "com.microsoft.office.excel"
                                             }
                 },
                 {
                     "id":  "com.microsoft.office.officehub.android",
                     "version":  "-1091809935",
                     "mobileAppIdentifier":  {
                                                 "@odata.type":  "#microsoft.graph.androidMobileAppIdentifier",
                                                 "packageId":  "com.microsoft.office.officehub"
                                             }
                 },
                 {
                     "id":  "com.microsoft.office.outlook.android",
                     "version":  "1146701235",
                     "mobileAppIdentifier":  {
                                                 "@odata.type":  "#microsoft.graph.androidMobileAppIdentifier",
                                                 "packageId":  "com.microsoft.office.outlook"
                                             }
                 },
                 {
                     "id":  "com.microsoft.office.powerpoint.android",
                     "version":  "1411665537",
                     "mobileAppIdentifier":  {
                                                 "@odata.type":  "#microsoft.graph.androidMobileAppIdentifier",
                                                 "packageId":  "com.microsoft.office.powerpoint"
                                             }
                 },
                 {
                     "id":  "com.microsoft.office.word.android",
                     "version":  "2122351424",
                     "mobileAppIdentifier":  {
                                                 "@odata.type":  "#microsoft.graph.androidMobileAppIdentifier",
                                                 "packageId":  "com.microsoft.office.word"
                                             }
                 },
                 {
                     "id":  "com.microsoft.sharepoint.android",
                     "version":  "84773357",
                     "mobileAppIdentifier":  {
                                                 "@odata.type":  "#microsoft.graph.androidMobileAppIdentifier",
                                                 "packageId":  "com.microsoft.sharepoint"
                                             }
                 },
                 {
                     "id":  "com.microsoft.skydrive.android",
                     "version":  "1887770705",
                     "mobileAppIdentifier":  {
                                                 "@odata.type":  "#microsoft.graph.androidMobileAppIdentifier",
                                                 "packageId":  "com.microsoft.skydrive"
                                             }
                 },
                 {
                     "id":  "com.microsoft.teams.android",
                     "version":  "1900143244",
                     "mobileAppIdentifier":  {
                                                 "@odata.type":  "#microsoft.graph.androidMobileAppIdentifier",
                                                 "packageId":  "com.microsoft.teams"
                                             }
                 }

    ],
"assignments@odata.context":  "https://graph.microsoft.com/beta/$metadata#deviceAppManagement/iosManagedAppProtections(\u0027T_2c8160fa-dfa6-4e01-8e7b-0f80f1f389df\u0027)/assignments",
    "assignments":  [
                        {
                            "id":  "53ef18b6-d9fe-4c32-85c1-395a03297805_incl",
                            "source":  "direct",
                            "sourceId":  "00000000-0000-0000-0000-000000000000",
                            "target":  {
                                           "@odata.type":  "#microsoft.graph.groupAssignmentTarget",
                                           "groupId":  "$allusersgroupid"
                                       }
                        }
                    ]
}

"@

####################################################

write-host

write-host "Adding iOS Managed App Policy" -f Yellow

Add-ManagedAppPolicy -Json $iOS

write-host "Adding Android Managed App Policy" -f Yellow

Add-ManagedAppPolicy -Json $Android
