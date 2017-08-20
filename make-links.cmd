REM create symlinks for testing
REM run as administrator
setlocal
set CMDDIR=%~dp0
if #%CMDDIR:~-1%# == #\# set CMDDIR=%CMDDIR:~0,-1%
set BUILDDIR=%CMDDIR%\build
set GIPDIR=%BUILDDIR%\get_iplayer\get_iplayer-3.02
set PERLDIR=%BUILDDIR%\perl\perl-5.24.1
set UTILSDIR=%CMDDIR%\utils
set ATOMICPARSLEYDIR=%UTILSDIR%\AtomicParsley-0.9.6
set FFMPEGDIR=%UTILSDIR%\ffmpeg-3.2.4-win32-static
del /q "%CMDDIR%\get_iplayer.pl"
del /q "%CMDDIR%\get_iplayer.cgi"
rd /q "%CMDDIR%\perl"
del /q "%UTILSDIR%\AtomicParsley.exe"
del /q "%UTILSDIR%\ffmpeg.exe"
mklink "%CMDDIR%\get_iplayer.pl" "%GIPDIR%\get_iplayer"
mklink "%CMDDIR%\get_iplayer.cgi" "%GIPDIR%\get_iplayer.cgi"
mklink /d "%CMDDIR%\perl" "%PERLDIR%"
mklink "%UTILSDIR%\AtomicParsley.exe" "%ATOMICPARSLEYDIR%\AtomicParsley.exe"
mklink "%UTILSDIR%\ffmpeg.exe" "%FFMPEGDIR%\bin\ffmpeg.exe"
pause
