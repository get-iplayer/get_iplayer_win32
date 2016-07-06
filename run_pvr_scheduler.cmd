@echo off
setlocal
set GIP_INST=%~dp0
if #%GIP_INST:~-1%# == #\# set GIP_INST=%GIP_INST:~0,-1%
"%GIP_INST%\get_iplayer.cmd" --pvrschedule 14400
