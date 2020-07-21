;=======================================================================
;                   Determine if winID is on nMonitor
;=======================================================================
getIsOnMonitor(winID, nMonitor := "")
{
  MonitorGetWorkArea(nMonitor, monLeft, monTop, monRight, monBottom)
  
  WinGetPos(winX,winY,Width,Height,"ahk_id " winID)

  ; && (winY + 8) >= monTop && (Height + 16) <= monBottom -- Detects if the window is sized with the appbar on top.
  if((Width - 16) <= monRight && (winX + 8) >= monLeft )
  {
    return True
  }
  else
  {
    return false
  }
}


;=======================================================================
;                   Get User's profile PIC if win10
;=======================================================================
userProfileIconCheck()
{
    if(SubStr(A_OSVersion,1,2) < 10)
    {
        return
    }
    
    Global UserDir
    if(!FileExist(UserDir . "\awesome\profile.bmp"))
    {
        Loop Files, UserDir . "\AppData\Roaming\Microsoft\Windows\AccountPictures\*" 
        {
            if(A_LoopFileExt = "accountpicture-ms")
            {
            RunWait("AccountPicConverter.exe " . A_LoopFileFullPath,,hide)
            FileDelete "*-448.bmp"
            FileMove "*-96.bmp", UserDir . "\awesome\profile.bmp",true
            break
            }
        }
    }

}


;=======================================================================
;            Check if a directory exists, and if not, build
;=======================================================================
dirCheck(targetDir)
{
    if(!dirExist(targetDir))
    {
        dirCreate(targetDir)
    }
    return targetDir
}


;=======================================================================
;            One Liner to check if start menu is open
;=======================================================================
AppVisibility := ComObjCreate(CLSID_AppVisibility := "{7E5FE3D9-985F-4908-91F9-EE19F9FD1514}", IID_IAppVisibility := "{2246EA2D-CAEA-4444-A3C4-6DE827E44313}")


;=======================================================================
;            Check if the window is a cloaked metro window
;=======================================================================
IsWindowCloaked(hwnd) {
    static gwa := DllCall("GetProcAddress", "ptr", DllCall("LoadLibrary", "str", "dwmapi", "ptr"), "astr", "DwmGetWindowAttribute", "ptr")
    return (gwa && DllCall(gwa, "ptr", hwnd, "int", 14, "int*", cloaked, "int", 4) = 0) ? cloaked : 0
}


;=======================================================================
;            Various File and directory handlers...
;=======================================================================
OpenDownloads(){
  global UserDir
  If(WinExist("Downloads"))
  {
      WinActivate
  }
  else{
      Run(explore UserDir . "\Downloads")
  }
}

OpenSearch(){
  Global isStartOpen := true
  send "#s"
}

OpenStart(){
  Global isStartOpen := true
  sendinput "{LWin}"
}

OpenNotifications(){
  sendinput "#a"
}


Guid_ToStr(ByRef VarOrAddress)
{
	pGuid := IsByRef(VarOrAddress) ? &VarOrAddress : VarOrAddress
	VarSetCapacity(sGuid, 78) ; (38 + 1) * 2
	if !DllCall("ole32\StringFromGUID2", "Ptr", pGuid, "Ptr", &sGuid, "Int", 39)
		throw Exception("Invalid GUID", -1, Format("<at {1:p}>", pGuid))
	return StrGet(&sGuid, "UTF-16")
}
;=======================================================================
;            Check progress of any downloading files
;=======================================================================
CheckForDownloadsInProgress(){
  Global downloadDir
  Loop files, downloadDir 
  {        
      If (a_LoopFileExt = "part" || a_LoopFileExt = "partial" || a_LoopFileExt = "crdownload")
      {
          SendRainmeterCommand("[!SetVariable Downloading 1 awesome]")
          return
      }
      else
      {
          SendRainmeterCommand("[!SetVariable Downloading 0 awesome]")
      }
  }
}

;=======================================================================
;            Send a command to rainmeter
;=======================================================================

SendRainmeterCommand(command) {
    if(Send_WM_COPYDATA(command, "ahk_class RainmeterMeterWindow") = 1)
    {
        ; If rainmeter is open and listening
        ; WinShow("ahk_class Shell_TrayWnd")
        ; WinShow("ahk_class Start Button")
        ExitApp
    }
    else{
        ; WinHide("ahk_class Shell_TrayWnd")
        ; WinHide("ahk_class Start Button")
    }
}


