function add-to-domain {
	param (
	[string] $Domain,
	[string] $Password,
	[string] $Username
	)
    $secpass = ConvertTo-SecureString -String $password -AsPlainText -force
	$credential = New-Object System.Management.Automation.PSCredential $username, $secpass
	Add-Computer -DomainName $domain -Credential $credential
}
