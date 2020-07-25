; This is a theme file (yes, you saw that one comming)
; You o verride ANY setting  here, including MeterStyles and shapes
; But please, avoid forcing options like DekstopColors / FocusMode
; You can replace things like oBarOffsetX oBarOffsetY to achieve the needed results tho.

; The theme name is the same as the file name.
; Any selected theme is cloned to the Custom one, so the user can customize it without losing the original one, or reseting every update.

[Variables]

tBarTint             = 0,0,0,0
tBarOpacity          = 0
tBarStrokeWidth      = 0
tBarStrokeColor      = 0,0,0
tBarShouldBlur       = 1
tBarBlurType         = Acrylic
tBarShadow           = "None"
tBarBorderRadius     = 0

tCenterClock         = 1
tHidePowerButton     = 0

tIconSize            = 16
tIconMargin          = 16
tBarPadding          = 16

tClockFontSize       = 10
tAppFontSize         = 10

tIconPack            = elementary

; First option defines the Y position of the hover background.
; Second option defines the shape of the hover background
; On the default theme, Hover is centered and is a 6px rounded square
; You can have up to 3 shapes on the hover function :)
; HoverW and HoverH are completly optional and you can even delete then, i did it because i think it's easier to read.
tHoverY              = ( #oBarHeight#/2 - [Hover:H]/2 )
tHoverW              = #oBarHeight#
tHoverH              = #oBarHeight#
tHoverShape          = Rectangle 0, 0, #tHoverW#, #tHoverH#, #tHoverH#
tHoverShape2         = 
tHoverShape3         = 

; Background for DEFAULTCOLORMODE with focusmode
tBackgroundLightColor     = 255,255,255
tBackgroundDarkColor      = 0,0,0

; If all modes are set to 0, how the fuck we get color contrast?
; Well, the theme decides, user can overwrite.
; Options: 1 = LightMode, 0 = DarkMode
tDefaultColorsMode = 0

; Background for when using (DefaultColorMode) or (Focusmode with TitlebarBlend)
tLightModeTextColor  =0,0,0,200
tLightModeHoverColor =255,0,144,255

tDarkModeTextcolor   =255,255,255,255
tDarkModeHoverColor  =149,0,255,255

[Text]
FontFace         = Montserrat
FontWeight       = 600
AntiAlias        = 1
FontSize         = 11

[TrayButton]
W                = #tIconSize#
H                = #tIconSize#
Y                = ((#oBarOffsetY#+#oBarHeight#)/2 - #tIconSize#/2)

[CenterClock]
FontFace         = Montserrat
FontSize         = #tClockFontSize#
FontWeight       = 700
Y                = (#oBarHeight#/2 - [c1:H]/2)
AntiAlias        = 1

[AppMenu]
FontFace         = Montserrat
FontSize         = #tAppFontSize#
Y                = (#oBarHeight#/2 - [AppStr:H]/2)
FontWeight       = 700
AntiAlias        = 1
