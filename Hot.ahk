CapsHelp:="================== CapsLock ħ��===================`n"
. "xd/g  `t=   Delete,    `tBackSpace,  `tFind,  `tggG;  `n"
. "uopn  `t=   PageUp,    `tHome,  `tEnd,  `tPageDown;  `n"
. "hjkl  `t=   Left,      `tDown,  `tUp,   `tRight;     `n"
. "[]ri  `t=   (), `tredo    `t^Enter                   `n"
. "`n`n"
PromoHelp:="==================== ����ʱ�� ====================`n"
. "(R)!s  `t  Start Promoto`n"
. "(R)!a  `t  Current State`n"
. "(R)!z  `t  Stop Promoto `n"
Help:="! = Alt;    ^ = Ctrl;    # = Win;    + = Shift;     `n`n`n"
. CapsHelp
. "`n`n"
. PromoHelp
. "`n`n"
. "================== R ϵ�� ========================`n"
. ""
CapsOn=false
Caps=flase
ChangeFlag=0
SetCapsLockState, AlwaysOff
SetTimer EarthLive,10000
#Include, Track.ahk
EarthLive:
SetTimer EarthLive, off
#Include, Earthlive.ahk
;==================   ����ʱ��    ==================
#Include, Time.ahk
;==================     ���ִ�    ================== 
#include, Hotstr.ahk
;================== CapsLock ħ�� ==================
#Include, Capslocks.ahk
;================== Gestures ==================
#Include, Gesture.ahk
#Up::WinMaximize, A
#Down::WinMinimize, A
#t::
;SetTitleMatchMode, 2 ;�趨ahkƥ�䴰�ڱ����ģʽ
winactivate,A ; ����˴���
sleep, 500 ; ��ʱ��ȷ��
WinSet, Style, ^0xC00000,A  ;�л�������
return

^!h::
MsgBox, ,HELP,%Help%,10
return
CapsLock & s::Suspend
;=======================================================================
; ����https://github.com/xxr3376/AHK-script/blob/master/shortCut.ahk
;=======================================================================
RAlt & n::
  path := Explorer_GetPath()
  Run ,python2 E:\6script\hwmd.py,%path%,Hide
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
; conemu has its own hotkeys
; #IfWinActive, ahk_exe ConEmu64.exe
; conemu quake mode!! Wonderful!!
F3::Send #{F4}

~^!n::
path := Explorer_GetPath()
if (path!="ERROR")
{
    InputBox, filename,, ,,,100
    FileAppend,, %path%\%filename%
}
else
    send ^!n
return

;^!a::
;h := DllCall("C:\Program Files (x86)\Tencent\WeChat\PrScrn.dll\PrScrn")
;if ErrorLevel
;  MsgBox %ErrorLevel%
;return

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
if Caps=false
    Caps = true
else
    Caps = false
Suspend on
Send, {ESC}
Suspend off
return

Esc::
MouseMove, 2000, 200, 0
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

^!r::Reload
