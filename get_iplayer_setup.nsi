;#######################################
;# Product Info
;#######################################

!define PRODUCT "get_iplayer"
!define VERSION "2.94.0"
; VERSION where Perl support last changed
!define PERLFILESVER "2.94.0"
; VERSION where helpers last changed
!define HELPERSVER "2.94.0"

;#######################################
;# get_iplayer host site
;#######################################

!define GITHUB_REPO "https://github.com/get-iplayer/get_iplayer"

;#######################################
;# Build Setup
;#######################################

!ifndef BUILDPATH
!define BUILDPATH "."
!endif
!ifndef SOURCEPATH
!define SOURCEPATH ".."
!endif
!ifndef PERLFILES
!define PERLFILES "${BUILDPATH}\perlfiles_${PERLFILESVER}"
!endif
!ifndef HELPERS
!define HELPERS "${BUILDPATH}\helpers_${HELPERSVER}"
!endif

;#######################################
;# Configuration
;#######################################

Name "get_iplayer"
SetCompressor /SOLID lzma
OutFile "${BUILDPATH}\get_iplayer-${VERSION}.exe"
RequestExecutionLevel admin
; default install location
InstallDir "$PROGRAMFILES\${PRODUCT}\"
; remember install folder
InstallDirRegKey HKCU "Software\${PRODUCT}" ""

;#######################################
;# Includes
;#######################################
!include "MUI2.nsh"
!include "Sections.nsh"
!include "FileFunc.nsh"
!include "StrFunc.nsh"
!include "TextFunc.nsh"
!include "Locate.nsh"
; StrFunc functions must be declared before use
${StrRep}
${StrCase}
${StrLoc}

;#######################################
;# Install Locations
;#######################################

; declare here for MUI_DIRECTORYPAGE_VARIABLE below
Var RecDir

;#######################################
;# Pages
;#######################################

; show warning on cancel
!define MUI_ABORTWARNING
; define the setup EXE logo
!define MUI_ICON "${SOURCEPATH}\windows\installer_files\iplayer_logo.ico"
!define MUI_UNICON "${SOURCEPATH}\windows\installer_files\iplayer_uninst.ico"
; welcome page
!insertmacro MUI_PAGE_WELCOME
; license page
!define MUI_PAGE_CUSTOMFUNCTION_PRE LicensePre
!insertmacro MUI_PAGE_LICENSE "${SOURCEPATH}\windows\installer_files\LICENSE.txt"
; install directory page
!define MUI_PAGE_CUSTOMFUNCTION_PRE DirectoryPre
!define MUI_PAGE_HEADER_TEXT "Choose Install Destination"
!define MUI_PAGE_HEADER_SUBTEXT "Choose the folder in which ${PRODUCT} will be installed."
!define MUI_DIRECTORYPAGE_TEXT_TOP "${PRODUCT} will be installed into the following folder.$\r$\n$\r$\n\
    To use a different folder, click Browse and select another folder. Click Next to continue."
!define MUI_DIRECTORYPAGE_TEXT_DESTINATION "Destination Folder"
!insertmacro MUI_PAGE_DIRECTORY
; recordings directory page
!define MUI_PAGE_HEADER_TEXT "Choose Recordings Location"
!define MUI_PAGE_HEADER_SUBTEXT "Choose the folder in which ${PRODUCT} will save all the recordings."
!define MUI_DIRECTORYPAGE_TEXT_TOP "${PRODUCT} will record all programmes into the following folder.$\r$\n$\r$\n\
    To use a different folder, click Browse and select another folder. Click Next to continue."
!define MUI_DIRECTORYPAGE_TEXT_DESTINATION "Recordings Folder"
; use $RecDir to avoid overwriting $INSTDIR
!define MUI_DIRECTORYPAGE_VARIABLE $RecDir
!insertmacro MUI_PAGE_DIRECTORY
; instfiles page
!define MUI_PAGE_CUSTOMFUNCTION_PRE InstFilesPre
!insertmacro MUI_PAGE_INSTFILES
; finish page
!insertmacro MUI_PAGE_FINISH
; uninstall pages
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES

