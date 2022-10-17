
class UI {
    static debug :=False
    __New(){

    }

    create(){
        
        global
        settings:=utils.readSettings("settings.ini")
        Gui D2RL: New, +LabelG_D2RL +hWndH_D2RL  -MaximizeBox +OwnDialogs -0x10000 -0x30000 -Resize
        Gui, D2RL:Default
        ;DllCall("UxTheme.dll\SetWindowTheme", "Ptr", hLVItems, "WStr", "Explorer", "Ptr", 0)
        local (buttonD:=30),(listviewW:=300), (perwidth:=(listviewW/buttonD), (extraW:=((listviewW-((bttns:=6)*buttonD))/bttns)-(perwidth-bttns)))
        Gui D2RL:Add, Picture, % "hWndhPlay vVarPlay gGPlay x" 10 " ym w" buttonD " h" buttonD " +BackgroundTrans +AltSubmit +0x400000", C:\Users\tthreeoh\Desktop\D2Rlauncher\Ass\play.png
        Gui D2RL:Add, Picture, % "hWndhStop vVarStop gGStop x+" extraW " ym w" buttonD " h" buttonD " +BackgroundTrans +AltSubmit +0x400000", C:\Users\tthreeoh\Desktop\D2Rlauncher\Ass\stop.png
        Gui D2RL:Add, Picture, % "hWndhAdd vVarAdd gGAdd x+" extraW " ym w" buttonD " h" buttonD " +BackgroundTrans +AltSubmit +0x400000", C:\Users\tthreeoh\Desktop\D2Rlauncher\Ass\add.png
        Gui D2RL:Add, Picture, % "hWndhMinus vVarMinus gGMinus x+" extraW " ym w" buttonD " h" buttonD " +BackgroundTrans +AltSubmit +0x400000", C:\Users\tthreeoh\Desktop\D2Rlauncher\Ass\minus.png
        Gui D2RL:Add, Picture, % "hWndhSettings vVarSettings gGSettings x+" extraW " ym w" buttonD " h" buttonD " +BackgroundTrans +AltSubmit +0x400000", C:\Users\tthreeoh\Desktop\D2Rlauncher\Ass\settings.png
        Gui D2RL:Add, Picture, % "hWndhMenu vVarMenu gGMenu x+" extraW " ym w" buttonD " h" buttonD " +BackgroundTrans +AltSubmit +0x400000", C:\Users\tthreeoh\Desktop\D2Rlauncher\Ass\menu.png
        local lvcols:="Profile|Username|Satus"
        local tGH:=this.GuiHeight()
        Gui D2RL:Add, ListView, % "-Multi Backgroundtrans hWndhLVItems vLVItems gGLVItems x8 y+ w" listviewW " h" tGH.lvH " +AltSubmit +Checked +Grid +LV0x4000 +LV0x10000 +0x200 +LV0x840 +C0xFFFFFF -0x10000 -0x30000 +0x800 +0x900 +E0x20 +LV0x200000 +LV0x400000", % lvcols
        Gui D2RL:Color, 0x808080 
        Gui, D2RL:+LastFound
        this.Guihwnd:=WinExist()
        ;WinSet, Transparent, EEAA99 150
        this.CreateListView()
    }
    show(){
        global
        local static shown
        static MainShow
        if !(shown){
            UI.systeminit()
            this.create()  
            shown:=true
        }
        if (this.MainShow:=(MainShow:=!MainShow)){
            Gui D2RL:Show, % "h" (this.GuiHeight()).guiH , D2RLauncher
        } else {
            Gui D2RL:Hide
        }
    }
    GuiHeight(){
        local guiH:=(lvH:=((rowheight:=20)*(profilecount:=D2RL.Profiles().Count()))+(lvY:=48))+60
        return {"lvY":lvY,"lvH":lvH,"guiH":guiH}
    }
    systeminit(){
        Critical
        Menu, Tray, NoDefault
        Menu Tray, Icon, shell32.dll, 22
        Menu, Tray, Add , UI, UISHOW
        if isFunc("ClipChanged")
            OnClipboardChange("ClipChanged")
        if isFunc("OnWM_MOUSEMOVE")
            OnMessage(0x200, "OnWM_MOUSEMOVE")
        if isFunc("OnWM_KEYDOWN")
            OnMessage(0x100, "OnWM_KEYDOWN")
        if isFunc("OnWM_KEYUP")
            OnMessage(0x101, "OnWM_KEYUP")
        if isFunc("OnWM_LBUTTONDOWN")
            OnMessage(0x201, "OnWM_LBUTTONDOWN")
        if isFunc("OnWM_LBUTTONUP")
            OnMessage(0x202, "OnWM_LBUTTONUP")
        if isFunc("OnWM_LBUTTONDBLCLK")
            OnMessage(0x203, "OnWM_LBUTTONDBLCLK")
        if isFunc("OnWM_RBUTTONDOWN")
            OnMessage(0x204, "OnWM_RBUTTONDOWN")
        if isFunc("OnWM_MBUTTONDOWN")
            OnMessage(0x207, "OnWM_MBUTTONDOWN")
        if isFunc("OnWM_MOVE")
            OnMessage(0x3, "OnWM_MOVE")
        if isFunc("OnWM_EXITSIZEMOVE")
            OnMessage(0x232, "OnWM_EXITSIZEMOVE")
        if isFunc("OnWM_MOUSELEAVE")
            OnMessage(0x2A3, "OnWM_MOUSELEAVE")
        if isFunc("OnWM_COMMAND")
            OnMessage(0x111, "OnWM_COMMAND")
        if isFunc("OnWM_NOTIFY")
            OnMessage(0x4E, "OnWM_NOTIFY")
        if isFunc("OnWM_PAINT")
            OnMessage(0xF, "OnWM_PAINT")
        if isFunc("OnWM_COPYDATA")
            OnMessage(0x4A, "OnWM_COPYDATA")
        if isFunc("OnWM_SETCURSOR")
            OnMessage(0x20, "OnWM_SETCURSOR")
        if isFunc("OnWM_ENTERMENULOOP")
            OnMessage(0x211, "OnWM_ENTERMENULOOP")
        if isFunc("OnWM_INITMENU")
            OnMessage(0x116, "OnWM_INITMENU")
        if isFunc("OnWM_ENDSESSION")
            OnMessage(0x16, "OnWM_ENDSESSION")
    }
    random(Min=0,Max=1){
        Random, rand , % Min, % Max
        return rand

    }
    findRow(value,col){
        global 
        Gui, D2RL:Default
        Gui, ListView, % hLVItems
        for row,_ in D2RL.Profiles()
        {
            if (this.LVgeText(row,1) == value)
                return row
        }
        
    }
    UpdateStatus(){
        D2RL.output(A_thisfunc,,False)
        Gui, D2RL:Default
        Gui, ListView, % hLVItems
        for i,o in D2RL.Profiles()
        {
            if luser:=(D2RL.Get(D2RL.Frame o)).usr
            {   
                if (this.LVgeText(i,3) != (StatT:=(iA:=WinExist(D2RL.Frame o)?"Active":"Not Active"))){
                    LV_Modify(i,,,,StatT)
                    D2RL.output( A_thisfunc ":`tProfile:" o " = " StatT "`n")

                }
            }
        }
        
    }
    CreateListView(){
        Critical
        LV_Delete()
        
        for i,o in D2RL.Profiles()
        {
        
            if luser:=(D2RL.Get(D2RL.Frame o)).usr
            {
                LV_Add("", o, luser, (iA:=WinExist(D2RL.Frame o)?"Active":"Not Active"))
            }
        }
        LV_ModifyCol(1,100)
        LV_ModifyCol(2,100)
        bindmeth:=objbindmethod(this,"UpdateStatus")
        SetTimer, %bindmeth% , 1000
    }
    ProfileAdd(){
        ProfileADDShow()
        UI.Show()
    }
    ProfileAddConfirmed(ProfileName2ADD,UsernameAdd,PasswordADD,AddprofileDrop){
        if !(UI.debug){
            D2RL.AddProfile(ProfileName2ADD,UsernameAdd,PasswordADD,AddprofileDrop)
            reload
        }
    }
    animate(cntrl,sleeptime=50,loops:=0,list=""){
        loop, % loops
            for each,type in ((list == "")?(list:=[((base:=A_ScriptDir "\Ass\") cntrl "-pressed.png"),(base cntrl ".png")]):list)
            {
                GuiControl,, % "Var" cntrl , % type
                sleep,  % sleeptime
            }
    }
    LVgeText(RowNumber,ColumnNumber:=1){
        LV_GetText(out, RowNumber,ColumnNumber)
        return out
    }
    funcCtrlEventInfoLevel(func="",CtrlHwnd="", GuiEvent="", EventInfo="", ErrLeve = ""){
        Gui, D2RL:Default
        Gui, ListView, % hLVItems
        ;if !(UI.debug)       
        switch (func) 
        {
            case "GLVItems" :{
            }
            case "GStop":{
                loop, % D2RL.Profiles().Count()
                {   
                    if this.SelectedRow()
                    if (this.LVgeText(A_Index,3) ~= "Active"){
                        if !(UI.debug)
                            WinClose, % "ahk_id " WinExist(D2RL.Frame this.LVgeText(A_Index))
                        LV_Modify(this.SelectedRow(), "-Select")
                    }

                }
            }
            case "GPlay":{
                if (RowNumber := this.CheckedRow()){
                    D2RL.output( "`n")
                    RowNumber := 0  ; This causes the first loop iteration to start the search at the top of the list.
                    Loop, % D2RL.Profiles().Count()
                    {
                        RowNumber := this.CheckedRow(RowNumber)  ; Resume the search at the row after that found by the previous iteration.
                        if not RowNumber  ; The above returned zero, so there are no more selected rows.
                            break
                        profile:=this.LVgeText(RowNumber)
                        D2RL.Start(profile)
                        LV_Modify(RowNumber, "-Check")
                    }

                } else if (selected:=this.SelectedRow()){
                    profile:=this.LVgeText(selected)
                    D2RL.Start(profile)
                    LV_Modify(selected, "-Select")
                } 


            }
            case "GAdd":{
                UI.ProfileAdd()
            }
            case "GMinus":{
                if (selected:=this.SelectedRow())
                {
                    MsgBox, 0x40134, WARNING, % "Confirm Removal`nProfile: " Rprofile:=this.LVgeText(selected)
                    IfMsgBox, YES
                    {   
                        if !(UI.debug)
                            D2RL.RemoveProfile(Rprofile)
                        MsgBox, 0x40040, Profile Removed ,% "Profile: " Rprofile " REMOVED"
                        if !(UI.debug)
                            reload
                    }
                }
            }
            case "GSettings":{
                if !(UI.debug)
                    reload
            }
            case "GMenu":{
            }
            Default:{
                D2RL.output( "`n" (A_ThisFunc ":" func ": CtrlHwnd:" CtrlHwnd " GuiEvent:" GuiEvent " EventInfo:" EventInfo " ErrLevel:" ErrLevel))
                D2RL.output( "`nselected row:" this.SelectedRow())
            }
        }
    }
    StripG(func){
        return RegExReplace(func, "^G(.*)","$1")
    }
    CheckedRow(RowNumber:=0){
            RowNumber := LV_GetNext(RowNumber,"C")  ; Resume the search at the row after that found by the previous iteration.
            if not RowNumber  ; The above returned zero, so there are no more selected rows.
                return
            return RowNumber
    }
    SelectedRow(){
        return LV_GetNext()
    }

}
;   
    UPDATE(){
        UI.UpdateStatus()
    }
    UISHOW(){
        UI.Show()
    }
    GLVItems(CtrlHwnd="", GuiEvent="", EventInfo="", ErrLeve = "") {
        UI.funcCtrlEventInfoLevel(A_ThisFunc,CtrlHwnd, GuiEvent, EventInfo, ErrLevel)

    }

    GStop(CtrlHwnd="", GuiEvent="", EventInfo="", ErrLeve = "") {
        
        UI.animate(UI.StripG(A_ThisFunc),100,1)
        UI.funcCtrlEventInfoLevel(A_ThisFunc,CtrlHwnd, GuiEvent, EventInfo, ErrLevel)
    }

    GPlay(CtrlHwnd="", GuiEvent="", EventInfo="", ErrLeve = "") {
        
        UI.animate(UI.StripG(A_ThisFunc),100,1)
        UI.funcCtrlEventInfoLevel(A_ThisFunc,CtrlHwnd, GuiEvent, EventInfo, ErrLevel)
    }   

    GAdd(CtrlHwnd="", GuiEvent="", EventInfo="", ErrLeve = "") {

        UI.animate(UI.StripG(A_ThisFunc),100,1)
        UI.funcCtrlEventInfoLevel(A_ThisFunc,CtrlHwnd, GuiEvent, EventInfo, ErrLevel)
        
    }

    GMinus(CtrlHwnd="", GuiEvent="", EventInfo="", ErrLeve = "") {

        UI.animate(UI.StripG(A_ThisFunc),100,1)
        UI.funcCtrlEventInfoLevel(A_ThisFunc,CtrlHwnd, GuiEvent, EventInfo, ErrLevel)
    }

    GSettings(CtrlHwnd="", GuiEvent="", EventInfo="", ErrLeve = "") {
        UI.animate(UI.StripG(A_ThisFunc),25,3)
        UI.Show()
        D2RL.output("A_ThisFunc:" A_ThisFunc "`nCtrlHwnd:" CtrlHwnd "`nGuiEvent:" GuiEvent "`nEventInfo:" EventInfo "`nErrLevel:" ErrLevel)
        UI.funcCtrlEventInfoLevel(A_ThisFunc,CtrlHwnd, GuiEvent, EventInfo, ErrLevel)
    }

    GMenu(CtrlHwnd="", GuiEvent="", EventInfo="", ErrLeve = "") {
        list:=[((base:=A_ScriptDir "\Ass\" UI.StripG(A_ThisFunc)) "-pressed-45.png")
        ,(base "-pressed-90.png")
        ,(base "-pressed-135.png")
        ,(base ".png")]
        UI.animate(UI.StripG(A_ThisFunc),25,1,list)
        UI.funcCtrlEventInfoLevel(A_ThisFunc,CtrlHwnd, GuiEvent, EventInfo, ErrLevel)
    }

    

    G_D2RLContextMenu(GuiHwnd, CtrlHwnd, EventInfo, IsRightClick, X, Y) {
        D2RL.output( "`n" (A_ThisFunc ": GuiHwnd:" GuiHwnd " CtrlHwnd:" CtrlHwnd " EventInfo:" EventInfo " IsRightClick:" IsRightClick " X:" X " Y:" Y ))
    }

    G_D2RLDropFiles(GuiHwnd, FileArray, CtrlHwnd, X, Y) {
        D2RL.output( "`n" (A_ThisFunc ": GuiHwnd:" GuiHwnd " FileArray:" FileArray.Count() " CtrlHwnd:" CtrlHwnd " X:" X " Y:" Y) "`n")
        if FileArray.Count()
            for each, file in FileArray
                switch (FileExist(file)){
                    Case "D":{
                        D2RL.output( each ":`t" file " is a Directory`n")
                        loop, % file "\*" ,1, R 
                        {
                             D2RL.output( A_Index ":`t" A_LoopFileFullPath  "`n")
                        }
                            
                    }
                    Case "A":{
                        D2RL.output( "`tFile" each ":`t" file " is an Archive`n")
                    }
                    Case "C":{
                        D2RL.output( each ":`t" file " is a COMPRESSED`n")
                    }
                    Case "R":{
                        D2RL.output( each ":`t" file " is a Directory`n")
                    }
                    Default:{
                        D2RL.output( each ":`t" file "`n")
                    }
                }

    }

    G_D2RLEscape(GuiHwnd) {
        D2RL.output( "`n" (A_ThisFunc ": GuiHwnd:" GuiHwnd ))
        ExitApp
    }

    G_D2RLClose(GuiHwnd) {
        D2RL.output( "`n" (A_ThisFunc ": GuiHwnd:" GuiHwnd ))
        UI.show()
    }

/*
    G_D2RLSize(GuiHwnd, EventInfo, Width, Height) {
        D2RL.output( "`n" (A_ThisFunc ": A_EventInfo:" A_EventInfo " GuiHwnd:" GuiHwnd " EventInfo:" EventInfo " Width:" Width " Height:" Height))
        If (A_EventInfo == 1) {
            Return
        }
    }
    ClipChanged(Type) {
        D2RL.output( "`n" (A_ThisFunc ": Type:" Type ))
    }
    OnWM_LBUTTONDBLCLK(wParam, lParam, msg, hWnd) {
        D2RL.output( "`n" (A_ThisFunc ": wParam:" wParam " lParam:" lParam " msg:" msg " hWnd:" hWnd ))
    }
    OnWM_LBUTTONDOWN(wParam, lParam, msg, hWnd) {
        D2RL.output( "`n" (A_ThisFunc ": wParam:" wParam " lParam:" lParam " msg:" msg " hWnd:" hWnd ))
    }
    OnWM_MOUSEMOVE(wParam, lParam, msg, hWnd) {
        D2RL.output( "`n" (A_ThisFunc ": wParam:" wParam " lParam:" lParam " msg:" msg " hWnd:" hWnd ))
    }
    OnWM_KEYDOWN(wParam, lParam, msg, hWnd) {
        D2RL.output( "`n" (A_ThisFunc ": wParam:" wParam " lParam:" lParam " msg:" msg " hWnd:" hWnd ))
    }

    OnWM_KEYUP(wParam, lParam, msg, hWnd) {
        D2RL.output( "`n" (A_ThisFunc ": wParam:" wParam " lParam:" lParam " msg:" msg " hWnd:" hWnd ))
    }

    

    OnWM_LBUTTONUP(wParam, lParam, msg, hWnd) {
        D2RL.output( "`n" (A_ThisFunc ": wParam:" wParam " lParam:" lParam " msg:" msg " hWnd:" hWnd ))
    }


    OnWM_RBUTTONDOWN(wParam, lParam, msg, hWnd) {
        D2RL.output( "`n" (A_ThisFunc ": wParam:" wParam " lParam:" lParam " msg:" msg " hWnd:" hWnd ))
    }

    OnWM_MBUTTONDOWN(wParam, lParam, msg, hWnd) {
        D2RL.output( "`n" (A_ThisFunc ": wParam:" wParam " lParam:" lParam " msg:" msg " hWnd:" hWnd ))
    }

    OnWM_MOVE(wParam, lParam, msg, hWnd) {
        D2RL.output( "`n" (A_ThisFunc ": wParam:" wParam " lParam:" lParam " msg:" msg " hWnd:" hWnd ))
    }

    OnWM_EXITSIZEMOVE(wParam, lParam, msg, hWnd) {
        D2RL.output( "`n" (A_ThisFunc ": wParam:" wParam " lParam:" lParam " msg:" msg " hWnd:" hWnd ))
    }

    OnWM_MOUSELEAVE(wParam, lParam, msg, hWnd) {
        D2RL.output( "`n" (A_ThisFunc ": wParam:" wParam " lParam:" lParam " msg:" msg " hWnd:" hWnd ))
    }

    OnWM_COMMAND(wParam, lParam, msg, hWnd) {
        D2RL.output( "`n" (A_ThisFunc ": wParam:" wParam " lParam:" lParam " msg:" msg " hWnd:" hWnd ))
    }

    OnWM_NOTIFY(wParam, lParam, msg, hWnd) {
        D2RL.output( "`n" (A_ThisFunc ": wParam:" wParam " lParam:" lParam " msg:" msg " hWnd:" hWnd ))
    }

    OnWM_PAINT(wParam, lParam, msg, hWnd) {
        D2RL.output( "`n" (A_ThisFunc ": wParam:" wParam " lParam:" lParam " msg:" msg " hWnd:" hWnd ))
    }

    OnWM_COPYDATA(wParam, lParam, msg, hWnd) {
        D2RL.output( "`n" (A_ThisFunc ": wParam:" wParam " lParam:" lParam " msg:" msg " hWnd:" hWnd ))
    }

    OnWM_SETCURSOR(wParam, lParam, msg, hWnd) {
        D2RL.output( "`n" (A_ThisFunc ": wParam:" wParam " lParam:" lParam " msg:" msg " hWnd:" hWnd ))
    }

    OnWM_ENTERMENULOOP(wParam, lParam, msg, hWnd) {
        D2RL.output( "`n" (A_ThisFunc ": wParam:" wParam " lParam:" lParam " msg:" msg " hWnd:" hWnd ))
    }

    OnWM_INITMENU(wParam, lParam, msg, hWnd) {
        D2RL.output( "`n" (A_ThisFunc ": wParam:" wParam " lParam:" lParam " msg:" msg " hWnd:" hWnd ))
    }

    OnWM_ENDSESSION(wParam, lParam, msg, hWnd) {
        D2RL.output( "`n" (A_ThisFunc ": wParam:" wParam " lParam:" lParam " msg:" msg " hWnd:" hWnd ))
    }
    */
;


AddprofileUI(){
    global
    Gui Profile: +LabelProfileADD +hWndhProfileADD +Resize -MinimizeBox -MaximizeBox
    Gui Profile:Add, Edit, vProfileName2ADD gProfileNameADD hWndPronameADDhwnd  x77 y9 w120 h21 -VScroll,
    Gui Profile:Add, Edit, vUsernameAdd gUsernameAdd x76 y36 w120 h21, Username
    Gui Profile:Add, Edit, vPasswordADD gPasswordADD x76 y62 w120 h21, Password
    Gui Profile:Add, DropDownList,vAddprofileDrop x7 y87 w65, Region||us|eu|kr
    Gui Profile:Add, Text, x9 y8 w65 h23 +0x200 , Profile Name
    Gui Profile:Add, Text, x7 y32 w65 h23 +0x200 , Username
    Gui Profile:Add, Text, x7 y58 w65 h23, Password
    Gui Profile:Add, Button, x102 y88 w80 h23 GAddtoCredMan AltSubmit, &Add

}
AddtoCredMan(){
    global 
    Gui, Profile:Default
    GuiControlGet, ProfileName2ADD
    GuiControlGet, UsernameAdd
    GuiControlGet, PasswordADD
    GuiControlGet, AddprofileDrop
    MsgBox,  1, CONFIRM, % "`tCORRECT?`nProfile Name:`t" ProfileName2ADD "`nUser Name:`t" UsernameAdd "`nPassword:`t" PasswordADD "`nRegion:`t`t" AddprofileDrop
    IfMsgBox, Cancel
        exit
    outputdebug, % " success?" (UI.debug?"Debug is on Cmd won't run":"") UI.ProfileAddConfirmed(ProfileName2ADD,UsernameAdd,PasswordADD,AddprofileDrop)
    ClearAdd()
}

ProfileNameADD(CtrlHwnd, GuiEvent, EventInfo, ErrLevel := "") {
    OutputDebug, % "`nCtrlHwnd:" CtrlHwnd "`nGuiEvent:" GuiEvent "`nEventInfo:" EventInfo "`nErrLevel:" ErrLevel 
}

UsernameAdd(CtrlHwnd, GuiEvent, EventInfo, ErrLevel := "") {
    OutputDebug, % "`nCtrlHwnd:" CtrlHwnd "`nGuiEvent:" GuiEvent "`nEventInfo:" EventInfo "`nErrLevel:" ErrLevel 
}

PasswordADD(CtrlHwnd, GuiEvent, EventInfo, ErrLevel := "") {
    OutputDebug, % "`nCtrlHwnd:" CtrlHwnd "`nGuiEvent:" GuiEvent "`nEventInfo:" EventInfo "`nErrLevel:" ErrLevel 
}


ProfileADDContextMenu(GuiHwnd, CtrlHwnd, EventInfo, IsRightClick, X, Y) {
    OutputDebug, % "`nCtrlHwnd:" CtrlHwnd "`nGuiEvent:" GuiEvent "`nEventInfo:" EventInfo "`nErrLevel:" ErrLevel 
}
ClearAdd(){
    Gui, Profile:Default
    Guicontrol,, ProfileName2ADD, 
    Guicontrol,,UsernameAdd,
    Guicontrol,,PasswordADD,
}
ProfileADDShow(){
    static shown
    global static ProfileADDdisplay
    if !shown
        AddprofileUI()
    ClearAdd()
    if (ProfileADDdisplay:=!ProfileADDdisplay){
        Gui Profile:Show, w219 h120, Profile Info
        Gui Profile:+LastFound
        ControlFocus, Edit1
    } else {
        ClearAdd()
        Gui Profile:hide,
        UI.Show()
    }
    shown:=true
}
ProfileADDEscape(GuiHwnd="") {
    ProfileADDShow()
}

ProfileADDClose(GuiHwnd="") {
    ProfileADDShow()
}