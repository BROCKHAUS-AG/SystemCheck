# Author(s)    			: paul mizel
# Company				: BROCKHAUS AG
# Year					: 2017

Function Get-Bits(){
	If(-NOT [Environment]::Is64BitProcess)
	{
		Return "32-bit"
	}
	Else
	{
		Return "64-bit"
	}    
}

#Get-Bits

function Write-Line {
     Param(
	    $title="",
		$info="",
        $error="",
        $success="",
        $warning=""
    )
	
	if(-NOT [string]::IsNullOrEmpty($title))
	{
		$title='{0,-80}' -f $title
		Write-Host $title -ForegroundColor Black -BackgroundColor Green
	}
	
	if(-NOT [string]::IsNullOrEmpty($info))
	{
		Write-Host ""
		$info='{0,-80}' -f $info
		Write-Host $info -ForegroundColor DarkGreen -BackgroundColor Green
	}	
}