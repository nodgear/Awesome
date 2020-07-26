[bPower]
Meter            = Image
MeterStyle       = TrayButton
X                = #tPowerPosX#
ImageName        = #@#Images\IconPacks\#tIconPack#\shutdown\power.png
ImageTint        = #vForeGround#
MouseOverAction  = [!ShowMeter Hover][!SetOption Hover X "([#CURRENTSECTION#:X]-([Hover:W]/2)+(#tIconSize#/2))"][!Update]
MouseLeaveAction = [!HideMeter Hover][!Update]
DynamicVariables = 1
Hidden = #tDisablePower#