;#######################################
;# Language
;#######################################

!insertmacro MUI_LANGUAGE "English"

;#######################################
;# Helper Apps
;#######################################

Var HelperName
Var HelperKey
Var HelperFile
Var HelperDir
Var HelperExe
Var HelperPath
Var HelperVal
Var HelperVer
Var HelperUrl
Var HelperDoc

; for checking helper EXE binary type
!define SCS_32BIT_BINARY 0
!define SCS_64BIT_BINARY 6

; helper app names for folder/file naming, UI text
!define FFMPEG "FFmpeg"
!define RTMPDUMP "RTMPDump"
!define ATOMICPARSLEY "AtomicParsley"

; options file keys for helper apps
!define FFMPEG_KEY "ffmpeg"
!define RTMPDUMP_KEY "flvstreamer"
!define ATOMICPARSLEY_KEY "atomicparsley"

; documentation URLs for helper apps (only if config file not used)
!define FFMPEG_DOC "http://ffmpeg.org/ffmpeg-doc.html"
!define RTMPDUMP_DOC "http://rtmpdump.mplayerhq.hu/"
!define ATOMICPARSLEY_DOC "http://atomicparsley.sourceforge.net/"

; common extension for downloaded helpers (may be ZIP or 7Z format, or EXE)
!define HELPER_EXT "zip"

; Wrapper macros for helper app install/uninstall
!macro _InstallHelper _name _key _url _doc
  StrCpy $HelperName "${_name}"
  StrCpy $HelperKey "${_key}"
  StrCpy $HelperFile "$INSTDIR\${_name}.${HELPER_EXT}"
  StrCpy $HelperDir "$INSTDIR\${_name}"
  StrCpy $HelperExe "${_name}.exe"
  StrCpy $HelperPath ""
  StrCpy $HelperVal ""
  StrCpy $HelperVer "unknown"
  StrCpy $HelperUrl "${_url}"
  StrCpy $HelperDoc "${_doc}"
  Call InstallHelper
!macroend
!define InstallHelper '!insertmacro _InstallHelper'

!macro un._InstallHelper _name _key
  StrCpy $HelperName "${_name}"
  StrCpy $HelperKey "${_key}"
  StrCpy $HelperFile "$INSTDIR\${_name}.${HELPER_EXT}"
  StrCpy $HelperDir "$INSTDIR\${_name}"
  Call un.InstallHelper
!macroend
!define un.InstallHelper '!insertmacro un._InstallHelper'

; Macros for helper app doc install/uninstall
!macro _InstallHelperDoc _name _doc
  WriteIniStr "$INSTDIR\${_name}_docs.url" "InternetShortcut" "URL" "${_doc}"
  CreateShortCut "$SMPROGRAMS\get_iplayer\Help\${_name} Documentation.lnk" \
    "$INSTDIR\${_name}_docs.url" "" "$SYSDIR\SHELL32.dll" 175
!macroend
!define InstallHelperDoc '!insertmacro _InstallHelperDoc'

!macro un._InstallHelperDoc _name
  Delete "$INSTDIR\${_name}_docs.url"
  Delete "$SMPROGRAMS\get_iplayer\Help\${_name} Documentation.lnk"
!macroend
!define un.InstallHelperDoc '!insertmacro un._InstallHelperDoc'

!macro _RemoveHelper _name _key
  StrCpy $HelperName "${_name}"
  StrCpy $HelperKey "${_key}"
  StrCpy $HelperFile "$INSTDIR\${_name}.${HELPER_EXT}"
  StrCpy $HelperDir "$INSTDIR\${_name}"
  Call RemoveHelper
!macroend
!define RemoveHelper '!insertmacro _RemoveHelper'

