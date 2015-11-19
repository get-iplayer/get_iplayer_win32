REM create symlinks for testing
REM run as administrator
setlocal
set CMDDIR=%~dp0
if #%CMDDIR:~-1%# == #\# set CMDDIR=%CMDDIR:~0,-1%
set BUILDDIR=%CMDDIR%\build
set GIPDIR=%BUILDDIR%\get_iplayer\get_iplayer-2.95
set PERLDIR=%BUILDDIR%\perl\perl-5.24.0
set UTILSDIR=%CMDDIR%\utils
set ATOMICPARSLEYDIR=%UTILSDIR%\AtomicParsley-0.9.6
set FFMPEGDIR=%UTILSDIR%\ffmpeg-3.0.1-win32-static
set RTMPDUMPDIR=%UTILSDIR%\rtmpdump-v2.4-102-ga3a600d-get_iplayer
del /q "%CMDDIR%\get_iplayer.pl"
del /q "%CMDDIR%\get_iplayer.cgi"
rd /q "%CMDDIR%\perl"
del /q "%UTILSDIR%\AtomicParsley.exe"
del /q "%UTILSDIR%\ffmpeg.exe"
del /q "%UTILSDIR%\ffplay.exe"
del /q "%UTILSDIR%\rtmpdump.exe"
mklink "%CMDDIR%\get_iplayer.pl" "%GIPDIR%\get_iplayer"
mklink "%CMDDIR%\get_iplayer.cgi" "%GIPDIR%\get_iplayer.cgi"
mklink /d "%CMDDIR%\perl" "%PERLDIR%"
mklink "%UTILSDIR%\AtomicParsley.exe" "%ATOMICPARSLEYDIR%\AtomicParsley.exe"
mklink "%UTILSDIR%\ffmpeg.exe" "%FFMPEGDIR%\bin\ffmpeg.exe"
mklink "%UTILSDIR%\ffplay.exe" "%FFMPEGDIR%\bin\ffplay.exe"
mklink "%UTILSDIR%\rtmpdump.exe" "%RTMPDUMPDIR%\rtmpdump.exe"
