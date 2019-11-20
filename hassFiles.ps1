Begin {
	if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
	{
	Add-Type -AssemblyName PresentationCore,PresentationFramework
	$ButtonType = [System.Windows.MessageBoxButton]::Ok
	$MessageIcon = [System.Windows.MessageBoxImage]::Warning
	$MessageBody = "You are not running this script as an administrator. Run it again as an administrator."
	$MessageTitle = "Admin Access Required"
	$Result = [System.Windows.MessageBox]::Show($MessageBody,$MessageTitle,$ButtonType,$MessageIcon)
	#Write-Warning "You are not running this script as an administrator. Run it again as administrator." ;
	break
	}
	
$start_time = Get-Date
Write-Host "`r`n"
Write-Host "This script will download automation and configuration files." -ForegroundColor Red -BackgroundColor Yellow
Write-Host "`r`n"

# Remove config file if already present
Remove-Item configuration.yaml -ErrorAction Ignore
Remove-Item automation.yaml -ErrorAction Ignore

# Get user's geolocation
#$Lat,$Lon = (Invoke-RestMethod http://ipinfo.io/loc) -split ','
#$Lon=$Lon.replace("`n",", ").replace("`r",", ").replace(","," ")

$pos=(Invoke-RestMethod http://ipinfo.io/loc)
Add-type -AssemblyName System.Device
$Geo = New-Object System.Device.Location.GeoCoordinate($pos.Split(','))
$Lat=$Geo.Latitude
$Lon=$Geo.Longitude
$timeX=(Invoke-RestMethod http://ipinfo.io/timezone).tostring()


# Fetch Configuration file from GitHub
$url = "https://raw.githubusercontent.com/msanaullahsahar/hassio/master/config.yaml"
$output = "$PSScriptRoot\config.yaml"
Invoke-WebRequest -Uri $url -OutFile $output

# Modify config file according to user location
Get-Content config.yaml | Foreach-Object {
$_.replace('LatX',"$Lat").replace('LongX', "$Lon").replace('timeZone',"$timeX")
} | Set-Content configuration.yaml

# Remove original config file
Remove-Item config.yaml -ErrorAction Ignore

# Fetch Automation file from GitHub
$url = "https://raw.githubusercontent.com/msanaullahsahar/hassio/master/automat.yaml"
$output = "$PSScriptRoot\automat.yaml"
Invoke-WebRequest -Uri $url -OutFile $output

# Ask user for his google home mini name
$speakerName = Read-Host -Prompt "What is your Google speaker name? If you do not remember your google home mini name, just open Google Home app on your android phone (sorry guys I have an android phone and do not know how to do this on ios) and on the bottom bar, tap on home icon. You will see the device name under your device icon :`n`n"
$spkName=$speakerName -replace ' ','_'
cat automat.yaml | % { $_ -replace "media_player.sahar_google_mini","$spkName" } > automation.yaml

# Remove original automat file
Remove-Item automat.yaml -ErrorAction Ignore

# Done
[console]::beep(2000,500)

Write-Host "Time taken: $((Get-Date).Subtract($start_time).Seconds) second(s)" -ForegroundColor Red -BackgroundColor Yellow

# Display Ok Box
Add-Type -AssemblyName PresentationCore,PresentationFramework
$ButtonType = [System.Windows.MessageBoxButton]::Ok
$MessageIcon = [System.Windows.MessageBoxImage]::Information
$MessageBody = "Please check your folder for automation.yaml and configuration.yaml files."
$MessageTitle = "Downloading Completed"
$Result = [System.Windows.MessageBox]::Show($MessageBody,$MessageTitle,$ButtonType,$MessageIcon)
}
