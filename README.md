# 🛠️ PowerShell Admin Scripts

A collection of PowerShell scripts for common Windows system administration and IT support tasks. Built to demonstrate practical sysadmin skills including system monitoring, user auditing, log analysis, and network diagnostics.

---

## 📋 Scripts

| Script | Description |
|---|---|
| `Get-SystemHealthReport.ps1` | Reports CPU, memory, and disk usage with threshold alerts |
| `Get-LocalUserAudit.ps1` | Audits local user accounts, flags disabled/stale accounts, exports CSV |
| `Invoke-DiskCleanup.ps1` | Clears temp folders and Recycle Bin, reports space freed |
| `Get-EventLogSummary.ps1` | Parses Windows Event Logs for critical/error events, exports CSV |
| `Test-NetworkConnectivity.ps1` | Pings target hosts and logs connectivity status and response times |

---

## ⚙️ Requirements

- Windows 10/11 or Windows Server 2016+
- PowerShell 5.1 or later
- Some scripts require **Run as Administrator**

---

## 🚀 How to Use

1. Clone or download the repo
2. Open PowerShell as Administrator
3. Navigate to the script folder:
```powershell
   cd C:\path\to\powershell-admin-scripts
```
4. Run any script directly:
```powershell
   .\Get-SystemHealthReport.ps1
```

> **Note:** You may need to set your execution policy first:
> ```powershell
> Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
> ```

---

## 📁 Output

Scripts that generate reports automatically save CSV files to the same directory they're run from, named with the current date (e.g., `UserAudit_20260519.csv`).

---

## 🔧 Customization

Each script has configurable variables at the top (thresholds, target hosts, log names, etc.). Edit those values to fit your environment before running.
