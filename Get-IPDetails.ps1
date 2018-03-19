<#
.NAME
    Get-IPDetails
    
.SYNOPSIS
   This script fetches the local ip, public ip and ISP details.

.SYNTAX
    Get-IPDetails [-Value] <string[]>

.EXAMPLE
   To Fetch the complete information ( localip, publicip and ISP Details )
   Get-IPDetails

.EXAMPLE
   To Fetch your Local IP details
   Get-IPDetails -Value LocalIP

.EXAMPLE
   To Fetch your Public IP details
   Get-IPDetails -Value PublicIP

.EXAMPLE
   To Fetch your ISP details
   Get-IPDetails -Value ISP

#>


Try
{
Function Get-IPDetails($Value)
{
    $Banner = "`n=======================================`n"
    Function LocalIP
    {
         $LocalIP = Get-WmiObject Win32_NetworkAdapterConfiguration|Where {$_.Ipaddress.length -gt 1}
         $LocalIP=$LocalIP.ipaddress[0];
         write-host "$Banner Your Local IP is : $LocalIP $Banner" -ForegroundColor Green
    }
    
    Function PublicIP
    {
         $PublicIP = Invoke-RestMethod -Uri "https://api.ipify.org"
         if($PublicIP)
         {
            write-host "$Banner Your Public IP is : $PublicIP $Banner" -ForegroundColor Green
         }
         else
         {
            write-host "Unable to fetch Public IP details" -ForegroundColor Red
         }       
    }

   Function ISP-Details
   {
          $PublicIP = Invoke-RestMethod -Uri "https://api.ipify.org"
          $ISP_Details = Invoke-RestMethod -Uri http://ip-api.com/json/$PublicIP
          write-host "$Banner Below is your ISP Details : $Banner" -ForegroundColor Green
          write-host ($ISP_Details | Format-List | Out-String ) -ForegroundColor Cyan
   }

   Function SearchIP
   {
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        $InputValue = Read-Host "Enter the IPAddress or Hostname to Search for "
        $SearchIP = ((Invoke-RestMethod -Uri "https://tools.keycdn.com/geo.json?host=$InputValue").data).geo
        write-host "$Banner Below is the IP Details : $Banner" -ForegroundColor Green
        write-host ($SearchIP | Format-List | Out-String ) -ForegroundColor Cyan
   }
 
     
    Switch ($Value)
    {
       LocalIP  { LocalIP }      
       PublicIP { PublicIP }
       ISP { ISP-Details }
       SearchIP { SearchIP }
       default{ LocalIP ; PublicIP ; ISP-Details}
    }
}
}
Catch
{
    $Exception = $_.Exception
    $Error_line = $_.InvocationInfo.ScriptLineNumber
    $Exception_msg = $Exception.Message
    Write-Host "Error: Got Exception. Full details : $Exception ; Error Message : $Exception_msg ; Error Line number : $Error_line"
}
