
handleout(Target="null.exe", Size:=""){
    ;MsgBox, % Target
    DetectHiddenWindows, On
    Run, %  (pComSpec := A_ComSpec ? A_ComSpec : ComSpec),, Hide, pid
    WinWait, % "ahk_pid " pid
    DllCall("kernel32\AttachConsole", "UInt",pid)00
    shell := ComObjCreate("WScript.Shell")
    try
    {
        Exec := shell.Exec(Target)
        StdOut := ""
        if !(Size = "")
            VarSetCapacity(StdOut, Size)
        while !Exec.StdOut.AtEndOfStream
            StdOut := Exec.StdOut.ReadAll()
        DllCall("kernel32\FreeConsole")
        Process, Close, % pid
        shell:=
        return StdOut
    } 
    catch
    {
        return "Command not found"
    }
    
}
HandlePrep(){
    Critical
    static KnownPath
    if KnownPath ~="handle"
        return KnownPath
    if !(((handleout((handleexe:="handle" utils.GetArch() ".exe") " -h") != (CNF:="Command not found"))?(handlepath:=handleexe):(handleout(tp:=A_ScriptDir "\" (handledir:="Handle") "\" handleexe " -h") != CNF )?(handlepath:=tp):(handlepath:=false)))
    {
        UrlDownloadToFile, https://download.sysinternals.com/files/Handle.zip , % file:="Handle.zip"
        utils.Extract2Folder(file,handledir)
        if FileExist(handledir "\Eula.txt" )
        {
            MsgBox, [ Options, Title, Text, Timeout]
            FileMove, % handledir "\Eula.txt", % handledir "\handle-Eula.txt", 1
            handleout(tp " -accepteula") 
            return path:=tp
        }
    } else {
        return KnownPath:=handlepath
    }
}
GetHandle(exe){
    if !(InStr((exist:=handleout(HandlePrep() " -nobanner -a -p " exe " Instances")), ("No matching")))
        return exist
}
closeHandle(pid,handle){
    if (A_IsAdmin){
        return handleout(HandlePrep() " -nobanner -p " . pid . " -c " . handle . " -y")

    } else {
        RunWait, % "*RunAs " HandlePrep() " -nobanner -p " pid " -c " handle " -y", hide, OutputVarPID
        ToolTip, try running as admin if you see this for too long
        while WinExist("ahk_pid " OutputVarPID )
            sleep, 10        
        ToolTip,
        return true
    }
}

CloseD2RHandle(){
    if (pidhandle:=GetHandle("D2R.exe")) 
        closeHandle( RegExReplace(pidhandle, "s).*pid: (\d*)\s*.*", "$1") 
        , RegExReplace(pidhandle, "s).*(...): \\Sessions\\\d*\\BaseNamedObjects\\DiabloII.*", "$1") )
}
isdxdiag(){
    return WinExist("ahk_exe dxdiag.exe")
}
   