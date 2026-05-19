# ============================================
# Test-NetworkConnectivity.ps1
# Pings a list of hosts and logs results.
# Useful for basic uptime/connectivity checks.
# ============================================

$hosts = @(
    "8.8.8.8",        # Google DNS
    "1.1.1.1",        # Cloudflare DNS
    "google.com",
    "github.com",
    "microsoft.com"
)

Write-Host "`n===== NETWORK CONNECTIVITY CHECK =====" -ForegroundColor Cyan
Write-Host "Generated: $(Get-Date)`n" -ForegroundColor Gray

$results = foreach ($target in $hosts) {
    $ping = Test-Connection -ComputetName $target -Count 2 -ErrorAction SilentlyContinue
    $status = if ($ping) { "Online" } else { "Unreachable" }
    $avg    = if ($ping) { [math]::Round(($ping | Measure-Object ResponseTime -Average).Average, 1) } else { "N/A" }
    $color  = if ($status -eq "Online") { "Green" } else { "Red" }

    Write-Host "  $target — $status (Avg: ${avg}ms)" -ForegroundColor $color

    [PSCustomObject]@{
        Host           = $target
        Status         = $status
        AvgResponseMs  = $avg
        Timestamp      = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
    }
}

$exportPath = "$PSScriptRoot\NetworkCheck_$(Get-Date -Format 'yyyyMMdd_HHmm').csv"
$results | Export-Csv -Path $exportPath -NoTypeInformation
Write-Host "`n✅ Results saved to: $exportPath`n" -ForegroundColor Green
