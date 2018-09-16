

function Run-At {
	param(
		[ScriptBlock] $Command,
		[string] $ComputerName,
		[int] $Port = 22
	)

	$res = $Command.ToString().Split("`n") | ? {$_ -ne ""} 
	$cmd = [string]::Join("; ", $res)
	ssh -p $Port $ComputerName pwsh -Command $cmd
}

import-module posh-git


function Prompt {
	Write-Host -NoNewLine ((get-date).ToString("hh:MM:ss"))
	Write-Host -NoNewLine " | "
	Write-Host -NoNewLine (hostname)
	write-host -NoNewLine -ForegroundColor green (Get-Location)
	Write-Host -NoNewLine " "
}

enum Display {
	HDMI
	VGA
	LVDS
}

function Set-Displpay {
	
	[CmdletBinding()]
	param(
		[Parameter(Mandatory)]
		[Display] $Display,
		[switch] $AdjustBackground
	)
	switch ($Display) 
	{
		HDMI 
		{
			xrandr --output LVDS1 --auto --output HDMI1 --same-as LVDS1
			xrandr --output HDMI1 --mode 1920x1080
		}
		VGA 
		{
			xrandr --output VGA1 --auto --output HDMI1 --auto
		}
		LVDS 
		{
			xrandr --output LVDS1 --auto --output HDMI1 --auto
		}
	}
	if ($AdjustBackground) 
	{
		feh --bg-scale Desktop/bg.jpg
	}
}

function Get-Displays 
{
	(xrandr --listmonitors | % {$_.Split(" ")[-1]} ) | Select-Object -Skip 1 
}
