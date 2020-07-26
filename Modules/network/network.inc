
[bNetwork]
Meter            = Image
MeterStyle       = TrayButton
X                = #tNetworkPosX#
ImageName        = #@#Images\IconPacks\#tIconPack#\ethernet\network.png
ImageTint        = #vForeGround#
MouseOverAction  = [!ShowMeter Hover][!SetOption Hover X "([#CURRENTSECTION#:X]-([Hover:W]/2)+(#tIconSize#/2))"][!Update]
MouseLeaveAction = [!HideMeter Hover][!Update]
DynamicVariables = 1
Hidden = #tDisableNetwork#