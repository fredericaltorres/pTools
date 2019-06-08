<#
In File
- %UserProfile%\My Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1
- Import-Module 'C:\tools\PowerShell.Customization.ps1'
#>
function prompt {
    Write-Host "Reset prompt" -ForegroundColor DarkYellow
    $p = Split-Path -leaf -path (Get-Location)
    "PS $p> "
}

Write-Host "PowerShell - Fred's Customization" -ForegroundColor Yellow
prompt
