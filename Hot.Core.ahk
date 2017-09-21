/*
Core.ahk
@author: zYeoman
@date: 2017-09-11
@description: ���ÿ⣬�޸���OneQuick
*/

Goto CORE_LABLE

#Persistent
#SingleInstance force
#MaxHotkeysPerInterval 200
#MaxThreads, 255
#MaxThreadsPerHotkey, 20
 
#Include, *i Hot.User.ahk
; ////////////////////////////////////

class Hot
{
	static ProgramName := "Hot"
	static icon_default := "Icon/fire.ico"
	static icon_suspend := "Icon/fire_blue.ico"
	static icon_pause := "Icon/fire_not.ico"
	static icon_suspend_pause := "Icon/fire_blue_not.ico"
    static Editor = 

	Ini()
	{
		SetBatchLines, -1   ; maximize script speed!
		SetWinDelay, -1
        SetCapsLockState, AlwaysOff
        DetectHiddenWindows, on
		CoordMode, Mouse, Screen
		CoordMode, ToolTip, Screen
		CoordMode, Menu, Screen

        if(this.Editor = "")
		{
			; %systmeroot% can't give to this.Editor directly
			defNotepad = %SystemRoot%\notepad.exe
			this.Editor := defNotepad
		}
        
		; Menu Tray
		this.SetIcon(this.icon_default)
        Menu, Tray, Nostandard
		Menu, Tray, Tip, % this.ProgramName
        Menu, Tray, Add, Open, Sub_Hot_ListLine
        Menu, Tray, Add, Spy, Sub_Hot_RunSpy
        Menu, Tray, Add
		Menu, Tray, Add, Reload, Sub_Hot_Reload
		Menu, Tray, Add, Exit, Sub_Hot_Exit
		Menu, Tray, Add
		Menu, Tray, Add, Suspend Hotkey, Sub_Hot_ToggleSuspend
		Menu, Tray, Add, Pause Thread, Sub_Hot_TogglePause
        Menu, Tray, Add
        
        Menu, Tray, Default, Suspend Hotkey
		Menu, Tray, Click, 1
        ; Create a Hot.User.ahk file
		; and add a User_ComputerName class
		user_str := "User_" A_ComputerName
		StringReplace, user_str, user_str, - , _, All
		user_str := RegExReplace(user_str, "[^a-zA-Z0-9_]")
		if IsFunc(user_str ".Ini")
		{
			%user_str%.Ini()
		}
		Else
		{
			str := "`nclass " user_str "`n{`n`tIni()`n`t{`n`n`t}`n}`n`n"
			FileAppend, % str, Hot.User.ahk
			MsgBox, 0x44, Hello, It's your first time run this script, open Readme file?
			IfMsgBox, Yes
			{
				RunWait % Hot.Editor . " " . A_ScriptDir . "\README.md"
			}
			Run % Hot.Editor . " " . A_ScriptDir . "\Hot.User.ahk"
		}
        
        Run, %A_ScriptDir%\Scripts\Track.ahk
        
	}

	SetIcon(ico)
	{
		Menu, Tray, Icon, %ico%,,1
	}

	AutoSetIcon()
	{
		if !A_IsSuspended && !A_IsPaused
			this.SetIcon(this.icon_default)
		Else if !A_IsSuspended && A_IsPaused
			this.SetIcon(this.icon_pause)
		Else if A_IsSuspended && !A_IsPaused
			this.SetIcon(this.icon_suspend)
		Else if A_IsSuspended && A_IsPaused
			this.SetIcon(this.icon_suspend_pause)
	}

}

class Win
{

    CommandDialog()
    {
        InputBox, command,,,,,100
        if command
          run(command)
        return
    }
    
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
    
    ToggleTop()
    {
        WinSet, AlwaysOnTop, toggle,A
        WinGetTitle, getTitle, A
        Winget, getTop,ExStyle,A
        if (getTop & 0x8)
        {
            TrayTip ���ö�, %getTitle%
        }
        else
        {
            TrayTip ȡ���ö�, %getTitle%
        }
        return
    }
}

class File
{
    static TODOFile = 
    pCMD := ""
    pTODO := ""
    
    OpenTODO()
    {
        if(this.TODOFile == "")
		{
			this.TODOFile := %A_ScriptDir% + "/todo.txt"
		}
        tFilename := this.TODOFile
        run %tFilename%
    }
    
    OpenFile(FilePath="")
    {
        if(FilePath=="")
            FilePath := this.GetPath(1)
        if (FilePath!="ERROR")
        {
            Send,{Esc}
            run % Hot.Editor . " " . FilePath
        }
    }
    
    GetPath(fileflag=0)
    ;fileflag=0  ����ļ���·��
    ;fileflag=1  ����ļ�·��orERROR
    {
        IfWinActive, AHK_exe Everything.exe
        {
            ClipSaved := ClipboardAll
            Send ^+c
            ClipWait
            Path = %clipboard%
            Clipboard := ClipSaved
        }
        Else IfWinActive, AHK_exe explorer.exe
        {
            Path := Explorer_GetSelected()
            if (Path=="ERROR" || Instr(Path, ";"))
            {
                Path := Explorer_GetPath()
            }
            if InStr(Path, ";")
                return "ERROR"
        }
        Else
            return "ERROR"
        FileGetAttrib, t_Attr, %Path%
        If (fileflag==1 && Instr(t_Attr, "D"))
            return "ERROR"
        If (Not InStr(t_Attr,"D")) && fileflag==0
        {
            SplitPath, Path, , PathDir
            return PathDir
        }
        return Path
    }
    
