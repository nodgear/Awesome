; This is a theme file (yes, you saw that one comming)
; You o verride ANY setting  here, including MeterStyles and shapes
; But please, avoid forcing options like DekstopColors / FocusMode
; You can replace things like oBarOffsetX oBarOffsetY to achieve the needed results tho.

; The theme name is the same as the file name.
; Any selected theme is cloned to the Custom one, so the user can customize it without losing the original one, or reseting every update.

[Variables]
tIconPack             = fluent

tBarTint              = 45,45,45,142 ; Optional, you can put value diresctly into the shape
tBarStrokeWidth       = 0        ; Optional, you can put value diresctly into the shape
tBarStrokeColor       = 0,0,0    ; Optional, you can put value diresctly into the shape
tBarBorderRadius      = 0        ; Optional, you can put value diresctly into the shape

tBarTintShape1        = Rectangle 0, 0, (#SCREENAREAWIDTH# - #oBarOffsetX#*2), #oBarHeight# | Fill Color #tBarTint# | StrokeWidth 0
tBarTintShape2        =
tBarTintShape3        =

tBarShouldBlur        = 1        ; Control for Windows 7 (support for windows 7 is not confirmed yet)
tBarBlurType          = Acrylic  ; Type of blur type (Acrylic | Blur | None)
tBarShadow            = "ALL"    ; Borders when blur is enabled


tIconSize             = 24
tIconMargin           = 18
tBarPadding           = 8

tClockFontSize        = 14
tAppFontSize          = 12

tCenterClock          = 1
tHidePowerButton      = 0



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

; Background for DEFAULTCOLORMODE with focusmode
tBackgroundLightColor = 255,255,255
tBackgroundDarkColor  = 0,0,0

; If all modes are set to 0, how the fuck we get color contrast?
; Well, the theme decides, user can overwrite.
; Options: 1          = LightMode, 0 = DarkMode
tDefaultColorsMode    = 0

; Background for when using (DefaultColorMode) or (Focusmode with TitlebarBlend)
tLightModeTextColor   = 0,0,0,200
tLightModeHoverColor  = 255,0,144,255

tDarkModeTextcolor    = 255,255,255,255
tDarkModeHoverColor   = 149,0,255,255

[Text]
FontFace              = Segoe UI
FontWeight            = 600
AntiAlias             = 1
FontSize              = 11

[TrayButton]
W                     = #tIconSize#
H                     = #tIconSize#
Y                     = ((#oBarOffsetY#+#oBarHeight#)/2 - #tIconSize#/2)

[CenterClock]
FontFace              = Segoe UI
FontSize              = #tClockFontSize#
FontWeight            = 500
Y                     = (#oBarHeight#/2 - [c1:H]/2 -1 )
AntiAlias             = 1

[AppMenu]
FontFace              = Segoe UI
FontSize              = #tAppFontSize#
Y                     = (#oBarHeight#/2 - [AppStr:H]/2 - 1)
FontWeight            = 500
AntiAlias             = 1
