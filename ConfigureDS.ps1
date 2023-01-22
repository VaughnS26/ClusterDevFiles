#needs AD-Domain-Services to be installed in order to function and a forest to have been created
#Currently untested
function Configure-DS {

    param(
        [string] $DomainName,
        [string] $Password
        )

    #Install DNS features if not there
    Install-WindowsFeature AD-Domain-Services -IncludeManagementTools
    $pw = ConvertTo-SecureString $password -AsPlainText -Force
    $domainName -Match "([^.]*)(\.|$)"
    $netbiosName = $Matches.1
    Install-ADDSForest -DomainName $domainName -DomainNetbiosName $netbiosName -InstallDNS -Force -SafeModeAdministratorPassword $pw
}
