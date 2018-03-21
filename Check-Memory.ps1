$Log_File = "C:\Scripts\CheckMemory.log"
$DateTime = $([datetime]::Now).tostring()
if(!(Test-Path $Log_File)){New-Item -Path $Log_File -ItemType File -Force | Out-Null}

$CPU = $proc = (Get-WmiObject -class win32_processor -EA SilentlyContinue | Measure-Object -property LoadPercentage -Average | Select-Object Average | % {$_.Average / 100}).ToString("P")
$Mem = Get-WmiObject win32_OperatingSystem -EA SilentlyContinue 
$Mem = (($Mem.TotalVisibleMemorySize - $Mem.FreePhysicalMemory) / $Mem.TotalVisibleMemorySize).ToString("P")
$Info = [pscustomobject]@{
        'Date and Time' = $DateTime
        'CPU Usage' = $CPU
        'MEM Usage' = $Mem
    }

#$info = ($Info | Format-List | Out-String).TrimStart()
Add-Content -Path $Log_File -Value $Info