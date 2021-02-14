#pragma parseroption -p-
; #define DUMPISPP
; #define NOPERL
; #define NOUTILS
; #define WIN64
#define AppName "get_iplayer"
#ifndef AppVersion
  #define AppVersion "3.26.1"
#endif
#ifdef WIN64
	#define AppArch "x64"
#else
	#define AppArch "x86"
#endif
#define Build "build-" + AppArch
#define Src Build + "\\src"
#define PerlSrc Src + "\\perl"
#define GiPSrc Src + "\\get_iplayer"
#define AtomicParsleySrc Src + "\\atomicparsley"
#define FFmpegSrc Src + "\\ffmpeg"
#define SetupDir Build
#define SetupSuffix "-windows-" + AppArch + "-setup"
#ifdef NOPERL
  #define SetupSuffix SetupSuffix + "-noperl"
#endif
#ifdef NOUTILS
  #define SetupSuffix SetupSuffix + "-noutils"
#endif
#define PerlDir "{app}\\perl"
#define UtilsDir "{app}\\utils"
#define LicensesDir "{app}\\licenses"
#define GiPIcon "{app}\\get_iplayer.ico"
#define GiPPVRIcon "{app}\\get_iplayer_pvr.ico"
#define GiPRepo "https://github.com/get-iplayer/get_iplayer"
#define GiPWiki GiPRepo + "/wiki"
#define GiPWin32Repo "https://github.com/get-iplayer/get_iplayer_win32"
#define HomeDir "%HOMEDRIVE%%HOMEPATH%"