    RunCmdHere()
    {
        path := this.GetPath()
        IfWinActive, ahk_EXE Everything.exe
            Send {Esc}
        t_pCMD := this.pCMD
        IfWinExist, AHK_PID %t_pCMD%
        {
            WinActivate
            WinWaitActive, AHK_pid %t_pCMD%
            if (path!="ERROR")
            {
                Send, cd %Path%`n
            }
        }
        Else
        {
            if (Path=="ERROR"){
                Run,  cmd /K cd /D "%UserProfile%",,, t_pCMD
            }
            else{
                Run,  cmd /K cd /D "%Path%",,, t_pCMD
            }
            this.pCMD := t_pCMD
        }
        return
    }
    
    Search()
    {
        ;ʹ��Everything����
        Path := this.GetPath()
        if (Path!="ERROR")
        {
            Send !{Space}
            WinWaitActive, Everything
            ControlSetText, Edit1, "%Path%"%A_space%, A
            sleep 150
            send {end}
        }
        return
    }
    
    NewFile()
    {
        ;�½��ļ�
        Path := this.GetPath()
        if (Path!="ERROR"){
            InputBox, filename, ���ļ�, ,,,100
            FileAppend,, %Path%\%filename%
        }
        return
    }
    
    CopyPath()
    {
    ;�����ļ�·��
        Path := Explorer_GetSelected()
        if (Path!="ERROR"){
            Clipboard := Path
        }
    return
    }
    
}


Sub_Hot_RunSpy:
    run %A_ScriptDir%/AU3_Spy.exe
Return

Sub_Hot_ListLine:
    ListLines
Return

Sub_Hot_Exit:
    msgbox, 0x40034, % Hot.ProgramName, Sure to Exit?
    IfMsgBox Yes
        ExitApp
return

Sub_Hot_Reload:
    Reload
return

; --------------------------
Sub_Hot_ToggleSuspend:
    if A_IsSuspended
    {
        Menu, Tray, Default, Pause Thread
        Menu, Tray, UnCheck, Suspend Hotkey
        Suspend, Off
    }
    else
    {
        Menu, Tray, Default, Pause Thread
        Menu, Tray, Check, Suspend Hotkey
        Suspend, On
    }
    Hot.AutoSetIcon()
Return

Sub_Hot_TogglePause:
    if A_IsPaused
    {
        Menu, Tray, Default, Suspend Hotkey
        Menu, Tray, UnCheck, Pause Thread
        Pause, Off
    }
    else
    {
        Menu, Tray, Default, Suspend Hotkey
        Menu, Tray, Check, Pause Thread
        ; pause will not run SetIcon(), so set icon First
        Hot.SetIcon(A_IsSuspended ? Hot.icon_suspend_pause : Hot.icon_pause)
        Pause, On
    }
    Hot.AutoSetIcon()
Return


; //////////////////////////////////////////////////////////////////////////
; //////////////////////////////////////////////////////////////////////////
; //////////////////////////////////////////////////////////////////////////
/*
three useful function
the command pass to run() can be:
1. a label or a function name, even "class.func"
2. a system cmd/run command, like "dir", or "http://google.com"
3. search
*/

t(str := "")
{
	if (str != "")
		ToolTip, % str
	Else
		ToolTip
}

run(command)
{
    if(InStr(command, " "))
    {
        Run, https://www.google.com/search?hl=zh-CN&q=%command%
	}
    else if(IsLabel(command))
	{
		Gosub, %command%
	}
	else if (IsFunc(command))
	{
		Array := StrSplit(command, ".")
		If (Array.MaxIndex() >= 2)
		{
			cls := Array[1]
			cls := %cls%
			Loop, % Array.MaxIndex() - 2
			{
				cls := cls[Array[A_Index+1]]
			}
			return cls[Array[Array.MaxIndex()]]()
		}
		Else
		{
			return %command%()
		}
	}
	Else
	{
		if(RegExMatch(command, "^https?://"))
		{
			brw := OneQuick.Browser
			if(brw == "")
				run, %command%
			Else if(brw == "microsoft-edge:")
				run, %brw%%command%
			Else
				run, %brw% %command%
			Return
		}
		else if(RegExMatch(command, "i)av(\d+)", avn))
		{
			run("http://www.bilibili.com/video/av" avn1)
			return
		}
		Try
		{
			run, %command%
			Return
		}
		Catch
		{
			if(IsFunc("run_user"))
			{
				func_name = run_user
				%func_name%(command)
			}
			else
            {
				Run, https://www.google.com/search?hl=zh-CN&q=%command%
            }
        }
	}
}

RunArr(arr)
{
	Loop, % arr.MaxIndex()
	{
		run(arr[A_Index])
	}
}


CORE_LABLE:
