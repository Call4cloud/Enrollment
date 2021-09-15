$content = @'
Windows Registry Editor Version 5.00
[HKEY_CURRENT_USER\Software\Microsoft\OneDrive]
"SilentBusinessConfigCompleted"="0"
"EnableAdal"=dword:00000001
"EnableTeamTier_Internal"=dword:00000001
[HKEY_CURRENT_USER\Software\Microsoft\OneDrive\Accounts\Business1]
"EnableADALForSilentBusinessConfig"=dword:00000001
"TimerAutoMount"=hex(b):01,00,00,00,00,00,00,00
[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Office\16.0\Common\Identity]
"EnableAdal"=dword:00000001
[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Office\16.0\Common\Licensing]
"EulasSetAccepted"="16.0,"
'@

 
# create custom folder and write PS script
$path = $(Join-Path $env:ProgramData CustomScripts)
if (!(Test-Path $path))
{
New-Item -Path $path -ItemType Directory -Force -Confirm:$false
}
Out-File -FilePath $(Join-Path $env:ProgramData CustomScripts\onedrive.reg) -Encoding unicode -Force -InputObject $content -Confirm:$false
 
# register script as scheduled task
$WshShell = New-Object -comObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("$env:ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp\config.lnk")
$Shortcut.TargetPath = '"c:\windows\System32\reg.exe"'
$Shortcut.Arguments = "import c:\programdata\CustomScripts\onedrive.reg"
$Shortcut.WorkingDirectory = '"c:\programdata\CustomScripts\"'
$Shortcut.Save()