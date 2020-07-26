[bNotify]
Meter            = Image
MeterStyle       = TrayButton
X                = #tNotificationPosX#
ImageName        = #@#Images\IconPacks\#tIconPack#\notification\notification_unread.png
ImageTint        = #vForeGround#
MouseOverAction  = [!ShowMeter Hover][!SetOption Hover X "([#CURRENTSECTION#:X]-([Hover:W]/2)+(#tIconSize#/2))"][!Update]
MouseLeaveAction = [!HideMeter Hover][!Update]
DynamicVariables = 1