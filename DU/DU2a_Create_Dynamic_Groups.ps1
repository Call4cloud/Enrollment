###########################################################################
#        Versie:  1.1 (07-04-2021)
#        Script:  DU.1A
#        Dynamic Groups aanmaken  #
###########################################################################


#$authResult = Get-MsalToken -ClientId 'd1ddf0e4-d672-4dae-b554-9d5bdfd93547' -Scopes 'https://graph.microsoft.com/.default'
#$accesstoken1b = $authresult.accesstoken

$headers = @{
            'Content-Type'='application/json'
            'Authorization'="Bearer " + $accesstoken1b
            'ExpiresOn'=$authResult.ExpiresOn
            }

#####################
#All Windows devices group
#############################

$dynamicGroupProperties = @{
    "description" = "All Windows Devices";
    "displayName" = "All Windows Devices";
    "groupTypes" = @("DynamicMembership");
    "mailEnabled" = $False;
    "mailNickname" = "Win";
    "membershipRule" = "(device.deviceOSType -contains ""Windows"")";
    "membershipRuleProcessingState" = "On";
    "securityEnabled" = $True
}
 
invoke-webrequest -Headers $headers -uri "https://graph.microsoft.com/beta/groups" -Body (ConvertTo-Json $dynamicGroupProperties) -method POST -Verbose


##########################
####MS365BusinessLicencesgroup
#######################

$staticGroupProperties = @{
    "description" = "MS365BusinessLicences";
    "displayName" = "MS365BusinessLicences";
    "mailEnabled" = $False;
    "mailNickname" = "Win";
    "membershipRuleProcessingState" = "On";
    "securityEnabled" = $True
}
 
invoke-webrequest -Headers $headers -uri "https://graph.microsoft.com/beta/groups" -Body (ConvertTo-Json $staticGroupProperties) -method POST -Verbose


##########################
####autopilotstaticgroup
############################

$staticGroupProperties = @{
    "description" = "AutopilotStaticGroup";
    "displayName" = "AutopilotStaticGroup";
    "mailEnabled" = $False;
    "mailNickname" = "AutopilotStatic";
    "securityEnabled" = $True
}
 
invoke-webrequest -Headers $headers -uri "https://graph.microsoft.com/beta/groups" -Body (ConvertTo-Json $staticGroupProperties) -method POST -Verbose

##########################
####ExclusionGroepen CA
#######################

$staticGroupProperties = @{
    "description" = "Exclude_Require_MDM_Managed_devices_Windows_Mac";
    "displayName" = "Exclude_Require_MDM_Managed_devices_Windows_Mac";
    "mailEnabled" = $False;
  "membershipRuleProcessingState" = "On";
    "mailNickname" = "Exclude_Require_MDM_Managed";
    "securityEnabled" = $True
}
 
invoke-webrequest -Headers $headers -uri "https://graph.microsoft.com/beta/groups" -Body (ConvertTo-Json $staticGroupProperties) -method POST -Verbose

$staticGroupProperties = @{
    "description" = "Exclude_Require_MDM_Managed_devices_mobile_access";
    "displayName" = "Exclude_Require_MDM_Managed_devices_mobile_access";
    "mailEnabled" = $False;
    "mailNickname" = "Exclude_Require_MDM_Managed_devices_mobile_access";
    "membershipRuleProcessingState" = "On";
    "securityEnabled" = $True
}
 
invoke-webrequest -Headers $headers -uri "https://graph.microsoft.com/beta/groups" -Body (ConvertTo-Json $staticGroupProperties) -method POST -Verbose

$staticGroupProperties = @{
    "description" = "Exclude_Require_MFA_Weblogin_Nonmanaged_devices";
    "displayName" = "Exclude_Require_MFA_Weblogin_Nonmanaged_devices";
    "mailEnabled" = $False;
    "mailNickname" = "Exclude_Require_MFA_Weblogin_Nonmanaged_devices";
    "membershipRuleProcessingState" = "On";
    "securityEnabled" = $True
}
 
