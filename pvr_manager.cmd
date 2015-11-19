@echo off
setlocal
set GIP_INST=%~dp0
if #%GIP_INST:~-1%# == #\# set GIP_INST=%GIP_INST:~0,-1%
set GIP_PERL=%GIP_INST%\perl
set GIP_UTILS=%GIP_INST%\utils
set PATH=%GIP_PERL%;%GIP_UTILS%;%PATH%
start "PVR Manager Service" /min /b cmd /k "%GIP_INST%\get_iplayer.cgi.cmd"
ping 127.0.0.1 -n 5 -w 1000 > NUL
"%GIP_INST%\pvr_manager.url"
