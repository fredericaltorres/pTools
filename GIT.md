# Git command summary

## Copy a repo locally

```bash
	git clone url
```	

## Status

```bash
	git status # list unstaged and staged
	git remote -v # list report url
	git branch -t # list all the branch
	git tag # list of the tag
```

## Split a repo
https://stackoverflow.com/questions/359424/detach-move-subdirectory-into-separate-git-repository/359759#359759

```bash
#We clone the repo, it only copy locally develop
git branch -t master origin/master
# rewrite history for the sub directory we keep
git filter-branch --tag-name-filter cat --prune-empty --subdirectory-filter ABC -- --all
```

## Initialize a branch new report
1) Create the repo on bit bucket
```bash
	git remote add origin ssh://xxxxxxxxx
	git remote -v # list the url
	git push -u origin master # push local master branch into remove develop
	git push -u origin develop # push local master branch into remove develop
```

## Get latest of develop branch:

```bash
	git pull
	git fetch -all
	git merge origin/develop
	git remote rm origin # disconnect the remote branch
```	

## Branch

```bash
	# Create
	git checkout -b BRANCH-NAME
	# Switch
	git checkout BRANCH-NAME
	# Rename a local branch
	git branch -m BRANCH-NAME BRANCH-NAME
	# Last commits on each branch
	git branch -v
	# Which branches are already merged into the branch you’re on
	git branch --merged
	# list all the branch
	git branch -t 
```

# Editor and merge tool

```bash
	# Set up editor:
	git config --global core.editor notepad
	# Set up a diff tool:
	# https://sourceforge.net/projects/kdiff3/files/
	# kdiff3.exe must be in the path
	git config --global merge.tool kdiff3
```	

# undo commited change ahead of remote
git reset --soft HEAD~1

## Undo

```bash
	# Undo unstaged changes
	git checkout .
	git checkout /folder/file.js
	# Undo unstaged and staged changes
	git reset --hard
	# Undo the last commited
	git reset --hard HEAD~1
	# Undo change committed in the wrong branch, but keep the changes
	git log # to find the hash for the change
	git reset --mixed 2c41838da2738c0e1e23336fe48c3e4bae10d5f6
	# Revert a change that you have committed
	git revert <commit 1> <commit 2>
	# Remove untracked files (new files)
	git clean -f
```

# How to change temporary changes - Stash (Selveset)
```bash
	git stash
	git pull
	git branch -m FredBundleStudy
	git stash pop
```

# Update NPM
https://nodejs.org/download/release/v9.2.0/
```bash
npm install -g npm@5.5.1
npm uninstall npm
npm uninstall -g npm
```

# How to delete a repo locally?

```bash
	c:\myFolder> attrib -s -h -r . /s /d
	c:\myFolder> del /F /S /Q /A .git
	c:\myFolder> rmdir .git
```
