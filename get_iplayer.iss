#pragma parseroption -p-
; #define DUMPISPP
; #define CLEANUP
; #define NOPERL
; #define NOUTILS
#ifndef GiPVersion
  #define GiPVersion "3.07"
#endif
#ifndef SetupBuild
  #define SetupBuild "0"
#endif
#expr Exec("make-gip.cmd", GiPVersion + ' ' + SetupBuild, SourcePath, 1, SW_HIDE)
#define SetupDir "build\\setup"
#define SetupSuffix '-setup'
#ifdef CLEANUP
  #define SetupSuffix SetupSuffix + '-cleanup'
#endif
#ifdef NOPERL
  #define SetupSuffix SetupSuffix + '-noperl'
#endif
#ifdef NOUTILS
  #define SetupSuffix SetupSuffix + '-noutils'
#endif
#define AppName "get_iplayer"
#define AppVersion GiPVersion + '.' + SetupBuild
#define GiPRepo "https://github.com/get-iplayer/get_iplayer"
#define GiPWiki GiPRepo + "/wiki"
#define GiPWin32Repo "https://github.com/get-iplayer/get_iplayer_win32"
#define GiPSrc "build\\get_iplayer\\get_iplayer-" + AppVersion
#define PerlSrc "build\\perl\\perl-5.24.1"
#define AtomicParsleySrc "utils\\AtomicParsley-0.9.6"
#define FFmpegSrc "utils\\ffmpeg-3.4-win32-static"
#define PerlDir "{app}\\perl"
#define UtilsDir "{app}\\utils"
#define LicensesDir UtilsDir + "\\licenses"
#define GiPIcon "{app}\\get_iplayer.ico"
#define GiPPVRIcon "{app}\\get_iplayer_pvr.ico"
#define HomeDir "%HOMEDRIVE%%HOMEPATH%"

