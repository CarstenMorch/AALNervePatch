:: Copy the created dll to the libs directory

IF EXIST c:\libs GOTO COPYLIB
echo Creating Folder
mkdir c:\libs

:COPYLIB

echo Copying dll
echo copy %1\%2 c:\libs\%2
copy %1\%2 c:\libs\%2