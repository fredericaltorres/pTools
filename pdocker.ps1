<#
    .SYNOPSIS
        Utiliy to handler docker images and instance on a machine
    .DESCRIPTION
    .NOTES
        Frederic Torres 2019
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)] 
    [Alias('a')]
    [ValidateSet('delete-image', 'list-image', 'delete-dangling-image')]
    [string]$action,

    [Parameter(Mandatory=$false)]
    [string]$filter = "fredcontainerregistry.azurecr.io/donation.*"
)

function askUserToConfirm($message) {
    $confirmation = Read-Host "$message y)es n)o"
    return $confirmation.ToLowerInvariant() -eq "y"
}

Write-Host "pDocker -  $action $filter"

switch($action.ToLowerInvariant()) {
    delete-image {
        docker images $filter
        $imageIds = docker images  $filter -q
        if($imageIds.length -eq 0) {
            Write-Host "No images found using the filer: $filter"
        }
        else {        
            if(askUserToConfirm "$($imageIds.length) images to delete") {
                Write-Host "deleting..."
                $imageIds | ForEach-Object -Process { docker rmi $_ --force }
            }
        }
    }
    delete-dangling-image {
        $imageIds = docker images -f "dangling=true" -q
        if($imageIds.length -eq 0) {
            Write-Host "No dangling images found"
        }
        else {
            if(askUserToConfirm "$($imageIds.length) images to delete") {
                Write-Host "deleting dangling images..."
                $imageIds | ForEach-Object -Process { docker rmi $_ --force }
            }
        }
    }
    list-image {
        docker images $filter
    }
}