[Setup]
AppCopyright=Copyright (C) 2008-2010 Phil Lewis
AppName={#AppName}
AppPublisher=The {#AppName} Contributors
AppPublisherURL={#GiPRepo}
AppSupportURL={#GiPWiki}
AppUpdatesURL={#GiPWin32Repo}/releases
AppVerName={#AppName} {#AppVersion}
AppVersion={#AppVersion}
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
SetupIconFile=get_iplayer.ico
UninstallDisplayIcon={app}\get_iplayer_uninst.ico

[Tasks]
Name: desktopicons; Description: Create &desktop shortcuts (for all users); Flags: unchecked;

[InstallDelete]
#ifdef CLEANUP
; removed in 4.3
Type: files; Name: {app}\linuxcentre.url;
Type: files; Name: {app}\get_iplayer_setup.nsi;
Type: files; Name: {app}\update_get_iplayer.cmd;
Type: files; Name: {app}\get_iplayer.cgi.old;
Type: files; Name: {app}\get_iplayer.pl.old;
Type: filesandordirs; Name: {app}\rtmpdump-2.2d;
Type: dirifempty; Name: {app}\Downloads;
; incomplete uninstallers before 4.6
Type: files; Name: {app}\update_get_iplayer.cmd;
Type: files; Name: {group}\Recordings Folder.lnk;
Type: files; Name: {group}\Run PVR Scheduler Now.lnk;
Type: files; Name: {group}\Uninstall Components.lnk;
Type: files; Name: {group}\Help\*.lnk;
Type: dirifempty; Name: {group}\Help;
Type: filesandordirs; Name: {group}\Updates;
Type: dirifempty; Name: {group};
; removed in 2.95.0
#define RemoveHelper(str HelperName) \
'Type: files; Name: {app}\\' + HelperName + '.zip;' + "\n" + \
'Type: files; Name: {app}\\' + HelperName + '_docs.url;' + "\n" + \
'Type: filesandordirs; Name: {app}\\' + HelperName + ';'
{#RemoveHelper("AtomicParsley")}
{#RemoveHelper("FFmpeg")}
{#RemoveHelper("LAME")}
{#RemoveHelper("MPlayer")}
{#RemoveHelper("RTMPDump")}
{#RemoveHelper("VLC")}
Type: files; Name: {app}\get_iplayer--pvr.bat;
Type: files; Name: {app}\run_pvr_scheduler.bat;
Type: files; Name: {app}\get_iplayer_docs.url;
Type: files; Name: {app}\get_iplayer_examples.url;
Type: files; Name: {app}\get_iplayer_home.url;
Type: files; Name: {app}\command_examples.url;
Type: files; Name: {app}\nsis_docs.url;
Type: files; Name: {app}\strawberry_docs.url;
Type: files; Name: {app}\download_latest_installer.url;
Type: files; Name: {app}\pvr_manager.url;
Type: files; Name: {app}\get_iplayer-ver.txt;
Type: files; Name: {app}\get_iplayer-ver-check.txt;
Type: files; Name: {app}\get_iplayer_config.ini;
Type: files; Name: {app}\get_iplayer_config-check.ini;
Type: files; Name: {app}\iplayer_logo.ico;
Type: files; Name: {app}\perl.exe;
Type: files; Name: {app}\*.dll;
Type: filesandordirs; Name: {app}\lib;
Type: filesandordirs; Name: {app}\perl-license;
Type: files; Name: {userprograms}\VLC Media Player.lnk;
Type: filesandordirs; Name: {userprograms}\get_iplayer;
Type: files; Name: {commonappdata}\get_iplayer\options;
Type: dirifempty; Name: {commonappdata}\get_iplayer;
Type: files; Name: {app}\Uninst.exe;
Type: files; Name: {code:VirtualStoreDir}\get_iplayer\get_iplayer*;
Type: dirifempty; Name: {code:VirtualStoreDir}\get_iplayer;
#define PluginsDir "{%USERPROFILE}\\.get_iplayer\\plugins"
Type: files; Name: {#PluginsDir}\localfiles.plugin;
Type: files; Name: {#PluginsDir}\localfiles.plugin.old;
Type: files; Name: {#PluginsDir}\podcast.plugin;
Type: files; Name: {#PluginsDir}\podcast.plugin.old;
Type: files; Name: {#PluginsDir}\plugin.template;
Type: dirifempty; Name: {#PluginsDir};
; removed in 3.00.0
Type: files; Name: {group}\Help\RTMPDump Documentation.url;
Type: files; Name: {app}\utils\rtmpdump.exe;
Type: filesandordirs; Name: {app}\utils\licenses\rtmpdump;
; removed in 3.06.0
Type: files; Name: {app}\pvr_manager.cmd;
Type: files; Name: {app}\run_pvr_scheduler.cmd;
Type: files; Name: {group}\Help\get_iplayer Examples.url;
; removed in 3.07.0
Type: files; Name: {app}\uninstall.exe;
#else
; ensure removal of obsolete system options
Type: files; Name: {commonappdata}\get_iplayer\options;
Type: dirifempty; Name: {commonappdata}\get_iplayer;
; ensure removal of obsolete uninstallers
Type: files; Name: {app}\Uninst.exe;
Type: files; Name: {app}\uninstall.exe;
#endif
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
Source: get_iplayer.cgi.cmd; DestDir: {app};
Source: get_iplayer_web_pvr.cmd; DestDir: {app};
Source: get_iplayer_pvr.cmd; DestDir: {app};
Source: get_iplayer.ico; DestDir: {app};
Source: get_iplayer_pvr.ico; DestDir: {app};
Source: get_iplayer_uninst.ico; DestDir: {app};
Source: {#SetupSetting('LicenseFile')}; DestDir: {app};
#ifndef NOPERL
Source: {#PerlSrc}\*; DestDir: {#PerlDir}; Flags: recursesubdirs createallsubdirs;
#endif
#ifndef NOUTILS
Source: sources.txt; DestDir: {#UtilsDir};
Source: {#AtomicParsleySrc}\AtomicParsley.exe; DestDir: {#UtilsDir};
Source: {#AtomicParsleySrc}\COPYING; DestDir: {#LicensesDir}\atomicparsley;
Source: {#FFmpegSrc}\bin\ffmpeg.exe; DestDir: {#UtilsDir}; MinVersion: 6.1;
Source: {#FFmpegSrc}\LICENSE.txt; DestDir: {#LicensesDir}\ffmpeg; MinVersion: 6.1;
Source: {#FFmpegSrc}\README.txt; DestDir: {#LicensesDir}\ffmpeg; MinVersion: 6.1;
#endif

[Icons]
Name: {group}\{#AppName}; Filename: {cmd}; \
  Parameters: /k get_iplayer.cmd --search dontshowanymatches && get_iplayer.cmd --help; \
  WorkingDir: {#HomeDir}; IconFilename: {#GiPIcon};
Name: {group}\Web PVR Manager; Filename: {cmd}; \
  Parameters: /c get_iplayer_web_pvr.cmd; WorkingDir: {#HomeDir}; IconFilename: {#GiPPVRIcon};
Name: {group}\Run PVR Scheduler; Filename: {cmd}; \
  Parameters: /k get_iplayer_pvr.cmd; WorkingDir: {#HomeDir}; IconFilename: {#GiPPVRIcon};
Name: {group}\Uninstall; Filename: {uninstallexe}; IconFilename: {#SetupSetting('UninstallDisplayIcon')};
Name: {group}\Help\{#AppName} Documentation; Filename: {#GiPWiki};
Name: {group}\Help\AtomicParsley Documentation; Filename: http://atomicparsley.sourceforge.net;
Name: {group}\Help\FFmpeg Documentation; Filename: http://ffmpeg.org/documentation.html;
Name: {group}\Help\Perl Documentation; Filename: http://perldoc.perl.org;
Name: {group}\Help\Strawberry Perl Home; Filename: http://strawberryperl.com;
Name: {group}\Update\Check for Update; Filename: {#SetupSetting('AppUpdatesURL')};
Name: {commondesktop}\{#AppName}; Filename: {cmd}; \
  Parameters: /k get_iplayer.cmd --search dontshowanymatches && get_iplayer.cmd --help; \
  WorkingDir: {#HomeDir}; IconFilename: {#GiPIcon}; Tasks: desktopicons;
Name: {commondesktop}\Web PVR Manager; Filename: {cmd}; \
  Parameters: /c get_iplayer_web_pvr.cmd; WorkingDir: {#HomeDir}; \
  IconFilename: {#GiPPVRIcon}; Tasks: desktopicons;
Name: {commondesktop}\Run PVR Scheduler; Filename: {cmd}; \
  Parameters: /k get_iplayer_pvr.cmd; WorkingDir: {#HomeDir}; \
  IconFilename: {#GiPPVRIcon}; Tasks: desktopicons;
Name: {commondesktop}\{#AppName} Documentation; Filename: {#GiPWiki};

[Registry]
#ifdef CLEANUP
; removed in 2.95.0
Root: HKCU; Subkey: Software\get_iplayer; ValueType: none; Flags: deletekey;
; removed in 3.07.0
Root: HKLM; Subkey: Software\Microsoft\Windows\CurrentVersion\Uninstall\get_iplayer; \
  ValueType: none; Flags: deletekey;
#endif

[Run]
Filename: {#GiPWiki}/releasenotes; Description: View {#AppName} release notes; \
  Flags: postinstall shellexec skipifsilent nowait;
Filename: {group}\Help\{#AppName} Documentation.url; Description: View {#AppName} documentation; \
  Flags: postinstall shellexec skipifsilent nowait unchecked;
Filename: {group}\{#AppName}.lnk; Description: Launch {#AppName}; \
  Flags: postinstall shellexec skipifsilent nowait unchecked;
Filename: {group}\Web PVR Manager.lnk; Description: Launch Web PVR Manager; \
  Flags: postinstall shellexec skipifsilent nowait unchecked;

[Messages]
BeveledLabel={#SetupSetting('AppVerName')}

[Code]
#ifdef CLEANUP
function VirtualStoreDir(Param: String): String;
var
  pf: String;
begin
  Log('VirtualStoreDir: enter');
  pf := ExpandConstant('{pf}');
  Log('VirtualStoreDir: pf=' + pf);
  Result := ExpandConstant('{localappdata}\VirtualStore' +
      Copy(pf, Length(ExtractFileDrive(pf)) + 1, MaxInt));
  Log('VirtualStoreDir: exit=' + Result);
end;

function ConfigRead(ConfigFile, KeyName, DefaultValue: String): String;
var
  I: Integer;
  KeyFull: String;
  FileLines: TArrayOfString;
begin
  Result := DefaultValue;
  if not LoadStringsFromFile(ConfigFile, FileLines) then
    exit;
  KeyFull := KeyName + ' ';
  for I := 0 to GetArrayLength(FileLines) - 1 do
  begin
    FileLines[I] := TrimLeft(FileLines[I]);
    if Pos(KeyFull, FileLines[I]) = 1 then
    begin
      Result := Copy(FileLines[I], Length(KeyFull) + 1, MaxInt);
      Break;
    end;
  end;
end;

procedure TransferOutputDir();
var
  Prompt, ProfileDir, UserOptionsFile, UserOutputDir, SysOptionsFile, SysOutputDir: String;
begin
  Log('TransferOutputDir: enter');
  ProfileDir := GetEnv('GETIPLAYERUSERPREFS');
  if Length(ProfileDir) = 0 then
    ProfileDir := ExpandConstant('{%USERPROFILE}\.get_iplayer');
  Log('TransferOutputDir: ProfileDir=' + ProfileDir);
  UserOptionsFile := AddBackslash(ProfileDir) + 'options';
  Log('TransferOutputDir: UserOptionsFile=' + UserOptionsFile);
  UserOutputDir := Trim(ConfigRead(UserOptionsFile, 'output', ''));
  Log('TransferOutputDir: UserOutputDir=' + UserOutputDir);
  if Length(UserOutputDir) > 0 then
  begin
    Log('TransferOutputDir: Custom output dir defined');
    exit;
  end;
  SysOptionsFile := ExpandConstant('{commonappdata}\get_iplayer\options');
  Log('TransferOutputDir: SysOptionsFile=' + SysOptionsFile);
  SysOutputDir := Trim(ConfigRead(SysOptionsFile, 'output', ''));
  Log('TransferOutputDir: SysOutputDir=' + SysOutputDir);
  if (Length(SysOutputDir) = 0) or
      (CompareText(RemoveBackslash(SysOutputDir),
      ExpandConstant('{userdesktop}\iPlayer Recordings')) = 0) then
  begin
    Log('TransferOutputDir: Custom output dir not defined');
    exit;
  end;
  if ForceDirectories(ProfileDir) then
  begin
    if SaveStringsToUTF8File(UserOptionsFile, ['output ' + SysOutputDir], True) then
    begin
      Log('TransferOutputDir: Transfer completed');
      exit;
    end
    else
      Log('TransferOutputDir: Could not write to options file');
  end
  else
    Log('TransferOutputDir: Could not create profile dir');
  Prompt := 'Setup was unable to transfer your previous custom output directory ' +
      'configuration to your user preferences. You can reconfigure it after ' +
      'installation with the following command:' + #13#10#13#10 +
      '{#AppName} --prefs-add --output="' + SysOutputDir + '"';
  SuppressibleMsgBox(Prompt, mbError, MB_OK, IDOK);
  Log('TransferOutputDir: exit');
end;

#else
function NSISUninstall(): Integer;
var
  Uninstaller, Prompt: String;
  RC: Integer;
begin
  Log('NSISUninstall: enter');
  Result := IDOK;
  if not RegQueryStringValue(HKLM,
    'Software\Microsoft\Windows\CurrentVersion\Uninstall\get_iplayer',
    'UninstallString', Uninstaller) then
  begin
    Log('NSISUninstall: uninstaller not defined');
    exit;
  end;
  Log('NSISUninstall: uninstaller=' + Uninstaller);
  if not FileExists(Uninstaller) then
  begin
    Log('NSISUninstall: uninstaller not found');
    exit;
  end;
  if Pos('Uninst.exe', Uninstaller) > 0 then
  begin
    // get_iplayer 2.94.0/installer 4.9 or earlier
    Prompt := 'Setup will now uninstall your previous version of {#AppName}. ';
    Prompt := Prompt + 'Select "No" when prompted to "Remove User Preferences, ' +
        'PVR Searches, Presets and Recording History". ';
    Prompt := Prompt + 'If you configured a custom output directory with a previous ' +
        'version of {#AppName} Setup, reconfigure it after installation with:' + #13#10#13#10 +
        '{#AppName} --prefs-add --output="your_custom_output_directory_here"';
    Prompt := Prompt + #13#10#13#10 + 'Click OK to continue or Cancel to exit setup';
    Result := MsgBox(Prompt, mbConfirmation, MB_OKCANCEL or MB_DEFBUTTON2);
  end
  else
  begin
    // get_iplayer 2.95.0 - 3.06.0
    Prompt := 'Setup will now uninstall your previous version of {#AppName}. ';
    Prompt := Prompt + #13#10#13#10 + 'Click OK to continue or Cancel to exit setup';
    Result := SuppressibleMsgBox(Prompt, mbConfirmation, MB_OKCANCEL or MB_DEFBUTTON2, IDOK);
  end;
  if Result = IDCANCEL then
  begin
    Log('NSISUninstall: cancelled');
    exit;
  end;
  if not Exec(Uninstaller, '/S _?=' + ExtractFileDir(Uninstaller), '', SW_SHOW,
      ewWaitUntilTerminated, RC) then
  begin
    Log(Format('NSISUninstall: uninstaller error: rc=%d msg=%s', [RC, SysErrorMessage(RC)]));
    Prompt := 'Uninstall of your previous version of {#AppName} generated an error.';
    Prompt := Prompt + #13#10#13#10 + Format('ERROR: Code=%d Message=%s', [RC, SysErrorMessage(RC)]);
  end
  else
    if RC <> 0 then
    begin
      Log(Format('NSISUninstall: uninstaller aborted: rc=%d', [RC]));
      Prompt := 'Uninstall of your previous version of {#AppName} was aborted.';
    end;
  begin
  end;
  if RC <> 0 then
  begin
    Log('NSISUninstall: failed');
    Prompt := Prompt + #13#10#13#10 + 'Uninstall your previous version of {#AppName} ' +
        'in Windows Control Panel and then re-run {#AppName} Setup.'
    SuppressibleMsgBox(Prompt, mbError, MB_OK, IDOK);
    Result := IDCANCEL;
  end;
  Log(Format('NSISUninstall: exit=%d', [Result]));
end;

#endif
function IsWindows7OrLater(): Boolean;
begin
  Result := (GetWindowsVersion() >= $06010000);
end;

function XPVistaWarning(): Integer;
var
  Prompt: String;
begin
  Result := IDOK;
  Prompt := 'NOTE: {#AppName} is not supported by the developer for use on Windows XP or Vista. ' +
      'Windows 7 is the minimum version required by the bundled version of ffmpeg. ' +
      'ffmpeg is not required to download programmes, but it is required to convert ' +
      'output files to MP4 and to add metadata tags. If you wish to use get_iplayer ' +
      'on Windows XP or Vista, you must install a compatible version of ffmpeg in ' +
      'the following directory:' + #13#10#13#10 +
      ExpandConstant('{#UtilsDir}') + #13#10#13#10 +
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
#ifdef CLEANUP
  TransferOutputDir();
#else
  RC := NSISUninstall();
  if RC = IDCANCEL then
  begin
    Result := 'Setup cancelled';
    exit;
  end;
#endif
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

// function ShouldSkipPage(PageID: Integer): Boolean;
// begin
//   Result := False;
//   if (PageID = wpReady) and (not IsTaskSelected('desktopicons')) then
//     Result := True;
// end;

// ----------------------------------------------------------------------------
//
// Inno Setup Ver:	5.4.2
// Script Version:	1.4.2
// Author:			Jared Breland <jbreland@legroom.net>
// Homepage:		http://www.legroom.net/software
// License:			GNU Lesser General Public License (LGPL), version 3
//						http://www.gnu.org/licenses/lgpl.html
//
// Script Function:
//	Allow modification of environmental path directly from Inno Setup installers
//
// ----------------------------------------------------------------------------

const
  ModPathName = 'modifypath';
  ModPathType = 'system';

function ModPathDir(): TArrayOfString;
begin
  setArrayLength(Result, 1);
  Result[0] := ExpandConstant('{app}');
end;

procedure ModPath();
var
	oldpath:    String;
	newpath:    String;
	updatepath: Boolean;
	pathArr:    TArrayOfString;
	aExecFile:  String;
	aExecArr:   TArrayOfString;
	i, d:       Integer;
	pathdir:    TArrayOfString;
	regroot:    Integer;
	regpath:    String;

begin
	// Get constants from main script and adjust behavior accordingly
	// ModPathType MUST be 'system' or 'user'; force 'user' if invalid
	if ModPathType = 'system' then begin
		regroot := HKEY_LOCAL_MACHINE;
		regpath := 'SYSTEM\CurrentControlSet\Control\Session Manager\Environment';
	end else begin
		regroot := HKEY_CURRENT_USER;
		regpath := 'Environment';
	end;

	// Get array of new directories and act on each individually
	pathdir := ModPathDir();
	for d := 0 to GetArrayLength(pathdir)-1 do begin
		updatepath := true;

		// Modify WinNT path
		if UsingWinNT() = true then begin

			// Get current path, split into an array
			RegQueryStringValue(regroot, regpath, 'Path', oldpath);
			oldpath := oldpath + ';';
			i := 0;

			while (Pos(';', oldpath) > 0) do begin
				SetArrayLength(pathArr, i+1);
				pathArr[i] := Copy(oldpath, 0, Pos(';', oldpath)-1);
				oldpath := Copy(oldpath, Pos(';', oldpath)+1, Length(oldpath));
				i := i + 1;

				// Check if current directory matches app dir
				if pathdir[d] = pathArr[i-1] then begin
					// if uninstalling, remove dir from path
					if IsUninstaller() = true then begin
						continue;
					// if installing, flag that dir already exists in path
					end else begin
						updatepath := false;
					end;
				end;

				// Add current directory to new path
				if i = 1 then begin
					newpath := pathArr[i-1];
				end else begin
					newpath := newpath + ';' + pathArr[i-1];
				end;
			end;

			// Append app dir to path if not already included
			if (IsUninstaller() = false) AND (updatepath = true) then
				newpath := newpath + ';' + pathdir[d];

			// Write new path
			RegWriteStringValue(regroot, regpath, 'Path', newpath);

		// Modify Win9x path
		end else begin

			// Convert to shortened dirname
			pathdir[d] := GetShortName(pathdir[d]);

			// If autoexec.bat exists, check if app dir already exists in path
			aExecFile := 'C:\AUTOEXEC.BAT';
			if FileExists(aExecFile) then begin
				LoadStringsFromFile(aExecFile, aExecArr);
				for i := 0 to GetArrayLength(aExecArr)-1 do begin
					if IsUninstaller() = false then begin
						// If app dir already exists while installing, skip add
						if (Pos(pathdir[d], aExecArr[i]) > 0) then
							updatepath := false;
							break;
					end else begin
						// If app dir exists and = what we originally set, then delete at uninstall
						if aExecArr[i] = 'SET PATH=%PATH%;' + pathdir[d] then
							aExecArr[i] := '';
					end;
				end;
			end;

			// If app dir not found, or autoexec.bat didn't exist, then (create and) append to current path
			if (IsUninstaller() = false) AND (updatepath = true) then begin
				SaveStringToFile(aExecFile, #13#10 + 'SET PATH=%PATH%;' + pathdir[d], True);

			// If uninstalling, write the full autoexec out
			end else begin
				SaveStringsToFile(aExecFile, aExecArr, False);
			end;
		end;
	end;
end;

// Split a string into an array using passed delimeter
procedure MPExplode(var Dest: TArrayOfString; Text: String; Separator: String);
var
	i: Integer;
begin
	i := 0;
	repeat
		SetArrayLength(Dest, i+1);
		if Pos(Separator,Text) > 0 then	begin
			Dest[i] := Copy(Text, 1, Pos(Separator, Text)-1);
			Text := Copy(Text, Pos(Separator,Text) + Length(Separator), Length(Text));
			i := i + 1;
		end else begin
			 Dest[i] := Text;
			 Text := '';
		end;
	until Length(Text)=0;
end;

procedure CurStepChanged(CurStep: TSetupStep);
begin
  if CurStep = ssInstall then
  begin
  end;
  if CurStep = ssPostInstall then
  begin
    ModPath();
  end;
  if CurStep = ssDone then
  begin
    CopyLog();
  end;
end;

procedure CurUninstallStepChanged(CurUninstallStep: TUninstallStep);
var
	aSelectedTasks: TArrayOfString;
	i:              Integer;
	taskname:       String;
	regpath:        String;
	regstring:      String;
	appid:          String;
begin
	// only run during actual uninstall
	if CurUninstallStep = usUninstall then begin
		// get list of selected tasks saved in registry at install time
		appid := '{#emit SetupSetting("AppId")}';
		if appid = '' then appid := '{#emit SetupSetting("AppName")}';
		regpath := ExpandConstant('Software\Microsoft\Windows\CurrentVersion\Uninstall\'+appid+'_is1');
		RegQueryStringValue(HKLM, regpath, 'Inno Setup: Selected Tasks', regstring);
		if regstring = '' then RegQueryStringValue(HKCU, regpath, 'Inno Setup: Selected Tasks', regstring);

		// check each task; if matches modpath taskname, trigger patch removal
		if regstring <> '' then begin
			taskname := ModPathName;
			MPExplode(aSelectedTasks, regstring, ',');
			if GetArrayLength(aSelectedTasks) > 0 then begin
				for i := 0 to GetArrayLength(aSelectedTasks)-1 do begin
					if comparetext(aSelectedTasks[i], taskname) = 0 then
						ModPath();
				end;
			end;
		end;
	end;
end;

function NeedRestart(): Boolean;
var
	taskname:	String;
begin
	taskname := ModPathName;
	if IsTaskSelected(taskname) and not UsingWinNT() then begin
		Result := True;
	end else begin
		Result := False;
	end;
end;

#ifdef DUMPISPP
  #expr SaveToFile(AddBackslash(SourcePath) + "get_iplayer.ispp.iss")
#endif
