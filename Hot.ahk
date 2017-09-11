/*
Hot.ahk
@author: zYeoman
@date: 2017-09-11
@description: ��������AHK�ű�
*/

#Include Core.ahk
Hot.Ini()

;Win10 1703 ɾ���� StickyNot.exe �ĳ��� Windows APP 
;ʹ��Win+W
#Up::WinMaximize, A
#Down::WinMinimize, A
#Enter::ToggleWindows()
#t::ToggleTitle()

LCtrl & Space::
    InputBox, SearchTEXT,,,,,100
    if SearchTEXT 
      Run, https://www.google.com/search?hl=zh-CN&q=%SearchTEXT%
return

^!t::
;��ǰ·������cmd
IfWinActive, AHK_exe Everything.exe
{
    ClipSaved := ClipboardAll
    Send ^+z
    ClipWait
    Path = %clipboard%
    Clipboard := ClipSaved
}
Else
    Path := Explorer_GetPath()
IfWinExist, AHK_pid %CMD_PID%
{
    WinActivate
    WinWaitActive, AHK_pid %CMD_PID%
    if (path!="ERROR")
    {
        Send, cd %Path%`n 
    }
}
Else
{
    if (path=="ERROR"){
        Run,  cmd /K cd /D "%UserProfile%",,, CMD_PID
    }
    else{
        Run,  cmd /K cd /D "%Path%",,, CMD_PID
    }
}
return

#IfWinActive, AHK_exe Everything.exe
^e::
;ʹ�ñ༭�����ļ�
	ControlGetFocus, current, A
	If(current == "EVERYTHING_LISTVIEW1") 
	{
		ClipSaved := ClipboardAll
		Send ^+c
		ClipWait
		Path = %clipboard%
		Clipboard := ClipSaved
        Send {ESC}
		run % Hot.Editor . " " . Path
	}
	Else
	{
		Suspend on
		Send {Space}
		Suspend off
	}
return
#if

#IfWinActive, AHK_exe explorer.exe
^e::
;ʹ�ñ༭�����ļ�
    Path := Explorer_GetSelected()
	run % Hot.Editor . " " . Path
return

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

Capslock::
;Capslockӳ��ΪESC
Suspend on
Send, {ESC}
Suspend off
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