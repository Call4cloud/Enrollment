$content = @'
$administrators = @( ([ADSI]"WinNT://./Administrators").psbase.Invoke('Members') | % { $_.GetType().InvokeMember('AdsPath','GetProperty',$null,$($_),$null) } ) -match '^WinNT'; 
$administrators = $administrators -replace "WinNT://","" 
foreach($administrator in $administrators) { if ($administrator -like "$env:COMPUTERNAME/administrator" -or $administrator -like "AzureAd/*" -or $administrator -like "$env:COMPUTERNAME/deltacom") { continue; } Remove-LocalGroupMember -group "administrators" -member $administrator }
# get accounts to remove
$remove = net localgroup administrators | select -skip 6 | ? {$_ -and $_ -notmatch 'De opdracht is voltooid.|^deltacom$|^administrator$|^admin$'}
#remove the accounts
foreach ($user in $remove) {
    net localgroup administrators "`"$user`"" /delete
}
$username = "deltacom"
if ($(Get-LocalGroupMember -Group "Administrators").Name -notcontains "$env:ComputerName\$username") {
    remove-LocalGroupMember -Group "Administrators" -Member $username}
$username = "admin"
if ($(Get-LocalGroupMember -Group "Administrators").Name -notcontains "$env:ComputerName\$username") {
    Add-LocalGroupMember -Group "Administrators" -Member $username}
get-localuser | Set-localUser -PasswordNeverExpires:$True
'@

 
# create custom folder and write PS script
$path = $(Join-Path $env:ProgramData CustomScripts)
if (!(Test-Path $path))
{
New-Item -Path $path -ItemType Directory -Force -Confirm:$false
}
Out-File -FilePath $(Join-Path $env:ProgramData CustomScripts\myScript.ps1) -Encoding unicode -Force -InputObject $content -Confirm:$false
 
# register script as scheduled task
$Time = New-ScheduledTaskTrigger -AtLogOn
$User = "SYSTEM"
$Action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-ex bypass -file `"C:\ProgramData\CustomScripts\myScript.ps1`""
Register-ScheduledTask -TaskName "RemoveAdmin" -Trigger $Time -User $User -Action $Action -Force
Start-ScheduledTask -TaskName "RemoveAdmin"
