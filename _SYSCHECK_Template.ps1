. "$PSScriptRoot\checkSystem.ps1"
. "$PSScriptRoot\checkService.ps1"
. "$PSScriptRoot\checkSoftware.ps1"
. "$PSScriptRoot\checkAdminUser.ps1"
. "$PSScriptRoot\checkUac.ps1"
. "$PSScriptRoot\checkRegedit.ps1"
. "$PSScriptRoot\checkWebConfigReadOnly.ps1"

$empty = ""
$debug = $false
$fix = $true

Write-Line -Title ("SYSTEM CHECK - " + (Get-Date).Year + " " +(Get-Bits))

Write-Line -Info "Check Services"

BagCheckService -Name "DNS-Client" -Debug $debug
BagCheckService -Name "NetTcpPortSharing" -Debug $debug
BagCheckService -Name "NetTcpActivator" -Debug $debug
BagCheckService -Name "MSDTC" -Debug $debug

Write-Line -Info "Check Software"

$softwarelist=BagCheckSoftware-Init

#Write-Host ($softwarelist | Where-Object {$_.Publisher -notlike '*Microsoft*'} | Format-Table | Out-String) |more

BagCheckSoftware -Name "KDiff3*" -Version "" -List $softwarelist -Debug $debug
BagCheckSoftware -Name "Microsoft .NET Framework 4.5.1*" -Version "4.5.51641" -List $softwarelist -Debug $debug
BagCheckSoftware -Name "Microsoft Visual Studio Enterprise 2015*" -Version "14.0.23107" -List $softwarelist -Debug $debug

Write-Line -Info "Check User"

BagCheckAdminUser -Debug $debug -Fix $fix
BagCheckUac -Debug $debug -Fix $fix

Write-Line -Info "Check DisableAttachSecurityWarning"

BagCheckRegedit-DisableAttachSecurityWarning -Text "VS2012 32bit" -Path Registry::HKEY_CURRENT_USER\Software\Microsoft\VisualStudio\12.0\Debugger -Debug $debug -Fix $fix
BagCheckRegedit-DisableAttachSecurityWarning -Text "VS2012 64bit" -Path Registry::HKEY_CURRENT_USER\Software\Wow6432Node\Microsoft\VisualStudio\12.0\Debugger -Debug $debug -Fix $fix
BagCheckRegedit-DisableAttachSecurityWarning -Text "VS2015 32bit" -Path Registry::HKEY_CURRENT_USER\Software\Microsoft\VisualStudio\14.0\Debugger -Debug $debug -Fix $fix
BagCheckRegedit-DisableAttachSecurityWarning -Text "VS2015 64bit" -Path Registry::HKEY_CURRENT_USER\Software\Microsoft\VisualStudio\14.0\Debugger -Debug $debug -Fix $fix


Write-Line -Info "Check web.config in D:\tfs\*\web.config"

Write-Host "Loading..."

BagCheckWebConfigReadOnly -Debug $debug -Fix $fix

Write-Host
Write-Host "Press any key to continue ..."
$x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
