OpenDesktops(){
  send "#{tab}"
}

goToDesktop(wParam, lParam){
  switchToDesktop(wParam)
}

getSessionId()
{
    ProcessId := DllCall("GetCurrentProcessId", "UInt")
    DllCall("ProcessIdToSessionId", "UInt", ProcessId, "UInt*", SessionId)
    return SessionId
}

getCurrentDesktopId()
{
    thisDesktopID := SubStr(RegRead("HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\SessionInfo\" getSessionId() "\VirtualDesktops", "CurrentVirtualDesktop"), 17)
	Global currentDesktopN
	Global currentDesktopID
	Global desktops
	thisDesktopN := indexOf(desktops, thisDesktopID)
	if(currentDesktopN != thisDesktopN)
	{
		currentDesktopN := thisDesktopN
		setDesktopIndicator(thisDesktopN)
	}
}

listDesktops()
{
	regIdLength := 32
	DesktopList := RegRead("HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VirtualDesktops", "VirtualDesktopIDs")	
	desktops := []
	rainmeterCommand := ""
	while true
	{
		desktopId := SubStr(DesktopList, ((A_index-1) * regIdLength) + 1, regIdLength)
		if(desktopId) 
		{
			if(A_index = 1)
			{
				rainmeterCommand := "[!ShowMeter BtnDesktops wwing]"
			}
			rainmeterCommand := rainmeterCommand . "[!ShowMeter BtnDesktop" A_Index " wwing]"
			desktops.push(SubStr(desktopId, 17))
		} 
		else
		{
			break
		}
	}
	if(desktops.length() > 1)
	{
		SendRainmeterCommand(rainmeterCommand)
	}
	
	return desktops
}	

setDesktopIndicator(desktopN)
{
	SendRainmeterCommand("[!SetOption BtnDesktopIndicator x `"[BtnDesktop" desktopN ":x]`" wwing][!UpdateMeter BtnDesktopIndicator wwing][!ShowMeter BtnDesktopIndicator wwing][!Redraw wwing]")
}

pauseRaindock()
{
	DetectHiddenWindows "on"
	targetWindow := WinGetID("raindock.ahk - AutoHotkey v" A_AhkVersion)
	Send_WM_COPYDATA("pauseRaindock","ahk_id " targetWindow)
	DetectHiddenWindows "off"
}

resumeRaindock()
{
	DetectHiddenWindows "on"
	targetWindow := WinGetID("raindock.ahk - AutoHotkey v" A_AhkVersion)
	Send_WM_COPYDATA("resumeRaindock","ahk_id " targetWindow)
	DetectHiddenWindows "off"
}

restoreWorkspaceFocus()
{
	Global desktopAppFocus
	Global currentDesktopN
	targetApplication := desktopAppFocus[currentDesktopN]
	
	WinActivate "ahk_id " targetApplication
}

checkFocusMaximized(targetApplication)
{
	if(WinGetMinMax("ahk_id " targetApplication) = 1 && getIsOnMonitor(targetApplication) && !IsWindowCloaked("ahk_id " targetApplication))
	{
		return true
	}
	return false
}


switchToDesktop(selectedDesktopN)
{
	Global desktops
	Global currentDesktopID
	Global currentDesktopN
	Global desktopAppFocus

	previousDesktopN := currentDesktopN    

	if(currentDesktopID = desktops[selectedDesktopN])
	{
		return
	}
	else          
	{
		SetTimer "daemonWindowMinMax","off"
		SetTimer "getCurrentDesktopId","off"
		sendString := ""
		currentDesktopN := selectedDesktopN
		showBackBar(desktopAppFocus[selectedDesktopN],true)
		restoreWorkspaceFocus()

		if(previousDesktopN > selectedDesktopN)
		{
			keyString := "#^{Left}"  
			keyCount := (previousDesktopN - selectedDesktopN)
		} 
		else if(selectedDesktopN > previousDesktopN)
		{
			keyString := "#^{Right}"
			keyCount := (selectedDesktopN - previousDesktopN)    
		}

		loop (keyCount)
		{
			sendString := sendString . keyString
		}

		SendEvent sendString
		SetTimer "daemonWindowMinMax","on"
		SetTimer "getCurrentDesktopId","on"
	}
}


currentDesktopID := ""
currentDesktopN := ""
desktops := listDesktops()