invoke-webrequest -Headers $headers -uri "https://graph.microsoft.com/beta/groups" -Body (ConvertTo-Json $staticGroupProperties) -method POST -Verbose

$staticGroupProperties = @{
    "description" = "Exclude_Require_MAM_Approved_app_Exceptexchange";
    "displayName" = "Exclude_Require_MAM_Approved_app_Exceptexchange";
    "mailEnabled" = $False;
    "mailNickname" = "Exclude_Require_MAM_Approved_app_Exceptexchange";
    "membershipRuleProcessingState" = "On";
    "securityEnabled" = $True
}
 
invoke-webrequest -Headers $headers -uri "https://graph.microsoft.com/beta/groups" -Body (ConvertTo-Json $staticGroupProperties) -method POST -Verbose

$staticGroupProperties = @{
    "description" = "Exclude_Require_MAM_Approved_app_Onlyexchange";
    "displayName" = "Exclude_Require_MAM_Approved_app_Onlyexchange";
    "mailEnabled" = $False;
    "mailNickname" = "Exclude_Require_MAM_Approved_app_Onlyexchange";
    "membershipRuleProcessingState" = "On";
    "securityEnabled" = $True
}
 
invoke-webrequest -Headers $headers -uri "https://graph.microsoft.com/beta/groups" -Body (ConvertTo-Json $staticGroupProperties) -method POST -Verbose


$staticGroupProperties = @{
    "description" = "Exclude_Block_exchangeDownloads_Nonmanaged_devices";
    "displayName" = "Exclude_Block_exchangeDownloads_Nonmanaged_devices";
    "mailEnabled" = $False;
    "mailNickname" = "Exclude_Block_exchangeDownloads_Nonmanaged_devices";
    "membershipRuleProcessingState" = "On";
    "securityEnabled" = $True
}
 
invoke-webrequest -Headers $headers -uri "https://graph.microsoft.com/beta/groups" -Body (ConvertTo-Json $staticGroupProperties) -method POST -Verbose

$staticGroupProperties = @{
    "description" = "Exclude_Block_activesync";
    "displayName" = "Exclude_Block_activesync";
    "mailEnabled" = $False;
    "mailNickname" = "Exclude_Block_activesync";
    "membershipRuleProcessingState" = "On";
    "securityEnabled" = $True
}
 
invoke-webrequest -Headers $headers -uri "https://graph.microsoft.com/beta/groups" -Body (ConvertTo-Json $staticGroupProperties) -method POST -Verbose

$staticGroupProperties = @{
    "description" = "Exclude_Block_Legacy_Authenticatie";
    "displayName" = "Exclude_Block_Legacy_Authenticatie";
    "mailEnabled" = $False;
    "mailNickname" = "Exclude_Block_Legacy_Authenticatie";
    "membershipRuleProcessingState" = "On";
    "securityEnabled" = $True
}
 
invoke-webrequest -Headers $headers -uri "https://graph.microsoft.com/beta/groups" -Body (ConvertTo-Json $staticGroupProperties) -method POST -Verbose

$staticGroupProperties = @{
    "description" = "Exclude_Block_Require_trusted_countries";
    "displayName" = "Exclude_Block_Require_trusted_countries";
    "mailEnabled" = $False;
    "mailNickname" = "Exclude_Block_Require_trusted_countries";
    "membershipRuleProcessingState" = "On";
    "securityEnabled" = $True
}
 
invoke-webrequest -Headers $headers -uri "https://graph.microsoft.com/beta/groups" -Body (ConvertTo-Json $staticGroupProperties) -method POST -Verbose

#Update V1.1 Added Group_Creators group for sl1 Teams Security

$staticGroupProperties = @{
    "description" = "Group_Creators";
    "displayName" = "Group_Creators";
    "mailEnabled" = $False;
    "mailNickname" = "Group_Creators";
    "membershipRuleProcessingState" = "On";
    "securityEnabled" = $True
}
 
invoke-webrequest -Headers $headers -uri "https://graph.microsoft.com/beta/groups" -Body (ConvertTo-Json $staticGroupProperties) -method POST -Verbose

