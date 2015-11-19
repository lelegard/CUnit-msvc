; CUnit for Windows installer script (used by NSIS)
;
; Building the binary installer:
; - Install NSIS (if not yet installed)
; - Right-click on this .nsi file from Windows Explorer
; - Select "Compile NSIS Script"
;

!define CUnitVersion "2.1-3"

Name "CUnit - A unit testing framework for C"

!verbose 3
!include "MUI2.nsh"
!include "WinMessages.NSH"
!verbose 4

; Registry key for where system environment variables are stored.
!define RegEnv '"SYSTEM\CurrentControlSet\Control\Session Manager\Environment"'

; Installer file name
OutFile "CUnit-win32-${CUnitVersion}.exe"

; Default installation folder
InstallDir "$PROGRAMFILES\CUnit"

; Get previous installation folder from registry if available.
; If it exists (previous version installed), it overrides InstallDir instruction.
InstallDirRegKey HKLM "Software\CUnit" ""

; Request administrator privileges
RequestExecutionLevel admin

; "Modern User Interface" (MUI) settings
!define MUI_ABORTWARNING

; Installer pages
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
  
; Uninstaller pages
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES
  
; Languages
!insertmacro MUI_LANGUAGE "English"


;===============================================================================
; CUnit installation section
;===============================================================================

Section "CUnit"

  ; Header files
  CreateDirectory "$INSTDIR\Include\CUnit"
  SetOutPath "$INSTDIR\Include\CUnit"
  File /x wxWidget.h /x MyMem.h /x CUnit_intl.h "..\CUnit\Headers\*.h"

  ; Libraries
  CreateDirectory "$INSTDIR\Lib\Release-Win32"
  SetOutPath "$INSTDIR\Lib\Release-Win32"
  File "..\VC14\Release-StaticLib-Win32\CUnit.lib"
  CreateDirectory "$INSTDIR\Lib\Debug-Win32"
  SetOutPath "$INSTDIR\Lib\Debug-Win32"
  File "..\VC14\Debug-StaticLib-Win32\CUnit.lib"
  File "..\VC14\Debug-StaticLib-Win32\CUnit.pdb"

  ; Visual Studio property files
  SetOutPath "$INSTDIR"
  File "CUnit.props"

  ; Documentation
  CreateDirectory "$INSTDIR\Doc"
  SetOutPath "$INSTDIR\Doc"
  File /r "..\doc\*.html"
  File /r "..\doc\*.css"
  CreateDirectory "$INSTDIR\Doc\headers"
  SetOutPath "$INSTDIR\Doc\headers"
  File /x wxWidget.h /x MyMem.h /x CUnit_intl.h "..\CUnit\Headers\*.h"

  ; XML tools
  CreateDirectory "$INSTDIR\Tools"
  SetOutPath "$INSTDIR\Tools"
  File "..\Share\*.xsl"
  File "..\Share\*.dtd"

  ; Add an environment variable to CUnit root installation
  WriteRegStr HKLM ${RegEnv} "CUnitRoot" $INSTDIR

  ; Store installation folder in registry
  WriteRegStr HKLM "Software\CUnit" "" $INSTDIR
  
  ; Create uninstaller
  WriteUninstaller "$INSTDIR\CUnitUninstall.exe"
  
  ; Declare uninstaller in Add/Remove control panel
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\CUnit" "DisplayName" "CUnit Unit Testing Framework for C"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\CUnit" "UninstallString" "$INSTDIR\CUnitUninstall.exe"

  ; Notify applications of environment modifications
  SendMessage ${HWND_BROADCAST} ${WM_WININICHANGE} 0 "STR:Environment" /TIMEOUT=5000

SectionEnd


;===============================================================================
; CUnit uninstallation section
;===============================================================================

Section "Uninstall"

  ; Uninstaller is in $INSTDIR
  ; Get installation folder from registry
  ReadRegStr $0 HKLM "Software\CUnit" ""
  SetOutPath "$0\.."

  ; Delete files
  RMDir /r "$0\Include"
  RMDir /r "$0\Lib"
  RMDir /r "$0\Doc"
  RMDir /r "$0\Tools"
  Delete "$0\CUnit.props"
  Delete "$0\CUnitUninstall.exe"
  RMDir "$0"

  ; Delete registry entries
  DeleteRegKey HKLM "Software\CUnit"
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\CUnit"
  DeleteRegValue HKLM ${RegEnv} "CUnitRoot"

  ; Notify applications of environment modifications
  SendMessage ${HWND_BROADCAST} ${WM_WININICHANGE} 0 "STR:Environment" /TIMEOUT=5000

SectionEnd
