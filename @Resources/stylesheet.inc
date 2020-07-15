[sBarIcon]
DynamicVariables=1
SolidColor=0,0,0,1
Y=( #awvOffset# + (#awvBarHeight#/2 - #awvBarIconSize#/2 ) )
W=#awvBarIconSize#
H=#awvBarIconSize#
UpdateDivider = -1
AntiAlias=1

[sTooltip]
FontFace=Montserrat
StringStyle=Bold
Text="sTooltip"
FontSize=14
AntiAlias=1

[sInfo]
FontFace=Montserrat
Text="sTooltip"
FontSize=11
AntiAlias=1

[sPaddingBottom]
padding=#awvItemPadding#,0,#awvItemPadding#,#awvItemPadding#

[sPaddingTop]
padding=#awvItemPadding#,#awvItemPadding#,#awvItemPadding#,0

[sPaddingAll]
padding=#awvItemPadding#,#awvItemPadding#,#awvItemPadding#,#awvItemPadding#

[sPaddingSides]
Padding=#awvItemPadding#,0,#awvItemPadding#,0

[sLeftAlign]
X=R

[sRightAlign]
X=(-(#awvBarSpacing#))r

[sHoverBubble]
MouseOverAction = [!MoveMeter "([#CURRENTSECTION#:X] - #awvBarIconSize#/2)" "0" HoverBG][!ShowMeter HoverBG][!UpdateMeter HoverBG]
MouseLeaveAction = [!HideMeter HoverBG]