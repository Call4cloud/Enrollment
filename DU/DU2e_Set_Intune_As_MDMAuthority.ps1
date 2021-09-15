###########################################################################
#        Versie:  1.22 (06-09-2021)
#        Script:  DU.2A
#        Intune Instellen als MDM Authority  #
###########################################################################

# Connecten naar msgraph (install-module microsoft.graph.intune)

$mdmAuth = (Invoke-MSGraphRequest -Url "https://graph.microsoft.com/beta/organization('$OrgId')?`$select=mobiledevicemanagementauthority" -HttpMethod Get -ErrorAction Stop).mobileDeviceManagementAuthority


 if($mdmAuth -notlike "intune")
{
    $OrgID = (Invoke-MSGraphRequest -Url "https://graph.microsoft.com/v1.0/organization" -HttpMethod Get -ErrorAction Stop).value.id
    Invoke-MSGraphRequest -Url "https://graph.microsoft.com/v1.0/organization/$OrgID/setMobileDeviceManagementAuthority" -HttpMethod Post -ErrorAction Stop
}



$url = "https://main.iam.ad.ext.azure.com/api/MdmApplications"
$mdmapp= Invoke-RestMethod –Uri $url –Headers $headersazurerm –Method get
$mdmapp = $mdmapp | Where-Object {$_.appDisplayName -eq "Microsoft Intune"}
$mdmappid = $mdmapp.objectId

$url = -join ('https://main.iam.ad.ext.azure.com/api/MdmApplications/',$mdmappid,'?mdmAppliesToChanged=true&mamAppliesToChanged=true')

$contentpart1 = -join ('{"objectId":"',$mdmappid,'","appId":"0000000a-0000-0000-c000-000000000000","appDisplayName":"Microsoft Intune","appCategory":"Mdm","logoUrl":null,"isOnPrem":false,"appData":{"mamEnrollmentUrl":"https://wip.mam.manage.microsoft.com/Enroll","mamComplianceUrl":"","mamTermsOfUseUrl":"","enrollmentUrl":"https://enrollment.manage.microsoft.com/enrollmentserver/discovery.svc","complianceUrl":"https://portal.manage.microsoft.com/?portalAction=Compliance","termsOfUseUrl":"https://portal.manage.microsoft.com/TermsofUse.aspx"},"originalAppData":{"mamEnrollmentUrl":"https://wip.mam.manage.microsoft.com/Enroll","mamComplianceUrl":"","mamTermsOfUseUrl":"","enrollmentUrl":"https://enrollment.manage.microsoft.com/enrollmentserver/discovery.svc","complianceUrl":"https://portal.manage.microsoft.com/?portalAction=Compliance","termsOfUseUrl":"https://portal.manage.microsoft.com/TermsofUse.aspx"},"mdmAppliesTo":1,"mamAppliesTo":2,"mdmAppliesToGroups":[{"objectId":"',$ms365licensegroupid,'","displayName":"MS365BusinessLicences ","dirSyncEnabled":null,"groupTypes":null,"securityEnabled":null,"mailEnabled":null}],"mamAppliesToGroups":[]}')
$content = $contentpart1

Invoke-RestMethod –Uri $url –Headers $headersazurerm –Method PUT -Body $content -ErrorAction Stop

###############################################################################
#Enable Continuous access evaluation   						V1.2.2
################################################################################

$url = "https://main.iam.ad.ext.azure.com/api/SmartSession/Config"
$content = '{"state":1,"groupsToInclude":[],"usersToInclude":[],"isStrictLocationEnforcementEnabled":false}'
Invoke-RestMethod –Uri $url –Headers $headersazurerm –Method Put -Body $content -ErrorAction Stop


###############################################################################
#Enable new mfa experience		   						V1.2.2
################################################################################

$url = "https://main.iam.ad.ext.azure.com/api/Directories/FeatureSettingsProperties"
$contentpart1 = '{"convergedUXV2FeatureValue":"2"}'
$content = $contentpart1
Invoke-RestMethod –Uri $url –Headers $headersazurerm –Method Put -Body $content -ErrorAction Stop

###############################################################################
#Enable / configure password reset	   						V1.2.2
################################################################################

$url = "https://main.iam.ad.ext.azure.com/api/PasswordReset/PasswordResetPolicies"
$contentpart1 = -join ('{"objectId":"default","enablementType":1,"numberOfAuthenticationMethodsRequired":1,"emailOptionEnabled":true,"mobilePhoneOptionEnabled":true,"officePhoneOptionEnabled":false,"securityQuestionsOptionEnabled":false,"mobileAppNotificationEnabled":false,"mobileAppCodeEnabled":false,"numberOfQuestionsToRegister":5,"numberOfQuestionsToReset":3,"registrationRequiredOnSignIn":true,"registrationReconfirmIntevalInDays":180,"skipRegistrationAllowed":true,"skipRegistrationMaxAllowedDays":7,"customizeHelpdeskLink":false,"customHelpdeskEmailOrUrl":"","notifyUsersOnPasswordReset":true,"notifyOnAdminPasswordReset":false,"passwordResetEnabledGroupIds":["',$ms365licensegroupid,'"],"passwordResetEnabledGroupName":"MS365BusinessLicences ","securityQuestions":[],"registrationConditionalAccessPolicies":[],"emailOptionAllowed":true,"mobilePhoneOptionAllowed":true,"officePhoneOptionAllowed":true,"securityQuestionsOptionAllowed":true,"mobileAppNotificationOptionAllowed":true,"mobileAppCodeOptionAllowed":true}')
$content = $contentpart1
Invoke-RestMethod –Uri $url –Headers $headersazurerm –Method Put -Body $content -ErrorAction Stop

