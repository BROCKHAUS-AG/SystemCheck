# Author(s)    			: Paul Mizel
# Company				: BROCKHAUS AG
# Year					: 2017
# Source				: https://github.com/BROCKHAUS-AG/SystemCheck

param([switch]$downloadLatestScripts = $false) # -downloadLatestScripts

$wc=New-Object System.Net.WebClient
$creds=Get-Credential
$wc.Proxy.Credentials=$creds

write-host "Download checkAdminUser"
$wc.DownloadFile("https://raw.githubusercontent.com/BROCKHAUS-AG/SystemCheck/master/checkAdminUser.ps1","checkAdminUser.ps1") 

write-host "Download checkAdminUser"
$wc.DownloadFile("https://raw.githubusercontent.com/BROCKHAUS-AG/SystemCheck/master/checkCOM+.ps1","checkCOM+.ps1") 

write-host "Download checkRegedit"
$wc.DownloadFile("https://raw.githubusercontent.com/BROCKHAUS-AG/SystemCheck/master/checkRegedit.ps1","checkRegedit.ps1") 

write-host "Download checkService"
$wc.DownloadFile("https://raw.githubusercontent.com/BROCKHAUS-AG/SystemCheck/master/checkService.ps1","checkService.ps1") 

write-host "Download checkSoftware"
$wc.DownloadFile("https://raw.githubusercontent.com/BROCKHAUS-AG/SystemCheck/master/checkSoftware.ps1","checkSoftware.ps1") 

write-host "Download checkSystem"
$wc.DownloadFile("https://raw.githubusercontent.com/BROCKHAUS-AG/SystemCheck/master/checkSystem.ps1","checkSystem.ps1") 

write-host "Download checkUac"
$wc.DownloadFile("https://raw.githubusercontent.com/BROCKHAUS-AG/SystemCheck/master/checkUac.ps1","checkUac.ps1") 

write-host "Download checkWebConfigReadOnly"
$wc.DownloadFile("https://raw.githubusercontent.com/BROCKHAUS-AG/SystemCheck/master/checkWebConfigReadOnly.ps1","checkWebConfigReadOnly.ps1") 

If($downloadLatestScripts)
{
write-host "Download downloadLatestScripts"
$wc.DownloadFile("https://raw.githubusercontent.com/BROCKHAUS-AG/SystemCheck/master/downloadLatestScripts.ps1","downloadLatestScripts.ps1") 

write-host "Download README.md"
$wc.DownloadFile("https://raw.githubusercontent.com/BROCKHAUS-AG/SystemCheck/master/README.md","README.md") 
}

Write-Host
Write-Host "Press any key to continue ..."
$x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")