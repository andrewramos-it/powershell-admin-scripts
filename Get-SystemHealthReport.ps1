# ============================================
# Get-SystemHealthReport.ps1
# Checks CPU, memory, and disk usage and
# outputs a summary report with alerts.
# ============================================

$threshold_cpu = 80
$threshold_mem = 80
$threshold_disk = 85

Write-Host "`n===== SYSTEM HEALTH REPORT =====" -ForegroundColor Cyan
Write-Host "Generated: $(Get-Date)" -ForegroundColor Gray

# --- CPU ---
$cpu = (Get-CimInstance -ClassName Win32_Processor | Measure-Object -Property LoadPercentage -Average).Average
$cpuColor = if ($cpu -ge $threshold_cpu) { "Red" } else { "Green" }
Write-Host "`n[CPU Usage]" -ForegroundColor Yellow
Write-Host "  Current Load: $cpu%" -ForegroundColor $cpuColor
if ($cpu -ge $threshold_cpu) { Write-Host "  ⚠️  ALERT: CPU usage is high!" -ForegroundColor Red }

# --- Memory ---
$os = Get-CimInstance -ClassName Win32_OperatingSystem
$totalMem = [math]::Round($os.TotalVisibleMemorySize / 1MB, 2)
$freeMem  = [math]::Round($os.FreePhysicalMemory / 1MB, 2)
$usedMem  = [math]::Round($totalMem - $freeMem, 2)
$memPct   = [math]::Round(($usedMem / $totalMem) * 100, 1)
$memColor = if ($memPct -ge $threshold_mem) { "Red" } else { "Green" }
Write-Host "`n[Memory Usage]" -ForegroundColor Yellow
Write-Host "  Total: ${totalMem} GB  |  Used: ${usedMem} GB  |  Free: ${freeMem} GB" -ForegroundColor $memColor
Write-Host "  Usage: $memPct%" -ForegroundColor $memColor
if ($memPct -ge $threshold_mem) { Write-Host "  ⚠️  ALERT: Memory usage is high!" -ForegroundColor Red }

# --- Disk ---
Write-Host "`n[Disk Usage]" -ForegroundColor Yellow
Get-PSDrive -PSProvider FileSystem | Where-Object { $_.Used -gt 0 } | ForEach-Object {
    $total = [math]::Round(($_.Used + $_.Free) / 1GB, 2)
    $used  = [math]::Round($_.Used / 1GB, 2)
    $pct   = [math]::Round(($_.Used / ($_.Used + $_.Free)) * 100, 1)
    $diskColor = if ($pct -ge $threshold_disk) { "Red" } else { "Green" }
    Write-Host "  Drive $($_.Name): ${used}GB used of ${total}GB ($pct%)" -ForegroundColor $diskColor
    if ($pct -ge $threshold_disk) { Write-Host "  ⚠️  ALERT: Drive $($_.Name) is almost full!" -ForegroundColor Red }
}

Write-Host "`n================================`n" -ForegroundColor Cyan
