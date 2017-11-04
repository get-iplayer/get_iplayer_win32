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
REM process get_iplayer version
set ARG1=%1
if "%ARG1%"=="" (
	call :log ERROR: get_iplayer version missing
	goto die
)
if "%ARG1:~0,1%"=="/" (
	call :log ERROR: get_iplayer version cannot be flag parameter
	goto die
)
REM process setup build number
set ARG2=%2
if "%ARG2%"=="" (
	call :log ERROR: setup build number missing
	goto die
)
if "%ARG2:~0,1%"=="/" (
	call :log ERROR: setup build number cannot be flag parameter
	goto die
)
if "%ARG1%"=="9.99" (
    set GIPVER=master
) else (
    set GIPVER=v%ARG1%
)
set COIVER=%ARG1%.%ARG2%
call :log get_iplayer version: %GIPVER%
call :log setup version: %COIVER%
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
REM put version string in scripts
perl -i.bak -p -e "s/^(my \$version_text).*$/$1 = \"%COIVER%\";/" "%COIDIR%\get_iplayer" >> "%LOG%" 2>&1
perl -i.bak -p -e "s/^(my \$VERSION_TEXT).*$/$1 = \"%COIVER%\";/" "%COIDIR%\get_iplayer.cgi" >> "%LOG%" 2>&1
del "%COIDIR%\get_iplayer.bak" >> "%LOG%" 2>&1
del "%COIDIR%\get_iplayer.cgi.bak" >> "%LOG%" 2>&1
call :log get_iplayer version strings updated in %COIDIR%
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
echo Copy get_iplayer scripts from Git repo for setup build
echo   and insert Windows version numbers
echo.
echo Usage:
echo   %~n0 GiPVersion SetupBuild
echo   %~n0 /? - this message
echo.
echo Parameters:
echo   GiPVersion - get_iplayer version (X.YY)
echo   SetupBuild - setup build number (Z)
echo.
echo Output (in build\get_iplayer\get_iplayer-X.YY.Z):
echo   get_iplayer - get_iplayer script
echo   get_iplayer.cgi - web pvr script
echo   LICENSE.txt - licesnse file
echo.