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
set OUTDIR=%CMDDIR%\build\installer
if not exist "%OUTDIR%" (
	md "%OUTDIR%"
)
REM init logfile
set LOG=%OUTDIR%\%CMDNAME%.log
echo Logging to file: %LOG%
echo %* > "%LOG%"
call :log START %CMDNAME% %date% %time%
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
REM process installer build number
set ARG2=%2
if "%ARG2%"=="" (
	call :log ERROR: installer build number missing
	goto die
)
if "%ARG2:~0,1%"=="/" (
	call :log ERROR: installer build number cannot be flag parameter
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
REM location of NSIS compiler
set MAKENSIS=C:\Program Files\NSIS\makensis.exe
REM build installer
call :log Building installer...
"%MAKENSIS%" /DVERSION=%ARG1% /DPATCHLEVEL=%ARG2% /DOUTDIR="%OUTDIR%" %NOPERL% %NOUTILS% %TESTERRORS% "%CMDDIR%\get_iplayer.nsi" >> "%LOG%" 2>&1
if %ERRORLEVEL% neq 0 (
	call :log ERROR: %MAKENSIS% failed
	goto die
)
call :log ...Finished
REM create checksums
if "%NOHASH%"=="" (
	call :log Creating checksum files...
	if not "!NOPERL!"=="" (
		set NOPERL=!NOPERL:/D=-!
	)
	if not "!NOUTILS!"=="" (
		set NOUTILS=!NOUTILS:/D=-!
	)
	for %%i in ( %OUTDIR%\get_iplayer-%ARG1%.%ARG2%-installer!NOPERL!!NOUTILS!.exe ) do (
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
echo Build NSIS installer for get_iplayer
echo.
echo Usage:
echo   %~n0 VERSION PATCHLEVEL [/NOPERL] [/NOUTILS]
echo   %~n0 /? - this message
echo.
echo Parameters:
echo   VERSION - get_iplayer version (X.YY)
echo   PATCHLEVEL - installer build number (Z)
echo   /NOPERL  - omit Perl support library from build
echo   /NOUTILS - omit helper utilities from build
echo   /NOHASH - do not create checksum files
echo.
echo Input:
echo   get_iplayer.nsi - installer source
echo.
echo Output (in build\installer):
echo   get_iplayer-X.YY.Z-installer.exe - installer EXE
echo	 (X.YY = get_iplayer version)
echo	   (Z = installer build number)
echo.