;=======================================================================
;            Send a Window Message
;=======================================================================
Send_WM_COPYDATA(ByRef StringToSend, ByRef TargetWindowClass)  
{
    VarSetCapacity(CopyDataStruct, 3*A_PtrSize, 0)  ; Set up the structure's memory area.
    ; First set the structure's cbData member to the size of the string, including its zero terminator:
    SizeInBytes := (StrLen(StringToSend) + 1) * (A_IsUnicode ? 2 : 1)
    NumPut(1, CopyDataStruct) ; Per example at https://docs.rainmeter.net/developers/
    NumPut(SizeInBytes, CopyDataStruct, A_PtrSize)  ; OS requires that this be done.
    NumPut(&StringToSend, CopyDataStruct, 2*A_PtrSize)  ; Set lpData to point to the string itself.
    SendMessage(0x4a, 0, &CopyDataStruct,, TargetWindowClass)  ; 0x4a is WM_COPYDATA. Must use Send not Post.
    return ErrorLevel  ; Return SendMessage's reply back to our caller.
}


;=======================================================================
;            MD5 check a string
;=======================================================================
MD5(string, case := False)    ; by SKAN | rewritten by jNizM
{
    static MD5_DIGEST_LENGTH := 16
    hModule := DllCall("LoadLibrary", "Str", "advapi32.dll", "Ptr")
    , VarSetCapacity(MD5_CTX, 104, 0), DllCall("advapi32\MD5Init", "Ptr", &MD5_CTX)
    , DllCall("advapi32\MD5Update", "Ptr", &MD5_CTX, "AStr", string, "UInt", StrLen(string))
    , DllCall("advapi32\MD5Final", "Ptr", &MD5_CTX)
    loop (MD5_DIGEST_LENGTH)
    { 
		   o .= Format("{:02" (case ? "X" : "x") "}", NumGet(MD5_CTX, 87 + A_Index, "UChar"))
	}
	DllCall("FreeLibrary", "Ptr", hModule)
    return o
}

;=======================================================================
;            setTimerAndFire, does as it says
;=======================================================================
SetTimerAndFire(timedFunction, timedDuration)
{
    %timedFunction%()
    SetTimer timedFunction, timedDuration
}

;=======================================================================
;            runTimerNow will immediately bring forward and execute a timer, and then reset it.
;=======================================================================
runTimerNow(timedFunction)
{
    SetTimer timedFunction, "Off"
    %timedFunction%()
    SetTimer timedFunction, "On"
}


;=======================================================================
;            :D
;=======================================================================
EmptyMem(PIDtoEmpty)
{   
    h:=DllCall("OpenProcess", "UInt", 0x001F0FFF, "Int", 0, "Int", PIDtoEmpty)
    DllCall("SetProcessWorkingSetSize", "UInt", h, "Int", -1, "Int", -1)
    DllCall("CloseHandle", "Int", h)
}

;=======================================================================
;            Everyone needs dis.
;=======================================================================
indexOf(obj, item)
{
	for i, val in obj {
		if (val = item)
		{
			return i
		}
	}
}

;=======================================================================
;            Logs a message to rainmeter
;=======================================================================

