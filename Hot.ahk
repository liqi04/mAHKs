/*
Hot.ahk
@author: zYeoman
@date: 2017-09-11
@description: ��������AHK�ű�
*/

#Include Hot.Core.ahk
Hot.Ini()

;Win10 1703 ɾ���� StickyNot.exe �ĳ��� Windows APP
;ʹ��Win+W
#Up::WinMaximize, A ;���
#Down::WinMinimize, A ;��С��
#Enter::Win.ToggleWindows() ;���/��С��
#t::Win.ToggleTitle() ;��ʾ/���ر�����
#`::Win.ToggleTop() ;�ö�/ȡ���ö�

LCtrl & Space::Win.CommandDialog() ;�����п�

^!t::File.RunCmdHere()
Capslock & t::File.OpenTODO()

#IfWinActive, AHK_exe Everything.exe
^e::
#IfWinActive, AHK_exe explorer.exe
^e::
File.OpenFile()
return
^f::File.Search()
^n::File.NewFile()
^+c::File.CopyPath()
#If

#IfWinActive ahk_class ConsoleWindowClass
^l::SendInput {Raw}clear`n

; Ctrl + U, ��յ�ǰ���������
^u::Send ^{Home}
#If

Capslock::
;Capslockӳ��ΪESC
Suspend on
IfWinActive AHK_exe notepad.exe
{
    Send, ^s
    Send, !{F4}
}
Send, {ESC}
Suspend off
return

^!r::Reload