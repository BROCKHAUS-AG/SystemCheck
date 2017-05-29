# Author(s)    			: Paul Mizel
# Company				: BROCKHAUS AG
# Year					: 2017
# Source				: https://github.com/BROCKHAUS-AG/SystemCheck


function BagCheckAdminUser{
    
    param($username=$env:username,
	      [bool]$Debug=$false,
	      [bool]$Fix=$false)
	
	if(-NOT $Debug) { $ErrorActionPreference = "Stop" }
	
	Try{
		#([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
		$_currentUser=([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent())
		If (-NOT $_currentUser.IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator"))
		{		
			write-host "ERROR: ("  $_currentUser.Identity.Name ") You do not have Administrator rights." -ForegroundColor Red
			If($Fix)
			{				
				Add-LocalUserToGroup  								
				Add-LocalUserToGroup -group RemoteDesktopBenutzer				
			}
		}
		Else
		{
			write-host "OK ("  $_currentUser ")" -ForegroundColor Green
		}
	}
	Catch
	{
		if(-NOT $Debug)
		{
			write-host "Ex:F:AdminUser, M:" $_.Exception.Message ")" -ForegroundColor Red
		}
	}
} 
 
 
function Add-LocalUserToGroup  {
     Param(
		[bool]$Debug=$false,
        $computer=$env:computername,
        $group='Administratoren',
        $userdomain=$env:userdomain,
        $username=$env:username
    )
	if(-NOT $Debug) { $ErrorActionPreference = "Stop" }
	
	Try
	{	
		([ADSI]"WinNT://$computer/$group,group").psbase.Invoke("Add",([ADSI]"WinNT://$domain/$user").path)	
		write-host "FIX: ("  $_currentUser.Identity.Name ") Add to " $group " Group" -ForegroundColor Yellow				
	}
	Catch
	{
		if(-NOT $Debug)
		{
			write-host "Ex:F:AdminUser, M:" $_.Exception.Message ")" -ForegroundColor Red
		}
	}
}

function Add-DomainUserToGroup 
{ 
		[cmdletBinding()] 
		Param( 
		[Parameter(Mandatory=$False)] 
		[string]$computer, 
		[Parameter(Mandatory=$False)] 
		[string]$domain, 
		[Parameter(Mandatory=$True)] 
		[string]$group, 
		[Parameter(Mandatory=$True)] 
		[string]$user 
		) 

	if([string]::IsNullOrEmpty($computer))
	{
		$computer = [System.Net.Dns]::GetHostByName(($env:computerName)).HostName;
	}

	if([string]::IsNullOrEmpty($domain))
	{
		$domain = (Get-WmiObject win32_computersystem).Domain;
	}

	$de = [ADSI]"WinNT://$computer/$group,group"
	$adUser = [ADSI]"WinNT://$domain/$user"
	$path = ([ADSI]"WinNT://$domain/$user").path
	$de.psbase.Invoke("Add", $path) 

	write-host "FIX: ("  $adUser.Name " added to group " $de.Name ")" -ForegroundColor Yellow				
} 