!macro _RemoveHelperDoc _name
  Delete "$INSTDIR\${_name}_docs.url"
  Delete "$SMPROGRAMS\get_iplayer\Help\${_name} Documentation.lnk"
!macroend
!define RemoveHelperDoc '!insertmacro _RemoveHelperDoc'

;#######################################
;# Options File
;#######################################

Var OptionsDir
Var OptionsFile
Var OptionKey
Var OptionVal

; Wrapper macros for creating/deleting options file settings
!macro _InstallOption _key _val
  StrCpy $OptionKey "${_key}"
  StrCpy $OptionVal "${_val}"
  Call InstallOption
!macroend
!define InstallOption '!insertmacro _InstallOption'

!macro un._InstallOption _key
  StrCpy $OptionKey "${_key}"
  Call un.InstallOption
!macroend
!define un.InstallOption '!insertmacro un._InstallOption'

!macro _RemoveOption _key
  StrCpy $OptionKey "${_key}"
  Call RemoveOption
!macroend
!define RemoveOption '!insertmacro _RemoveOption'

;#######################################
;# Virtual Store-Aware Cleanup
;#######################################

; Remove all get_iplayer files for un/re-install
!macro RemoveGetIPlayer _un
Function ${_un}RemoveGetIPlayer
  StrCpy $1 $INSTDIR
  RMDir /r "$1\lib"
  RMDir /r "$1\perl-license"
  Delete "$1\*.dll"
  Delete "$1\perl.exe"
  Delete "$1\get_iplayer.cgi.cmd"
  Delete "$1\get_iplayer.cmd"
  Delete "$1\iplayer_logo.ico"
  Delete "$1\pvr_manager.cmd"
  Delete "$1\get_iplayer.cgi"
  Delete "$1\get_iplayer.pl"
  Delete "$1\get_iplayer.pl.old"
  Delete "$1\get_iplayer--pvr.bat"
  Delete "$1\run_pvr_scheduler.bat"
  ; URLs
  Delete "$1\pvr_manager.url"
  Delete "$1\get_iplayer_docs.url"
  Delete "$1\get_iplayer_examples.url"
  Delete "$1\strawberry_docs.url"
  ; shortcuts
  Delete "$SMPROGRAMS\get_iplayer\get_iplayer.lnk"
  Delete "$SMPROGRAMS\get_iplayer\Recordings Folder.lnk"
  Delete "$SMPROGRAMS\get_iplayer\Web PVR Manager.lnk"
  Delete "$SMPROGRAMS\get_iplayer\Run PVR Scheduler Now.lnk"
  Delete "$SMPROGRAMS\get_iplayer\Help\get_iplayer Documentation.lnk"
  Delete "$SMPROGRAMS\get_iplayer\Help\get_iplayer Examples.lnk"
  Delete "$SMPROGRAMS\get_iplayer\Help\Strawberry Perl Home.lnk"
  ; clean files in VirtualStore (Win7/Vista) that may have been updated directly by get_iplayer.pl
  StrCpy $2 "$LOCALAPPDATA\VirtualStore\Program Files\get_iplayer"
  Delete "$2\get_iplayer.pl"
  Delete "$2\get_iplayer.pl.old"
FunctionEnd
!macroend
!insertmacro RemoveGetIPlayer ""
!insertmacro RemoveGetIPlayer "un."

;#######################################
;# Section Sizes/Descriptions
;#######################################

; helper sizes
!define FFMPEG_SIZE 87707
!define RTMPDUMP_SIZE 9113
!define ATOMICPARSLEY_SIZE 393

;#######################################
;# Sections
;#######################################

Section "get_iplayer" section1
  SectionIn RO
  ; clear files before (re)install
  Call RemoveGetIPlayer
  ; copy files into place
  File "${SOURCEPATH}\windows\get_iplayer\get_iplayer.cgi.cmd"
  File "${SOURCEPATH}\windows\get_iplayer\get_iplayer.cmd"
  File "${SOURCEPATH}\windows\get_iplayer\iplayer_logo.ico"
  File "${SOURCEPATH}\windows\get_iplayer\pvr_manager.cmd"
