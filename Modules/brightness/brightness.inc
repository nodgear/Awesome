[bBrightness]
Meter            = Image
MeterStyle       = TrayButton
X                = #tBrightnessPosX#
ImageName        = #@#Images\IconPacks\#tIconPack#\brightness\brightness.png
ImageTint        = #vForeGround#
MouseOverAction  = [!ShowMeter Hover][!SetOption Hover X "([#CURRENTSECTION#:X]-([Hover:W]/2)+(#tIconSize#/2))"][!Update]
MouseLeaveAction = [!HideMeter Hover][!Update]
DynamicVariables = 1
