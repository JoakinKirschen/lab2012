set args = WScript.Arguments

Vrs = (Wscript.Arguments.Item(0))
ExePath = (Replace(Wscript.Arguments.Item(1),"\\","\"))

set WshShell = WScript.CreateObject("WScript.Shell")
strDesktop = WshShell.SpecialFolders("Desktop")
set oShellLink = WshShell.CreateShortcut(strDesktop & "\L12_" & Vrs & ".lnk")
oShellLink.TargetPath = ExePath
oShellLink.Arguments="/p LAB2012_1 /t acadiso /nologo"
oShellLink.WindowStyle = 1
oShellLink.IconLocation = ExePath
oShellLink.Description = "Shortcut Script"
oShellLink.WorkingDirectory = strDesktop
oShellLink.Save