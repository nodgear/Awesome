[AlignLeft]
X                = R
[AlignRight]
X                = (-(#tIconMargin#+#tIconSize#))r

[Text]
FontFace         = Montserrat
FontWeight       = 600
AntiAlias        = 1
FontSize         = 11

[TrayButton]
W                = #tIconSize#
H                = #tIconSize#
Y                = ((#oBarOffset#+#oBarHeight#)/2 - #tIconSize#/2)


[SettingsButton]
FontFace         = IBM Plex Sans
FontSize         = 10
FontColor        = 230,230,230
DynamicVariables = 1
Group            = Settings
Antialias        = 1
X                = 5
Y                = 5R

[CheckButton]
InlinePattern    = ^.
InlineSetting2   = Color | #colorAccent#
InlinePattern2   = ^.
InlineSetting3   = Face | Font Awesome 5 Free
InlinePattern3   = ^.
InlineSetting4   = CharacterSpacing | 2
InlinePattern4   = ^.(.)

[RadioButton]
InlineSetting    = Weight | 400
InlinePattern    = ^.
InlineSetting2   = Color | #colorAccent#
InlinePattern2   = ^.
InlineSetting3   = Face | Font Awesome 5 Free
InlinePattern3   = ^.
InlineSetting4   = CharacterSpacing | 2
InlinePattern4   = ^.(.)

[RadioButtonInline]
X                = 7R
Y                = r

[SettingsH1]
FontFace         = Segoe UI
FontSize         = 16
FontColor        = 255,255,255
Antialias        = 1


[SettingsH2]
FontFace         = Segoe UI
FontSize         = 9
FontColor        = 255,255,255
FontWeight       = Bold
Antialias        = 1

[SettingsH3]
FontFace         = Segoe UI
FontSize         = 9
FontColor        = 255,255,255
Antialias        = 1

[SettingsHint]
FontFace         = Segoe UI
FontSize         = 9
FontColor        = 104,104,104
Antialias        = 1