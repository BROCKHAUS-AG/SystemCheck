function BagCheckWebConfigReadOnly{
    
    param([bool]$Debug=$false,
		  [bool]$Fix=$false)
	
	if(-NOT $Debug){ $ErrorActionPreference = "Stop" }
	
	Try{
		$error=$false;
		$items=get-childitem "D:\tfs\" -Recurse -Filter "web.config" -Attributes ReadOnly		
		ForEach($item in $items)
		{
			if(-NOT ($item.DirectoryName.EndsWith(".WebUI","CurrentCultureIgnoreCase") -OR 
			         $item.DirectoryName.EndsWith(".WebUI","CurrentCultureIgnoreCase")))
			{continue}
			if($Debug)
			{
				Write-Host "File" $item.Fullname
				Write-Host "Dir" $item.DirectoryName
				Write-Host "Mode" $item.Mode
			}
			write-host "ERROR: File " $item.Fullname " is readonly" -ForegroundColor Red
			$error=$true;
		}
		if(-NOT $error)
		{
			write-host "OK: (All web.config files are not readonly)" -ForegroundColor Green
		}
	}
	Catch
	{
		if(-NOT $Debug)
		{
			write-host "Exception: (Function: BagCheckWebConfigReadOnly, Message : " $_.Exception.Message ")" -ForegroundColor Red
		}
	}
} 
 
