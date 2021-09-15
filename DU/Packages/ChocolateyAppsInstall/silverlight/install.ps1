if (!(Test-Path -Path "$env:ProgramData\Chocolatey")) {
  Invoke-Expression((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
}
$ChocoPackages = @("silverlight")
$chocoinstall = Get-Command -Name 'choco' -ErrorAction SilentlyContinue -WarningAction SilentlyContinue | Select-Object -ExpandProperty Source
foreach($Package in $ChocoPackages) {
     try {
         Invoke-Expression “cmd.exe /c $ChocoInstall Install $Package -y” -ErrorAction Stop
     }
     catch {
         Throw “Failed to install $Package”
     }
}

New-Item -Path "c:\" -Name "temp" -ItemType "directory" -force
$path = "c:\temp"
New-Item -path $path -name "chocosilverlight.txt" -ItemType file -force