!ifndef WITHOUTPERL
  ; embedded perl
  File /r "${PERLFILES}\lib"
  File /r "${PERLFILES}\perl-license"
  File "${PERLFILES}\*.dll"
  File "${PERLFILES}\perl.exe"
!endif
  ; embedded main scripts
  File "/oname=get_iplayer.pl" "${SOURCEPATH}\get_iplayer"
  File "${SOURCEPATH}\get_iplayer.cgi"
  ; embedded plugins
  CreateDirectory "$PROFILE\.get_iplayer"
  SetOutPath "$PROFILE\.get_iplayer"
  File /r "${SOURCEPATH}\plugins"
  SetOutPath $INSTDIR
  ; create recordings folder
  CreateDirectory $RecDir
  ; set default options
  ${InstallOption} "output" $RecDir
  ${InstallOption} "nopurge" "1"
  ; create run_pvr_scheduler batch file
  FileOpen $0 "$INSTDIR\run_pvr_scheduler.bat" "w"
  FileWrite $0 "cd $INSTDIR$\r$\n"
  FileWrite $0 "perl.exe get_iplayer.pl --pvrschedule 14400$\r$\n"
  FileWrite $0 "$\r$\n"
  FileClose $0
  ; create Windows scheduler batch file
  FileOpen $0 "$INSTDIR\get_iplayer--pvr.bat" "w"
  FileWrite $0 "cd $INSTDIR$\r$\n"
  FileWrite $0 "perl.exe get_iplayer.pl --pvr$\r$\n"
  FileWrite $0 "$\r$\n"
  FileClose $0
  ; root start menu URLs
  WriteINIStr "$INSTDIR\pvr_manager.url" "InternetShortcut" "URL" "http://localhost:1935"
  ; root start menu items
  CreateShortCut "$SMPROGRAMS\get_iplayer\get_iplayer.lnk" "$SYSDIR\cmd.exe" \
    "/k get_iplayer.cmd --search dontshowanymatches && get_iplayer.cmd --help" "$INSTDIR\iplayer_logo.ico"
  CreateShortCut "$SMPROGRAMS\get_iplayer\Recordings Folder.lnk" "$RecDir"
  CreateShortCut "$SMPROGRAMS\get_iplayer\Web PVR Manager.lnk" "$SYSDIR\cmd.exe" \
    "/c pvr_manager.cmd" "$INSTDIR\iplayer_logo.ico"
  CreateShortCut "$SMPROGRAMS\get_iplayer\Run PVR Scheduler Now.lnk" "$SYSDIR\cmd.exe" \
    "/k run_pvr_scheduler.bat" "$INSTDIR\iplayer_logo.ico"
  ; help start menu URLs
  WriteINIStr "$INSTDIR\get_iplayer_docs.url" "InternetShortcut" "URL" "${GITHUB_REPO}/wiki"
  WriteINIStr "$INSTDIR\get_iplayer_examples.url" "InternetShortcut" "URL" "${GITHUB_REPO}/wiki/documentation"
  WriteINIStr "$INSTDIR\strawberry_docs.url" "InternetShortcut" "URL" "http://strawberryperl.com/"
  ; help start menu items
  CreateShortCut "$SMPROGRAMS\get_iplayer\Help\get_iplayer Documentation.lnk" \
    "$INSTDIR\get_iplayer_docs.url" "" "$SYSDIR\SHELL32.dll" 175
  CreateShortCut "$SMPROGRAMS\get_iplayer\Help\get_iplayer Examples.lnk" \
    "$INSTDIR\get_iplayer_examples.url" "" "$SYSDIR\SHELL32.dll" 175
  CreateShortCut "$SMPROGRAMS\get_iplayer\Help\Strawberry Perl Home.lnk" \
    "$INSTDIR\strawberry_docs.url" "" "$SYSDIR\SHELL32.dll" 175
SectionEnd

