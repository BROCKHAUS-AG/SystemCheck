# Author(s)                      	: Paul Mizel
# Company                               : BROCKHAUS AG
# Year                                  : 2017
# Source                                : https://github.com/BROCKHAUS-AG/SystemCheck
 
 
function BagCheckAcl{
 
    param(
                  [string]$Path="C:\",           
          [string]$Identity="*UserName*",
                  [string]$Value="Allow",
          [string]$FileSystemRights="FullControl",
          [string]$Name="",
                  [bool]$Debug=$false,
              [bool]$Fix=$false)
       
        if(-NOT $Debug) { $ErrorActionPreference = "Stop" }
       
        Try{   
            #$ACL = Get-Acl C:\Users\D650476\AppData\Local\ITERGO
        #$ACL.Access <= //hier sind die UserDaten
 
                $ACL = Get-Acl $Path      
 
        $parts = $FileSystemRights -split ",";
        $found = $false;
        $found_item = $null;
        Foreach ($access in $ACL.Access)
        {
            if($Debug){
                    $access
            }
            if($access.IdentityReference -like ("*"+$Identity+"*"))
            {
                $found = $true;
                $found_item = $access;
 
 
            }
        }
 
        if($found)
        {
            if($found_item.AccessControlType -eq $Value) #allow
            {
                write-host "OK (" $Name ":" $found_item.IdentityReference ":" $Path "["$found_item.FileSystemRights ">" $found_item.AccessControlType "])" -ForegroundColor Green                              
            }
            else{
                write-host "WRN (" $Name ":" $found_item.IdentityReference ":" $Path "["$found_item.FileSystemRights ">" $found_item.AccessControlType "])" -ForegroundColor Yellow                            
            }
        }
        else{
            write-host "NOK (" $Name ":" $Path " :not set:" $Identity " )" -ForegroundColor Yellow                             
            #try to fix
            If($Fix)
            {
                $acl = Get-Acl $Path;
                $domain = (Get-WmiObject win32_computersystem).Domain;
                $fullname = ($domain+"\"+$Identity);
                $permission = $fullname,"FullControl","Allow";
                $accessRule = New-Object System.Security.AccessControl.FileSystemAccessRule $permission;
                $acl.SetAccessRule($accessRule);
                $acl | Set-Acl $Path;
                write-host "FIX (" $Name ": " $Path " add User: "  $fullname " FullControl:Allow )" -ForegroundColor Green                             
            }
            #$acl = Get-Acl c:\temp
            #$permission = "domain\user","FullControl","Allow"
            #$accessRule = New-Object System.Security.AccessControl.FileSystemAccessRule $permission
            #$acl.SetAccessRule($accessRule)
            #$acl | Set-Acl c:\temp
        }
                
        }
        Catch
        {
                if(-NOT $Debug)
                {
                        write-host "Ex:F:BagCheckAcl, M:" $_.Exception.Message ")" -ForegroundColor Red
                }
        }
}
 
If($global:GLOBAL -ne $true)
{
  Write-Host "BagCheckAcl"
 
  BagCheckAcl -Name "Check Permission" -Path "C:\Windows" -Identity $env:USERNAME -Fix $true
 
   Write-Host "Press any key to continue ..."
   If(-NOT $psISE){
    $x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
   }
}
