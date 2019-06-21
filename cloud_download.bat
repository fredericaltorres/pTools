@echo off
echo download ".\%1"
set EXE=C:\tools\azure\Azure.Blob.Api.Console.exe
"%EXE%" download "%1" container public localpath ".\%1"

