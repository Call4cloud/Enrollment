if (!(Test-Path -Path "$env:ProgramData\Chocolatey")) {
  Invoke-Expression((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1')) | out-null
}

start-process -wait -filepath "c:\programdata\chocolatey\choco.exe" -argumentlist "install gotomeeting -y"