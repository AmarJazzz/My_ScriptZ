$Domains = plesk db -Ne "Select name from domains"
foreach($Domain in $Domains)
{
    $NS = Resolve-DnsName -Name $Domain -Type NS -DnsOnly
    if($NS)
    {
        for($i = 0; $i -lt 2; $i++)
        {
            $DomainName, $NS_Name, $IPAddress = $Null
            $DomainName = $NS[$i].Name
            $NS_Name = $NS[$i].NameHost
            $IPAddress = (Resolve-DnsName -Name $NS_Name -Type A -DnsOnly).IPAddress
            "$Domain"+","+"$NS_Name"+","+"$IPAddress" >> D:\output.txt
        }
    }
    else
    {
        "$Domain :: ERROR , Unable to fetch NS Records"
    }
}
