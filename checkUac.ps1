# Author(s)    			: Paul Mizel
# Company				: BROCKHAUS AG
# Year					: 2017
# Source				: https://github.com/BROCKHAUS-AG/SystemCheck


function BagCheckUac{
    
    param([bool]$Debug=$false,
	      [bool]$Fix=$false)
	
	if(-NOT $Debug) { $ErrorActionPreference = "Stop" }
	
	Try{
		$status = Get-UACStatus
		If ($status)
		{		
			write-host "ERROR: ("  $status ") Uac is not disabled." -ForegroundColor Red
			If($Fix)
			{
				write-host "FIX: ("  $status ") Diable Uac" -ForegroundColor Yellow				
				Set-UACStatus -Enabled $false
			}
		}
		Else
		{
			write-host "OK ( Uac Status: " $status ")" -ForegroundColor Green
		}
	}
	Catch
	{
		if(-NOT $Debug)
		{
			write-host "Ex:F:Uac, M:" $_.Exception.Message ")" -ForegroundColor Red
		}
	}
} 


function Get-UACStatus {
	<#
	.SYNOPSIS
	   	Gets the current status of User Account Control (UAC) on a computer.

	.DESCRIPTION
	    Gets the current status of User Account Control (UAC) on a computer. $true indicates UAC is enabled, $false that it is disabled.

	.EXAMPLE
		Get-UACStatus

		Description
		-----------
		Returns the status of UAC for the local computer. $true if UAC is enabled, $false if disabled.

	.EXAMPLE
		Get-UACStatus -Computer [computer name]

		Description
		-----------
		Returns the status of UAC for the computer specified via -Computer. $true if UAC is enabled, $false if disabled.


	.INPUTS
		None. You cannot pipe objects to this script.

	#Requires -Version 2.0
	#>

	[cmdletBinding(SupportsShouldProcess = $true)]
	param(
		[parameter(ValueFromPipeline = $false, ValueFromPipelineByPropertyName = $true, Mandatory = $false)]
		[string]$Computer
	)
	[string]$RegistryValue = "EnableLUA"
	[string]$RegistryPath = "Software\Microsoft\Windows\CurrentVersion\Policies\System"
	[bool]$UACStatus = $false
	$OpenRegistry = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey([Microsoft.Win32.RegistryHive]::LocalMachine,$Computer)
	$Subkey = $OpenRegistry.OpenSubKey($RegistryPath,$false)
	$Subkey.ToString() | Out-Null
	$UACStatus = ($Subkey.GetValue($RegistryValue) -eq 1)
	#write-host $Subkey.GetValue($RegistryValue)
	return $UACStatus
} # end function Get-UACStatus

function Set-UACStatus {
	<#
	.SYNOPSIS
		Enables or disables User Account Control (UAC) on a computer.

	.DESCRIPTION
		Enables or disables User Account Control (UAC) on a computer.

	.EXAMPLE
		Set-UACStatus -Enabled [$true|$false]

		Description
		-----------
		Enables or disables UAC for the local computer.

	.EXAMPLE
		Set-UACStatus -Computer [computer name] -Enabled [$true|$false]

		Description
		-----------
		Enables or disables UAC for the computer specified via -Computer.

	.INPUTS
		None. You cannot pipe objects to this script.

	#Requires -Version 2.0
	#>

	param(
		[cmdletbinding()]
		[parameter(ValueFromPipeline = $false, ValueFromPipelineByPropertyName = $true, Mandatory = $false)]
		[string]$Computer = $env:ComputerName,
		[parameter(ValueFromPipeline = $false, ValueFromPipelineByPropertyName = $true, Mandatory = $true)]
		[bool]$enabled
	)
	[string]$RegistryValue = "EnableLUA"
	[string]$RegistryPath = "Software\Microsoft\Windows\CurrentVersion\Policies\System"
	$OpenRegistry = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey([Microsoft.Win32.RegistryHive]::LocalMachine,$Computer)
	$Subkey = $OpenRegistry.OpenSubKey($RegistryPath,$true)
	$Subkey.ToString() | Out-Null
	if ($enabled -eq $true){
		$Subkey.SetValue($RegistryValue, 1)
	}else{
		$Subkey.SetValue($RegistryValue, 0)
	}
	$UACStatus = $Subkey.GetValue($RegistryValue)
	$UACStatus
	$Restart = Read-Host "`nSetting this requires a reboot of $Computer. Would you like to reboot $Computer [y/n]?"
	if ($Restart -eq "y"){
		Restart-Computer $Computer -force
		Write-Host "Rebooting $Computer"
	}else{
		Write-Host "Please restart $Computer when convenient"
	}
} # end function Set-UACStatus