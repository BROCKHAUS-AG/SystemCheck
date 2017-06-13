# Author(s)    			: Paul Mizel
# Company				: BROCKHAUS AG
# Year					: 2017
# Source				: https://github.com/BROCKHAUS-AG/SystemCheck


function BagCheckConfig{
    
    param(
		  [string]$Path="",
		  [string]$Keys="configuration,system.web",
          [string]$Attribute="enabled",
		  [string]$Value="true",
          [String]$Name="",
		  [bool]$Debug=$false,
	      [bool]$Fix=$false)
	
	if(-NOT $Debug) { $ErrorActionPreference = "Stop" }
	
	Try{

		[xml]$xml = [xml](get-content $Path)
        
        #$root = $xml.get_DocumentElement();
       
        $part = $xml;
        $parts = $Keys -split ",";

        Foreach ($p in $parts)
        {
            if (Get-Member -InputObject $part -Name $p -MemberType Properties) {
                $part = $part[$p];
            }
            else{
                write-host "ERROR: (" $p ") Tag not found." -ForegroundColor Red
                return;
            }
        }

        $result = $part.$Attribute;
     

		If ($result -eq $Value)
		{	
            write-host "OK ( " $Name ": " $Attribute "=" $Value ")" -ForegroundColor Green				
		}
		Else
		{
			write-host "NOK ( " $Name ": " $Attribute "!= Found: "$result " != " $Value " )" -ForegroundColor Yellow				
		}
	}
	Catch
	{
		if(-NOT $Debug)
		{
			write-host "Ex:F:Config, M:" $_.Exception.Message ")" -ForegroundColor Red
		}
	}
} 

If($global:GLOBAL -ne $true)
{
  Write-Host "BagCheckConfig"

  BagCheckConfig -Path "web.config" -Keys "configuration,system.webServer,security,authentication,windowsAuthentication" -Attribute "enabled" -Value "true" -Name "Security Tag"
    
  Write-Host "Press any key to continue ..."
  $x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}
