checkFocusMaximized(targetApplication)
{
	if(WinGetMinMax("ahk_id " targetApplication) = 1 && getIsOnMonitor(targetApplication) && !IsWindowCloaked("ahk_id " targetApplication))
	{
		return true
	}
	return false
}

currentDesktopID := ""
currentDesktopN := ""
