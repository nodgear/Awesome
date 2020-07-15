systrayPID := 0
fuckingtest := 0
#WinActivateForce
TrayIcon_GetInfo()
{
	Global isStartOpen
	if(isStartOpen = true)
	{
		exit
	}
	
	DetectHiddenWindows (Setting_A_DetectHiddenWindows := A_DetectHiddenWindows) ? "On" : "Off"
	
	Global iconCheck
	Global trayIconDir
	Global systemTrayData
	Global systrayPID

	trayArray := {"Shell_TrayWnd":"User Promoted Notification Area","NotifyIconOverflowWindow":"Overflow Notification Area"}
	active_id := WinGetID("A")
	

	for sTray,trayCall in trayArray
	{
		
		if(isStartOpen = true)
		{
			DetectHiddenWindows Setting_A_DetectHiddenWindows
			exit
		}

		TrayIndex := A_Index
		explorerProcess := WingetPid("Program Manager")
		pidTaskbar := WinGetPID("ahk_class " sTray)		
		systrayPID := pidTaskbar
		trayLookup := ControlGetHwnd(trayCall,"ahk_class " sTray)
		trayId := "ahk_id " trayLookup			
		hProc := DllCall("OpenProcess", UInt, 0x38, Int, 0, UInt, pidTaskbar)
		pRB   := DllCall("VirtualAllocEx", Ptr, hProc, Ptr, 0, UPtr, 20, UInt, 0x1000, UInt, 0x4)
		TrayCount := SendMessage(0x418, 0, 0, ,trayId)   ; TB_BUTTONCOUNT
		szBtn := VarSetCapacity(btn, (A_Is64bitOS ? 32 : 20), 0)
		szNfo := VarSetCapacity(nfo, (A_Is64bitOS ? 32 : 24), 0)
		szTip := VarSetCapacity(tip, 128 * 2, 0)
		Index := 0
		
		if(!explorerProcess)
		{	;yes, the below repetition is seriously really necessary.
			Run "explorer.exe",,"Hide"
			WinActivate "ahk_id " active_id
			WinActivate "ahk_id " active_id
			WinActivate "ahk_id " active_id
			WinActivate "ahk_id " active_id
			WinActivate "ahk_id " active_id
			WinActivate "ahk_id " active_id
			Sleep 1000
			WinActivate "ahk_id " active_id
			DetectHiddenWindows Setting_A_DetectHiddenWindows
			exit
		}
		
		Loop TrayCount
		{
			
			SendMessage(0x417, A_Index - 1, pRB, ,trayId)   ; TB_GETBUTTON
			DllCall("ReadProcessMemory", Ptr, hProc, Ptr, pRB, Ptr, &btn, UPtr, szBtn, UPtr, 0)

			;iBitmap := NumGet(btn, 0, "Int")     
			;IDcmd   := NumGet(btn, 4, "Int")
			;statyle := NumGet(btn, 8)
			dwData  := NumGet(btn, (A_Is64bitOS ? 16 : 12))
			iString := NumGet(btn, (A_Is64bitOS ? 24 : 16), "Ptr")

			DllCall("ReadProcessMemory", Ptr, hProc, Ptr, dwData, Ptr, &nfo, UPtr, szNfo, UPtr, 0)

			hWnd  := NumGet(nfo, 0, "Ptr")
			uID   := NumGet(nfo, (A_Is64bitOS ? 8 : 4), "UInt")
			msgID := NumGet(nfo, (A_Is64bitOS ? 12 : 8))
			hIcon := NumGet(nfo, (A_Is64bitOS ? 24 : 20), "Ptr")

			sProcess :=  WinGetProcessName("ahk_id " hWnd)
			
			if(hWnd = "0")
			{
				PostMessage(0x12, 0, 0, , "Program Manager")
				Sleep 250
				OutputVar := ProcessClose(explorerProcess)
				Sleep 250
				DetectHiddenWindows Setting_A_DetectHiddenWindows
				exit
			}

			if(!sProcess)
			{
				continue
			}
			tip := ""

			DllCall("ReadProcessMemory", Ptr, hProc, Ptr, iString, Ptr, &tip, UPtr, szTip, UPtr, 0)

			sToolTip := StrGet(&tip, "UTF-16")

			if(sProcess = "wwing.exe")
			{
				sToolTip := "WingPanel Clone for Windows"
			}

			if((sProcess = "TaskMgr.exe" && sToolTip = "Task Manager") || sProcess = "spotify.exe")
			{
				continue
			}
			else if(sProcess = "explorer.exe")
			{
				if(uID = "100" )
				{ 
					continue
				}
			}

			Index := Index + 1					
			;systemTrayData[sTray,Index,"idx"]     := A_Index - 1
			;systemTrayData[sTray,Index,"IDcmd"]   := IDcmd
			SplitPath sProcess ,,,, sTitle

			systemTrayData[sTray,Index,"uID"]     := uID
			systemTrayData[sTray,Index,"msgID"]   := msgID
			systemTrayData[sTray,Index,"hIcon"]   := hIcon
			systemTrayData[sTray,Index,"hWnd"]    := hWnd
			systemTrayData[sTray,Index,"Process"] := sProcess
			systemTrayData[sTray,Index,"Title"] 	:= sTitle
			systemTrayData[sTray,Index,"Tooltip"] := sToolTip
			systemTrayData[sTray,Index,"Tray"]    := sTray
	
			if(!iconCheck[hIcon])
			{		
				processIconFolder := dirCheck(TrayIconDir "\" sProcess)
				hIconBmp := hIcon
				iconBitmap := Gdip_CreateBitmapFromHICON(hIcon)

				if(!iconBitmap)
				{
					hIconBmp := extractIconFromExe(WinGetProcessPath("ahk_id " hWnd))
					iconBitmap := Gdip_CreateBitmapFromHICON(hIconBmp)
				}

				iconPixels := Gdip_GetPixels(iconBitmap)
				iconMD5 := MD5(iconPixels)
				iconFilePNG := processIconFolder "\" iconMD5 ".png"
				iconFileICO := processIconFolder "\" iconMD5 ".ico"

				if(sProcess = "wwing.exe")
				{
					iconCheck[hIcon] := A_WorkingDir . "\wwing.png"
				}
				else if(FileExist(iconFilePNG))
				{
					iconCheck[hIcon] := iconFilePNG
				}
				else 
				{	
					if(!FileExist(iconFileICO))
					{
						SaveHICONtoFile(hIconBmp,iconFileICO)
					}

					iconCheck[hIcon] := iconFileICO
				}	
			}
			systemTrayData[sTray,Index,"IconFile"] := iconCheck[hIcon]
		}

		if(!systemTrayData[sTray])
		{
			return
		}

		if(systemTrayData[sTray].length() > Index)
		{
			systemTrayData[sTray].RemoveAt((Index + 1), (systemTrayData[sTray].length() - Index))
		}	

	}

	DllCall("VirtualFreeEx", Ptr, pRB, Ptr, hProc, Ptr, pProc, UPtr, 0, Uint, MEM_RELEASE)
	DllCall("CloseHandle", Ptr, hProc)
	DetectHiddenWindows Setting_A_DetectHiddenWindows
}

cleanSystrayMemory()
{
	Global systrayPID
	EmptyMem(systrayPID)
}

renderSystrayIconTheme(workFile,renderTo)
{
    SendRainmeterCommand("[!SetOption magickmeter1 ExportTo `"" . renderTo . "`" wwing][!SetOption magickmeter1 Image `"Rectangle 0,0,#vIconWidth#,#vIconHeight#  | Color 255,255,255,1  `"  wwing][!SetOption magickmeter1 Image2 `"File " . workFile . " | RenderSize 24,24 | move ((#vIconWidth# - 24) / 2),((#vIconHeight# - 24) / 2)`"  wwing][!UpdateMeasure magickmeter1 wwing]")
}

updateCache(cacheObject,cacheString)
{
	if(!cacheObject["cache" cacheString] || cacheObject[cacheString] != cacheObject["cache" cacheString] )
	{
		cacheObject["cache" cacheString] := cacheObject[cacheString]
		return True
	}
}

LastSystrayCount := []
SteamActive := False

refreshSystemTray()
{
	Global systemTrayData
	Global LastSystrayCount
	Global rainIconName
	Global SteamActive

	if(!systemTrayData)
	{
		exit
	}

	for sTray in systemTrayData
	{
		if(stray = "NotifyIconOverflowWindow")
		{
			TrayStyleName := "styleOverflowTray"
			TrayGroupName := "groupOverflowTray"
			iconString := "btnOverflowTray"
		}
		else
		{
			TrayStyleName := "styleSystray"
			TrayGroupName := "groupSystray"
			iconString := "btnSysTray"
		}
		
		TrayIndex := A_Index
		TrayIconMax := 0
		visIndex := 1
			
		RainMeterCommand := ""
		UpdateRequired := False

		loop 20
		{
			nTrayIcon := A_Index
			
			iconSystray := iconString visIndex		

			if(!systemTrayData[sTray,nTrayIcon])
			{
				RainMeterCommand := RainMeterCommand  "[!SetOption `"" iconSystray "`" Hidden 1 wwing]"
				continue
			}

			if(systemTrayData[sTray,nTrayIcon].Process = "steam.exe")
			{
				if(!SteamActive)
				{
					SteamActive := True
					SendRainmeterCommand("[!SetOption BtnSteam RightMouseDownAction `"`"`"[!CommandMeasure MeasureWindowMessage `"SendMessage 1668" TrayIndex " " nTrayIcon " 3`"]`"`"`" wwing][!SetOption BtnSteam RightMouseUpAction `"`"`"[!CommandMeasure MeasureWindowMessage `"SendMessage 1668" TrayIndex " " nTrayIcon " 6`"]`"`"`" wwing]")
				}
				continue	
			}

			if(systemTrayData[sTray,nTrayIcon].Process = "explorer.exe")
			{
				if(SubStr(systemTrayData[sTray,nTrayIcon].uID, 1, 2) = "49")
				{
					TooltipArray := StrSplit(systemTrayData[sTray,nTrayIcon].Tooltip , "`n")
					SendRainmeterCommand("[!SetVariable ifSSID `" @ " TooltipArray[1] "`"  wwing\components\network][!SetVariable ifInternet `"" TooltipArray[2] "`"  wwing\components\network]")
					continue
				}
			}

			if(updateCache(systemTrayData[sTray,nTrayIcon],"Process"))
			{
				RainMeterCommand := RainMeterCommand "[!SetOption " iconSystray " LeftMouseDownAction `"`"`"[!CommandMeasure MeasureWindowMessage `"SendMessage 1668" TrayIndex " " nTrayIcon " 1`"]`"`"`" wwing]"
				RainMeterCommand := RainMeterCommand "[!SetOption " iconSystray " MiddleMouseDownAction `"`"`"[!CommandMeasure MeasureWindowMessage `"SendMessage 1668" TrayIndex " " nTrayIcon " 2`"]`"`"`" wwing]"
				RainMeterCommand := RainMeterCommand "[!SetOption " iconSystray " RightMouseDownAction `"`"`"[!CommandMeasure MeasureWindowMessage `"SendMessage 1668" TrayIndex " " nTrayIcon " 3`"]`"`"`" wwing]"
				RainMeterCommand := RainMeterCommand "[!SetOption " iconSystray " LeftMouseUpAction `"`"`"[!CommandMeasure MeasureWindowMessage `"SendMessage 1668" TrayIndex " " nTrayIcon " 4`"]`"`"`" wwing]"
				RainMeterCommand := RainMeterCommand "[!SetOption " iconSystray " MiddleMouseUpAction `"`"`"[!CommandMeasure MeasureWindowMessage `"SendMessage 1668" TrayIndex " " nTrayIcon " 5`"]`"`"`" wwing]"
				RainMeterCommand := RainMeterCommand "[!SetOption " iconSystray " RightMouseUpAction `"`"`"[!CommandMeasure MeasureWindowMessage `"SendMessage 1668" TrayIndex " " nTrayIcon " 6`"]`"`"`" wwing]"
				RainMeterCommand := RainMeterCommand "[!SetOption " iconSystray " MouseOverAction `"`"`"[!SetOption #CURRENTSECTION# SolidColor #vTooltipColor#][!UpdateMeter #CURRENTSECTION#][!Setoption MeterProcess Text `"#" iconSystray "_title#`" `"wwing\components\systray`"][!Setoption MeterTooltip Text  `"#" iconSystray "_tooltip#`" `"wwing\components\systray`"][!Move `"([#CURRENTSECTION#:X] - ((#vSkinWidth#) / 2 - 24))`" `"40`" `"wwing\components\systray`"][!UpdateMeter `"MeterProcess`" `"wwing\components\systray`"][!UpdateMeter `"MeterTooltip`" `"wwing\components\systray`"][!Redraw `"wwing\components\systray`"][!Show `"wwing\components\systray`"]`"`"`" wwing]"
				RainMeterCommand := RainMeterCommand "[!SetOption " iconSystray " MouseLeaveAction `"`"`"[!SetOption #CURRENTSECTION# SolidColor 0,0,0,1][!UpdateMeter #CURRENTSECTION#][!Hide `"wwing\components\systray`"]`"`"`" wwing]"
				UpdateRequired := True
			}

			if(updateCache(systemTrayData[sTray,nTrayIcon],"hIcon"))
			{	
				SplitPath systemTrayData[sTray,nTrayIcon].IconFile , , ,iconExt

				if(iconExt = "ico")
				{
					varStyle := " | styleSystrayIconUnstyled"
				}
				else
				{
					varStyle := ""
				}
				RainMeterCommand := RainMeterCommand "[!SetOption `"" iconSystray "`" Hidden 0 wwing]"
				RainMeterCommand := RainMeterCommand "[!SetOption " iconSystray " imagename `"" systemTrayData[sTray,nTrayIcon].IconFile "`" wwing]"
				RainMeterCommand := RainMeterCommand "[!SetOption " iconSystray " MeterStyle `" sStyleIcon | sRightAlign | styleSystrayIcon | " TrayStyleName varStyle "`" wwing]"
				UpdateRequired := True
				
			}	

			if(updateCache(systemTrayData[sTray,nTrayIcon],"Tooltip") || updateCache(systemTrayData[sTray,nTrayIcon],"Title"))
			{
			
				filterTitle := systemTrayData[sTray,nTrayIcon,"Title"]
				filterTooltip := systemTrayData[sTray,nTrayIcon,"Tooltip"]

				if(filterTitle = "Explorer" || filterTitle = filterTooltip || filterTitle = "")
				{
					filterTitle := filterTooltip
					filterTooltip := ""
				}

				SendRainmeterCommand("[!SetVariable " iconSystray "_title `"" filterTitle "`" wwing\components\systray][!SetVariable " iconSystray "_tooltip `"" filterTooltip "`" wwing\components\systray]")
			}

			visIndex := visIndex + 1
		}

		if(UpdateRequired)
		{
			RainMeterCommand := RainMeterCommand "[!UpdateMeterGroup " TrayGroupName  " awesomebar][!Redraw awesomebar]"
			SendRainmeterCommand(RainMeterCommand)
		}
	}

	
}

