REM create symlinks for testing
REM run as administrator
setlocal
set CMDDIR=%~dp0
if #%CMDDIR:~-1%# == #\# set CMDDIR=%CMDDIR:~0,-1%
set BUILDDIR=%CMDDIR%\build
set UTILSDIR=%CMDDIR%\utils
set SRCDIR=%BUILDDIR%\src
set GIPSRC=%SRCDIR%\get_iplayer
set PERLSRC=%SRCDIR%\perl
set ATOMICPARSLEYSRC=%SRCDIR%\atomicparsley
set FFMPEGSRC=%SRCDIR%\ffmpeg
del /q "%CMDDIR%\get_iplayer.pl"
del /q "%CMDDIR%\get_iplayer.cgi"
rd /q "%CMDDIR%\perl"
del /q "%UTILSDIR%\AtomicParsley.exe"
del /q "%UTILSDIR%\ffmpeg.exe"
mklink "%CMDDIR%\get_iplayer.pl" "%GIPSRC%\get_iplayer"
mklink "%CMDDIR%\get_iplayer.cgi" "%GIPSRC%\get_iplayer.cgi"
mklink /d "%CMDDIR%\perl" "%PERLSRC%"
mklink "%UTILSDIR%\AtomicParsley.exe" "%ATOMICPARSLEYSRC%\AtomicParsley.exe"
mklink "%UTILSDIR%\ffmpeg.exe" "%FFMPEGSRC%\ffmpeg.exe"