[Setup]
AppCopyright=Copyright (C) 2008-2010 Phil Lewis
AppName={#AppName}
AppPublisher=The {#AppName} Contributors
AppPublisherURL={#GiPRepo}
AppSupportURL={#GiPWiki}
AppUpdatesURL={#GiPWin32Repo}/releases
AppVerName={#AppName} {#AppVersion} ({#AppArch})
AppVersion={#AppVersion}
#ifdef WIN64
ArchitecturesAllowed=x64
ArchitecturesInstallIn64BitMode=x64
#endif
ChangesEnvironment=yes
DefaultDirName={pf}\{#AppName}
DefaultGroupName={#AppName}
DisableDirPage=yes
DisableFinishedPage=no
DisableProgramGroupPage=yes
DisableReadyPage=no
DisableStartupPrompt=yes
DisableWelcomePage=no
LicenseFile={#GiPSrc}\LICENSE.txt
OutputBaseFilename={#AppName}-{#AppVersion}{#SetupSuffix}
OutputDir={#SetupDir}
SetupIconFile={#AppName}.ico
UninstallDisplayIcon={app}\{#AppName}_uninst.ico

[Tasks]
Name: desktopicons; Description: Create &desktop shortcuts (for all users); Flags: unchecked;

[InstallDelete]
; remove obsolete items
Type: files; Name: {app}\get_iplayer.cgi.cmd;
Type: filesandordirs; Name: {group}\Update;
Type: files; Name: {group}\Uninstall.lnk;
Type: files; Name: {#UtilsDir}\sources.txt;
Type: files; Name: {#UtilsDir}\AtomicParsley.exe;
Type: files; Name: {#UtilsDir}\ffmpeg.exe;
Type: filesandordirs; Name: {#UtilsDir}\licenses;
Type: filesandordirs; Name: {group}\Help;
Type: files; Name: {group}\Uninstall {#AppName}
Type: files; Name: {#LicensesDir}\ffmpeg\LICENSE.txt;
Type: files; Name: {#LicensesDir}\ffmpeg\README.txt;
; remove obsolete uninstallers
Type: files; Name: {app}\Uninst.exe;
Type: files; Name: {app}\uninstall.exe;
#ifndef NOPERL
; reset perl on install
Type: filesandordirs; Name: {#PerlDir};
#endif
#ifndef NOUTILS
Type: dirifempty; Name: {#UtilsDir};
#endif
Type: dirifempty; Name: {app};

[UninstallDelete]
Type: files; Name: {app}\Setup Log*;

[Files]
Source: {#GiPSrc}\get_iplayer; DestDir: {app}; DestName: get_iplayer.pl;
Source: {#GiPSrc}\get_iplayer.cgi; DestDir: {app};
Source: get_iplayer.cmd; DestDir: {app};
Source: get_iplayer_cgi.cmd; DestDir: {app};
Source: get_iplayer_web_pvr.cmd; DestDir: {app};
Source: get_iplayer_pvr.cmd; DestDir: {app};
Source: get_iplayer.ico; DestDir: {app};
Source: get_iplayer_pvr.ico; DestDir: {app};
Source: get_iplayer_uninst.ico; DestDir: {app};
Source: {#SetupSetting('LicenseFile')}; DestDir: {app};
Source: sources.txt; DestDir: {app};
#ifndef NOPERL
Source: {#PerlSrc}\*; DestDir: {#PerlDir}; Excludes: \licenses; Flags: recursesubdirs createallsubdirs;
Source: {#PerlSrc}\licenses\*; DestDir: {#LicensesDir}; Flags: recursesubdirs createallsubdirs;
#endif
#ifndef NOUTILS
Source: {#AtomicParsleySrc}\AtomicParsley.exe; DestDir: {#UtilsDir}\bin; MinVersion: 6.1;
Source: {#AtomicParsleySrc}\COPYING; DestDir: {#LicensesDir}\atomicparsley; MinVersion: 6.1;
Source: {#FFmpegSrc}\ffmpeg.exe; DestDir: {#UtilsDir}\bin; MinVersion: 6.1;
Source: {#FFmpegSrc}\lgpl-2.1.txt; DestDir: {#LicensesDir}\ffmpeg; MinVersion: 6.1;
Source: {#FFmpegSrc}\lgpl.txt; DestDir: {#LicensesDir}\ffmpeg; MinVersion: 6.1;
Source: {#FFmpegSrc}\gpl-2.0.txt; DestDir: {#LicensesDir}\ffmpeg; MinVersion: 6.1;
Source: {#FFmpegSrc}\gpl.txt; DestDir: {#LicensesDir}\ffmpeg; MinVersion: 6.1;
#endif

[Icons]
Name: {group}\{#AppName}; Filename: {cmd}; \
  Parameters: "/k """"{app}\get_iplayer.cmd"" --search dontshowanymatches && ""{app}\get_iplayer.cmd"" --help"""; \
  WorkingDir: {#HomeDir}; IconFilename: {#GiPIcon};
Name: {group}\Web PVR Manager; Filename: {cmd}; \
  Parameters: "/c ""{app}\get_iplayer_web_pvr.cmd"""; WorkingDir: {#HomeDir}; IconFilename: {#GiPPVRIcon};
Name: {group}\Run PVR Scheduler; Filename: {cmd}; \
  Parameters: "/k ""{app}\get_iplayer_pvr.cmd"""; WorkingDir: {#HomeDir}; IconFilename: {#GiPPVRIcon};
Name: {group}\Uninstall {#AppName}; Filename: {uninstallexe}; IconFilename: {#SetupSetting('UninstallDisplayIcon')};
Name: {group}\Check for Update; Filename: {cmd}; \
  Parameters: "/k ""{app}\get_iplayer.cmd"" --release-check"; \
  WorkingDir: {#HomeDir}; IconFilename: {#SetupSetting('UninstallDisplayIcon')};
Name: {group}\Download {#AppName}; Filename: {#SetupSetting('AppUpdatesURL')};
Name: {group}\{#AppName} Documentation; Filename: {#GiPWiki};
Name: {group}\AtomicParsley Documentation; Filename: http://atomicparsley.sourceforge.net;
Name: {group}\FFmpeg Documentation; Filename: http://ffmpeg.org/documentation.html;
Name: {group}\Perl Documentation; Filename: http://perldoc.perl.org;
Name: {group}\Strawberry Perl Home; Filename: http://strawberryperl.com;
Name: {commondesktop}\{#AppName}; Filename: {cmd}; \
  Parameters: "/k """"{app}\get_iplayer.cmd"" --search dontshowanymatches && ""{app}\get_iplayer.cmd"" --help"""; \
  WorkingDir: {#HomeDir}; IconFilename: {#GiPIcon}; Tasks: desktopicons;
Name: {commondesktop}\Web PVR Manager; Filename: {cmd}; \
  Parameters: "/c ""{app}\get_iplayer_web_pvr.cmd"""; WorkingDir: {#HomeDir}; \
  IconFilename: {#GiPPVRIcon}; Tasks: desktopicons;
Name: {commondesktop}\Run PVR Scheduler; Filename: {cmd}; \
  Parameters: "/k ""{app}\get_iplayer_pvr.cmd"""; WorkingDir: {#HomeDir}; \
  IconFilename: {#GiPPVRIcon}; Tasks: desktopicons;
Name: {commondesktop}\{#AppName} Documentation; Filename: {#GiPWiki}; Tasks: desktopicons;

[Registry]
Root: HKLM; Subkey: "SYSTEM\CurrentControlSet\Control\Session Manager\Environment"; \
  ValueType: expandsz; ValueName: "Path";  ValueData: "{olddata};{app}"; Check: PathCheck(ExpandConstant('{app}'));

[Run]
Filename: {#GiPWiki}/releasenotes; Description: View {#AppName} release notes; \
  Flags: postinstall shellexec skipifsilent nowait;
Filename: {group}\{#AppName} Documentation.url; Description: View {#AppName} documentation; \
  Flags: postinstall shellexec skipifsilent nowait unchecked;
Filename: {cmd}; Parameters: "/k ""set ""PATH=%PATH%;{app}"" && ""{app}\get_iplayer.cmd"" --search dontshowanymatches && ""{app}\get_iplayer.cmd"" --help"""; \
  WorkingDir: {%HOMEDRIVE}{%HOMEPATH}; Description: Launch {#AppName};  \
  Flags: postinstall skipifsilent nowait unchecked;
Filename: {cmd}; Parameters: "/c ""set ""PATH=%PATH%;{app}"" && ""{app}\get_iplayer_web_pvr.cmd"""; \
  WorkingDir: {%HOMEDRIVE}{%HOMEPATH}; Description: Launch Web PVR Manager; \
  Flags: postinstall skipifsilent nowait unchecked;

[Messages]
BeveledLabel={#SetupSetting('AppVerName')}

[Code]
function UninstallPrevious(UninstallString, UninstallParams, DisplayName: String): Integer;
var
  Prompt: String;
  RC: Integer;
begin
  Log('UninstallPrevious: Enter');
  Result := IDOK;
  if Pos('Uninst.exe', UninstallString) > 0 then
  begin
    // get_iplayer 2.94.0/installer 4.9 or earlier
    Prompt := 'Setup must uninstall ' + DisplayName + ' before continuing. Your settings will be preserved. ' +
      'Select "No" when prompted to "Remove User Preferences, PVR Searches, Presets and Recording History?". ' +
      'If you configured a custom output directory with an obsolete version ' +
      'of {#AppName} Setup, reconfigure it after installation with:' + #13#10#13#10 +
      '{#AppName} --prefs-add --output="<output_directory>"' + #13#10#13#10 + 
      'Click OK to continue or Cancel to exit {#AppName} Setup';
    Result := MsgBox(Prompt, mbConfirmation, MB_OKCANCEL or MB_DEFBUTTON2);
  end
  else
  begin
    Prompt := 'Setup must uninstall ' + DisplayName + ' before continuing. ' +
      'Your settings will be preserved.' + #13#10#13#10 +
      'Click OK to continue or Cancel to exit {#AppName} Setup';
    Result := SuppressibleMsgBox(Prompt, mbConfirmation, MB_OKCANCEL or MB_DEFBUTTON2, IDOK);
  end;
  if Result = IDCANCEL then
  begin
    Log('UninstallPrevious: Cancelled');
    exit;
  end;
  if not Exec(UninstallString, UninstallParams, '', SW_SHOW, ewWaitUntilTerminated, RC) then
  begin
    Log(Format('UninstallPrevious: Error: rc=%d msg=%s', [RC, SysErrorMessage(RC)]));
    Prompt := 'Uninstall of ' + DisplayName + ' generated an error.' + #13#10#13#10 + 
      Format('ERROR: Code=%d Message=%s', [RC, SysErrorMessage(RC)]);
  end
  else
  begin
    if RC <> 0 then
    begin
      Log(Format('UninstallPrevious: Aborted: rc=%d', [RC]));
      Prompt := 'Uninstall of ' + DisplayName + ' was aborted.';
    end;
  end;
  if RC <> 0 then
  begin
    Log('UninstallPrevious: Failed');
    Prompt := Prompt + #13#10#13#10 + 
      'Uninstall ' + DisplayName + ' in Settings->Apps->Apps & features ' +
      'or Control Panel->Programs and Features and then run {#AppName} Setup again.';
    SuppressibleMsgBox(Prompt, mbError, MB_OK, IDOK);
    Result := IDCANCEL;
  end;
  Log(Format('UninstallPrevious: Exit=%d', [Result]));
end;

function NSISUninstallPrevious(): Integer;
var
  RegKey, UninstallString, UninstallParams, DisplayName: String;
begin
  Log('NSISUninstallPrevious: Enter');
  Result := IDOK;
  RegKey := 'SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{#AppName}';
  Log('NSISUninstallPrevious: RegKey=' + RegKey);
  if not RegQueryStringValue(HKLM32, RegKey, 'UninstallString', UninstallString) then
  begin
    Log('NSISUninstallPrevious: UninstallString not defined');
    exit;
  end;
  UninstallString := RemoveQuotes(UninstallString);
  Log('NSISUninstallPrevious: UninstallString=' + UninstallString);
  if not FileExists(UninstallString) then
  begin
    Log('NSISUninstallPrevious: UninstallString not found');
    exit;
  end;
  UninstallParams := '/S _?=' + ExtractFileDir(UninstallString);
  Log('NSISUninstallPrevious: UninstallParams=' + UninstallParams);
  if not RegQueryStringValue(HKLM32, RegKey, 'DisplayName', DisplayName) then
  begin
    Log('NSISUninstallPrevious: DisplayName not defined');
    DisplayName := 'an obsolete version';
  end;
  Log('NSISUninstallPrevious: DisplayName=' + DisplayName);
  Result := UninstallPrevious(UninstallString, UninstallParams, DisplayName);
  if Result = IDOK then
  begin
    // ensure removal of obsolete system options
    DeleteFile(ExpandConstant('{commonappdata}\{#AppName}\options'));
    RemoveDir(ExpandConstant('{commonappdata}\{#AppName}'));
  end;
  Log(Format('NSISUninstallPrevious: Exit=%d', [Result]));
end;

function InnoUninstallPrevious(): Integer;
var
  RegKey, UninstallString, UninstallParams, DisplayName: String;
  US, DN: Boolean;
begin
  Log('InnoUninstallPrevious: Enter');
  Result := IDOK;
  RegKey := 'SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{#AppName}_is1';
  Log('InnoUninstallPrevious: RegKey=' + RegKey);
  if Is64BitInstallMode() then
  begin
    Log('InnoUninstallPrevious: Is64BitInstallMode=True');
    US := RegQueryStringValue(HKLM32, RegKey, 'UninstallString', UninstallString);
    DN := RegQueryStringValue(HKLM32, RegKey, 'DisplayName', DisplayName);
  end
  else
  begin
    Log('InnoUninstallPrevious: Is64BitInstallMode=False');
    if IsWin64() then
    begin
      Log('InnoUninstallPrevious: IsWin64=True');
      US := RegQueryStringValue(HKLM64, RegKey, 'UninstallString', UninstallString);
      DN := RegQueryStringValue(HKLM64, RegKey, 'DisplayName', DisplayName);
    end
    else
    begin
      Log('InnoUninstallPrevious: IsWin64=False');
      Log('InnoUninstallPrevious: No need to remove previous version');
      exit;
    end;
  end;
  if not US then
  begin
    Log('InnoUninstallPrevious: UninstallString not defined');
    exit;
  end;
  UninstallString := RemoveQuotes(UninstallString);
  Log('InnoUninstallPrevious: UninstallString=' + UninstallString);
  if not FileExists(UninstallString) then
  begin
    Log('InnoUninstallPrevious: UninstallString not found');
    exit;
  end;
  UninstallParams := '/VERYSILENT /SUPPRESSMSGBOXES';
  Log('InnoUninstallPrevious: UninstallParams=' + UninstallParams);
  if not DN then
  begin
    Log('InnoUninstallPrevious: DisplayName not defined');
    DisplayName := 'your previous version';
  end;
  Log('InnoUninstallPrevious: DisplayName=' + DisplayName);
  Result := UninstallPrevious(UninstallString, UninstallParams, DisplayName);
  Log(Format('InnoUninstallPrevious: Exit=%d', [Result]));
end;

function IsWindows7OrLater(): Boolean;
begin
  Result := (GetWindowsVersion() >= $06010000);
end;

function XPVistaWarning(): Integer;
var
  Prompt: String;
begin
  Result := IDOK;
  Prompt := 'NOTE: Windows 7 is the minimum version required for the bundled versions ' +
    'of ffmpeg and AtomicParsley. ffmpeg and AtomicParsley are not required to download ' +
    'programmes, but they are required to convert output files to MP4 and to add metadata tags. ' +
    'If you wish to use {#AppName} on Windows XP/Vista, you must install compatible versions ' +
    'of ffmpeg and AtomicParsley in the following directory:' + #13#10#13#10 + 
    ExpandConstant('{#UtilsDir}\bin') + #13#10#13#10 +
    'Click OK to continue or Cancel to exit setup';
  Result := MsgBox(Prompt, mbConfirmation, MB_OKCANCEL or MB_DEFBUTTON2);
end;

function PrepareToInstall(var NeedsRestart: Boolean): String;
var
  RC: Integer;
begin
  if not IsWindows7OrLater() then
  begin
    RC := XPVistaWarning();
    if RC = IDCANCEL then
    begin
      Result := 'Setup cancelled';
      exit;
    end;
  end;
  RC := NSISUninstallPrevious();
  if RC = IDCANCEL then
  begin
    Result := 'Setup cancelled';
    exit;
  end;
  RC := InnoUninstallPrevious();
  if RC = IDCANCEL then
  begin
    Result := 'Setup cancelled';
    exit;
  end;
end;

function PathCheck(Param: String): Boolean;
var
    OrigPath: String;
    Index: Integer;
begin
  Log('PathCheck: Enter');
  if not RegQueryStringValue(HKEY_LOCAL_MACHINE,
    'SYSTEM\CurrentControlSet\Control\Session Manager\Environment',
    'Path', OrigPath) then
  begin
    Log('PathCheck: Empty path');
    Result := True;
    exit;
  end;
  Index := Pos(';' + Param + ';', OrigPath + ';');
  Log(Format('PathCheck: Index=%d OrigPath=%s', [Index, OrigPath]));
  if IsUninstaller() and (Index > 0) then
  begin
    Log('PathCheck: Uninstall');
    Delete(OrigPath, Index, Length(Param) + 1);
    if not RegWriteStringValue(HKEY_LOCAL_MACHINE,
      'SYSTEM\CurrentControlSet\Control\Session Manager\Environment',
      'Path', OrigPath) then
    begin
      Log('PathCheck: Write failed');
    end;
  end;
  Result := (Index = 0);
  Log(Format('PathCheck: Exit=%d', [Result]));
 end;

function CopyLog(): Boolean;
var
  LogFile, LogFileName, LogFileCopy: String;
begin
  Result := False
  LogFile := ExpandConstant('{log}');
  if (Length(LogFile) > 0) and (FileExists(LogFile)) then
  begin
    LogFileName := ExtractFileName(LogFile);
    LogFileCopy := ExpandConstant('{app}\' + LogFileName);
    Result := FileCopy(LogFile, LogFileCopy, False);
  end;
end;

procedure CurStepChanged(CurStep: TSetupStep);
begin
  if CurStep = ssDone then
  begin
    CopyLog();
  end;
end;

procedure CurUninstallStepChanged(CurUninstallStep: TUninstallStep);
begin
  if CurUninstallStep = usUninstall then
  begin
    PathCheck(ExpandConstant('{app}'));
  end;
end;

#ifdef DUMPISPP
  #expr SaveToFile(AddBackslash(SourcePath) + "get_iplayer.ispp.iss")
#endif
