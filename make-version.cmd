@echo off
REM Build script for get_iplayer scripts
setlocal EnableDelayedExpansion
REM show help if requested
echo.%1 | find "?" >NUL
if not ERRORLEVEL 1 goto usage
REM script location
set CMDNAME=%~n0
set CMDDIR=%~dp0
if #%CMDDIR:~-1%# == #\# set CMDDIR=%CMDDIR:~0,-1%
REM get_iplayer build dir
set GIPDIR=%CMDDIR%\build\get_iplayer
REM init logfile
set LOG=%GIPDIR%\%CMDNAME%.log
echo Logging to file: %LOG%
echo %* > "%LOG%"
call :log START %CMDNAME% %date% %time%
REM get target version
set GIPVER=%1
if "%GIPVER%"=="" (
    call :log ERROR: branch, tag or commit missing
	goto die
)
set COIVER=%GIPVER%
REM strip leading "v" from tag
if "!COIVER:~0,1!"=="v" (
    set COIVER=!COIVER:~1!
)
call :log get_iplayer version: %COIVER%
REM get_iplayer script dir
set COIDIR=%GIPDIR%\get_iplayer-%COIVER%
REM put version string in scripts
perl -i.bak -p -e "s/^(my \$version_text).*$/$1 = \"%1-windows.%2\";/" "%COIDIR%\get_iplayer" >> "%LOG%" 2>&1
perl -i.bak -p -e "s/^(my \$VERSION_TEXT).*$/$1 = \"%1-windows.%2\";/" "%COIDIR%\get_iplayer.cgi" >> "%LOG%" 2>&1
del "%COIDIR%\get_iplayer.bak" >> "%LOG%" 2>&1
del "%COIDIR%\get_iplayer.cgi.bak" >> "%LOG%" 2>&1
call :log FINISH %CMDNAME% %date% %time%
:done
exit /b
:die
echo Exiting - see %LOG%
exit /b 1
:log
echo %*
echo %* >> "%LOG%"
goto :eof

