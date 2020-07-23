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

tIconPack            = tray

; First option defines the Y position of the hover background.
; Second option defines the shape of the hover background
; On the default theme, Hover is centered and is a 6px rounded square
; You can have up to 3 shapes on the hover function :)
; HoverW and HoverH are completly optional and you can even delete then, i did it because i think it's easier to read.
tHoverY              = ( #oBarHeight#/2 - [Hover:H]/2 )
tHoverW              = #oBarHeight#
tHoverH              = #oBarHeight#
tHoverShape          = Rectangle 0, 0, #tHoverW#, #tHoverH#, 12, 12
tHoverShape2         = 
tHoverShape3         = 

; Background for DEFAULTCOLORMODE with focusmode
tBackgroundLightColor     = 255,255,255
tBackgroundDarkColor      = 0,0,0

; Background for when using (DefaultColorMode) or (Focusmode with TitlebarBlend)
tLightModeTextColor  = 0,0,0,255
tLightModeHoverColor = 255,255,255

tDarkModeTextcolor   = 255,255,255,255
tDarkModeHoverColor  = 0,0,0,255

