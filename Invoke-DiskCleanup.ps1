# ============================================
# Invoke-DiskCleanup.ps1
# Clears temp files, Windows temp folder,
# and empties the Recycle Bin.
# Run as Administrator.
# ============================================

Write-Host "`n===== DISK CLEANUP UTILITY =====" -ForegroundColor Cyan
Write-Host "Generated: $(Get-Date)`n" -ForegroundColor Gray

function Remove-TempFiles {
    param([string]$Path, [string]$Label)
    if (Test-Path $Path) {
        $before = (Get-ChildItem $Path -Recurse -Force -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum
        Get-ChildItem $Path -Recurse -Force -ErrorAction SilentlyContinue | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue
        $after = (Get-ChildItem $Path -Recurse -Force -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum
        $freed = [math]::Round(($before - $after) / 1MB, 2)
        Write-Host "  [$Label] Freed: ${freed} MB" -ForegroundColor Green
    } else {
        Write-Host "  [$Label] Path not found, skipping." -ForegroundColor Yellow
    }
}

Write-Host "[1] Cleaning User Temp Folder..." -ForegroundColor Yellow
Remove-TempFiles -Path $env:TEMP -Label "User Temp"

Write-Host "[2] Cleaning Windows Temp Folder..." -ForegroundColor Yellow
Remove-TempFiles -Path "C:\Windows\Temp" -Label "Windows Temp"

Write-Host "[3] Emptying Recycle Bin..." -ForegroundColor Yellow
Clear-RecycleBin -Force -ErrorAction SilentlyContinue
Write-Host "  [Recycle Bin] Emptied." -ForegroundColor Green

Write-Host "`n✅ Disk cleanup complete.`n" -ForegroundColor Cyan
