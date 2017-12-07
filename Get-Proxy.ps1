Function Get-Proxy
{
    param(
        [int]$Value    
    )

    Begin
    {        
        $Option = $null
        if($Value)
        {
            $Option = $Value
        }       
        
        if($Option -eq $null)
        {
            $Option = Read-Host "`nSelect any one of the Proxy type`n`n1. Direct Proxy`n2. Anonymous Proxy`n3. Proxy with Port 80`n4. Country Level Proxy`n5. Speed Proxy`n`nYour option is "
        }
        $Proxy = "https://gimmeproxy.com/api/getProxy?"
    }
    Process
    {
        if($Option -eq 1)
        {
            Invoke-RestMethod ($proxy+"anonymityLevel=0") | Select-Object -ExpandProperty ipPort
        }

        if($Option -eq 2)
        {
            Invoke-RestMethod ($proxy+"anonymityLevel=1") | Select-Object -ExpandProperty ipPort
        }

        if($Option -eq 3)
        {
            Invoke-RestMethod ($proxy+"port=80") | Select-Object -ExpandProperty ipPort
        }

        if($Option -eq 4)
        {
            $CountryCode =  Read-Host "`nEnter the Country code Like US,IN,PK,UK etc "
            if($CountryCode -eq $null)
            {
                Write-Host "Not a valid country code" -ForegroundColor Red
                Break
            }
            else
            {
                Invoke-RestMethod ($proxy+"country=$CountryCode") | Select-Object -ExpandProperty ipPort
            }
        }

        if($Option -eq 5)
        {
            Invoke-RestMethod ($proxy+"minSpeed=50") | Select-Object -ExpandProperty ipPort
        }
        
        if($Option -notmatch "[1-5]")
        {
            Write-Host "Invalid option Selected, Try Again" -ForegroundColor Red
            Break
        }
    }
}
