Try
{

#==[  Defining Varibles ]==#

$LogName ="System"
$LogPath = "C:\scripts\recycleDomainLogs.log"
$ReportFile = "C:\Scripts\recycleDomainReport.txt"
$EventPath = "D:\Eventlogs\System.evtx"

#==[ Checking Log and Report Path Exists or Not ]==#

if(!(Test-Path $LogPath)){New-Item -Path $LogPath -Type file | Out-Null} ; if(!(Test-Path $ReportFile)){New-Item -Path $ReportFile -Type file | Out-Null}

#==[ Start of Script ]==#

$Data = Get-WinEvent -FilterHashtable @{Path=$EventPath;Level=2;Id=5117} -ErrorAction Stop | Select-Object -ExpandProperty Message
#$Data = Get-WinEvent -LogName $LogName |  ?{$_.ID -eq "5117" -and $_.Message -like "*has requested a recycle*"} | Select-Object -ExpandProperty Message

$FinalOutput = $Data | ForEach-Object { $_.Split( "'(" )[1] } | Group-Object | Select-Object -Property @(
@{Label = 'Domain Name'; Expression = {$_.Name}} 
@{Label = 'No. of Times Recycled'; Expression = {$_.Count}} 
)

$FinalOutput = $FinalOutput | ft -AutoSize
$FinalOutput | Out-File $ReportFile
$([datetime]::Now).tostring() + "Stats generated successfully" | Add-content $LogPath
}
Catch
{
    $Exception = $_.Exception
    $Error_line = $_.InvocationInfo.ScriptLineNumber
    $Exception_msg = $Exception.Message
    $([datetime]::Now).tostring() + "Error: Got Exception. Full details : $Exception ; Error Message : $Exception_msg ; Error Line number : $Error_line" | Add-content $LogPath
}

