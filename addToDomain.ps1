function add-to-domain {
	param (
	[string] $domain,
	[string] $user,
	[string] $password,
	[string] $username
	)
    $secpass = ConvertTo-SecureString -String $password -AsPlainText -force
	$credential = New-Object System.Management.Automation.PSCredential $username, $secpass
	Add-Computer -DomainName $domain -Credential $credential
}
