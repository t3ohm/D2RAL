#SingleInstance Force
SetWorkingDir %A_ScriptDir%
SetBatchLines -1
#Include, lib\D2RL.ahk
#Include, lib\UI.ahk
;UI.debug:=true
UI.show()
^F3::Reload
^F4::UI.show()