ReplaceIcon(wParam, lParam, sTray)
{
	Global systemTrayData
	Global trayIconDir
	Global iconCheck
	SelectedIcon := FileSelect(1, trayIconDir . "\" . systemTrayData[sTray,wParam].Process, "Select the System Tray Icon for this Process that you wish to replace","(*.png; *.ico)")
	if(SelectedIcon)
	{
		ReplacementIcon := FileSelect(1, , "Select the new Icon you wish to use","(*.png; *.ico)")
		if(ReplacementIcon)
		{		
			SplitPath ReplacementIcon , , , ReplacementIconExt, ReplacementIconName
			SplitPath SelectedIcon , , SelectedIconDir, SelectedIconExt,SelectedIconName

			if(ReplacementIconExt != SelectedIconExt)
			{				
				destinationFile := SelectedIconDir "\" SelectedIconName "." ReplacementIconExt
				FileDelete SelectedIcon				
			}
			else
			{
				destinationFile := SelectedIcon
			}	

			FileCopy  ReplacementIcon,destinationFile, 1
			iconCheck[systemTrayData[sTray,wParam].hIcon] := destinationFile
			systemTrayData[sTray,wParam].hIcon := destinationFile
			systemTrayData[sTray,wParam].Delete("cachehIcon")

			if(stray = "NotifyIconOverflowWindow")
			{
				iconString := "btnOverflowTray"
			}
			else
			{
				iconString := "btnSysTray"
			}

			SendRainmeterCommand("[!UpdateMeter " iconString wParam " wwing][!Redraw wwing]")
		}
	}
}

SystrayClickNormal(wParam, lParam)
{
	ClickSystray(wParam, lParam, "Shell_TrayWnd")
}

SystrayClickExtended(wParam, lParam)
{
	ClickSystray(wParam, lParam, "NotifyIconOverflowWindow")
}

ClickSystray(wParam, lParam, systemTrayData)
{
  if(lParam = 1)
  {
    SendSystrayClick(systemTrayData,wParam,"LBUTTONDOWN")
  }
  else if(lParam = 2)
  {
	ReplaceIcon(wParam, lParam, systemTrayData)
  }
  else if(lParam = 3)
  {
    SendSystrayClick(systemTrayData,wParam,"RBUTTONDOWN")
  }
  else if(lParam = 4)
  {
    SendSystrayClick(systemTrayData,wParam,"LBUTTONUP")
  }
  else if(lParam = 6)
  {
    SendSystrayClick(systemTrayData,wParam,"RBUTTONUP")
  }
}

SendSystrayClick(trayObject, buttonIndex, sButton := "LBUTTONUP")
{
	Global systemTrayData	
	DetectHiddenWindows (Setting_A_DetectHiddenWindows := A_DetectHiddenWindows) ? "On" : "Off"
	WM_MOUSEMOVE	  := 0x0200
	WM_LBUTTONDOWN	  := 0x0201
	WM_LBUTTONUP	  := 0x0202
	WM_LBUTTONDBLCLK := 0x0203
	WM_RBUTTONDOWN	  := 0x0204
	WM_RBUTTONUP	  := 0x0205
	WM_RBUTTONDBLCLK := 0x0206
	WM_MBUTTONDOWN	  := 0x0207
	WM_MBUTTONUP	  := 0x0208
	WM_MBUTTONDBLCLK := 0x0209
	sButton := "WM_" sButton
	msgID  := systemTrayData[trayObject,buttonIndex].msgID
	uID    := systemTrayData[trayObject,buttonIndex].uID
	hWnd   := systemTrayData[trayObject,buttonIndex].hWnd

	if(systemTrayData[trayObject,buttonIndex].Tooltip = "Safely Remove Hardware and Eject Media" && (sButton := "WM_LBUTTONUP" || sButton := "WM_RBUTTONUP"))
	{
		Run "RunDll32.exe shell32.dll,Control_RunDLL hotplug.dll"
	}
	else
	{
		Sleep 30
		SendMessage(msgID, uID, %sButton%, , "ahk_id " hWnd)
	}
		
	DetectHiddenWindows Setting_A_DetectHiddenWindows
	return
}
