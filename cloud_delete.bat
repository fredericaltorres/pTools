@echo off
echo delete ".\%1"
set EXE=C:\tools\azure\Azure.Blob.Api.Console.exe
"%EXE%" delete "%1" container public
