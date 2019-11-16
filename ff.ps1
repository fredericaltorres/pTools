<#
    .SYNOPSIS
        Helper to search for files and in files from the current folder or not
    .DESCRIPTION
    .NOTES
        Frederic Torres 2019
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)] ## $true
    [Alias('f')]
    #[ValidateSet('dotnet', 'vb6', 'allcode')]
    $wildcard,
    
    [Parameter(Mandatory=$false)]
    [Alias('s')]
    [string]$searchForRegEx = "",

    [Parameter(Mandatory=$false)]
    [Alias('r')]
    [string]$replace = "",

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
$dotNetFileExtensions = @("*.cs", "*.aspx", "*.ascx", "*.asax", "*.csproj", "*.sln")
$vb6FileExtensions = @("*.cls", "*.bas", "*.vbp")
$classicAspFileExtensions = @("*.asp", "*.vbs")
$javaScriptFrontEndFileExtensions = @("*.js", "*.ts", "*.json")

if($excludeBinary) {
    $exclude = $exclude + @("*.exe","*.pdb","*.dll", "node_modules", "*.bak")
}
if($wildcard -eq "dotnet") {
    $wildcard = $dotNetFileExtensions
}
if($wildcard -eq "vb6") {
    $wildcard = $vb6FileExtensions
}
if($wildcard -eq "allcode") {
    $wildcard = $vb6FileExtensions + $dotNetFileExtensions + $classicAspFileExtensions + $javaScriptFrontEndFileExtensions
}

$scriptTitle = "FindFile ff"

if($exclude.length -eq 0) {
    $exclude = $null
}

if($replace -eq "") {

    if($searchForRegEx -eq "") {
        Write-Host "$scriptTitle - wildcard: $wildcard"
        Get-ChildItem -path $path -rec -include $wildcard -exclude $exclude 
    }
    else {
        Write-Host "$scriptTitle - wildcard:'$wildcard' exclude:'$exclude' search:'$searchForRegEx'"
        if($path -ne ".") {
            Write-Host "path:'$path'"
        }
        Get-ChildItem -path $path -rec -include $wildcard -exclude $exclude | select-string $searchForRegEx -list 
    }
}
else {
Write-Host "$scriptTitle - wildcard:'$wildcard' exclude:'$exclude' search:'$searchForRegEx' replace:'$replace'"
    $files = Get-ChildItem -path $path -rec -include $wildcard -exclude $exclude
    foreach ($file in $files)
    {
        $content = Get-Content $file.PSPath
        if($content -match $searchForRegEx) {

            Write-Host "Updating file $file"
            $content = $content -replace $searchForRegEx, $replace         
            $content | Set-Content $file.PSPath
        }
    }
}
