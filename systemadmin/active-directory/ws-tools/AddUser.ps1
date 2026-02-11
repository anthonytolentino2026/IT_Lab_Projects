# =============================================
# Improved AD User Creation Script - FIXED for UPN
# =============================================

Import-Module ActiveDirectory -ErrorAction Stop

Add-Type -AssemblyName System.Windows.Forms

# File picker dialog
$dialog = New-Object System.Windows.Forms.OpenFileDialog
$dialog.InitialDirectory = "C:\"
$dialog.Filter = "CSV files (*.csv)|*.csv"
$dialog.Title = "Select your CSV file with user data"
$result = $dialog.ShowDialog()

if ($result -ne "OK") {
    Write-Host "No file selected. Exiting." -ForegroundColor Yellow
    exit
}

$CSVFile = $dialog.FileName

if (-not (Test-Path $CSVFile)) {
    Write-Host "File not found: $CSVFile" -ForegroundColor Red
    exit
}

Write-Host "Reading CSV file..." -ForegroundColor Cyan
try {
    $users = Import-Csv -Path $CSVFile -ErrorAction Stop
} catch {
    Write-Host "Error reading CSV: $($_.Exception.Message)" -ForegroundColor Red
    exit
}

$createdCount = 0
$failedCount   = 0
$skippedCount  = 0

foreach ($user in $users) {
    $first = if ($user.'FirstName') { $user.'FirstName'.Trim() } else { "" }
    $last  = if ($user.'LastName')  { $user.'LastName'.Trim()  } else { "" }

    if ([string]::IsNullOrWhiteSpace($first) -or [string]::IsNullOrWhiteSpace($last)) {
        Write-Host "SKIP: Missing FirstName or LastName → $($user.'FirstName') $($user.'LastName')" -ForegroundColor Yellow
        $failedCount++
        continue
    }

    # Safe substring
    $fnPart = if ($first.Length -ge 7) { $first.Substring(0,7) } else { $first }
    $lnPart = if ($last.Length  -ge 6) { $last.Substring(0,6)  } else { $last }

    # Build base SamAccountName
    $samBase = "$fnPart.$lnPart".Replace(" ","").ToLower()

    # Start with base name
    $samAccountName = $samBase
    $originalSam    = $samBase
    $counter        = 1

    # Safe duplicate check with apostrophe escaping
    do {
        # Escape single quotes for LDAP filter ( ' → '')
        $escapedSam = $samAccountName.Replace("'", "''")
        $filter = "SamAccountName -eq '{0}'" -f $escapedSam

        $exists = Get-ADUser -Filter $filter -ErrorAction SilentlyContinue

        if ($exists) {
            $samAccountName = "$originalSam$counter"
            $counter++
        }
    } while ($exists)

    $fullName = "$first $last"

    try {
        $params = @{
            Name               = $fullName
            GivenName          = $first
            Surname            = $last
            UserPrincipalName  = $user.'Email'                   # FIXED: Use Email column for UPN
            EmailAddress       = $user.'Email'
            SamAccountName     = $samAccountName
            Path               = $user.'Organizational Unit'
            AccountPassword    = (ConvertTo-SecureString $user.'Password' -AsPlainText -Force)
            ChangePasswordAtLogon = $true
            Enabled            = [System.Convert]::ToBoolean($user.Enabled)
            ErrorAction        = 'Stop'
        }

        New-ADUser @params

        Write-Host "SUCCESS: $samAccountName / $($user.'Email')" -ForegroundColor Green
        $createdCount++
    }
    catch {
        Write-Host "FAILED: $samAccountName / $($user.'Email')" -ForegroundColor Red
        Write-Host "   Error: $($_.Exception.Message)" -ForegroundColor Red
        
        if ($_.Exception.Message -match "already (exists|in use)") {
            Write-Host "   (Hint: Account may already exist)" -ForegroundColor DarkYellow
        }
        
        $failedCount++
    }
}

Write-Host "`n======================================" -ForegroundColor Cyan
Write-Host "           Script Finished           " -ForegroundColor Cyan
Write-Host "======================================" -ForegroundColor Cyan
Write-Host "Created successfully : $createdCount users" -ForegroundColor Green
Write-Host "Failed / Skipped     : $failedCount users" -ForegroundColor Red
Write-Host ""
Read-Host "Press Enter to exit"
