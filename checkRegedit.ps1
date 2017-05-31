# Author(s)    			: Paul Mizel
# Company				: BROCKHAUS AG
# Year					: 2017
# Source				: https://github.com/BROCKHAUS-AG/SystemCheck


function BagCheckRegedit{
    
    param([bool]$Debug=$false,
	      [bool]$Fix=$false,
		  [object]$Path="",
		  [String]$Name="",
		  [String]$Compare=""
		  )
	
	if(-NOT $Debug) { $ErrorActionPreference = "Stop" }
	
	Try{
	
	    $result = Get-ItemProperty -Path $Path -Name $Name
	
		If ($result -eq $Compare)
		{		
			write-host "OK ( Regedit " $Name " : " $result ")" -ForegroundColor Green
		}
		Else
		{
			write-host "ERROR: ("  $result ") ." -ForegroundColor Red
		}
	}
	Catch
	{
		if(-NOT $Debug)
		{
			write-host "Ex:F:Regedit, M:" $_.Exception.Message ")" -ForegroundColor Red
		}
	}
} 

function BagCheckRegedit-DisableAttachSecurityWarning{
    
    param([bool]$Debug=$false,
	      [bool]$Fix=$false,		  
		  [String]$Text="DisableAttachSecurityWarning",
		  [String]$Name="DisableAttachSecurityWarning",
		  [object]$Path="Registry::HKEY_CURRENT_USER\Software\Microsoft\VisualStudio\14.0\Debugger",
		  [object]$Compare=1
		  )
	
	if(-NOT $Debug) { $ErrorActionPreference = "Stop" }
	
	Try{
	
		#Get-ItemProperty -Path "Registry::HKEY_CURRENT_USER\Software\Microsoft\VisualStudio\14.0\Debugger" -Name "DisableAttachSecurityWarning"
	    $result = Get-ItemProperty -Path $Path -Name $Name
	    		
		if($Debug)
		{
			write-host $result
		}
		
		If ($result.$Name -eq $Compare)
		{		
			write-host ("OK ( Regedit "+ $Text +" : 1)") -ForegroundColor Green
		}
		Else
		{
			write-host "ERROR: ("  $result ") ." -ForegroundColor Red
			If($Fix)
			{
				write-host "FIX: ("  $status ") Disable AttachSecurityWarning" -ForegroundColor Yellow								
				#[Microsoft.Win32.Registry]::SetValue($Path,"DisableAttachSecurityWarning",1,[Microsoft.Win32.RegistryValueKind]::DWord)
				regedit /s DisableAttachSecurityWarning.reg
			}
		}
	}
	Catch
	{
		if(-NOT $Debug)
		{
			write-host "Ex:F:Regedit, M:" $_.Exception.Message ")" -ForegroundColor Red
		}
	}
}

function BagCheckRegedit-MSDTC{
    
    param([bool]$Debug=$false,
	      [bool]$Fix=$false,		  
		  [String]$Text="NetworkDtcAccess",
		  [String]$Name="NetworkDtcAccess",
		  [object]$Path="Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\MSDTC\Security",
		  [object]$Compare=1
		  )
	
	if(-NOT $Debug) { $ErrorActionPreference = "Stop" }
	
	Try{
	
		#Get-ItemProperty -Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\MSDTC\Security" -Name "NetworkDtcAccess"
	    $result = Get-ItemProperty -Path $Path -Name $Name
	    		
		if($Debug)
		{
			write-host $result
		}
		
		If ($result.$Name -eq $Compare)
		{		
			write-host ("OK ( Regedit "+ $Text +" : 1)") -ForegroundColor Green
		}
		Else
		{
			write-host "ERROR: ("  $result ") ." -ForegroundColor Red
			If($Fix)
			{
				write-host "FIX: ("  $status ") Enable MSDTC Settings" -ForegroundColor Yellow								
				#[Microsoft.Win32.Registry]::SetValue($Path,"DisableAttachSecurityWarning",1,[Microsoft.Win32.RegistryValueKind]::DWord)
				regedit /s MSDTC.Security.reg
			}
		}
	}
	Catch
	{
		if(-NOT $Debug)
		{
			write-host "Ex:F:Regedit, M:" $_.Exception.Message ")" -ForegroundColor Red
		}
	}
}