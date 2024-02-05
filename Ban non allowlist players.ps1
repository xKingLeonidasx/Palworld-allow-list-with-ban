# In the first section change to your server details and preferences.
# You need RCON enabled on your server.
# You will need ARRCON: https://github.com/radj307/ARRCON
# This can be run from another machine not the one hosting your server.
# Log is optional by setting the $LogED variable 0 for OFF and 1 for ON.
# If you turn on log set the path for the log to save and write to.
# The default ban list will save to Palserver\Pal\Saved\SavedGames.
# Set this as a Task using Task Scheduler to run as often as you like.

<#----------------------------------------------ADD YOUR SERVER DETAILS IN THIS SECTION----------------------------------------------#>

<# Server Info #>

$ServerIP = '12.345.67.89'     # Add your server IP here

<# RCON Info #>  

$ServerPort = '12345'     # Add your server RCON Port here 
$RCONPW = 'YOURPASSWORD'     # Add your server RCON PW here
$RCONpath = 'C:\RCON\ARRCON-3.3.7-Windows\arrcon.exe'     # Add ARRCON path here

<# File Paths & Log Enable/Disable#>

$Allowlistpath = 'C:\Users\Leo\Desktop\allowlist.txt'     # Add path/file to your allowlist

$LogED = '0'     # Keep at 0 to keep disabled. Change to 1 to enable log and enter a path below
$Banlog = 'C:\Logs\banlog.txt'     # Add the path / file you want the ban log to write to

<#------------------------------------------------------------------------------------------------------------------------------------#>
<#-----------------------------------------------------NO NEED TO EDIT BELOW HERE-----------------------------------------------------#>
<#------------------------------------------------------------------------------------------------------------------------------------#>

$Date = Get-Date
$Allowlist = Get-Content -Path $Allowlistpath
$CMDshow = $RCONpath + " -H " + $ServerIP + " -P " + $ServerPort + " -p " + $RCONPW + " showplayers "
$CMD = $RCONpath + " -H " + $ServerIP + " -P " + $ServerPort + " -p " + $RCONPW

$Players = Invoke-Expression $CMDshow | Select -Skip 2 | Select -Skiplast 1
if ($Players -gt 0) {
$PlayerID = $Players -replace '^[^,]+,' -replace '^[^,]+,'
ForEach ($SteamID in $PlayerID) {
if ($SteamID -notin $Allowlist) {$CMDban = $CMD + ' "banplayer $($SteamID)"'}
if ($SteamID -notin $Allowlist) {Invoke-Expression $CMDban}
if ($SteamID -notin $Allowlist -And $LogED -gt 0) {Add-Content -Path $Banlog -Value "$($SteamID) Banned due to not being on allowlist on: $($Date)"}} 
Exit
} elseif ($Players -eq 0) {
Exit
}
