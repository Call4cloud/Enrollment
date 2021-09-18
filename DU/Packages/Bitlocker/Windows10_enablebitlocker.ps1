##########################
#  create bitlocker.ps###
############################
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
Enable-BitLocker -MountPoint "C:" -EncryptionMethod XtsAes256 -UsedSpaceOnly -SkipHardwareTest -RecoveryPasswordProtector
$BLV = Get-BitLockerVolume -MountPoint "C:" | select *
BackupToAAD-BitLockerKeyProtector -MountPoint "C:" -KeyProtectorId $BLV.KeyProtector[1].KeyProtectorId
}
if($BLinfo.EncryptionPercentage -eq '100'){
$BLV = Get-BitLockerVolume -MountPoint "C:" | select *
BackupToAAD-BitLockerKeyProtector -MountPoint "C:" -KeyProtectorId $BLV.KeyProtector[1].KeyProtectorId
}
'@

##########################
# output content to file #
##########################
$path = $(Join-Path $env:ProgramData CustomScripts)
if (!(Test-Path $path))
{
New-Item -Path $path -ItemType Directory -Force -Confirm:$false
}
Out-File -FilePath $(Join-Path $env:ProgramData CustomScripts\enablebitlocker.ps1) -Encoding unicode -Force -InputObject $content -Confirm:$false

###########################################################
# register script as scheduled task to run at each logon  #
###########################################################

$Time = New-ScheduledTaskTrigger -AtLogOn
$User = "SYSTEM"
$Action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-ex bypass -file `"C:\ProgramData\CustomScripts\enablebitlocker.ps1`""
Register-ScheduledTask -TaskName "EnableBitlocker" -Trigger $Time -User $User -Action $Action -Force

################################
###Create Bitlocker Policies ###
################################

$BitLockerRegLoc = 'HKLM:\SOFTWARE\Policies\Microsoft'
New-Item -Path "$BitLockerRegLoc" -Name 'FVE'
New-ItemProperty -Path "$BitLockerRegLoc\FVE" -Name 'ActiveDirectoryBackup' -Value '00000001' -PropertyType DWORD
New-ItemProperty -Path "$BitLockerRegLoc\FVE" -Name 'RequireActiveDirectoryBackup' -Value '00000001' -PropertyType DWORD
New-ItemProperty -Path "$BitLockerRegLoc\FVE" -Name 'OSRequireActiveDirectoryBackup' -Value '00000001' -PropertyType DWORD
New-ItemProperty -Path "$BitLockerRegLoc\FVE" -Name 'OSRecovery' -Value '00000001' -PropertyType DWORD
New-ItemProperty -Path "$BitLockerRegLoc\FVE" -Name 'OSManageDRA' -Value '00000001' -PropertyType DWORD
New-ItemProperty -Path "$BitLockerRegLoc\FVE" -Name 'OSActiveDirectoryBackup' -Value '00000001' -PropertyType DWORD
New-ItemProperty -Path "$BitLockerRegLoc\FVE" -Name 'FDVRecovery' -Value '00000001' -PropertyType DWORD
New-ItemProperty -Path "$BitLockerRegLoc\FVE" -Name 'FDVManageDRA' -Value '00000000' -PropertyType DWORD
New-ItemProperty -Path "$BitLockerRegLoc\FVE" -Name 'FDVRecoveryPassword' -Value '00000002' -PropertyType DWORD
New-ItemProperty -Path "$BitLockerRegLoc\FVE" -Name 'FDVRecoveryKey' -Value '00000002' -PropertyType DWORD
New-ItemProperty -Path "$BitLockerRegLoc\FVE" -Name 'FDVActiveDirectoryBackup' -Value '00000001' -PropertyType DWORD
New-ItemProperty -Path "$BitLockerRegLoc\FVE" -Name 'FDVRequireActiveDirectoryBackup' -Value '00000001' -PropertyType DWORD
New-ItemProperty -Path "$BitLockerRegLoc\FVE" -Name 'OSActiveDirectoryInfoToStore' -Value '00000002' -PropertyType DWORD
New-ItemProperty -Path "$BitLockerRegLoc\FVE" -Name 'FDVActiveDirectoryInfoToStore' -Value '00000002' -PropertyType DWORD

############################################
###Eject all Media before bitlocker	 ###
############################################

#$Diskmaster = New-Object -ComObject IMAPI2.MsftDiscMaster2 
#$DiskRecorder = New-Object -ComObject IMAPI2.MsftDiscRecorder2 
#$DiskRecorder.InitializeDiscRecorder($DiskMaster) 
#$DiskRecorder.EjectMedia() 

$volumes = get-wmiobject -Class Win32_Volume | where{$_.drivetype -eq '2'}  
foreach($volume in $volumes){
$ejectCmd = New-Object -comObject Shell.Application
$ejectCmd.NameSpace(17).ParseName($volume.driveletter).InvokeVerb("Eject")
} 
################################
###Start bitlocker encryption###
################################

Start-ScheduledTask -TaskName "EnableBitlocker"









