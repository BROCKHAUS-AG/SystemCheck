# Author(s)    			: Paul Mizel
# Company				: BROCKHAUS AG
# Year					: 2017
# Source				: https://github.com/BROCKHAUS-AG/SystemCheck


# sample #
# $my_softwarelist = BagCheckSoftware-Init
# Write-Host ($my_softwarelist | Where-Object {$_.Publisher -notlike '*Microsoft*'} | Format-Table | Out-String) |more
function BagCheckSoftware-Init{
    $Wow6432Node= Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* |`
    	Select-Object DisplayName, DisplayVersion, Publisher | `
		Where-Object { ![string]::IsNullOrEmpty($_.DisplayName) -and !($_.DisplayName -like "*Hotfix*") -and !($_.DisplayName -like "*Update*")}
		#Sort-Object -Property DisplayName
	$EmptyNode= Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* |`
    	Select-Object DisplayName, DisplayVersion, Publisher | `
		Where-Object { ![string]::IsNullOrEmpty($_.DisplayName) -and !($_.DisplayName -like "*Hotfix*") -and !($_.DisplayName -like "*Update*")}
		#Sort-Object -Property DisplayName
    return $Wow6432Node + $EmptyNode | Sort-Object -Property DisplayName
}

If($global:GLOBAL -ne $true)
{
  Write-Host "Software"

  $my_softwarelist = BagCheckSoftware-Init
  Write-Host ($my_softwarelist | Where-Object {$_.Publisher -notlike '*Microsoft*'} | 
  Format-List | Out-String)
  #DisplayName, DisplayVersion -auto
  
  Write-Host "Press any key to continue ..."
  $x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}

# sample #
# BagCheckSoftware -Name "Microsoft .NET Framework 4.5.1*" -Version "4.5.51641" -List $softwarelist -Debug $debug
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
                
				if($Version -like "*,*")
				{
					$Version.Split(",") | ForEach {
						$_version_item=$_;
						if($item.DisplayVersion -eq $_version_item -OR $_version_item -eq "")
						{
							$found = 1
						}
					}
				}
				else 
				{
					if($item.DisplayVersion -eq $Version -OR $Version -eq "")
					{
						$found = 1
					}
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
				write-host "WRN ("  $founditem.DisplayName ") Found: '" $founditem.DisplayVersion "' <>  " $Version  -ForegroundColor Yellow
			}
			1  {
				write-host "OK (" $founditem.DisplayName ") OK: " $founditem.DisplayVersion  -ForegroundColor Green
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


