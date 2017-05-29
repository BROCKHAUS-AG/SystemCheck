# Author(s)    			: paul mizel
# Company				: BROCKHAUS AG
# Year					: 2017

function BagCheckService{
    
    param([string]$Name,
	      [bool]$Debug=$false,
		  [bool]$Fix=$false)
	
	if(-NOT $Debug) { $ErrorActionPreference = "Stop"	}
	
	Try{
		$arrService = Get-Service -Name $Name
		if ($arrService.Status -ne "Running"){
			Start-Service $Name
		}
		write-host "OK ("  $Name ")" -ForegroundColor Green
	}
	Catch
	{
		if(-NOT $Debug)
		{
			write-host "Ex:Service,M:" $_.Exception.Message "" -ForegroundColor Red
		}
	}
}


#BagCheckService -Name "ServiceName" 

