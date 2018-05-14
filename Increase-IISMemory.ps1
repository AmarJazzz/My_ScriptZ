#===[ Defining variables ]===#

$host_name = $env:COMPUTERNAME.tolower()
$log = "C:\scripts\privatememory.log"

Try
{

#===[ Setting Server-Wide configuration for new and unlimited domains ]===#

$([datetime]::Now).tostring() + ", Info: Executing server-wide configuration" | Out-File -Append $log
& "C:\Program Files (x86)\Parallels\Plesk\bin\server_pref.exe" --set-iis-app-pool-settings -recycling-by-private-memory 256000

#===[ Setting the configuration for all Subscriptions ]===#

$FinalCheck = plesk db -Ne "Select name from domains where id in (Select ownerid from iisapppools where recyclingbyprivatememory = '204800' or recyclingbyprivatememory = '153600') and webspace_id = 0;"
if(!($host_name.contains('bh')))
{
    if($FinalCheck)
    {
        foreach ($Final in $FinalCheck)
        {
            $([datetime]::Now).tostring() + ", Info: Setting private memory for the subscription : $Final" | Out-File -Append $log
            $query_error = $null
            $query_error = & "C:\Program Files (x86)\Parallels\Plesk\admin\bin\subscription.exe" --update $Final -recycling-by-private-memory 256000
            if($query_error) 
            { 
                $mode = $null
                if($query_error -notlike '*SUCCESS*')
                {
                    $mode = 'Error'
                }
                else
                {
                    $mode= 'Info'
                }

                $([datetime]::Now).tostring() + ', ' + $mode +",$query_error" | Out-File $log -Append 
             }
             else
             {
                $([datetime]::Now).tostring() + ", Error: Query didn't got executed, try to execute manually for domain : $Final" | Out-File -Append $log 
             }
        }
    }
    else
    {
        $([datetime]::Now).tostring() + ", Info: Cannot find subsciption with Memory 150MB or 200 MB" | Out-File -Append $log
    }
}
}
Catch
{
    $Exception = $_.Exception
    $Error_line = $_.InvocationInfo.ScriptLineNumber
    $Exception_msg = $Exception.Message
    $([datetime]::Now).tostring() + ",Error: Got Exception. Full details : $Exception ; Error Message : $Exception_msg ; Error Line number : $Error_line" | Out-File -Append $log
}
