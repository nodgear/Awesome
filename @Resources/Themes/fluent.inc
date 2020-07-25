; This is a theme file (yes, you saw that one comming)
; You o verride ANY setting  here, including MeterStyles and shapes
; But please, avoid forcing options like DekstopColors / FocusMode
; You can replace things like oBarOffsetX oBarOffsetY to achieve the needed results tho.

; The theme name is the same as the file name.
; Any selected theme is cloned to the Custom one, so the user can customize it without losing the original one, or reseting every update.

[Variables]

; This defines the modules order and positions.
; To get a list of available modules, just check the Modules folder.
; You can create your own modules following the same folder structure
; Modules 
;    - moduleName 
;       - moduleName.ini       
;    - widget 
;       - widget_moduleName.ini


tIconPack             = fluent

; Optional, you can put values diresctly into the shape
tBarTint              = 45,45,45,142 
tBarStrokeWidth       = 0        
tBarStrokeColor       = 0,0,0    
tBarBorderRadius      = 0       


tBarShouldBlur        = 1        ; Control for Windows 7 (support for windows 7 is not confirmed yet)
tBarBlurType          = Acrylic  ; Type of blur type (Acrylic | Blur | None)
tBarShadow            = "ALL"    ; Borders when blur is enabled


;                     = =================================================
;                     = MODULES STYLE AND POSITION
;                     = =================================================

tIconSize             = 24
tIconMargin           = 18
tBarPadding           = 8

tClockFontSize        = 14
tAppFontSize          = 12

tDisableCenterClock   = 0

; All modules Horizontal positions. That way you can move modules whatever you want for your theme.
;Heres one example of a right sided clock!
; tClockPosX            = ([bBrightness:X]  - #tIconMargin# - [bClock:W])


tMenuPosX             = #tIconMargin#R
tAppPosX              = #tIconMargin#R
tClockPosX            = (#WORKAREAWIDTH#/2 - [bClock:W]/2)
tMediaPosX            = (-(#tIconMargin#+#tIconSize#))r
tBrightnessPosX       = (-(#tIconMargin#+#tIconSize#))r
tVolumePosX           = (-(#tIconMargin#+#tIconSize#))r
tNetworkPosX          = (-(#tIconMargin#+#tIconSize#))r
tNotificationPosX     = (-(#tIconMargin#+#tIconSize#))r
tPowerPosX            = (-(#tIconMargin#+#tIconSize#))r


;                     = =================================================
;                     = HOVER STYLE
;                     = =================================================

; First option defines the Y position of the hover background.
; Second option defines the shape of the hover background
; On the default theme, Hover is centered and is a 6px rounded square
; You can have up to 3 shapes on the hover function :)
; HoverW and HoverH are completly optional and you can even delete then, i did it because i think it's easier to read.
tHoverY               = ( #oBarHeight#/2 - [Hover:H]/2 )
tHoverW               = #oBarHeight#
tHoverH               = #oBarHeight#
tHoverShape           = Rectangle 0, 0, (#tHoverW# + #tIconMargin#/2) , #tHoverH#, 0
tHoverShape2          = 
tHoverShape3          = 


;                     = =================================================
;                     = BACKGROUND OPTIONS
;                     = =================================================
tBarTintShape1        = Rectangle 0, 0, (#SCREENAREAWIDTH# - #oBarOffsetX#*2), #oBarHeight# | Fill Color #tBarTint# | StrokeWidth 0
tBarTintShape2        = 
tBarTintShape3        = 




;                     = =================================================
;                     = COLORS OPTIONS
;                     = =================================================

; If all modes are set to 0, how the fuck we get color contrast?
; Well, the theme decides, user can overwrite.
; Options: 1          = LightMode, 0 = DarkMode
tDefaultColorsMode    = 0

; Background for when using (DefaultColorMode) or (Focusmode with TitlebarBlend)
tLightModeTextColor   = 0,0,0,200
tLightModeHoverColor  = 255,0,144,255

tDarkModeTextcolor    = 255,255,255,255
tDarkModeHoverColor   = 149,0,255,255

; Background for DEFAULTCOLORMODE with focusmode
tBackgroundLightColor = 255,255,255
tBackgroundDarkColor  = 0,0,0

;                     = =================================================
;                     = METER STYLES
;                     = =================================================


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
FontSize              = #tClockFontSize#
FontWeight            = 500
Y                     = (#oBarHeight#/2 - [bClock:H]/2)
AntiAlias             = 1

[Menu]
FontFace              = Segoe UI
FontSize              = #tAppFontSize#
Y                     = (#oBarHeight#/2 - [bApp:H]/2)
FontWeight            = 500
AntiAlias             = 1
