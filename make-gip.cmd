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
if not exist "%GIPDIR%" (
    md "%GIPDIR%"
)
REM init logfile
set LOG=%GIPDIR%\%CMDNAME%.log
echo Logging to file: %LOG%
echo %* > "%LOG%"
call :log START %CMDNAME% %date% %time%
REM determine parent directory
for %%D in (%CMDDIR%\..) do (
    set BASEDIR=%%~fD
)
if #%BASEDIR:~-1%# == #\# set BASEDIR=%BASEDIR:~0,-1%
REM assume git at ..\PortableGit
set GIT=%BASEDIR%\PortableGit\bin\git.exe
REM assume repo at ..\get_iplayer
set REPO=%BASEDIR%\get_iplayer
REM process version
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
REM create get_iplayer files dir
set COIDIR=%GIPDIR%\get_iplayer-%COIVER%
if exist "%COIDIR%" (
    rd /q /s "%COIDIR%" >> "%LOG%" 2>&1
)
md "%COIDIR%" >> "%LOG%" 2>&1
REM checkout version in repo
"%GIT%" --git-dir="%REPO%\.git" --work-tree="%REPO%" checkout %GIPVER% >> "%LOG%" 2>&1
REM check result
if %ERRORLEVEL% neq 0 (
    call :log ERROR: checkout %GIPVER% failed
    goto die
)
REM use checkout-index to copy files to build dir
"%GIT%" --git-dir="%REPO%\.git" checkout-index --prefix="%COIDIR%\\" get_iplayer get_iplayer.cgi LICENSE.txt >> "%LOG%" 2>&1
REM check result
if %ERRORLEVEL% neq 0 (
    call :log ERROR: checkout-index %GIPVER% failed
    goto die
)
if not exist "%COIDIR%\get_iplayer" (
    call :log ERROR: CLI missing
    goto die
)
if not exist "%COIDIR%\get_iplayer.cgi" (
    call :log ERROR: WPM missing
    goto die
)
if not exist "%COIDIR%\LICENSE.txt" (
    call :log ERROR: license missing
    goto die
)
call :log get_iplayer files copied to %COIDIR%
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
echo Copy get_iplayer scripts from Git repo for installer build
echo.
echo Usage:
echo   %~n0 VERSION
echo   %~n0 /? - this message
echo.
echo Parameters:
echo   VERSION - branch, tag or commit to use
echo.
echo Output (in build\get_iplayer):
echo   get_iplayer-X - get_iplayer scripts
echo     (X = version specified, with leading "v" stripped from tags)
echo.
