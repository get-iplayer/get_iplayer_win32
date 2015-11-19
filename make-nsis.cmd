@echo off
REM Build script for get_iplayer installer
setlocal EnableDelayedExpansion
REM show help if requested
echo.%1 | find "?" >NUL
if not ERRORLEVEL 1 goto usage
REM script location
set CMDDIR=%~dp0
set CMDNAME=%~n0
if #%CMDDIR:~-1%# == #\# set CMDDIR=%CMDDIR:~0,-1%
REM NSIS build dir
set NSIDIR=%CMDDIR%\build\installer
if not exist "%NSIDIR%" (
    md "%NSIDIR%"
)
REM init logfile
set LOG=%NSIDIR%\%CMDNAME%.log
echo Logging to file: %LOG%
echo %* > "%LOG%"
call :log START %CMDNAME% %date% %time%
REM process command line
for %%A in (%*) do (
	set FLAG=%%A
	if "!FLAG:~0,1!"=="/" (
		set FLAG=!FLAG:/=!
		set !FLAG!=/D!FLAG!
	)
)
REM location of NSIS compiler
set MAKENSIS=C:\Program Files\NSIS\makensis.exe
REM build installer
call :log Building installer...
"%MAKENSIS%" /NOCD %NOPERL% %NOUTILS% %TESTERRORS% "%CMDDIR%\get_iplayer.nsi" >> "%LOG%" 2>&1
if %ERRORLEVEL% neq 0 (
    call :log ERROR: %MAKENSIS% failed
    goto die
)
call :log ...Finished
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
:usage
echo.
echo Build NSIS installer for get_iplayer
echo.
echo Usage:
echo   %~n0 [/noperl] [/noutils]
echo   %~n0 /? - this message
echo.
echo Parameters:
echo   /noperl  - omit Perl support library from build
echo   /noutils - omit helper utilities from build
echo.
echo Input:
echo   get_iplayer.nsi - installer source
echo.
echo Output (in build\nsis):
echo   get_iplayer-N.N.X.exe - installer EXE
echo     (N.N = get_iplayer version)
echo       (.X = installer patch level)
echo.
