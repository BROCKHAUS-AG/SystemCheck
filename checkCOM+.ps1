function BagCheckComPlus-Init
{
	$list = New-Object System.Collections.ArrayList

	$comAdmin = New-Object -com ("COMAdmin.COMAdminCatalog.1")
	$applications = $comAdmin.GetCollection("Applications") 
	$applications.Populate() 

	foreach ($application in $applications)
	{
		$components = $applications.GetCollection("Components",$application.key)
		$components.Populate()
		foreach ($component in $components)
		{
            
			$item = New-Object System.Object
			$item | Add-Member -MemberType NoteProperty -Name "ApplicationName" -Value $application.Value("Name")
			$item | Add-Member -MemberType NoteProperty -Name "ComponentName" -Value $component.Name			
			$item | Add-Member -MemberType NoteProperty -Name "DLL" -Value $component.Value("DLL")	
            $item | Add-Member -MemberType NoteProperty -Name "Description" -Value $component.Value("Description")				
			$item | Add-Member -MemberType NoteProperty -Name "Identity" -Value $application.Value("Identity")
			$item | Add-Member -MemberType NoteProperty -Name "Activation" -Value $application.Value("Activation")
			$list.Add($item) | Out-Null

			#application.Value("ID") = "{da2d72e3-f402-4f98-a415-66d21dafc0a9}"
			#application.Value("Name") = "SampleApp"
			#application.Value("Activation") = COMAdmin.COMAdminActivationOptions.COMAdminActivationLocal
			#application.Value("ApplicationAccessChecksEnabled") = #COMAdmin.COMAdminAccessChecksLevelOptions.COMAdminAccessChecksApplicationComponentLevel#
			#application.Value("Description") = "Sample Application"
			#application.Value("Identity") = "YourMachine\administrator"
			#application.Value("Password") = "YourPassword"
			#application.Value("RunForever") = True
		}
	}
	return $list;
}

If($global:GLOBAL -ne $true)
{
  Write-Host "COM+ Components"
  $my_compluslist = BagCheckComPlus-Init

  Write-Host ($my_compluslist | Format-List | Out-String)
  
  Write-Host "Press any key to continue ..."
  If(-NOT $psISE){
    $x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
  }
}


function BagCheckComPlus
{ 
	#[cmdletBinding()] 
	param([object]$List,
		  [string]$Name,

	      [int]$Activation=-1,
          [string]$Identity="",
          [bool]$DLL=$false,
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
				Write-Host ($item | Format-List | Out-String)
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
				write-host "WRN ("  $founditem.ComponentName ") Found: '" $founditem.DisplayVersion "' <>  " $Version  -ForegroundColor Yellow
			}
			1  {
				write-host "OK (" $founditem.ComponentName ") OK: " $founditem.DisplayVersion  -ForegroundColor Green
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

$compluslist = BagCheckComPlus-Init
BagCheckComPlus -List $compluslist -Name "Itergo.Ecsa*"
BagCheckComPlus -List $compluslist -Name "EventPublisher.EventPublisher" -Identity LocalSystem -Activation 1


Write-Host "Press any key to continue ..."
If(-NOT $psISE){
    $x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}