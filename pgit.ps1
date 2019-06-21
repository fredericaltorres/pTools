<#
    Git command helper/reminder written in powershell
    Torres Frederic 2018
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory=$false, Position=0)]
    [string]$verb         = "status",
    [Parameter(Mandatory=$false, Position=1)]
    [string]$object       = "",
    [Parameter(Mandatory=$false, Position=2)]
    [string]$objectName   = "",
    [Parameter(Mandatory=$false, Position=3)]
    [string]$objectName2  = "",
    [Parameter(Mandatory=$false, Position=4)]
    [Alias('m')]
    [string]$message = ""
)

$TEMP_FILE_NAME = ".\pgit.txt"

# A function just to trace the final git command line
function t_($ex) {
    write-host "git translation -> $ex"  -ForegroundColor DarkCyan
    return $ex
}
function deleteFile ($fileName) {
    if(Test-Path $fileName -PathType Leaf) {
        remove-item $fileName
    }
}
function deleteTempFile () {
    deleteFile $TEMP_FILE_NAME
}
function getTempFileContent() {
    return (get-content $TEMP_FILE_NAME)
}
function validObjectName($oName) {
    if($oName -eq "" -or $oName -eq $null) {
        throw "Cannot perform action of ObjectName:'$oName'"   
    }
    return $oName
}
$ShortCutToCommandMap = @{ 
    sw='switch'; 
    li='list';
    cr='create';
    br='branch';
    de='delete';
    re='rename';
    pu='push';
    co='commit';
    ge='get';
    st='status';
    un='undo';
    hi='history';
    sh='shelveset';
    uns='unshelve';
    des='deletesure';
}

function shortCutToCommand($shortCut) {
    if($ShortCutToCommandMap.contains($shortCut)) {
        return $ShortCutToCommandMap[$shortCut];
    }
    else {
        return $shortCut;
    }
}
function getCommitHistory($countCommit) {

    if($countCommit -eq "") {
        $countCommit = 2
    }
    iEx (t_( "git log -n $countCommit --pretty=format:""%H"" > $TEMP_FILE_NAME" ))
    $content = getTempFileContent
    deleteTempFile  
    return $content
}
function displayCommandLineHelp() {
        write-host @" 
Command line options:

    list [branch, url, tag, history, merge-history, shelveset, commit]

    create branch branchName, 
    switch branch branchName, 
    delete branch branchName, 
    deleteSure branch branchName,
    rename branch oldBranchName newBranchName
    push branch branchName
    
    get branch # get latest

    status
    commit
    commit -m ""message""
    push
    pull # pull the current repo
    commit push BranchName -m ""message"" # add file, commit and push to branch
    check in -m ""message"" # add file, commit and push to current branch

    undo last-commit-file fileName # undo the last commit for one specific file
    undo last-commit-file fileName commit-hash # Restore one specific file from a specific commit

    undo unstaged # undo changes in unstaged files
    undo unstaged-staged # undo changes in staged and unstaged files
    undo last-commit # undo the last commit
    undo last-untracked-file # Remove new created file never added

    add files

    # shelveset are stacked and can only be pushed and poped
    list-shelveset
    create-shelveset ""name""
    unshelve-shelveset # unselve the selveset at the top of the stack

    delete-tag ""tag"" # delete remote and local tag
"@ -ForegroundColor cyan

}

function addFiles() {
    iEx (t_(  "git add . " ))
}


# -----
# Main
# -----

$action = (shortCutToCommand($verb))
if($object -ne "") {
    $action += "-" + (shortCutToCommand($object));
}
write-host "pGit " -NoNewline -ForegroundColor Green
write-host "action:$action" -ForegroundColor DarkGreen

