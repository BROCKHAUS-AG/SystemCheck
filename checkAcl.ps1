# sample 
# BagCheckAcl -Path "C:\" -Identity "pmizel" -Identity LocalSystem
function BagCheckAcl
{ 
	#[cmdletBinding()] 
	param([string]$Name,
          [string]$Identity="",
          [string]$Path="C:\",
          [string]$List,
	      [bool]$Debug=$false,
		  [bool]$Fix=$false)
		  
	if(-NOT $Debug) { $ErrorActionPreference = "Stop"	}
	
	Try{
		$found = -1
		$founditem = $null
		
		$componentFound = 0;
		foreach ($item in $List)
		{
			if($item.ApplicationName -like $Name -OR $item.ComponentName -like $Name)
			{
				If($Debug)
				{
					Write-Host ($item | Format-List | Out-String)
				}
				$founditem = $item;
				$found = 0
			}
		}	
		
		switch($found)
		{ 
			-1 {
				write-host "NOT FOUND ("  $Name ")" -ForegroundColor Red
			}
			0  {
			
				if($Activation -ge 0){
					if($Activation -eq $founditem.Activation){
						write-host "OK (" $founditem.ComponentName ") OK: Activation: " $founditem.Activation  -ForegroundColor Green
					}
					else{
						write-host "WRN ("  $founditem.ComponentName ") Found: '" $founditem.Activation "' <>  " $Activation  -ForegroundColor Yellow
					}
				}
				
				if($Identity -ne ""){
					if($Identity -eq $founditem.Identity){
						write-host "OK (" $founditem.ComponentName ") OK: Identity: " $founditem.Identity  -ForegroundColor Green
					}
					else{
						write-host "WRN ("  $founditem.ComponentName ") Found: '" $founditem.Identity "' <>  " $Identity  -ForegroundColor Yellow
					}
				}
				
				if($DLL){
					if([System.IO.File]::Exists($founditem.DLL)){
						write-host "OK (" $founditem.ComponentName ") OK: DLL:" $founditem.DLL  -ForegroundColor Green
					}
					else{
						write-host "WRN ("  $founditem.ComponentName ") File not found: '" $founditem.DLL "'"  -ForegroundColor Yellow
					}
				}
				
			}
			default {
				write-host "ERROR (" $Name ")" -ForegroundColor Red
			} 
		}
	}
	Catch
	{
		if($Debug)
		{
			write-host "Ex:COM+,M: " $Name " - " $_.Exception.Message "" -ForegroundColor Red
		}
	}
}