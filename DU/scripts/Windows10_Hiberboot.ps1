$Path = "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Power"
$Name = "HiberbootEnabled"
$value = "0"
 
#Check if $Path exist. If not, create $Path and then add the item and set value.
 
If (!(Test-Path $Path))
 
{
    New-Item -Path $Path -Force | Out-Null
    New-ItemProperty -Path $Path -Name $Name -Value $value -PropertyType DWORD -Force | Out-Null
}
 
 ELSE
{
    New-ItemProperty -Path $Path -Name $Name -Value $value -PropertyType DWORD -Force | Out-Null
}