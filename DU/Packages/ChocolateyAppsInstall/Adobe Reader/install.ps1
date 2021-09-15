if (!(Test-Path -Path "$env:ProgramData\Chocolatey")) {
  Invoke-Expression((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
}
$chocoinstall = Get-Command -Name 'choco' -ErrorAction SilentlyContinue -WarningAction SilentlyContinue | Select-Object -ExpandProperty Source

$ChocoPackages = @("adobereader")
foreach($Package in $ChocoPackages) {
     try {
         Invoke-Expression “cmd.exe /c c:\ProgramData\Chocolatey\choco.exe Install $Package --ignore-checksums -y” -ErrorAction Stop
     }
     catch {
         Throw “Failed to install $Package”
     }
}

New-Item -Path "c:\" -Name "temp" -ItemType "directory" -force
$path = "c:\temp"
New-Item -path $path -name "adobereader.txt" -ItemType file -force
