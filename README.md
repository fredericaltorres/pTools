# pTools
## Overview
Powershell script utilities 
- git
- docker
- kubernetes

## pDocker.ps1
Utiliy to handler docker images and instance on a machine
```
C:\ PS> pdocker.ps1 -a list-image -filter myDemo.*
C:\ PS> pdocker.ps1 -a delete-image -filter myDemo.*
C:\ PS> pdocker.ps1 -a delete-dangling-image
```

## ff.ps1 ~ Find File
Helper to search for files and in files from the current folder or not
```
C:\ PS> ff.ps1 -f fred*.cs # search for file with fred in the name
C:\ PS> ff.ps1 -f *.cs -s Fred # search for file which contain the word fred in them
C:\ PS> ff.ps1 -f *.cs -p "c:\dvt\src" -s Fred # search for file which contain the word fred in them
```

## pgit.ps1
A powershell script to simplify git commands

```bash
    pgit list [branch, url, tag, history, merge-history, shelveset, commit]

    pgit create branch `branchName`
    pgit switch branch `branchName`
    pgit delete branch `branchName`
    pgit deleteSure branch `branchName`
    pgit rename branch `oldBranchName` `newBranchName`
    pgit push branch `branchName`
    
    pgit get branch # get latest

    pgit status
    pgit commit
    pgit commit -m ""message""
    pgit push
    pgit commit push BranchName -m ""message""

    pgit undo last-commit-file `fileName` # undo the last commit for one specific file
    pgit undo last-commit-file `fileName` commit-hash # Restore one specific file from a specific commit

    pgit undo unstaged # undo changes in unstaged files
    pgit undo unstaged-staged # undo changes in staged and unstaged files
    pgit undo last-commit # undo the last commit
    pgit undo last-untracked-file # Remove new created file never added

    pgit add files

    # shelveset are stacked and can only be pushed and poped
    pgit list-shelveset
    pgit create-shelveset ""name""
    pgit unshelve-shelveset # unselve the selveset at the top of the stack
```

### Shortcuts
All key word can replaced with the first 2 chars of the word.

* un = undo
* uns = unshelve

### How to undo commited and pushed changed?
* Find the commit to undo
* Use the hash of the commit previous to the one you want to undo

```bash
git log -2
git checkout d5cb6dc91bd src/components/reports/lifetime/cashFlowLifetimeYearDetails.jsx
```
