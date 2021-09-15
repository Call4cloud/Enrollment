###########################################################################
#        Versie:  1.0 (07-04-2021)
#        Script:  DU.1d
#        Autopilot profile assigment
###########################################################################
#Autopilot profile assigment

$autopilotprofile = Get-autopilotprofile 
$autopilotprofileid1 = $autopilotprofile[0].id


$body = @"
{"target":{"@odata.type":"#microsoft.graph.groupAssignmentTarget","groupId":"$autopilotstaticgroupid"}}
"@
$apiurl = 
"https://graph.microsoft.com/beta/deviceManagement/windowsAutopilotDeploymentProfiles/$autopilotprofileid1/assignments"
$Data = Invoke-RestMethod -Headers @{Authorization = "Bearer $($accessToken1b)"} -Uri $apiUrl -Body $body -Method Post -ContentType 'application/json'

