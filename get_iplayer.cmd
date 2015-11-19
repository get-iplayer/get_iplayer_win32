@echo off
setlocal
set GIP_INST=%~dp0
if #%GIP_INST:~-1%# == #\# set GIP_INST=%GIP_INST:~0,-1%
set GIP_PERL=%GIP_INST%\perl
set GIP_UTILS=%GIP_INST%\utils
set PATH=%GIP_PERL%;%GIP_UTILS%;%PATH%
"%GIP_PERL%\perl.exe" "%GIP_INST%\get_iplayer.pl" %*