Section "un.get_iplayer" un.section1
  SectionIn RO
  MessageBox MB_YESNO|MB_ICONQUESTION|MB_DEFBUTTON2 \
    "Remove User Preferences, PVR Searches, Presets and Recording History?" \
    IDNO clean_files
    ; delete the local user data
    RMDir /r $PROFILE\.get_iplayer
  clean_files:
  ; clear files on uninstall
  Call un.RemoveGetIPlayer
SectionEnd

Section ${FFMPEG} section2
  SectionIn RO
  ; embedded helper file
  File "${HELPERS}\${FFMPEG}.${HELPER_EXT}"
  AddSize ${FFMPEG_SIZE}
  ${InstallHelper} ${FFMPEG} ${FFMPEG_KEY} ${FFMPEG_URL} ${FFMPEG_DOC}
SectionEnd

Section "un.${FFMPEG}" un.section2
  SectionIn RO
  ${un.InstallHelper} ${FFMPEG} ${FFMPEG_KEY}
SectionEnd

Section ${RTMPDUMP} section3
  SectionIn RO
  ; embedded helper file
  File "${HELPERS}\${RTMPDUMP}.${HELPER_EXT}"
  AddSize ${RTMPDUMP_SIZE}
  ${InstallHelper} ${RTMPDUMP} ${RTMPDUMP_KEY} ${RTMPDUMP_URL} ${RTMPDUMP_DOC}
SectionEnd

Section "un.${RTMPDUMP}" un.section3
  SectionIn RO
  ${un.InstallHelper} ${RTMPDUMP} ${RTMPDUMP_KEY}
SectionEnd

Section ${ATOMICPARSLEY} section4
  SectionIn RO
  ; embedded helper file
  File "${HELPERS}\${ATOMICPARSLEY}.${HELPER_EXT}"
  AddSize ${ATOMICPARSLEY_SIZE}
  ${InstallHelper} ${ATOMICPARSLEY} ${ATOMICPARSLEY_KEY} ${ATOMICPARSLEY_URL} ${ATOMICPARSLEY_DOC}
SectionEnd

Section "un.${ATOMICPARSLEY}" un.section4
  SectionIn RO
  ${un.InstallHelper} ${ATOMICPARSLEY} ${ATOMICPARSLEY_KEY}
SectionEnd

;#######################################
;# Before Installation
;#######################################

Function .onInit
  ; init recordings dir
  StrCpy $RecDir "$DESKTOP\iPlayer Recordings\"
  ; nothing more to do for fresh install
  IfFileExists "$INSTDIR\*.*" +2
    Return
  ; proceed with re-install
  SetOutPath $INSTDIR
FunctionEnd

;#######################################
;# After Successful Installation
;#######################################

!macro _DeleteSwfUrl201306 _key
  StrCpy $1 "$PROFILE\.get_iplayer\options"
  IfFileExists $1 0 no_options_${_key}
    StrCpy $2 "http://www.bbc.co.uk/emp/releases/iplayer/revisions/617463_618125_4/617463_618125_4_emp.swf"
    StrCpy $3 "--swfVfy"
    ${ConfigRead} $1 "${_key} " $R0
    Push $R0
    Call Trim
    Pop $R0
    ${StrLoc} $4 $R0 $2 ">"
    IntCmp $4 0 ${_key}1 0
      ${ConfigWrite} $1 "${_key}" "" $R1
      Goto ${_key}2
    ${_key}1:
    StrCmp $R0 $3 0 ${_key}2
      ${ConfigWrite} $1 "${_key}" "" $R1
    ${_key}2:
  no_options_${_key}:
!macroend
!define DeleteSwfUrl201306 '!insertmacro _DeleteSwfUrl201306'

