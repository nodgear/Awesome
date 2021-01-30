#Persistent
SetTitleMatchMode "RegEx"
#SingleInstance force
TraySetIcon(A_WorkingDir . "\awesome.ico")
A_IconTip := "Awesome - Window Daemon"

SendRainmeterCommand("[!SetVariable AHKVersion " . A_AhkVersion . " awesome]")
SendRainmeterCommand("[!UpdateMeasure MeasureWindowMessage awesome]")
UserDir := EnvGet("USERPROFILE")
userProfileIconCheck()
downloadDir := UserDir . "\Downloads\*.*"

desktopAppFocus := []
isStartOpen := false

#Include inc_graphics.ahk
#Include inc_lib.ahk
#Include inc_desktops.ahk


OnMessage(16686, "OpenDownloads")
OnMessage(16684, "OpenStart")
OnMessage(16683, "OpenNotifications")


SetTimerAndFire("CheckForDownloadsInProgress", 2000)
SetTimerAndFire("daemonWindowMinMax", 200)
SetTimerAndFire("daemonWindowTitle", 200)
; SetTimer("startMenuCheck", 1000)

startEventLoop(200)

startMenuCheck()
{
  Global isStartOpen
  Global AppVisibility
  ;if( (DllCall(NumGet(NumGet(AppVisibility+0)+4*A_PtrSize), "Ptr", AppVisibility, "Int*", fVisible) >= 0) && fVisible = 1 )
  startMenuOpenCheck := isStartOpen

  if(WinGetTitle("A") = "Cortana" && WinGetClass("A") = "Windows.UI.Core.CoreWindow")
  {
    isStartOpen := true
  }
  else
  {
    isStartOpen := false
  }

  if(isStartOpen != startMenuOpenCheck)
  {
    if(isStartOpen = true)
    {
      ; SendRainmeterCommand("[!HideMeterGroup groupStart wwing][!ShowMeterGroup groupSearch wwing]")
    }
    else
    {
      ; SendRainmeterCommand("[!HideMeterGroup groupSearch wwing][!ShowMeterGroup groupStart wwing]")
    }
  }
}
