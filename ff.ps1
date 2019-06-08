<#
    .SYNOPSIS
        Helper to search for files and in files from the current folder or not
    .DESCRIPTION
    .NOTES
        Frederic Torres 2019
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)] 
    [Alias('f')]
    [string]$wildcard,

    [Parameter(Mandatory=$false)]
    [Alias('s')]
    [string]$searchForRegEx = $null,

    [Parameter(Mandatory=$false)]
    [Alias('p')]
    [string]$path = "."
)
$scriptTitle = "FindFile ff"
# Write-Host "searchForRegEx:$searchForRegEx, IsNull:$($null -eq $searchForRegEx)"

if($searchForRegEx -eq $null) {
    Write-Host "$scriptTitle - wildcard: $wildcard"
    Get-ChildItem -path $path -rec -include $wildcard
}
else {
    Write-Host "$scriptTitle - wildcard: $wildcard - search: $searchForRegEx"
    Get-ChildItem -path $path -rec -include $wildcard | select-string $searchForRegEx
}
