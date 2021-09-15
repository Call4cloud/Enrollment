$content = @'
Get-Service -Name IntuneManagementExtension | Restart-Service
'@

 
# create custom folder and write PS script
$path = $(Join-Path $env:ProgramData CustomScripts)
if (!(Test-Path $path))
{
New-Item -Path $path -ItemType Directory -Force -Confirm:$false
}
Out-File -FilePath $(Join-Path $env:ProgramData CustomScripts\restartservice.ps1) -Encoding unicode -Force -InputObject $content -Confirm:$false


$triggers = @()
$triggers += New-ScheduledTaskTrigger -At (get-date) -Once -RepetitionInterval (New-TimeSpan -Minutes 30)
$triggers += New-ScheduledTaskTrigger -AtLogOn
$User = "SYSTEM"
$Action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-ex bypass -file `"C:\ProgramData\CustomScripts\restartservice.ps1`""
Register-ScheduledTask -TaskName "Restartservice" -Trigger $triggers -User $User -Action $Action -Force

