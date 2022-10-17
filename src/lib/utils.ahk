class utils {
    output(out="",newline:=1,log=True){
        OutputDebug, % output:=(out (newline?"`n":"") )
        If (log)
            FileAppend, % output, log.txt
        return out
    }

    msg(text="",time=0){
        msgbox,,, % text, % time
    }

    Extract2Folder(Zip, Dest="", Filename=""){
        /*
            Zip (required)
                If no path is specified then Zip is assumed to be in the Script Folder
            Dest (optional)
                Name of folder to extract to
                If not specified, a folder based on the Zip name is created in the Script Folder
                If a full path is not specified, then the specified folder is created in the Script Folder
            Filename (optional)
                Name of file to extract
                If not specified, the entire contents of Zip are extracted
                Only works for files in the root folder of Zip
                Wildcards not allowed
        */
        SplitPath, Zip,, SourceFolder
        if ! SourceFolder
            Zip := A_ScriptDir . "\" . Zip
        
        if ! Dest {
            SplitPath, Zip,, DestFolder,, Dest
            Dest := DestFolder . "\" . Dest . "\"
        }
        if SubStr(Dest, 0, 1) <> "\"
            Dest .= "\"
        SplitPath, Dest,,,,,DestDrive
        if ! DestDrive
            Dest := A_ScriptDir . "\" . Dest
        
        fso := ComObjCreate("Scripting.FileSystemObject")
        If Not fso.FolderExists(Dest)  ;http://www.autohotkey.com/forum/viewtopic.php?p=402574
        fso.CreateFolder(Dest)
        
        AppObj := ComObjCreate("Shell.Application")
        FolderObj := AppObj.Namespace(Zip)
        if Filename {
            FileObj := FolderObj.ParseName(Filename)
            AppObj.Namespace(Dest).CopyHere(FileObj, 4|16)
        }
        else
        {
            FolderItemsObj := FolderObj.Items()
            AppObj.Namespace(Dest).CopyHere(FolderItemsObj, 4|16)
        }
    }

    GetArch(){
        for sysinfo in ComObjGet("winmgmts:\\.\root\cimv2").ExecQuery("SELECT OSArchitecture FROM Win32_OperatingSystem")
            return sysinfo.OSArchitecture="64-bit"?"64":""
    }
    stdout(Target="null.exe", Size:=""){
        ;MsgBox, % Target
        DetectHiddenWindows, On
        pComSpec := A_ComSpec ? A_ComSpec : ComSpec
        Run, % pComSpec,, Hide, pid
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
    
    
    PIDbyExe(exe){
        process, exist, % exe
        return ErrorLevel
    }
    closeExe(exe){
        process, close, % exe
        return ErrorLevel
    }
    HandlePrep(){
        static path
        if path ~="handle"
            return path
        if !(((this.stdout((handleexe:="handle" utils.GetArch() ".exe") " -h") != (CNF:="Command not found"))?(handlepath:=handleexe):(this.stdout(tp:=A_ScriptDir "\" (handledir:="Handle") "\" handleexe " -h") != CNF )?(handlepath:=tp):(handlepath:=false)))
        {
            UrlDownloadToFile, https://download.sysinternals.com/files/Handle.zip , % file:="Handle.zip"
            utils.Extract2Folder(file,handledir)
            if FileExist(handledir "\Eula.txt" )
            {
                FileMove, % handledir "\Eula.txt", % handledir "\handle-Eula.txt", 1
                this.stdout(tp " -accepteula") 
                return path:=tp
            }
        } else {
            return path:=handlepath
        }
    }

    readSettings(baseSettingsFile="", settingsFile="") {
    if (baseSettingsFile != "")
    {
        ; these are the default values
        settings := []

        ; read from the ini file and overwrite any of the above values
        IniRead, sectionNames, %baseSettingsFile%
        Loop, Parse, sectionNames , `n
        {
            thisSection := A_LoopField
            if (thisSection == "Settings") {
                IniRead, OutputVarSection, %baseSettingsFile%, %thisSection%
                Loop, Parse, OutputVarSection , `n
                {
                    valArr := StrSplit(A_LoopField,"=")
                    valArr[1]
                    if (valArr[2] == "true") {
                        valArr[2] := true
                    }
                    if (valArr[2] == "false") {
                        valArr[2] := false
                    }
                    settings[valArr[1]] := valArr[2]
                }
            }
        }
    }
    if (settingsFile != "")
    {
        ; read from the ini file and overwrite any of the above values
        IniRead, sectionNames, %settingsFile%
        Loop, Parse, sectionNames , `n
        {
            thisSection := A_LoopField
            IniRead, OutputVarSection, %settingsFile%, %thisSection%
            Loop, Parse, OutputVarSection , `n
            {
                valArr := StrSplit(A_LoopField,"=")
                valArr[1]
                if (valArr[2] == "true") {
                    valArr[2] := true
                }
                if (valArr[2] == "false") {
                    valArr[2] := false
                }
                settings[valArr[1]] := valArr[2]
            }
        }
    }
    return settings
}
    /*
        HandlePrep(){
            static path
            if path ~="handle"
                return path
            if !(((this.stdout((handleexe:="handle" this.GetArch() ".exe") " -h") != (CNF:="Command not found"))?(handlepath:=handleexe):(this.stdout(tp:=A_ScriptDir "\" (handledir:="Handle") "\" handleexe " -h") != CNF )?(handlepath:=tp):(handlepath:=false)))
            {
                UrlDownloadToFile, https://download.sysinternals.com/files/Handle.zip , % file:="Handle.zip"
                this.Extract2Folder(file,handledir)
                if FileExist(handledir "\Eula.txt" )
                {
                    FileMove, % handledir "\Eula.txt", % handledir "\handle-Eula.txt", 1
                    this.stdout(tp " -accepteula") 
                    return path:=tp
                }
            } else {
                return path:=handlepath
            }
        }
        closeHandle(name){
            pid := 0
            handle := this.getHandle(pid,name)
            if (handle.handle = "")
                return 1 ; handle not found
            return this.stdout(this.HandlePrep() " -nobanner -p " . handle.pid . " -c " . handle.handle . " -y")
        }    
        getHandle(ByRef pid,name) {
            ;msgbox, % commandexe:=A_ScriptDir . "config\libs\handle\handle" this.GetArch() ".exe"
            command := this.HandlePrep() " -nobanner -a -p " . name . " Instances"
            stdout := this.stdout(command)
            needle := "No matching" ;when Handle found nothing return in standard output "No matching handles found."
            IfInString, stdout, %needle%
                {
                return ""
                }	
            handle := RegExReplace(stdout, "s).*(...): \\Sessions\\\d*\\BaseNamedObjects\\DiabloII.*", "$1")
            IsFunc(utils.output(handle))
            pid := RegExReplace(stdout, "s).*pid: (\d*)\s*.*", "$1")
            ;MsgBox,,, % stdout . "`nhandle:" . handle . "`npid:" . pid
            info:= {"handle": handle, "pid": pid}
            Return info
        } 
    */  
    
}
