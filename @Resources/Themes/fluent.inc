; This is a theme file (yes, you saw that one comming)
; You override ANY setting  here, including MeterStyles and shapes
; But please, avoid forcing options like DekstopColors / FocusMode
; You can replace things like oBarOffsetX oBarOffsetY to achieve the needed results tho.

; The theme name is the same as the file name.
; Any selected theme is cloned to the Custom one, so the user can customize it without losing the original one, or reseting every update.

[Variables]
;                     =  Which icon pack should we use?
tIconPack             = fluent
; Bar background tint color | Doesn't affect FocusMode.
tBarTint              = 45,45,45,142 
; Thickness of the bar border
tBarStrokeWidth       = 0        
; Color of the bar border
tBarStrokeColor       = 0,0,0    
; Bar corner radius
tBarBorderRadius      = 0       
; Shapes for the bar background | https://docs.rainmeter.net/manual/meters/shape/
tBarTintShape1        = Rectangle 0, 0, (#SCREENAREAWIDTH# - #oBarOffsetX#*2), #oBarHeight# | Fill Color #tBarTint# | StrokeWidth 0
tBarTintShape2        = 
tBarTintShape3        = 
; Control for Windows 7 (support for windows 7 is not confirmed yet)
tBarShouldBlur        = 1      
; Type of blur type (Acrylic | Blur | None)  
tBarBlurType          = Acrylic  
; https://forum.rainmeter.net/viewtopic.php?t=23106
tBarShadow            = "All"    
; Size of the bar modules Icons - avoid sizes bigger than the bar size.
tIconSize             = 24
; Margin between modules icons
tIconMargin           = 18
; Padding on the sides of the bar
tBarPadding           = 8

;                     = MODULES STYLE
; Module Disabler
tDisableMenu          = 0
tDisableApp           = 0
tDisableClock         = 0
tDisableMedia         = 0
tDisableBrightness    = 0
tDisableVolume        = 0
tDisableNetwork       = 0
tDisableNotification  = 0
tDisablePower         = 0


; All modules Horizontal positions. That way you can move modules whatever you want for your theme.
; Heres one example of a right sided clock using another modules as position variables
; tClockPosX            = ([bBrightness:X]  - #tIconMargin# - [bClock:W])
; You can use relative positioning, just remember to check the load order on the topbar.ini file.
tMenuPosX             = #tBarPadding#
tAppPosX              = #tIconMargin#R
tClockPosX            = (#WORKAREAWIDTH#/2 - [bClock:W]/2)
tMediaPosX            = (-(#tIconMargin#+#tIconSize#))r
tBrightnessPosX       = (-(#tIconMargin#+#tIconSize#))r
tVolumePosX           = (-(#tIconMargin#+#tIconSize#))r
tNetworkPosX          = (-(#tIconMargin#+#tIconSize#))r
tNotificationPosX     = (-(#tIconMargin#+#tIconSize#))r
tPowerPosX            = (#SCREENAREAWIDTH# - #tBarPadding# - #tIconSize#)

;                     = HOVER STYLE
; First option defines the Y position of the hover background.
; Second option defines the shape of the hover background
; On the default theme, Hover is centered and is a 6px rounded square
; You can have up to 3 shapes on the hover function :)
; HoverW and HoverH are completly optional and you can even delete then, i did it because i think it's easier to read.
tHoverY               = ( #oBarHeight#/2 - [Hover:H]/2 )
tHoverW               = #oBarHeight#
tHoverH               = #oBarHeight#

tBarShape1        = Rectangle 0, 0, (#SCREENAREAWIDTH# - #oBarOffsetX#*2), #oBarHeight# | Fill Color #tBarTint# | StrokeWidth 0
tBarShape2        = 
tBarShape3        = 

tHoverShape           = Rectangle 0, 0, (#tHoverW# + #tIconMargin#/2) , #tHoverH#, 0
tHoverShape2          = 
tHoverShape3          = 

;                     = COLORS OPTIONS
; If all modes are set to 0, how the fuck we get color contrast?
; Well, the theme decides, user can overwrite.
; Options: 1=LightMode, 0=DarkMode
tDefaultColorsMode    = 0

; Colors for when using (DefaultColorMode) or (Focusmode with TitlebarBlend)
tLightModeTextColor   = 0,0,0,200
tLightModeHoverColor  = 255,0,144,255

tDarkModeTextcolor    = 255,255,255,255
tDarkModeHoverColor   = 149,0,255,255

; Colors for DEFAULTCOLORMODE with focusmode
tBackgroundLightColor = 255,255,255
tBackgroundDarkColor  = 0,0,0

;                     = STYLESHEET

[Text]
FontFace              = Segoe UI
FontWeight            = 600
AntiAlias             = 1
FontSize              = 11

[TrayButton]
W                     = #tIconSize#
H                     = #tIconSize#
Y                     = ((#oBarOffsetY#+#oBarHeight#)/2 - #tIconSize#/2)

[Clock]
FontFace              = Segoe UI
FontSize              = 14
FontWeight            = 500
Y                     = (#oBarHeight#/2 - [bClock:H]/2)
AntiAlias             = 1

[Menu]
FontFace              = Segoe UI
FontSize              = 12
Y                     = (#oBarHeight#/2 - [bApp:H]/2)
FontWeight            = 500
AntiAlias             = 1
