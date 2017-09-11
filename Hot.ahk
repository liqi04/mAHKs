/*
@author: zYeoman
@date: 2017-09-10
@description: ��������AHK�ű�
 */

SetCapsLockState, AlwaysOff
Menu, Tray, Icon, H.ico
DetectHiddenWindows, on
;================== CapsLock ħ�� ==================
#Include, Capslocks.ahk
F4::ToggleSticky()
#Up::WinMaximize, A
#Down::WinMinimize, A
#t::
;SetTitleMatchMode, 2 ;�趨ahkƥ�䴰�ڱ����ģʽ
winactivate,A ; ����˴���
sleep, 500 ; ��ʱ��ȷ��
WinSet, Style, ^0xC00000,A  ;�л�������
return

CapsLock & s::Suspend
;=======================================================================
; ����https://github.com/xxr3376/AHK-script/blob/master/shortCut.ahk
;=======================================================================
RAlt & n::
  path := Explorer_GetPath()
  Run ,python2 E:\6script\hwmd.py,%path%,Hide
return

LCtrl & Space::
  InputBox, SearchTEXT,,,,,100
  if SearchTEXT {
    Run, https://www.google.com/search?hl=zh-CN&q=%SearchTEXT%
  }
return

#Enter::
WinGet,KDE_Win,MinMax,A
if KDE_Win
  WinRestore,A
else
  WinMaximize,A
return

;==================================================
; ��ݼ�Ctrl+o��ʼ��
; Ctrl+o Ctrl+s ��sublime��
; Ctrl+o Ctrl+v ��gvim��
;==================================================
ClearOpenFlag:
  OpenFlag := 0
  return
^o::
WinGet, process, processName, % "ahk_id" WinExist("A")
if (process=="explorer.exe"){
  path := Explorer_GetSelected()
}
else if (process=="Explorer.EXE"){
  path := Explorer_GetSelected()
}
else if (process=="Everything.exe"){
  ClipSaved := ClipboardAll
  Send ^+c
  ClipWait
  path = %clipboard%
  Clipboard := ClipSaved
}
else{
  Suspend On
  Send ^o
  Suspend Off
  return
}
SetTimer, ClearOpenFlag, 500
OpenFlag = 1
return
^v::
if (OpenFlag==1){
  SetTimer, ClearOpenFlag, off
  OpenFlag = 0
  Run, "C:\Windows\vim.bat" "--remote-silent" "%path%"
}
else{
  Suspend On
  Send, ^v
  Suspend Off
}
return

^s::
if (OpenFlag==1){
  SetTimer, ClearOpenFlag, off
  OpenFlag = 0
  Run, "D:\Sublime3\subl.exe" "%path%"
}
else{
  Suspend On
  Send, ^s
  Suspend Off
}
return


#!Space::
path := Explorer_GetPath()
if (path=="ERROR"){
    Send !{Space}
}
else{
    Send !{Space}
    WinWaitActive, Everything
    ControlSetText, Edit1, "%path%"%A_space%, A
    sleep 150
    send {end}
}
return

;==================================================
;��ݼ�F3��ʾCMD����
;==================================================
F3::Send #{F4}

#IfWinActive, ahk_exe explorer.exe
F7::
path := Explorer_GetPath()
if (path!="ERROR")
{
    InputBox, filename, ���ļ�, ,,,100
    FileAppend,, %path%\%filename%
}
return
F8::
path := Explorer_GetPath()
if (path!="ERROR")
{
    InputBox, filename, ���ļ���, ,,,100
    FileCreateDir, %path%\%filename%
}
return
^+c::
path := Explorer_GetSelected()
if (path!="ERROR")
{
    Clipboard := path
}
return
#If

;==================================================
;��ݼ� ctrl+alt+t ��ǰ·������cmd
;==================================================
^!t::
path := Explorer_GetPath()
if (path=="ERROR"){
    Run,  cmd /K cd /D "C:/user",,, CMD_PID
}
else{
    Run,  cmd /K cd /D "%path%",,, CMD_PID
}
return


;==================================================
;ӳ��CapslockΪEsc����Shift+CapslockΪԭ����Capslock
;==================================================

Capslock::
;suspend to prevent calling esc
Suspend on
Send, {ESC}
Suspend off
return

Esc::
ToggleCursors()
MouseMove, 500, 200, 0
return

;==================================================
;��ݼ� win+` ʹ��ǰ�����ö�
;==================================================
#`::
WinSet, AlwaysOnTop, toggle,A
WinGetTitle, getTitle, A
Winget, getTop,ExStyle,A
if (getTop & 0x8){
TrayTip ���ö�, %getTitle%
}else{
TrayTip ȡ���ö�, %getTitle%
}
return

^!r::
RestoreCursors()
Reload
return

ToggleSticky()
{
    GroupAdd, Sticky, ahk_class Sticky_Notes_Note_Window
    IfWinNotExist ahk_class Sticky_Notes_Note_Window
    {
        Run StikyNot.exe
        WinActivate
    }
    Else IfWinNotActive ahk_class Sticky_Notes_Note_Window
    {
        WinShow, ahk_group Sticky
        WinActivate
    }
    Else
    {
        WinHide, ahk_group Sticky
        WinActivate, ahk_class Shell_TrayWnd
    }
    Return
}
ToggleCursors()
{
    static AndMask, XorMask, $, h_cursor, b
    ,c0,c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11,c12,c13 ; system cursors
    , b1,b2,b3,b4,b5,b6,b7,b8,b9,b10,b11,b12,b13 ; blank cursors
    if ($ = "") ; init when requested or at first call
    {
        $ := "1"
        VarSetCapacity( h_cursor,4444, 1 )
        VarSetCapacity( AndMask, 32*4, 0xFF )
        VarSetCapacity( XorMask, 32*4, 0 )
        system_cursors = 32512,32513,32514,32515,32516,32642,32643,32644,32645,32646,32648,32649,32650
        StringSplit c, system_cursors, `,
        Loop %c0%
        {
            b%A_Index% := DllCall("CreateCursor", Uint, 0, Int, 0, Int, 0
            , Int, 32, Int, 32, Uint, &AndMask, Uint, &XorMask )
        }
    }

    if ($ == "1")
    {
        Loop %c0%
        {
            h_cursor := DllCall( "CopyImage", Uint,b%A_Index%, Uint,2, Int,0, Int,0, Uint,0 )
            DllCall( "SetSystemCursor", Uint,h_cursor, Uint,c%A_Index% )
        }
        $ := "0"
    }
    else
    {
        RestoreCursors()
        $ := "1"
    }
}

RestoreCursors()
{
	SPI_SETCURSORS := 0x57
	DllCall( "SystemParametersInfo", UInt, SPI_SETCURSORS, UInt, 0, UInt, 0, UInt, 0 )
}
