SendMode Input
SetTitleMatchMode "RegEx"
DetectHiddenWindows True
#SingleInstance force
idTrayWindow := wingetid("ahk_class Shell_TrayWnd")
idControl := ControlGetHwnd("Button2", "ahk_id " idTrayWindow)
SendMessage( 0x00F5 ,0,0,,"ahk_id " idControl) 

WinMove( 1000, 40,,,"ahk_class NotifyIconOverflowWindow")

hWnd := WinExist("ahk_class NotifyIconOverflowWindow")
hSysMenu:=DllCall("GetSystemMenu","Int",hWnd,"Int",FALSE) 
nCnt:=DllCall("GetMenuItemCount","Int",hSysMenu) 
DllCall("RemoveMenu","Int",hSysMenu,"UInt",nCnt-6,"Uint","0x400") 
DllCall("DrawMenuBar","Int",hWnd) 

;DeleteWindowMoving(hWnd = "") {
;  Return RemoveMenu(hWnd, 0xF010)  ; SC_MOVE = 0xF010
;}

;ControlMove 1000, 40, , , ,"A"