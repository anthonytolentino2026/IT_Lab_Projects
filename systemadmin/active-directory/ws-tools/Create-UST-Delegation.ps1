$zoneName   = "ust.edu.ph"
$subdomains = @(
    #Example Subdomains:
    #"myusteportal", `
    #"student", `
    #...
)

$nsEntries = @(
    @{ Name = "ns1.p201.dns.oraclecloud.net"; IP = "108.59.166.201" },
    @{ Name = "ns2.p201.dns.oraclecloud.net"; IP = "108.59.168.201" },
    @{ Name = "ns3.p201.dns.oraclecloud.net"; IP = "108.59.170.201" },
    @{ Name = "ns4.p201.dns.oraclecloud.net"; IP = "108.59.172.201" }
)

Write-Host "=== DNS Delegation Automation for $zoneName ===" -ForegroundColor Green

# Step 1: Glue A records (safe to re-run)
Write-Host "`n[1/2] Adding/Checking Glue A Records..." -ForegroundColor Cyan
foreach ($ns in $nsEntries) {
    try {
        $rr = Get-DnsServerResourceRecord -ZoneName $zoneName -Name $ns.Name -RRType A -ErrorAction SilentlyContinue
        if ($rr -and $rr.RecordData.IPv4Address.IPAddressToString -eq $ns.IP) {
            Write-Host "  → Glue already exists: $($ns.Name) → $($ns.IP)" -ForegroundColor Yellow
        } else {
            Add-DnsServerResourceRecordA -ZoneName $zoneName -Name $ns.Name -IPv4Address $ns.IP -TimeToLive 01:00:00 -ErrorAction Stop
            Write-Host "  ✓ Added glue: $($ns.Name) → $($ns.IP)" -ForegroundColor Green
        }
    }
    catch {
        Write-Host "  ✗ Glue error for $($ns.Name): $($_.Exception.Message)" -ForegroundColor Red
    }
}

# Step 2: Delegations (create one NS record per call)
Write-Host "`n[2/2] Creating/Verifying Delegations..." -ForegroundColor Cyan
foreach ($sub in $subdomains) {
    Write-Host "`n  Handling delegation for $sub.$zoneName" -ForegroundColor White

    $addedCount = 0
    foreach ($ns in $nsEntries) {
        try {
            Add-DnsServerZoneDelegation -ZoneName $zoneName `
                -ChildZoneName $sub `
                -NameServer $ns.Name `
                -IPAddress $ns.IP `
                -ErrorAction Stop | Out-Null

            Write-Host "    ✓ Added NS: $($ns.Name) (IP: $($ns.IP))" -ForegroundColor Green
            $addedCount++
        }
        catch {
            $errMsg = $_.Exception.Message
            if ($errMsg -match "already exists" -or $errMsg -match "record already exists") {
                Write-Host "    → NS $($ns.Name) already delegated (skipping)" -ForegroundColor Yellow
                $addedCount++  # count as success for summary
            } else {
                Write-Host "    ✗ Error for $($ns.Name): $errMsg" -ForegroundColor Red
            }
        }
    }

    if ($addedCount -gt 0) {
        Write-Host "  ✓ Delegation setup complete for $sub.$zoneName ($addedCount/4 NS)" -ForegroundColor Green
    } else {
        Write-Host "  ✗ No NS added for $sub - check permissions or zone type" -ForegroundColor Red
    }
}

Write-Host "`n=== Script Finished ===" -ForegroundColor Green
Write-Host "Next steps:"
Write-Host "  • Run repadmin /syncall /A /e if you have multiple DCs"
Write-Host "  • On test client: ipconfig /flushdns"
Write-Host "  • Verify: nslookup myusteportal.ust.edu.ph  (should show public IPs like 104.18.15.162)"
Write-Host "  • Open DNS MMC → ust.edu.ph zone → expand → look for NS records under each subdomain (e.g., under myusteportal)"
Write-Host "  • If still not resolving: Check Event Viewer (DNS Server logs) or firewall outbound 53"
