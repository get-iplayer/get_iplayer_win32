@echo off
setlocal
set GIP_INST=%~dp0
if #%GIP_INST:~-1%# == #\# set GIP_INST=%GIP_INST:~0,-1%
if "%GIP_PATH%" == "" set GIP_PATH=%GIP_INST%\perl\bin;%GIP_INST%\utils\bin;%PATH%
if not "%GIP_PATH%" == "" set PATH=%GIP_PATH%
perl.exe "%GIP_INST%\get_iplayer.pl" %*
