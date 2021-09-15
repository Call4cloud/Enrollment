$content = @'
$BLinfo = Get-Bitlockervolume
if($BLinfo.EncryptionPercentage -ne '100' -and $BLinfo.EncryptionPercentage -ne '0'){
Resume-BitLocker -MountPoint "C:"
$BLV = Get-BitLockerVolume -MountPoint "C:" | select *
BackupToAAD-BitLockerKeyProtector -MountPoint "C:" -KeyProtectorId $BLV.KeyProtector[1].KeyProtectorId
}
if($BLinfo.VolumeStatus -eq 'FullyEncrypted' -and $BLinfo.ProtectionStatus -eq 'Off'){
Resume-BitLocker -MountPoint "C:"
$BLV = Get-BitLockerVolume -MountPoint "C:" | select *
BackupToAAD-BitLockerKeyProtector -MountPoint "C:" -KeyProtectorId $BLV.KeyProtector[1].KeyProtectorId
}
if($BLinfo.EncryptionPercentage -eq '0'){
Enable-BitLocker -MountPoint "C:" -EncryptionMethod XtsAes128 -UsedSpaceOnly -SkipHardwareTest -RecoveryPasswordProtector
$BLV = Get-BitLockerVolume -MountPoint "C:" | select *
BackupToAAD-BitLockerKeyProtector -MountPoint "C:" -KeyProtectorId $BLV.KeyProtector[1].KeyProtectorId
}
'@

Out-File -FilePath "C:\ProgramData\CustomScripts\enablebitlocker.ps1" -Encoding unicode -Force -InputObject $content

 
# create custom folder and write PS script
$path = $(Join-Path $env:ProgramData CustomScripts)
if (!(Test-Path $path))
{
New-Item -Path $path -ItemType Directory -Force -Confirm:$false
}
Out-File -FilePath $(Join-Path $env:ProgramData CustomScripts\enablebitlocker.ps1) -Encoding unicode -Force -InputObject $content -Confirm:$false
 
# register script as scheduled task
$Time = New-ScheduledTaskTrigger -AtLogOn
$User = "SYSTEM"
$Action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-ex bypass -file `"C:\ProgramData\CustomScripts\enablebitlocker.ps1`""
Register-ScheduledTask -TaskName "EnableBitlocker" -Trigger $Time -User $User -Action $Action -Force
Start-ScheduledTask -TaskName "EnableBitlocker"