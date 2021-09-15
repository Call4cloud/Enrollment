md "c:\program files (x86)\ico"
copy .\intune.ico "c:\program files (x86)\ico\deltacom.ico"

#Create Shortcut Desktops
if (-not (Test-Path "C:\Users\Public\Desktop\Deltacom-Helpdesk.url"))
{
$null = $WshShell = New-Object -comObject WScript.Shell
$path = "C:\Users\Public\Desktop\Deltacom-Helpdesk.url"
$targetpath = "c:\windows\system32\quickassist.exe"
$iconlocation = "c:\program files (x86)\ico\deltacom.ico"
$iconfile = "IconFile=" + $iconlocation
$Shortcut = $WshShell.CreateShortcut($path)
$Shortcut.TargetPath = $targetpath
$Shortcut.Save()

Add-Content $path "HotKey=0"
Add-Content $path "$iconfile"
Add-Content $path "IconIndex=0"
}

