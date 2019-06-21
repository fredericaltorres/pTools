@echo off
echo upload %1
pause
set EXE=C:\tools\azure\Azure.Blob.Api.Console.exe
"%EXE%" upload "%1" container public

