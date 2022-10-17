#Include, lib\utils.ahk
class CredentialManager extends utils {
    List(target=""){
        command:="cmdkey /List:" target
        return this.stdOut(command)
    }
    AddGeneric(targetName,ProfileUsername,Password){
        ;MsgBox, % targetName "`n" ProfileUsername "`n" Password
        if (targetName=""){
            InputBox, targetName, % A_ThisFunc, Enter Target Name,, %Width%, %Height%, %X%, %Y%
        }
        if (ProfileUsername=""){
            InputBox, ProfileUsername,  % A_ThisFunc, Enter ProfileUsername,, %Width%, %Height%, %X%, %Y%
        }
        if (Password=""){
            InputBox, Password,, % "Enter Password for " ProfileUsername, HIDE, %Width%, %Height%, %X%, %Y%
        }
        command:="cmdkey /generic:" targetName " /user:" ProfileUsername " /pass:" Password
        try
        {
            result:=this.stdOut(command)
        }
        ;MsgBox, % result
        if result ~=successfully
            return result
        else
            return 0
        
    }
    Delete(targetName){
        if (targetName=""){
            InputBox, targetName, % A_ThisFunc, Enter Target Name To Delete,, %Width%, %Height%, %X%, %Y%
        }
        if this.stdOut("cmdkey /Delete:" targetName) ~=successfully
            return 1
        else
            return 0
    }
    Get(targetName) {
        ; DllCall is used to invoke the CredRead API, defined in WinCred.h:
            ;
            ; BOOL CredReadW(
                ;   In  LPCWSTR         TargetName 
                ;,  In  DWORD           Type 
                ;,  In  DWORD           Flags 
                ;,  Out PCREDENTIAL     *Credential);
            ;
            ; VOID CredFree(
            ;   _In_ PVOID Buffer
            ; );
            ;
            ; typedef struct _CREDENTIALW {
            ;  0	   DWORD		            Flags;
            ;  4	   DWORD				    Type;
            ;  8	   LPWSTR				    TargetName;
            ;  8 + 1*p LPWSTR				    Comment;
            ;  8 + 2*p FILETIME			        LastWritten; { 8+2p DWORD dwLowDateTime; 12+2p DWORD dwHighDateTime; }
            ; 16 + 2*p DWORD				    CredentialBlobSize;
            ;(20 + 2*p DWORD padding on 64-bit)
            ; 16 + 3*p LPBYTE				    CredentialBlob;
            ; 16 + 4*p DWORD				    Persist;
            ; 20 + 4*p DWORD				    AttributeCount;
            ; 24 + 4*p PCREDENTIAL_ATTRIBUTE    Attributes;
            ; 24 + 5*p LPWSTR				    TargetAlias;
            ; 24 + 6*p LPWSTR				    ProfileUsername;
            ; } CREDENTIAL, *PCREDENTIAL;
            ;
            ; #define CRED_TYPE_GENERIC			   1
        ;#Include, <cmd>
        pCred := 0
        ret := DllCall( "ADVAPI32\CredReadW", "WStr", targetName, "UInt", 1, "UInt", 0, "Ptr*", pCred, "Int" )
        if ( 0 != ErrorLevel ) {
            IsFunc(this.output(A_LineNumber "`nDllCall error invoking CredReadW: " . ErrorLevel))
            return
        }
        if ( 1 != ret ) {
            IsFunc(this.output(A_LineNumber "`nError from CredRead: " . A_LastError))
            
            return
        }
        credentialBlobSizeOffset := 16 + 2*A_PtrSize
        uCredentialBlobOffset	:= 24 + 6*A_PtrSize
        pCredentialBlobOffset	:= 16 + 3*A_PtrSize

        credentialBlobSize := NumGet( pCred + credentialBlobSizeOffset, "UInt" )
        uCredentialBlob	:= NumGet( pCred + uCredentialBlobOffset,	"Ptr" )
        pCredentialBlob	:= NumGet( pCred + pCredentialBlobOffset,	"Ptr" )

        ProfileUsername := StrGet( uCredentialBlob,, "UTF-16" )
        password := StrGet( pCredentialBlob, credentialBlobSize / 2, "UTF-16" )

        DllCall( "ADVAPI32\CredFree", "Ptr", pCred )
        if ( ErrorLevel != 0  ) {
            IsFunc(this.output(A_LineNumber "`nDllCall error invoking CredFree: " . ErrorLevel))
            return
        }
        return {"usr": ProfileUsername, "passwd": password}
    }
} 