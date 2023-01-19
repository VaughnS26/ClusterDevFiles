function Configure-winrm{
    param (
    [bool]$configSSL
    )
	echo "y" | winrm quickconfig
    If ($configSSL) {
        
        $hostName = $env:COMPUTERNAME
        $hostIP = (Get-NetAdapter | Get-NetIPAddress).IPv4Address | Out-String
        $cert = New-SelfSignedCertificate -DnsName $hostName,$hostIP -CertStoreLocation "cert:\LocalMachine\My"
        New-Item -Path WSMan:\localhost\Listener -Transport HTTTPS -Address * -CertificateThumbPrint $cert.Thumbprint -Force
        New-NetFirewallRule -DisplayName 'winrm' -Name 'winrm' -Profile Any -LocalPort 5986 -Protocol TCP -Action Allow
        Restart-Service WinRM

    }
}

#I think this will setup winRM, didn't know if I should do something else.
