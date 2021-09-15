###########################################################################
#        Versie:  1.0 (07-04-2021)
#        Script:  DU.2C
#        Apple MDM configureren  #
###########################################################################

#IOS_UserEnrollmentCOnfigureren

$body = @"
{"id":"74bff598-526e-40b5-95e0-2ca176acc8dc","displayName":"IOS_UserEnrollment","description":"","priority":0,"platform":"iOS","createdDateTime":"2021-03-25T09:36:38.7935651Z","lastModifiedDateTime":"2021-03-25T09:57:22Z","defaultEnrollmentType":"device","availableEnrollmentTypeOptions":[]}
"@
$apiurl = “
https://graph.microsoft.com/beta/deviceManagement/appleUserInitiatedEnrollmentProfiles”

$Data = Invoke-RestMethod -Headers @{Authorization = "Bearer $($accessToken1b)"} -Uri $apiUrl -Body $body -Method Post -ContentType 'application/json'

#assignment maken

$Data = Invoke-RestMethod -Headers @{Authorization = "Bearer $($accessToken1b)"} -Uri $apiUrl  -Method get 
$id = $data.value.id

$apiurl = “https://graph.microsoft.com/beta/deviceManagement/appleUserInitiatedEnrollmentProfiles/$id/assignments”

$body = @"
{"target":{"@odata.type":"#microsoft.graph.allLicensedUsersAssignmentTarget"}}
"@
$Data = Invoke-RestMethod -Headers @{Authorization = "Bearer $($accessToken1b)"} -Uri $apiUrl -Body $body -Method Post -ContentType 'application/json'