Function .onInstSuccess
  ; remove items obsolete in 4.3+
  RMDir /r "$INSTDIR\rtmpdump-2.2d"
  RMDir /r "$INSTDIR\Downloads"
  Delete "$INSTDIR\linuxcentre.url"
  Delete "$INSTDIR\get_iplayer_setup.nsi"
  Delete "$INSTDIR\update_get_iplayer.cmd"
  ; clean up the mess from June 2013 SWF URL debacle
  ${DeleteSwfUrl201306} "rtmptvopts"
  ${DeleteSwfUrl201306} "rtmpradioopts"
  ${DeleteSwfUrl201306} "rtmplivetvopts"
  ${DeleteSwfUrl201306} "rtmpliveradioopts"
  ; clean up obsolete items in 2.94.0+
  Delete "$INSTDIR\get_iplayer_home.url"
  Delete "$INSTDIR\command_examples.url"
  Delete "$INSTDIR\nsis_docs.url"
  Delete "$INSTDIR\download_latest_installer.url"
  Delete "$SMPROGRAMS\get_iplayer\Help\Get_iPlayer Home.lnk"
  Delete "$SMPROGRAMS\get_iplayer\Help\get_iplayer Example Commands.lnk"
  Delete "$SMPROGRAMS\get_iplayer\Help\NSIS Installer Home.lnk"
  Delete "$SMPROGRAMS\get_iplayer\Updates\Download Latest Installer.lnk"
  RMDir /r "$SMPROGRAMS\get_iplayer\Updates"
  Delete "$SMPROGRAMS\get_iplayer\Uninstall Components.lnk"
  DeleteRegValue HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\get_iplayer" "Publisher"
  ; remove version files
  Delete "$INSTDIR\get_iplayer-ver.txt"
  Delete "$INSTDIR\get_iplayer-ver-check.txt"
  ; remove config files
  Delete "$INSTDIR\get_iplayer_config.ini"
  Delete "$INSTDIR\get_iplayer-ver-check.txt"
  ; remove obsolete options
  ${RemoveOption} "mmsnothread"
  ; remove obsolete helpers
  ${RemoveHelper} "MPlayer" "mplayer"
  ${RemoveHelper} "LAME" "lame"
  ${RemoveHelper} "VLC" "vlc"
  ; put uninstall info in registry
  CreateShortCut "$SMPROGRAMS\get_iplayer\Uninstall.lnk" "$INSTDIR\Uninst.exe" "" "$INSTDIR\Uninst.exe" 0
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\get_iplayer" "DisplayName" "${PRODUCT} ${VERSION}"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\get_iplayer" "DisplayVersion" "${VERSION}"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\get_iplayer" "URLInfoAbout" "${GITHUB_REPO}"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\get_iplayer" "UninstallString" "$INSTDIR\Uninst.exe"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\get_iplayer" "DisplayIcon" "$INSTDIR\Uninst.exe"
  WriteRegStr HKCU "Software\${PRODUCT}" "" "$INSTDIR"
  WriteUninstaller "$INSTDIR\Uninst.exe"
FunctionEnd

;#######################################
;# Before Uninstallation
;#######################################

Function un.onInit
  ; ensure options file path is defined
  Call un.CreateOptionsPaths
FunctionEnd

;#######################################
;# After Successful Uninstallation
;#######################################

Function un.onUninstSuccess
  ; remove start menu dirs and all contents
  RMDir /r "$SMPROGRAMS\get_iplayer"
  ; remove the global options file
  Delete $OptionsFile
  RMDir $OptionsDir
  ; remove installed status in registry
  DeleteRegKey HKCU "SOFTWARE\get_iplayer"
  DeleteRegKey HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\get_iplayer"
  HideWindow
  MessageBox MB_OK|MB_ICONINFORMATION "$(^Name) was successfully removed from your computer.."
  ; remove uninstaller and install dir
  Delete "$INSTDIR\Uninst.exe"
  RMDir $INSTDIR
FunctionEnd

;#######################################
;# Custom Page Functions
;#######################################

Function LicensePre
  ; read install dir from registry
  ReadRegStr $1 HKCU "Software\${PRODUCT}" ""
  ; skip license if already installed
  StrCmp $1 "" done
    Abort
  done:
