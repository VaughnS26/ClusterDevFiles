function Enable-RDP {
    param (
        [string[]] $Users
    )
    Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server' -name "fDenyTSConnections" -value 0
    Enable-NetFirewallRule -DisplayGroup "Remote Desktop"
    
    foreach ($User in $Users) {
        Add-LocalGroupMember -Group "Remote Desktop Users" -Member $User
    }
}

# Change users to actual users
Enable-RDP -Users user1, user2