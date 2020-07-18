Dim Arg, var1
Set Arg = WScript.Arguments

var1 = Arg(0)

Set oShell = CreateObject ("Wscript.Shell") 
Dim strArgs
strArgs = "cmd /c " _
       & var1 & ".bat"
oShell.Run strArgs, 0, false

set Arg = Nothing