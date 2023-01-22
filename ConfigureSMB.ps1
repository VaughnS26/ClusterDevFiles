function Configure-SMB{
    
    param(
        [string] $Name = "Files",
        [string] $Path = "C:\"
        )

    $Parameters = @{
    Name = $name
    Path = $path
    FullAccess = "Everyone"

    }
    if (!(Test-Path $path -PathType Container)) {
    New-Item -ItemType Directory -Force -Path $path
}

    New-SmbShare @Parameters
}
