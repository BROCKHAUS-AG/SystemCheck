# Author(s)    			: Paul Mizel
# Company				: BROCKHAUS AG
# Year					: 2017
# Source				: https://github.com/BROCKHAUS-AG/SystemCheck

$wc=New-Object System.Net.WebClient
$creds=Get-Credential
$wc.Proxy.Credentials=$creds

$wc.DownloadFile("https://raw.githubusercontent.com/BROCKHAUS-AG/SystemCheck/master/checkAdminUser.ps1","checkAdminUser.ps1") 
$wc.DownloadFile("https://raw.githubusercontent.com/BROCKHAUS-AG/SystemCheck/master/checkRegedit.ps1","checkRegedit.ps1") 
$wc.DownloadFile("https://raw.githubusercontent.com/BROCKHAUS-AG/SystemCheck/master/checkService.ps1","checkService.ps1") 
$wc.DownloadFile("https://raw.githubusercontent.com/BROCKHAUS-AG/SystemCheck/master/checkSoftware.ps1","checkSoftware.ps1") 
$wc.DownloadFile("https://raw.githubusercontent.com/BROCKHAUS-AG/SystemCheck/master/checkSystem.ps1","checkSystem.ps1") 
$wc.DownloadFile("https://raw.githubusercontent.com/BROCKHAUS-AG/SystemCheck/master/checkUac.ps1","checkUac.ps1") 
$wc.DownloadFile("https://raw.githubusercontent.com/BROCKHAUS-AG/SystemCheck/master/checkWebConfigReadOnly.ps1","checkWebConfigReadOnly.ps1") 
$wc.DownloadFile("https://raw.githubusercontent.com/BROCKHAUS-AG/SystemCheck/master/downloadLatestScripts.ps1","downloadLatestScripts.ps1") 
$wc.DownloadFile("https://raw.githubusercontent.com/BROCKHAUS-AG/SystemCheck/master/README.md","README.md") 

Write-Host
Write-Host "Press any key to continue ..."
$x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")