FunctionEnd

Function DirectoryPre
  ; read install dir from registry
  ReadRegStr $1 HKCU "Software\${PRODUCT}" ""
  ; skip destination selection if already installed
  StrCmp $1 "" done
    Abort
  done:
FunctionEnd

Function InstFilesPre
  SetOutPath $INSTDIR
  ; start menu dirs
  CreateDirectory "$SMPROGRAMS\get_iplayer\Help"
  ; ensure options file exists
  Call CreateOptionsFile
FunctionEnd

;#######################################
;# Options File Functions
;#######################################

; Define paths to global options dir/file
!macro CreateOptionsPaths _un
Function ${_un}CreateOptionsPaths
  ReadEnvStr $1 "ALLUSERSPROFILE"
  StrCpy $OptionsDir "$1\get_iplayer"
  StrCpy $OptionsFile "$OptionsDir\options"
 FunctionEnd
!macroend
!insertmacro CreateOptionsPaths ""
!insertmacro CreateOptionsPaths "un."

; Create global options file if necessary
Function CreateOptionsFile
  Call CreateOptionsPaths
  ; create global options folder if needed
  IfFileExists "$OptionsDir\*.*" check_file
  ClearErrors
  CreateDirectory $OptionsDir
  IfErrors 0 check_file
    MessageBox MB_OK|MB_ICONSTOP "Could not create global options directory:$\r$\n$\r$\n$OptionsDir$\r$\n$\r$\nAborting installation."
    Abort
  check_file:
  ; create global options file if needed
  IfFileExists $OptionsFile done
    ClearErrors
    FileOpen $0 $OptionsFile "w"
    FileClose $0
    IfErrors 0 done
      MessageBox MB_OK|MB_ICONSTOP "Could not create global options file:$\r$\n$\r$\n$OptionsFile$\r$\n$\r$\nAborting installation."
      Abort
  done:
  Push "OK"
FunctionEnd

; Write entry in global options file
; Wrapped by _InstallOption
Function InstallOption
  ${ConfigWrite} $OptionsFile "$OptionKey " $OptionVal $0
  Push $0
FunctionEnd

; Delete entry in global options file
; Wrapped by un._InstallOption
Function un.InstallOption
  ${ConfigWrite} $OptionsFile "$OptionKey " "" $0
  Push $0
FunctionEnd

; Remove entry in global options file during install
; Wrapped by _RemoveOption
Function RemoveOption
  ${ConfigWrite} $OptionsFile "$OptionKey " "" $0
  Push $0
FunctionEnd

;#######################################
;# Helper App Utility Functions
;#######################################

