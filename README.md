# SystemCheck



### Enable Powershell
```powershell
start %SystemRoot%\SysWOW64\WindowsPowerShell\v1.0\powershell.exe Set-ExecutionPolicy Unrestricted -Scope CurrentUser
```

### Run Script from Std::Shell
```powershell
#start %SystemRoot%\SysWOW64\WindowsPowerShell\v1.0\powershell.exe -NoProfile -ExecutionPolicy Bypass -Command  "& '%cd%\_SystemCheck\_SystemCheck.ps1'"

start %SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe -NoProfile -ExecutionPolicy Bypass -Command  "& '%cd%\_SystemCheck\_SystemCheck.ps1'"
```

