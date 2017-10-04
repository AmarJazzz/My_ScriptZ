$ServerList = "172.16.220.125"
foreach($Server in $ServerList)
{
	$ComputerName = $Server
	$Uptime = (get-date) - (gcim Win32_OperatingSystem -ComputerName $ComputerName).LastBootUpTime
	$Result = @{
		Computername = $Computername
		Uptime = $Uptime
	}
}
$Result