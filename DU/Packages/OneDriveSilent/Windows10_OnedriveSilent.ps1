$content = @'
$registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\OneDrive"
$Name1 = "SilentAccountConfig"
New-ItemProperty -Path $registryPath -Name $name1 -Value 1 -PropertyType DWord -Force
gpupdate /force
'@

Out-File -FilePath $(Join-Path $env:ProgramData CustomScripts\onedrivesilent.ps1) -Encoding unicode -Force -InputObject $content -Confirm:$false
 
New-Item -Path "c:\" -Name "temp" -ItemType "directory" -force
$path = "c:\temp"
New-Item -path $path -name "onedrivesilent.txt" -ItemType file -force

# register script as scheduled task
$Time = New-ScheduledTaskTrigger -AtLogOn
$User = "SYSTEM"
$Action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-ex bypass -file `"C:\ProgramData\CustomScripts\onedrivesilent.ps1`" -Verb RunAs"
Register-ScheduledTask -TaskName "onedrivesilent" -Trigger $Time -User $User -Action $Action -Force
Start-ScheduledTask -TaskName "onedrivesilent"