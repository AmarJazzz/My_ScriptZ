Function Get-BLLIP
{
[cmdletbinding()]
 param(
    [parameter(Mandatory=$true)]$IP
 )

$BLL_IPQuery = Invoke-RestMethod "http://bll-1.webhostbox.net:8003/ippool/ipaddress_details.jsp?key=qwedsa&ip=$IP&submit=Submit"
$Result = $BLL_IPQuery  | findstr "<td>"
$Result = ($Result[3].trim()) -replace "<td>|</td>",""

Write-Host "IP : $IP`nServerName : $Result" -fore Green
}

