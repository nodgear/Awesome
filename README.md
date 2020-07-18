# AWESOME 😎 - A Rainmeter Topbar for Windows!.

Awesome is the **spiritual successor** to WWING by [Jon Seppanen](https://github.com/jonseppanen).
It aims to be a taskbar replacement/companion for windows for anyone.

![My desktop screenshot](https://i.imgur.com/DVz2fNa.png)

## FEATURES

#### Extreme customization

* DesktopColors Mode - Will change bar colors to match your desktop color.
* DefaultColors Mode - Set it to Dark or Light mode, and awesome will only use the colors you have defined for this option
* Theming - Set sizes, Margins, Paddings, Colors and every aspect of the topbar with a simple config file.

Theming tool will come soon...

#### FocusMode

###### With window maximized:

* TitleBarBlend Option - Bar background will assume the same color as the maximized window titlebar color.
* DefaultColors Option - Bar background will assume the colors defined by the user.

With window NOT maximized:

* DesktopColors Mode - Bar text and icons will assume the apropriate color theme (dark/light) based on the background colors.
* DefaultColors Mode - Bar will assume only assume the colors define by the user.

FocusMode can also be disabled, making the bar background never change.

#### Out of your way.

* Fixed Mode - Reserves a space on the top of your screen for the bar, hides when fullscreen.
* AutoHide Mode - No space reserved, bar will hide itself after a couple of seconds, hover your cursor on the top of the screen to show it again.

#### Media and Volume Control

Awesome supports WebNowPlaying and NowPlaying Plugins for rainmeter, making it capable of showing almost all modern websites and music players status.

#### Less actions, more productivity.

You never need to click on anything to get the information you need.
Simply hover your cursor on icons to display their widget, click to toggle and scroll to increase/decrease, simple as that 🤗

#### Optimized as possible.

I took care of measuring skin CPU usage during the entire development, every part of the skin only updates when needed making it Gaming friendly (yes, i have a bad pc 😅)

#### User variables, update without fear.

Awesome variables can be backed up to your personal folder, making updates free from override problems.

#### Modules

* Volume - Controls system volume and output.
* Brightness - You know what it does.
* Weather
* Download indicator - When a download is in progress the download indicator will be shown up, hovering shows your download speed.
* Desktop Management - Scroll between your workspaces(virtual desktops) or just check them all :)
* Clock - What would we do without one of these?
* Media Player and control - When a compatible player is detected, the media module will be displayer, media controls are also displayed when a music/video is currently playing
* Menu bar -  Quickly~~~~ change your current window.

### Pre-requisites

Rainmeter 4.1 +
Image Magick.
WebNowPlaying plugin (Opera?, Firefox, Chrome, Edge ...) - Only needed if you want to control the browser media.
~~A Dock or app launcher.~~
A brain.

## Download

Releases are going to be available when the suit comes to stable release. But you can always clone this repostitory and test/contribute to the project.

## Some Credits <3

* Jon Seppanen for inc_lib - AHK Utils for rainmeter.
* Khanhas for Polybar project - Image Magick for Rainmeter creation.
* Cariboudjan#6360 For DropTop Project - Utils and snippets from DropTop <3

## BUGS:

* ~~FocusMode (Changing bar background when maximizing windows) doesn't work if the bar is set to autohide and the windows taskbar is also set to auto-hideApparently, windows doesn't report a window as maximized (GDIP.dll) when theres no APPBar limiting the window, this can be fixed by using a dock that reserves space, or, using the fixed mode.~~

Currently none, if you find one open an issue.