switch($action) {

    list-url            {  iEx (t_(  "git remote -v "  )) }
    list-branch         {  iEx (t_(  "git branch -t"  )) }
    list-tag            {  iEx (t_(  "git tag"  )) }
    list-history        {  iEx (t_(  "git log"  )) }
    list-merge-history  {  iEx (t_(  "git branch --merged"  )) } # Which branches are already merged into the branch you’re on
    status              {  iEx (t_(  "git status"  )) }

    create-branch       {  iEx (t_(  "git checkout -b $(validObjectName($objectName))"  )) }
    switch-branch       {  iEx (t_(  "git checkout $(validObjectName($objectName))"  )) }

    delete-branch       {  iEx (t_(  "git branch -d $(validObjectName($objectName))"  )) }

    deletesure-branch   {  iEx (t_(  "git branch -D $(validObjectName($objectName))"  )) }

    rename-branch       {  iEx (t_(  "git branch -m $(validObjectName($objectName)) $(validObjectName($objectName2))"  )) }
    push-branch         {  iEx (t_(  "git push -u origin $(validObjectName($objectName))"  )) }
    get-branch          {  iEx (t_(  "git pull"  )) }

    # https://medium.freecodecamp.org/useful-tricks-you-might-not-know-about-git-stash-e8a9490f0a1a
    list-shelveset      {  iEx (t_(  "git stash list "  )) }
    create-shelveset    {  iEx (t_(  'git stash save "$(validObjectName($objectName))"'  )) }        
    unshelve-shelveset  {  iEx (t_(  'git stash pop' )) }
    # delete-shelveset    {  iEx (t_(  'git stash drop stash@{0}' )) }

    push                {  iEx (t_(  "git push -u origin $(validObjectName($objectName))"  )) }

    pull                {  iEx (t_(  "git pull"  )) }

    commit              {
        if($message -ne "") {
            write-host "Commit current changes under message:$message"
            iEx (t_( "git commit -m ""$message"" " )) 
        }
        else {
            iEx (t_(  "git commit" )) 
        }
    }

    commit-push {
        if($message -ne "") {
            write-host "About to commit current changes under message:$message"  -ForegroundColor Cyan
            write-host "About to push to branch $objectName" -ForegroundColor Magenta
            write-host "Hit space to continue, or Ctrl+C to abort"
            pause
            addFiles
            iEx (t_( "git commit -m ""$message"" " )) 
            iEx (t_(  "git push -u origin $(validObjectName($objectName))"  ))
        }
        else {
            Write-Error "commit-push require a message set with parameter -m"
        }
    }

    check-in {
        if($message -ne "") {
            write-host "About to commit current changes under message:$message"  -ForegroundColor Cyan
            write-host "About to push to the current branch" -ForegroundColor Magenta
            write-host "Hit space to continue, or Ctrl+C to abort"
            pause
            addFiles
            iEx (t_( "git commit -m ""$message"" " )) 
            iEx (t_(  "git push "  ))
        }
        else {
            Write-Error "check-in require a message set with parameter -m"
        }
    }
    
    add-.           {  addFiles }
    add-files       {  addFiles }

    list-commit     {  
        
        $content = getCommitHistory($objectName)
        write-host "$($content.length) commits found"
        write-host "------------"
        write-host "$content"
        write-host "------------"
        $commitId = $content[$content.length-1]
        write-host "Last Commit: $commitId"
    }

    delete-tag {
        iEx (t_(  "git push --delete origin $(validObjectName($objectName))"  )) 
        iEx (t_(  "git tag --delete $(validObjectName($objectName))"  )) 
    }

<#
    git diff 307f22619cd979d48f2bf374092e35cecd5e4ada src/components/projections/__tests__/projectionsDropdown.spec.jsx
    git reset 307f22619cd979d48f2bf374092e35cecd5e4ada src/components/projections/__tests__/projectionsDropdown.spec.jsx
    git checkout src/components/projections/__tests__/projectionsDropdown.spec.jsx
    git reset HEAD src/components/projections/__tests__/projectionsDropdown.spec.jsx
    pgit 
    undo all
    git reset 307f22619cd979d48f2bf374092e35cecd5e4ada
    git checkout .
    
    28377a8 Tutu, 28377a8eff7c763013c4c4bfb4ecd56f748abd8e
    git rev-parse HEAD~1 # get the hash of the last commit
    git checkout 307f22619cd979d48f2bf374092e35cecd5e4ada -- src/components/projections/__tests__/projectionsDropdown.spec.jsx
    git reset --hard src/components/projections/__tests__/projectionsDropdown.spec.jsx
    git reset HEAD src/components/projections/__tests__/projectionsDropdown.spec.jsx
    git reset 307f22619cd979d48f2bf374092e35cecd5e4ada src/components/projections/__tests__/projectionsDropdown.spec.jsx
    git checkout 307f22619cd979d48f2bf374092e35cecd5e4ada src/components/projections/__tests__/projectionsDropdown.spec.jsx

    pgit undo last-commit-file src/components/projections/__tests__/projectionsDropdown.spec.jsx
    pgit undo last-commit-file src/components/projections/projectionsDropdown.jsx 307f22619cd979d48f2bf374092e35cecd5e4ada
#>
    undo-unstaged         {  iEx (t_(  "git checkout . "  )) }
    undo-unstaged-staged  {  iEx (t_(  "git reset --hard"  )) } # Undo unstaged and staged changes
    undo-last-commit      {  iEx (t_(  "git reset --hard HEAD~1"  )) } # Undo all files changes located in the last commit
    undo-last-commit-file {

        $fileNameToUndo = $objectName
        $content        = getCommitHistory("")

        if($objectName2 -ne "") {
            $commitId = $objectName2
            write-host "Commit: $commitId"
        }
        else {
            $commitId = $content[$content.length-1]
            write-host "$($content.length) commits found"
        }

        ##iEx (t_( "git reset $commitId ""$fileNameToUndo"" " )) # bring the file from the commit to staged in the local branch
        iEx (t_( "git checkout $commitId ""$fileNameToUndo"" " )) # bring the file from staged (or the stage) to local
        write-host "File ""$fileNameToUndo"" has been restored in staged mode, you will have to commit the change" -ForegroundColor DarkCyan
        iEx (t_( "git status" ))
    }

    undo-untracked-file {  iEx (t_(  "git clean -f "  )) } # Remove untracked files (new files)
    
    "-h"                { displayCommandLineHelp }
    "--h"               { displayCommandLineHelp }
    "--help"            { displayCommandLineHelp }
    "?"                 { displayCommandLineHelp }
    help                { displayCommandLineHelp }

    default             { write-error "Unknown pgit command:$action" }
}
