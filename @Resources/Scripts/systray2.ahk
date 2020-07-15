iVirtualDesktopManager := ComObjCreate("{aa509086-5ca9-4c25-8f95-589d3c07b48a}", "{a5cd92ff-29be-454c-8d04-d82879fb3f1b}")

Guid_ToStr(ByRef VarOrAddress)
{
	pGuid := IsByRef(VarOrAddress) ? &VarOrAddress : VarOrAddress
	VarSetCapacity(sGuid, 78) ; (38 + 1) * 2
	if !DllCall("ole32\StringFromGUID2", "Ptr", pGuid, "Ptr", &sGuid, "Int", 39)
		throw Exception("Invalid GUID", -1, Format("<at {1:p}>", pGuid))
	return StrGet(&sGuid, "UTF-16")
}

getWindowDesktopId(hWnd) 
{
	Global iVirtualDesktopManager
	
	desktopId := ""
	VarSetCapacity(desktopID, 16, 0)

	Error := DllCall(NumGet(NumGet(iVirtualDesktopManager+0), 4*A_PtrSize), "Ptr", iVirtualDesktopManager, "Ptr", hWnd, "Ptr", &desktopID)			
	return &desktopID
}

getCurrentDesktopId()
{
	return SubStr(RegExReplace(Guid_ToStr(getWindowDesktopId(WinGetId("A"))), "[-{}]"), 17)
}

listDesktops()
{
	regIdLength := 32
	DesktopList := RegRead("HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VirtualDesktops", "VirtualDesktopIDs")	
	desktops := []
	while true
	{
		desktopId := SubStr(DesktopList, ((A_index-1) * regIdLength) + 1, regIdLength)
		if(desktopId) 
		{
			MsgBox SubStr(desktopId, 17)
			desktops.push(SubStr(desktopId, 17))
		} 
		else
		{
			break
		}
	}
	return desktops
}	

indexOf(obj, item)
{
	for i, val in obj {
		if (val = item)
		{
			return i
		}
	}
}

desktops := listDesktops()

MsgBox desktops[1] " | " desktops[2] " | " desktops[3] " | " getCurrentDesktopId()

MsgBox indexOf(desktops, getCurrentDesktopId())