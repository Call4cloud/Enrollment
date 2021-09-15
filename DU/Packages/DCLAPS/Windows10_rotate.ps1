$content = @'
function Get-RandomCharacters($length, $characters) {
    $random = 1..$length | ForEach-Object { Get-Random -Maximum $characters.length }
    $private:ofs=""
    return [String]$characters[$random]
}
 
function Scramble-String([string]$inputString){     
    $characterArray = $inputString.ToCharArray()   
    $scrambledStringArray = $characterArray | Get-Random -Count $characterArray.Length     
    $outputString = -join $scrambledStringArray
    return $outputString 
}
$password = Get-RandomCharacters -length 8 -characters  'abcdefghiklmnoprstuvwxyz'
$password += Get-RandomCharacters -length 2 -characters  'ABCDEFGHKLMNOPRSTUVWXYZ'
$password += Get-RandomCharacters -length 3 -characters '1234567890'
$password += Get-RandomCharacters -length 1 -characters '!$%&/()=?@#*+'
net user admin $password
$registryPath = "HKLM:\SOFTWARE\Microsoft\DCLAPS"
New-Item -Path $registryPath
$name = "lapsww"
$value = $password
New-ItemProperty -Path $registryPath -Name $name -Value $value -Force | Out-Null

#Change Register permissions
$path = 'HKLM:\software\microsoft\dclaps'
#breaks inheritens.
$acl = (Get-Item $path).GetAccessControl('Access')
$acl.SetAccessRuleProtection($true,$true)
set-acl $path -AclObject $acl
#removes all access rules based on 'BUILTIN\Users'
$acl = (Get-Item $path).GetAccessControl('Access')
$acl.Access |where {$_.IdentityReference -eq 'INGEBOUWD\Gebruikers'} |%{$acl.RemoveAccessRule($_)}
set-acl $path -AclObject $acl
'@

# create custom folder and write PS script
$path = $(Join-Path $env:ProgramData CustomScripts)
if (!(Test-Path $path))
{
New-Item -Path $path -ItemType Directory -Force -Confirm:$false
}
Out-File -FilePath $(Join-Path $env:ProgramData CustomScripts\rotate.ps1) -Encoding unicode -Force -InputObject $content -Confirm:$false

# register script as scheduled task
$Time = New-ScheduledTaskTrigger -At 11:00AM -Weekly -WeeksInterval 4 -DaysOfWeek Monday
$User = "SYSTEM"
$Action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-ex bypass -file `"C:\ProgramData\CustomScripts\rotate.ps1`""
Register-ScheduledTask -TaskName "Rotate" -Trigger $Time -User $User -Action $Action -Force 
Set-ScheduledTask -taskname "Rotate" -Settings $(New-ScheduledTaskSettingsSet -StartWhenAvailable -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries)
Start-ScheduledTask -TaskName "Rotate"

