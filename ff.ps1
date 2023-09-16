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
    $wildcard = "",
    
    [Parameter(Mandatory=$false)]
    [Alias('s')]
    [string]$searchForRegEx = "",

    [Parameter(Mandatory=$false)]
    [Alias('r')]
    [string]$replace = '',

    [Parameter(Mandatory=$false)]
    [Alias('p')]
    $paths = @("."),

    [Parameter(Mandatory=$false)]
    [Alias('e')]
    $exclude = @(),

    [Parameter(Mandatory=$false)]
    [Alias('eb')]
    [bool]$excludeBinary = $false,

    [Parameter(Mandatory=$false)]
    [Alias('ed')]
    [switch]$edit = $false,

    [Parameter(Mandatory=$false)]
    [string]$editor = "C:\Users\ftorres\AppData\Local\Programs\Microsoft VS Code\Code.exe"    ,

    [Parameter(Mandatory=$false)]
    [Alias('d')]
    [bool]$deleteFile = $false
)

# "-f $wildcard, -s $searchForRegEx -r $replace"
# pause

if($searchForRegEx -eq "-" -or $replace -eq "-") {

}

$dotNetFileExtensions = @("*.vb", "*.resx", "*.xsd", "*.wsdl", "*.htm", "*.html", "*.ashx", "*.aspx", "*.ascx", "*.asmx", "*.svc", "*.asax", "*.config", "*.asp", "*.asa", "*.cshtml", "*.vbhtml", "*.css", "*.xml", "*.cs", "*.js", "*.csproj", "*.sql", "*.ts")
$vb6FileExtensions = @("*.cls", "*.bas", "*.vbp")
$classicAspFileExtensions = @("*.asp", "*.vbs")
$javaScriptFrontEndFileExtensions = @("*.js", "*.ts", "*.json")
$cFileExtensions = @("*.c", "*.h", "*.cpp")
$textFileExtensions = @("*.txt", "*.log", "*.md", "*.csv")

if($excludeBinary) {
    $exclude = $exclude + @("*.exe","*.pdb","*.dll", "node_modules", "*.bak")
}
if($wildcard -eq "c") {
    $wildcard = $cFileExtensions
}
if($wildcard -eq "text") {
    $wildcard = $textFileExtensions
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

function showUserBanner([string]$msg) {

    Write-Host $msg -ForegroundColor Yellow
}

function showUserInfo([string]$msg) {

    Write-Host $msg -ForegroundColor Green
}

function convertToArray($result) {

    if($result.GetType().Name -ne "Object[]") {

        $result = @($result)
    }
    return $result
}

function printResultFiles($r) {

    Write-Host ($r -join [System.Environment]::NewLine)
}

function openWithEditor($files) {

    foreach($file in $files) {

        #write-host "$editor" "`"$file`""
        & "$editor" "`"$file`""
    }
}

function convertMatchInfo($matchInfos) {

    $r = @()
    foreach($matchInfo in $matchInfos) {
        $r += $matchInfo.RelativePath("")
    }
    return $r
}

$scriptTitle = "FindFile ff"

if($exclude.length -eq 0) {
    $exclude = $null
}

if($replace -eq '') {  # Search mode only

    if($searchForRegEx -eq "") {  # Only search based on the filename
        
        showUserBanner "$scriptTitle - FileName Search Mode - wildcard: $wildcard"
        foreach($path in $paths) {

            showUserInfo "path:$path"
            $r = Get-ChildItem -path $path -rec -include $wildcard -exclude $exclude
            if($r -ne $null) {
                $r = convertToArray($r)
                printResultFiles($r)
                if($edit) {
                    openWithEditor $r
                }
                if($deleteFile) {
                    $confimDeletion = Read-Host -Prompt 'Delete files above ? [yes, no]'
                    if($confimDeletion -eq "yes") {
                        foreach($f in $r) {
                            write-output "Deleting $($f.FullName)"
                            remove-item -Path $f.FullName
                        }
                    }
                }
            }
        }
    }
    else { 
        # Search on filename + content
        showUserBanner "$scriptTitle - FileName/Content Search Mode - wildcard:'$wildcard' exclude:'$exclude' search:'$searchForRegEx'"
        if($path -ne ".") {

            showUserInfo "path:'$path'"
        }
        foreach($path in $paths) {

            showUserInfo "path:$path"
            $r = Get-ChildItem -path $path -rec -include $wildcard -exclude $exclude | select-string $searchForRegEx -list 
            if($r -ne $null) {
                $r = convertToArray($r)
                printResultFiles($r)
                if($edit) {
                    openWithEditor(convertMatchInfo($r))                
                }
            }
        }
    }
}
else { # Search/Replace mode
    
    showUserBanner "$scriptTitle - Search/Replace Content Mode - wildcard:'$wildcard' exclude:'$exclude' search:'$searchForRegEx' replace:'$replace'"
    $answer = Read-Host -Prompt 'Confirm search/replace? [y, n]'
    if($answer -eq "y") {
        foreach($path in $paths) {

            $files = Get-ChildItem -path $path -rec -include $wildcard -exclude $exclude

            foreach ($file in $files) {

                $content = Get-Content $file.PSPath
                if($content -match $searchForRegEx) {

                    showUserInfo "Updating file $file"
                    $content = $content -replace $searchForRegEx, $replace         
                    $content | Set-Content $file.PSPath
                }
            }
        }
    }
}

showUserInfo "`r`n$scriptTitle - done"
