net user Administrator Server2019
net user Administrator /active:yes


$DomainName = "yourdomain.com"
$DomainMode = "7"
$ForestMode = "7"
$DatabasePath = "C:\Windows\NTDS"
$SysvolPath = "C:\Windows\SYSVOL"
$LogPath = "C:\Logs"

$IPAddress = "172.27.160.8"
$Gateway = "172.27.160.1"
$DNS1 = "127.0.0.1"

New-NetIPAddress –IPAddress $IPAddress -DefaultGateway $Gateway -PrefixLength 24 -InterfaceIndex (Get-NetAdapter).InterfaceIndex
Set-DNSClientServerAddress –InterfaceIndex (Get-NetAdapter).InterfaceIndex –ServerAddresses $DNS1

Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools

Install-ADDSForest -CreateDnsDelegation:$false `
    -SafeModeAdministratorPassword (Convertto-SecureString -AsPlainText "Server2019" -Force) `
    -DatabasePath $DatabasePath `
    -LogPath $LogPath `
    -SysvolPath $SysvolPath `
    -DomainName $DomainName `
    -DomainMode $DomainMode `
    -ForestMode $ForestMode `
    -InstallDNS:$true `
    -NoRebootOnCompletion:$true `
    -Force:$true

Restart-Computer

