# Define the OU
$OU = "OU=CICS-Students,DC=ust,DC=edu,DC=ph"

# Define the new password for all users
$NewPassword = "NewP@ssw0rd123"

# Get all users in the OU
$Users = Get-ADUser -Filter * -SearchBase $OU

foreach ($User in $Users) {
    try {
        # Reset password
        Set-ADAccountPassword -Identity $User -Reset -NewPassword (ConvertTo-SecureString $NewPassword -AsPlainText -Force)
        
        # Force change at next logon
        Set-ADUser -Identity $User -ChangePasswordAtLogon $true

        Write-Host "✅ Password reset for $($User.SamAccountName)"
    }
    catch {
        Write-Warning "⚠ Failed to reset password for $($User.SamAccountName): $_"
    }
}