; Extract $HelperFile to $OUTDIR
Function UnpackHelper
  ; MUST try ZipDLL first regardless of file extension (Nsis7z doesn't return error code)
  ; ZIP format file will be extracted, 7Z format file will error and fall through
  ZipDLL::extractall $HelperFile $OUTDIR
  Pop $R0
  StrCmp $R0 "success" done
    ; else fall through to Nsis7z
    Nsis7z::ExtractWithDetails $HelperFile "Installing $HelperName %s..."
  done:
FunctionEnd

;#######################################
;# Helper App Install Functions
;#######################################

; Download and unpack helper app archive and locate EXE
; Wrapped by _InstallHelper
Function InstallHelper
  ; create target dir for helper app
  RMDir /r $HelperDir
  SetOutPath $HelperDir
  ; unpack archive
  Call UnpackHelper
  ; restore $OUTDIR
  SetOutPath $INSTDIR
  ; check for empty dir
  ${DirState} $HelperDir $R0
  IntCmp $R0 1 delete_file
    ; might be just EXE that was downloaded
    StrCpy $R1 $HelperFile
    System::Call "kernel32::GetBinaryType(t R1, *i .R2) i .R0"
    ; rename and save if 32-bit EXE
    IntCmp $R2 ${SCS_32BIT_BINARY} 0 not_exe
    ; generate lower case EXE name
    ${StrCase} $R0 $HelperName "L"
    StrCpy $R1 "$HelperDir\$R0.exe"
    Rename $HelperFile $R1
    Goto got_exe
    not_exe:
    MessageBox MB_OK|MB_ICONEXCLAMATION "Extract failed: $HelperFile$\r$\n$\r$\nSkipped installation: $HelperName"
    RMDir /r $HelperDir
    Delete $HelperFile
    Push "ENOFILE"
    Return
  delete_file:
  ; remove archive after unpacking
  Delete $HelperFile
  ; $R1 = helper EXE
  StrCpy $R1 ""
	${locate::Open} $HelperDir "/F=1 /D=0 /N=$HelperExe" $0
	StrCmp $0 0 0 loop_locate
    MessageBox MB_OK|MB_ICONEXCLAMATION "Could not open $HelperDir for search$\r$\n$\r$\nSkipped installation: $HelperName"
    ${locate::Close} $0
    ${locate::Unload}
    RMDir /r $HelperDir
    Return
	loop_locate:
	${locate::Find} $0 $R9 $R8 $R7 $R6 $R5 $R4
  StrCmp $R9 "" stop_locate
    ; get binary type of located EXE
    System::Call "kernel32::GetBinaryType(t R9, *i .R2) i .R0"
    ; must be 32-bit Windows EXE
    IntCmp $R2 ${SCS_32BIT_BINARY} 0 +2
      ; save EXE path
      StrCpy $R1 $R9
    Goto loop_locate
	stop_locate:
	${locate::Close} $0
	${locate::Unload}
  StrCmp $R1 "" 0 got_exe
    MessageBox MB_OK|MB_ICONEXCLAMATION "Could not locate $HelperExe in $HelperDir$\r$\n$\r$\nSkipped installation: $HelperName"
    RMDir /r $HelperDir
    Push "ENOEXE"
    Return
  got_exe:
  StrCpy $HelperPath $R1
  ; use relative EXE path for options file
  ${StrRep} $HelperVal $HelperPath $INSTDIR "."
  ${InstallOption} $HelperKey $HelperVal
  ; skip empty doc url
  StrCmp $HelperDoc "" no_doc
    ${InstallHelperDoc} $HelperName $HelperDoc
  no_doc:
FunctionEnd

; Remove helper app and option setting
; Wrapped by un._InstallHelper
Function un.InstallHelper
  ${un.InstallHelperDoc} $HelperName
  ${un.InstallOption} $HelperKey
  RMDir /r $HelperDir
  Delete $HelperFile
FunctionEnd

; Remove helper during install
; Wrapped by _RemoveHelper
Function RemoveHelper
  ${RemoveHelperDoc} $HelperName
  ${RemoveOption} $HelperKey
  RMDir /r $HelperDir
  Delete $HelperFile
FunctionEnd

; Trim
;   Removes leading & trailing whitespace from a string
; Usage:
;   Push
;   Call Trim
;   Pop
Function Trim
	Exch $R1 ; Original string
	Push $R2
Loop:
	StrCpy $R2 "$R1" 1
	StrCmp "$R2" " " TrimLeft
	StrCmp "$R2" "$\r" TrimLeft
	StrCmp "$R2" "$\n" TrimLeft
	StrCmp "$R2" "$\t" TrimLeft
	GoTo Loop2
TrimLeft:
	StrCpy $R1 "$R1" "" 1
	Goto Loop
Loop2:
	StrCpy $R2 "$R1" 1 -1
	StrCmp "$R2" " " TrimRight
	StrCmp "$R2" "$\r" TrimRight
	StrCmp "$R2" "$\n" TrimRight
	StrCmp "$R2" "$\t" TrimRight
	GoTo Done
TrimRight:
	StrCpy $R1 "$R1" -1
	Goto Loop2
Done:
	Pop $R2
	Exch $R1
FunctionEnd
