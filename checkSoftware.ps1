


function BagCheckSoftware-Init{
    $Wow6432Node= Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* |`
    	Select-Object DisplayName, DisplayVersion, Publisher, InstallDate | `
		Where-Object { ![string]::IsNullOrEmpty($_.DisplayName) -and !($_.DisplayName -like "*Hotfix*") -and !($_.DisplayName -like "*Update*")}
		#Sort-Object -Property DisplayName
	$EmptyNode= Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* |`
    	Select-Object DisplayName, DisplayVersion, Publisher, InstallDate | `
		Where-Object { ![string]::IsNullOrEmpty($_.DisplayName) -and !($_.DisplayName -like "*Hotfix*") -and !($_.DisplayName -like "*Update*")}
		#Sort-Object -Property DisplayName
    return $Wow6432Node + $EmptyNode | Sort-Object -Property DisplayName
}

function BagCheckSoftware{
    
    param(
		  [object]$List,
		  [string]$Name,
	      [string]$Version,
	      [bool]$Debug=$false,
		  [bool]$Fix=$false)
	
	if(-NOT $Debug) { $ErrorActionPreference = "Stop"	}
	
	Try{
		#$List = Get-WmiObject -Class Win32_Product		
		
		$found = -1
		$founditem = $null
		
		foreach($item in $List)
		{		
			#if(![string].IsNullOrEmpty($item.DisplayName)){
			#	write-host $item.DisplayName
			#}
			
			if ($item.DisplayName -like $Name){
			
				$founditem = $item			
				$found = 0

                
                
				if($item.DisplayVersion -eq $Version -OR $Version -eq "")
				{
					$found = 1
				}
			}			
		}	
		
		#write-host $found
		
		switch($found)
		{ 
			-1 {
				write-host "NOT FOUND ("  $Name ")" -ForegroundColor Red
			}
			0  {
				write-host "WRN ("  $founditem.DisplayName ") V: '" $founditem.DisplayVersion "' <> " $Version  -ForegroundColor Yellow
			}
			1  {
				write-host "OK (" $founditem.DisplayName ") V: " $founditem.DisplayVersion  -ForegroundColor Green
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
			write-host "Ex:Software,M: " $Name " - " $_.Exception.Message "" -ForegroundColor Red
		}
	}
}


