Invoke-Expression ((New-Object net.webclient).DownloadString('https://chocolatey.org/install.ps1')) -ErrorAction Stop
$ChocoPackages = @("adobereader")
$chocoinstall = Get-Command -Name 'choco' -ErrorAction SilentlyContinue -WarningAction SilentlyContinue | Select-Object -ExpandProperty Source

foreach($Package in $ChocoPackages) {
     try {
         Invoke-Expression “cmd.exe /c $ChocoInstall Install $Package -y” -ErrorAction Stop
     }
     catch {
         Throw “Failed to install $Package”
     }
}

##Create A scheduled task to Update all packages each day at 12:00
choco install choco-upgrade-all-at --params "'/DAILY:yes /TIME:12:00 /ABORTTIME:14:00'"  -y

New-Item -Path "c:\" -Name "temp" -ItemType "directory" -force
$path = "c:\temp"
New-Item -path $path -name "chocoinstall.txt" -ItemType file -force
