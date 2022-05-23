
$ComputerName = "192.168.43.176"
$Ports = 1..1000

foreach ($Computer in $ComputerName) 
{    
    foreach ($Port in $Ports) 
    {
        $Socket = New-Object Net.Sockets.TcpClient
        $ErrorActionPreference = 'SilentlyContinue'
        $Socket.Connect($Computer, $Port)
        $ErrorActionPreference = 'Continue'
        
        if ($Socket.Connected) 
        {
            write-host "${Computer}: Port $Port is open" -ForegroundColor Green
            $Socket.Close()
        }
        else 
        {
            write-host "${Computer}: Port $Port is closed or filtered" -ForegroundColor Red
        }
    
        $Socket.Dispose()
        $Socket = $null       
    }  
}

trap 
{
    Write-Host "`nScript Path : $($_.InvocationInfo.ScriptName)`nLine Number : $($_.InvocationInfo.ScriptLineNumber)`nDetail : $(($_.InvocationInfo.Line).trim())`n"
}