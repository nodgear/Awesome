#Persistent
SetTitleMatchMode "RegEx"
#SingleInstance force
TraySetIcon(A_WorkingDir . "\wwing.ico")

SendRainmeterCommand("[!SetVariable AHKVersion " . A_AhkVersion . " awesomebar]")
SendRainmeterCommand("[!UpdateMeasure MeasureWindowMessage awesomebar]")
UserDir := EnvGet("USERPROFILE")
userProfileIconCheck()
downloadDir := UserDir . "\Downloads\*.*"
wwingDir := dirCheck(UserDir "\wwing")
trayIconDir := dirCheck(wwingDir "\trayIcons")
iconTmp := dirCheck(EnvGet("TMP") "\wwing")
iconCheck := {}
trayIconList := {}
lastMinMax := 0
systrayCount := 0
systemTrayData := {}
desktopAppFocus := []
isStartOpen := false

#Include inc_graphics.ahk
#Include inc_lib.ahk
#Include inc_desktops.ahk
#Include inc_systray.ahk

OnMessage(16686, "OpenDownloads")
OnMessage(16685, "OpenDesktops")
OnMessage(16684, "OpenStart")
OnMessage(16683, "OpenNotifications")
OnMessage(16682, "SystrayClickNormal")
OnMessage(16681, "SystrayClickExtended")
OnMessage(16680, "goToDesktop")

SetTimerAndFire("cleanSystrayMemory",30000)
SetTimerAndFire("CheckForDownloadsInProgress", 2000)
SetTimerAndFire("getCurrentDesktopId", 100)
SetTimerAndFire("daemonWindowMinMax", 100)
SetTimerAndFire("TrayIcon_GetInfo", 400)
SetTimer("startMenuCheck", 150)
SetTimer("refreshSystemTray", 400)

startEventLoop(100)

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
      SendRainmeterCommand("[!HideMeterGroup groupStart wwing][!ShowMeterGroup groupSearch wwing]")
    }
    else
    {
      SendRainmeterCommand("[!HideMeterGroup groupSearch wwing][!ShowMeterGroup groupStart wwing]")
    }
  }
}
