[bApp] Meter = String Substitute =
"^(.*)\.(.*)$":"\1","Explorer":"#lDessktop#","Rainmeter":"Awesome" Text =
#vProcess# X = #tAppPosX# MeterStyle = TrayInfo | Menu fontColor =
#vForeGround#; MouseOverAction = [!ShowMeter Hover][!SetOption Hover X
"([#CURRENTSECTION#:X]-([Hover:W]/2)+(#tIconSize#/2))"][!Update] ;
MouseLeaveAction = [!HideMeter Hover][!Update] DynamicVariables = 1 Hidden =
#tDisableApp#
