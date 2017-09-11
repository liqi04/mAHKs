/*
@author: zYeoman
@date: 2017-09-11
@description: ��������AHK�ű�
*/

SetCapsLockState, AlwaysOff
Menu, Tray, Icon, H.ico
DetectHiddenWindows, on
Editor := "C:\LiberKey\Apps\Notepad++\App\Notepad++\notepad++.exe"
;Win10 1703 ɾ���� StickyNot.exe �ĳ��� Windows APP 
;ʹ��Win+W
#Up::WinMaximize, A
#Down::WinMinimize, A
#Enter::ToggleWindows()
#t::ToggleTitle()

CapsLock & s::Suspend

LCtrl & Space::
    InputBox, SearchTEXT,,,,,100
    if SearchTEXT 
      Run, https://www.google.com/search?hl=zh-CN&q=%SearchTEXT%
return

#IfWinActive, ahk_exe Everything.exe
Space::
	ClipSaved := ClipboardAll
	Send ^+c
	ClipWait
	Path = %clipboard%
	Clipboard := ClipSaved
	run % Editor . " " . Path
return
#if
#IfWinActive, ahk_exe explorer.exe
Space::
    Path := Explorer_GetSelected()
	run % Editor . " " . Path
return
#if

#IfWinActive, ahk_exe explorer.exe
^f::
;ʹ��Everything����
	path := Explorer_GetPath()
	if (path!="ERROR"){
		Send !{Space}
		WinWaitActive, Everything
		ControlSetText, Edit1, "%path%"%A_space%, A
		sleep 150
		send {end}
	}
return
^n::
;�½��ļ�
	path := Explorer_GetPath()
	if (path!="ERROR"){
		InputBox, filename, ���ļ�, ,,,100
		FileAppend,, %path%\%filename%
	}
return
^+c::
;�����ļ�·��
	path := Explorer_GetSelected()
	if (path!="ERROR"){
		Clipboard := path
	}
return
#If

^!t::
;��ǰ·������cmd
path := Explorer_GetPath()
if (path=="ERROR"){
    Run,  cmd /K cd /D "%UserProfile%",,, CMD_PID
}
else{
    Run,  cmd /K cd /D "%path%",,, CMD_PID
}
return


Capslock::
;Capslockӳ��ΪESC
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

ToggleWindows()
{
	WinGet,KDE_Win,MinMax,A
	if KDE_Win
	  WinRestore,A
	else
	  WinMaximize,A
	return
}

ToggleTitle()
{
	;SetTitleMatchMode, 2 ;�趨ahkƥ�䴰�ڱ����ģʽ
	winactivate,A ; ����˴���
	sleep, 500 ; ��ʱ��ȷ��
	WinSet, Style, ^0xC00000,A  ;�л�������
	return
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