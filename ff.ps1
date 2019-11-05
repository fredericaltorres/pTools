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
    #[ValidateSet('dotnet', 'vb6')]
    $wildcard,
    
    [Parameter(Mandatory=$false)]
    [Alias('s')]
    [string]$searchForRegEx = "",

    [Parameter(Mandatory=$false)]
    [Alias('p')]
    [string]$path = ".",

    [Parameter(Mandatory=$false)]
    [Alias('e')]
    $exclude = @(),

    [Parameter(Mandatory=$false)]
    [Alias('eb')]
    [bool]$excludeBinary = $false
)
if($excludeBinary) {
    $exclude = $exclude + @("*.exe","*.pdb","*.dll", "node_modules", "*.bak")
}
if($wildcard -eq "dotnet") {
    $wildcard = @("*.cs", "*.aspx", "*.ascx", "*.asax", "*.csproj", "*.sln")
}
if($wildcard -eq "vb6") {
    $wildcard = @("*.cls", "*.bas", "*.vbp")
}
$scriptTitle = "FindFile ff"
# Write-Host "searchForRegEx:$searchForRegEx, IsNull:$($null -eq $searchForRegEx)"

if($searchForRegEx -eq "") {
    Write-Host "$scriptTitle - wildcard: $wildcard"
    Get-ChildItem -path $path -rec -include $wildcard
}
else {
    Write-Host "$scriptTitle - wildcard:'$wildcard' exclude:'$exclude' search:'$searchForRegEx'"
    if($path -ne ".") {
        Write-Host "path:'$path'"
    }
    Get-ChildItem -path $path -rec -include $wildcard -Exclude $exclude | select-string $searchForRegEx -list
}
