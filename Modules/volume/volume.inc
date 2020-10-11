[bVolume]
Meter            = Image
MeterStyle       = TrayButton
X                = #tVolumePosX#
ImageName        = #@#Images\IconPacks\#tIconPack#\volume\volume_#vVolumeStep#.png
ImageTint        = #vForeGround#
MouseOverAction  = [!ShowMeter Hover][!SetOption Hover X "([#CURRENTSECTION#:X]-([Hover:W]/2)+(#tIconSize#/2))"][!Update]
MouseLeaveAction = [!HideMeter Hover][!Update]
DynamicVariables = 1
Hidden = #tDisableVolume#
