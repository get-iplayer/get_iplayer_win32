@echo off
REM Build script for get_iplayer setup
setlocal EnableDelayedExpansion
REM show help if requested
echo.%1 | find "?" >NUL
if not ERRORLEVEL 1 goto usage
REM script location
set CMDDIR=%~dp0
set CMDNAME=%~n0
if #%CMDDIR:~-1%# == #\# set CMDDIR=%CMDDIR:~0,-1%
REM Inno build dir
set OUTDIR=%CMDDIR%\build\setup
if not exist "%OUTDIR%" (
	md "%OUTDIR%"
)
REM init logfile
set LOG=%OUTDIR%\%CMDNAME%.log
echo Logging to file: %LOG%
echo %* > "%LOG%"
call :log START %CMDNAME% %date% %time%
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
REM process command line
for %%A in (%*) do (
	set FLAG=%%A
	if "!FLAG:~0,1!"=="/" (
		set FLAG=!FLAG:/=!
		set !FLAG!=/D!FLAG!
	)
)
REM location of Inno compiler
set ISCC=C:\Program Files\Inno Setup 5\ISCC.exe
REM build setup
call :log Building setup...
"%ISCC%" /DGiPVersion=%ARG1% /DSetupBuild=%ARG2% %CLEANUP% %NOPERL% %NOUTILS% /O"%OUTDIR%" "%CMDDIR%\get_iplayer.iss" >> "%LOG%" 2>&1
if %ERRORLEVEL% neq 0 (
	call :log ERROR: %ISCC% failed
	goto die
)
call :log ...Finished
REM create checksums
if "%NOHASH%"=="" (
	call :log Creating checksum files...
	if not "!CLEANUP!"=="" (
		set CLEANUP=!CLEANUP:/D=-!
	)
	if not "!NOPERL!"=="" (
		set NOPERL=!NOPERL:/D=-!
	)
	if not "!NOUTILS!"=="" (
		set NOUTILS=!NOUTILS:/D=-!
	)
	for %%i in ( %OUTDIR%\get_iplayer-%ARG1%.%ARG2%-setup!CLEANUP!!NOPERL!!NOUTILS!.exe ) do (
		if exist %%i (
			for %%a in ( MD5, SHA1 ) do (
				set HASH=
				set ALGO=%%a
				set ALGO=!ALGO:MD=md!
				set ALGO=!ALGO:SHA=sha!
				for /f "skip=1 delims=" %%# in (
					'certutil -hashfile "%%~fi" %%a'
				) do (
					if "!HASH!"=="" (
						set HASH=%%#
						set HASH=!HASH: =!
						echo !HASH!  %%~nxi > %%~fi.!ALGO!
					)
				)
			)
		)
	)
	call :log ...Finished
)
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
echo Build Inno Setup installer for get_iplayer
echo.
echo Usage:
echo   %~n0 GiPVersion SetupBuild [/NOPERL] [/NOUTILS]
echo   %~n0 /? - this message
echo.
echo Parameters:
echo   GiPVersion - get_iplayer version (X.YY)
echo   SetupBuild - setup build number (Z)
echo   /CLEANUP - build with internal NSIS cleanup code
echo   /NOPERL - omit Perl support library from build
echo   /NOUTILS - omit helper utilities from build
echo   /NOHASH - do not create checksum files
echo.
echo Input:
echo   get_iplayer.iss - setup source
echo.
echo Output (in build\setup):
echo   get_iplayer-X.YY.Z-setup.exe - setup EXE
echo     (X.YY = get_iplayer version)
echo       (Z = setup build number)
echo.