debug(messageString)
{   
    SendRainmeterCommand("[!Log `"" . messageString .  "`" notice]")
}

;=======================================================================
;            Send an async function to the queue
;=======================================================================

queueAsyncFunction(asyncFunction,delayMS := 0)
{
    Global asyncQueue
    delayN := (asyncQueue.length() + 1)
    asyncQueue[delayN,asyncFunction] := delayMS
}

;=======================================================================
;            async event loop
;=======================================================================

startEventLoop(tickRate)
{
    Global asyncQueue := []
    Global asyncRate := tickRate
    ;asyncQueue := asyncQueue ? asyncQueue : []
    SetTimerAndFire("eventLoop", tickRate)
}

eventLoop()
{
    Global asyncQueue
    Global asyncRate
    for asyncQueueN in asyncQueue
    {
        for asyncFunction, delayedTime in asyncQueue[asyncQueueN]
        {       
            if(delayedTime > 0)
            {
                asyncQueue[asyncQueueN,asyncFunction] := (delayedTime - asyncRate)
            }
            else
            {
                %asyncFunction%()
                asyncQueue.RemoveAt(asyncQueueN)
            }
        }
    }
}


state_titlebarColors := {}
showBackBar(targetWindow,instant := false)
{
    WinGetPos(vMaxmizedX, vMaximizedY, vMaximizedW, vMaximizedH, "A")
    CoordMode "Pixel", "Screen" 
    fadeString := instant ? "" : "Fade"
    Global state_titlebarColors

    if(!checkFocusMaximized(targetWindow))
    {
        SendRainmeterCommand("[!SetVariable vTitlebarY `" vMaximizedY `" awesome\Modules\Processor]")
        hideBackBar(instant)
        return
    }

    ; if(!state_titlebarColors[targetWindow])
    ; {
        
        iterations := 0
        PixelColorHex := PixelGetColor(vMaximizedW*0.7,vMaximizedY+8)
        startCount := A_TickCount
        While (PixelGetColor(vMaximizedW*0.7,vMaximizedY+8) = PixelColorHex && ((A_TickCount - startCount) < 200))
        {
            iterations++
        }
        TitlebarColor := PixelGetColor(vMaximizedW*0.7,vMaximizedY+8)
        state_titlebarColors[targetWindow] := TitlebarColor
    ; }
    ; else
    ; {
    ;     Tooltip TitlebarColor
    ;     TitlebarColor := state_titlebarColors[targetWindow]
    ; }
    ; SendRainmeterCommand("[!SetOption Background SolidColor `"" SplitRGBColor(TitlebarColor) "`" awesome\Modules\background]")
    SendRainmeterCommand("[!SetVariable vBGColor `"" SplitRGBColor(TitlebarColor) "`" awesome\Modules\processor][!Update awesome\Modules\Processor][!UpdateMeasure ProcessBackground  awesome\Modules\processor][!UpdateMeasure ProcessForeground  awesome\Modules\processor]")
    SendRainmeterCommand("[!SetVariable vBGLuminance `"" RGB2L(TitlebarColor) "`" awesome\Modules\processor][!UpdateMeasure ProcessBackground  awesome\Modules\processor][!UpdateMeasure ProcessForeground  awesome\Modules\processor]")
    SendRainmeterCommand("[!SetVariable vMaximized 1 awesome\Modules\Processor][!UpdateMeasure ProcessBackground  awesome\Modules\processor][!UpdateMeasure ProcessForeground  awesome\Modules\processor]")
    SendRainmeterCommand("[!SetVariable vTitlebarY `"" vMaximizedY+4 "`" awesome\Modules\Processor][!UpdateMeasure MeasureDebugMode awesome\Modules\Processor][!UpdateMeasure ProcessForeground  awesome\Modules\processor]")
    ; SendRainmeterCommand("[!SetOption Background SolidColor `"" SplitRGBColor(TitlebarColor) "`" awesome\Modules\background][!SetVariable awvBGColor `"" SplitRGBColor(TitlebarColor) "`" awesome\Modules\background][!Update awesome\Modules\background][!Redraw awesome\Modules\background][!Show" fadeString " awesome\Modules\background][!SetVariable vMaximized 1 awesome\Modules\background][!Delay 300][!Update awesome][!Redraw awesome]")
}

hideBackBar(instant := false)
{
  fadeString := instant ? "" : "Fade"
  SendRainmeterCommand("[!SetVariable vMaximized 0 awesome\Modules\Processor][!UpdateMeasure ProcessBackground  awesome\Modules\processor][!UpdateMeasure ProcessForeground  awesome\Modules\processor]")
  ; SendRainmeterCommand("[!SetVariable vMaximized 0 awesome\Modules\background][!Hide" fadeString " awesome\Modules\background][!Delay 300][!Update awesome][!Redraw awesome]")
}

daemonWindowMinMax()
{
  Global state_daemonWindowMinMax
  Global desktopAppFocus
  Global currentDesktopN 
  targetWindow := WinGetID("A")
  minMaxState := WinGetMinMax("ahk_id " targetWindow)
  boolInstant := state_daemonWindowMinMax ? False : True

  if(WinGetClass("ahk_id " targetWindow) != "RainmeterMeterWindow")
  {
    if(!IsWindowCloaked(targetWindow))
    {
      if(minMaxState > -1)
      {
        desktopAppFocus[currentDesktopN] := targetWindow
      }
      else
      {
        desktopAppFocus[currentDesktopN] := ""
      }
      
      if(state_daemonWindowMinMax != minMaxState . "_" . targetWindow)
      {
        if(minMaxState = 1 && getIsOnMonitor(targetWindow))
        {
          showBackBar(targetWindow,boolInstant)
        }
        else
        {
          hideBackBar(boolInstant)
        }
      }
      state_daemonWindowMinMax := minMaxState . "_" . targetWindow
    }
  }
} 
