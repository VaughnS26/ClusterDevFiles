function setUpMSSQL {
	[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
	Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
	Install-Module -Name SqlServerDsc -Force
	Install-Module -Name SqlServer -Force -AllowClobber
}
