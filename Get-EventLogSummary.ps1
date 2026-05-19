# ============================================
# Get-EventLogSummary.ps1
# Pulls recent critical/error events from
# System and Application logs and exports a report.
# ============================================

param(
    [int]$HoursBack = 24,
    [string]$LogName = "System"
)

Write-Host "`n===== EVENT LOG SUMMARY =====" -ForegroundColor Cyan
Write-Host "Log: $LogName | Last $HoursBack hours | Generated: $(Get-Date)`n" -ForegroundColor Gray

$startTime = (Get-Date).AddHours(-$HoursBack)

$events = Get-WinEvent -FilterHashtable @{
    LogName   = $LogName
    Level     = 1, 2       # 1 = Critical, 2 = Error
    StartTime = $startTime
} -ErrorAction SilentlyContinue

if (-not $events) {
    Write-Host "  No critical or error events found in the last $HoursBack hours.`n" -ForegroundColor Green
    exit
}

$report = $events | Select-Object TimeCreated, Id, LevelDisplayName, ProviderName, Message |
    Sort-Object TimeCreated -Descending

$report | Format-Table TimeCreated, Id, LevelDisplayName, ProviderName -AutoSize

# Export
$exportPath = "$PSScriptRoot\EventLog_${LogName}_$(Get-Date -Format 'yyyyMMdd').csv"
$report | Export-Csv -Path $exportPath -NoTypeInformation
Write-Host "✅ Full report exported to: $exportPath`n" -ForegroundColor Green
