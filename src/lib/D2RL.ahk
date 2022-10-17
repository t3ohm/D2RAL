#Include, lib\handle.ahk
#Include, lib\CredentialManager.ahk
class D2RL extends CredentialManager {
    static defaulttitle:="Diablo II: Resurrected"
    static workingdir:="C:\Program Files (x86)\Diablo II Resurrected\"
    static exe:="D2R.exe"
    static URL:=".actual.battle.net"
    static region:="us"
    static Frame := "D2R-"
    static SendSpace:=true
    __New(profilename="",ProfileUsername="",password="",location=""){
        this:=this.profile(profilename).Location(location)
        profileExist:=false
        for i,o in this.Profiles()
            if (o == profilename)
                if profile:=this.Get(this.frame profilename)
                    ((profile.usr == ((ProfileUsername != "")?ProfileUsername:profile.usr))?up:=false:up:=true) , ((profile.passwd == ((password != "")?password:profile.passwd))?pu:=false:pu:=true) , profileExist:=true, break

        if ((a:=!profileExist) or (b:=up) or (c:=pu))
            if this.AddProfile(profilename,ProfileUsername,Password)
                this.output("Credential Succeded")

        this.output(A_ThisFunc ":" this.profilename " " this.status:=((a?"added":b or c?"Updated":"Exist")))
        return this
    }
    Title(){
        if (this.profilename)
            WinSetTitle,  % "ahk_id " this.hwnd,, % this.Frame this.profilename
    }
    Start(profilename=""){
        if (profilename !="")
            this.profilename:=profilename
        this.output(A_ThisFunc ":" this.Frame this.profilename)
        if keys:=this.Get(this.Frame this.profilename)
            if !keys.passwd
                MsgBox, no password
        if keys.usr and keys.passwd and this.region
            logindata:=this.LoginData(keys.usr,keys.passwd,keys.region)
        keys:=False
        this.cmdoptions:=" -direct -txt"
        this.target:=this.workingdir this.exe cmdoptions
        if WinExist(this.profilename)
            exit
        this.hwnd:=False
        this.wPID:=False
        if this.hwnd:=this.RunD2R(logindata)
        this.Spacer()
        MsgBox, 1, , "ok to continue, cancle to abort"
        IfMsgBox, Cancel
            exit
        
        return this
    }
    Move(){
        WinMove, "ahk_id " this.hwnd, ,,, 1280, 720
    }
    RunD2R(logindata=False){
        this.output("starting..."(target:=(this.target?this.target:this.workingdir this.exe)))
        CloseD2RHandle()
        Run, % target (this.debug?"":(logindata?logindata:"")) , % this.workingdir,,wPID
        logindata:=False
        sleep, 3
        while !this.hwnd:=WinExist((this.wPID:=wPID)){
            if (this.hwnd:= WinExist(this.defaulttitle)){
                ;this.SendSpace:=False
                break
            }
            sleep, 10
        }
        this.Move()
        this.Title()
        CloseD2RHandle()
        return this.hwnd
    }
    LoginData(U,P,region=False){
        return ((U!="" and P!="")?" -Username " U " -password " P " -address " (region?region:this.region)  this.URL:"")
    }
    Spacer(){
        if (this.SendSpace){
            loops:=0
            loop, 10
            {   
                if !WinExist(win:=("ahk_id " this.hwnd))
                    break
                ControlSend,, {space}, % win
                (A_Index=1?this.output("sent space to window " this.profilename):"")
                sleep, 1000
            }
        }
    }
    AddProfile(name,ProfileUsername,Password,region=""){
        return CredentialManager.AddGeneric(this.Frame name,ProfileUsername,Password)
    }
    RemoveProfile(profilename){
        return this.Delete(this.Frame profilename)
    }
    profile(name=""){
        if name
            this.profilename:=name
        return this
    }
    login(ProfileUsername,password){
        if ProfileUsername
            this.ProfileUsername:=ProfileUsername
        if password
            this.password:=password
        return this
    }
    Location(location){
        if location
            this.region:=location
        return this
    }
    Profiles(){
        profiles:=[]
        loop,parse, % this.List(), `n, `r
            if RegExMatch(A_LoopField, "D2R[-].*" , lprofile)
                if uprofile:=RegExReplace(lprofile, "D2R[-](.*)$" , "$1")
                    profiles.push(uprofile)
        return profiles
    }
}