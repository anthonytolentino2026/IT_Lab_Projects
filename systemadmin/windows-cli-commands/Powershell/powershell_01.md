# PowerShell 01: Installing AD-Domain-Services and Creating a User

## Instruction 1: Install AD Domain Services

```powershell
Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools
```

This installs **Active Directory Domain Services (AD DS)** and **Active Directory Lightweight Directory Services (AD LDS)**. It also installs management tools such as **Active Directory Users and Computers (ADUC)**.

The parameter `-IncludeManagementTools` ensures the server includes the required administrative tools for managing Active Directory.

---

### View Available AD DS Deployment Cmdlets

```powershell
Get-Command -Module ADDSDeployment
```

Use this command to list available cmdlets and optional parameters related to AD DS deployment. These parameters are commonly used when:

- Promoting a server to a **Domain Controller**
- Joining a server to an **existing domain**
- Creating a **new forest**

If this is the **first installation** of Active Directory in the environment, use:

```powershell
Install-ADDSForest
```

---

## Instruction 2: Create a New Active Directory User

```powershell
New-ADUser
```

This command allows you to create a new Active Directory user through PowerShell.

When creating users, several important parameters are commonly required:

| Parameter | Description |
|----------|-------------|
| `-Name` | Name of the user |
| `-GivenName` | First name of the user |
| `-Surname` | Last name of the user |
| `-SamAccountName` | User logon account (legacy username) |
| `-UserPrincipalName` | User logon account with domain suffix |
| `-AccountPassword` | User password (SecureString format required) |
| `-Enabled` | Enables the user account (`$true` or `$false`) |
| `-PasswordNeverExpires` | Prevents password expiration |

---

### Convert Password to Secure String

Before assigning a password to a user, convert it to a **SecureString** format:

```powershell
$Password = "Password123!" | ConvertTo-SecureString -AsPlainText -Force
```

This variable can then be used with the `New-ADUser` cmdlet.

---

### Example: Create a New User

```powershell
$Password = "AdminP@ssW0rd2026" | ConvertTo-SecureString -AsPlainText -Force

New-ADUser \
-Name "Michael" \
-GivenName "Michael Frank" \
-Surname "Jackson" \
-SamAccountName "MFJackson103" \
-UserPrincipalName "michaelFrankJackson@netcorp.local" \
-AccountPassword $Password \
-Enabled $true \
-PasswordNeverExpires $true
```

---

### Verify the User Exists

```powershell
Get-ADUser -Identity MFJackson103
```

Use this command to confirm that the user exists and to retrieve user information.

---

### Remove a User from Active Directory

```powershell
Remove-ADUser -Identity MFJackson103
```

This command removes the specified user from Active Directory.

---

## References

### Install AD DS Using PowerShell

https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/deploy/install-active-directory-domain-services--level-100-

### New-ADUser Cmdlet

https://learn.microsoft.com/en-us/powershell/module/activedirectory/new-aduser?view=windowsserver2025-ps

### Get-ADUser Cmdlet

https://learn.microsoft.com/en-us/powershell/module/activedirectory/get-aduser?view=windowsserver2025-ps

### Remove-ADUser Cmdlet

https://learn.microsoft.com/en-us/powershell/module/activedirectory/remove-aduser?view=windowsserver2025-ps

