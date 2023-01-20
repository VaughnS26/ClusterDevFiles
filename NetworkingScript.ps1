# This script parses the cloud-init networking data and updates the relevant settings.
# It should be run by a scheduled task on system startup after resetting the system
# This will also delete system reset scheduled task. That Scheduled task should be named "ResetSID"

$yamlText = Get-Content D:\OPENSTACK\CONTENT\0000 -Raw
If ($yamlText -match 'address\s((\d{1,3}\.){3}\d{1,3})') {
    $staticIp = $Matches.1
} Else {
    echo "Failed to find static ip address config line" $yamlText
}

If ($yamlText -match 'netmask\s((\d{1,3}\.){3}\d{1,3})') {
    $netmask = $Matches.1
    $prefixBits = 0
    $octets = $netmask.Split('.')
    #convert netmask to prefix
    foreach ($octet in $octets) {
        while (0 -ne $octet)
        {
            $octet = ($octet -shl 1) -band [byte]::MaxValue
            $prefixBits++;
        }
    }
} Else {
    echo "Failed to find netmask address config line" $yamlText
}
If ($yamlText -match 'gateway\s((\d{1,3}\.){3}\d{1,3})'){
    $gateway = $Matches.1
} Else {
    echo "Failed to find gateway address config line" $yamlText
}

If ($yamlText -match 'dns_nameservers\s((\d{1,3}\.){3}\d{1,3})\s((\d{1,3}\.){3}\d{1,3})') {
    $dnsServers = @($Matches.1, $Matches.3)
} ElseIf ($yamlText -match 'dns_nameservers\s((\d{1,3}\.){3}\d{1,3})') {
    $dnsServers = @($Matches.1)
} Else {
    echo "Failed to find dns server address config line" $yamlText
}
$openAdapter = (Get-NetAdapter | where status -eq 'Up')
$openAdapterIndex = $openAdapter.ifIndex
If (($openAdapter | Get-NetIPConfiguration).IPv4Address.IPAddress) {
    Remove-NetIPAddress -IpAddress (($openAdapter | Get-NetIPConfiguration).IPv4Address.IPAddress) -AddressFamily IPv4 -Confirm:$false
}
If (($openAdapter | Get-NetIPConfiguration).IPv4DefaultGateway) {
    $openAdapter | Remove-NetRoute -AddressFamily IPv4 -Confirm:$false
}

New-NetIPAddress -InterfaceIndex $openAdapterIndex -DefaultGateway $gateway -IPAddress $staticIp -PrefixLength $prefixBits
Set-DNSClientServerAddress -InterfaceIndex $openAdapterIndex -ServerAddresses $dnsServers
Set-NetConnectionProfile -InterfaceIndex $openAdapterIndex -NetworkCategory "Private"

C:\Windows\System32\schtasks.exe /delete /tn "ResetSID" /f