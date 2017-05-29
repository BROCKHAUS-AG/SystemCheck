# Author(s)    			: paul mizel
# Company				: BROCKHAUS AG
# Year					: 2017

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
		  [object]$Path="Registry::HKEY_CURRENT_USER\Software\Microsoft\VisualStudio\14.0\Debugger",
		  [object]$Compare=1
		  )
	
	if(-NOT $Debug) { $ErrorActionPreference = "Stop" }
	
	Try{
	
	    $result = Get-ItemProperty -Path $Path -Name $Name
	    		
		if($Debug)
		{
			#write-host $result		
			#write-host "RES:" $result.DisableAttachSecurityWarning
		}
		
		If ($result.DisableAttachSecurityWarning -eq $Compare)
		{		
			write-host "OK ( Regedit DisableAttachSecurityWarning : 1)" -ForegroundColor Green
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