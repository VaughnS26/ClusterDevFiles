function Configure-IIS {
    param (
    [bool]$ConfigSSL
    )

    # Begin installation process
    Install-WindowsFeature -name Web-Server -IncludeManagementTools
    if ($ConfigSSL)
    {
        Import-Module -name WebAdministration
        $hostName = $env:COMPUTERNAME
        $hostIP = (Get-NetAdapter | Get-NetIPAddress).IPv4Address | Out-String
        $cert = New-SelfSignedCertificate -DnsName $hostName,$hostIP -CertStoreLocation "cert:\LocalMachine\My"
        New-WebBinding -Name "Default Web Site" -IP "*" -Port 443 -Protocol https
        cd IIS:\SslBindings\
        get-item ("Cert:\LocalMachine\My\" + $cert.thumbprint) | new-item 0.0.0.0!443

    }



}
