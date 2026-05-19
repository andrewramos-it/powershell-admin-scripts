# ============================================
# Get-LocalUserAudit.ps1
# Lists all local user accounts, their status,
# last logon, and flags disabled or stale accounts.
# ============================================

Write-Host "`n===== LOCAL USER AUDIT =====" -ForegroundColor Cyan
Write-Host "Generated: $(Get-Date)`n" -ForegroundColor Gray

$users = Get-LocalUser

$report = foreach ($user in $users) {
    $lastLogon = if ($user.LastLogon) { $user.LastLogon.ToString("yyyy-MM-dd HH:mm") } else { "Never" }
    $status    = if ($user.Enabled) { "Active" } else { "Disabled" }
    $stale     = if ($user.LastLogon -and ((Get-Date) - $user.LastLogon).Days -gt 90) { "Yes" } else { "No" }

    [PSCustomObject]@{
        Username       = $user.Name
        FullName       = $user.FullName
        Status         = $status
        LastLogon      = $lastLogon
        StaleAccount   = $stale
        PasswordExpires = $user.PasswordExpires
    }
}

$report | Format-Table -AutoSize

# Export to CSV
$exportPath = "$PSScriptRoot\UserAudit_$(Get-Date -Format 'yyyyMMdd').csv"
$report | Export-Csv -Path $exportPath -NoTypeInformation
Write-Host "✅ Report exported to: $exportPath`n" -ForegroundColor Green
