#This Function adds a new domainName to a File, if any duplicate entry is present returns an Error
Function Add-DomainName{
[CmdletBinding()]
      param(
          [Parameter(Mandatory=$true)]
          [String]$DomainName,$FilePath
      )
 
if(!(Select-String -Pattern "^$DomainName$" -Path $Filepath)){
 "$DomainName" | Out-File -FilePath $Filepath -Append -NoNewline
Write-Output "Domain : $DomainName Added"
} else{Write-Error "Domain already exists!!"}
}

Add-DomainName -DomainName "test.com" -FilePath $Filepath

#This Function removes a domainName from a list of domains
Function Remove-DomainName{
[CmdletBinding()]
            param(
                [Parameter(Mandatory=$true)]
                [String]$DomainName, $FilePath
            )

if(Select-String -Pattern "^$DomainName$" -Path $FilePath){
(gc $FilePath) | Select-String -Pattern "^$DomainName$" -NotMatch -Raw | Out-File $FilePath
Write-Output "Domain : $DomainName Removed"
}
else {Write-Error "Domain doesn't exists!!"}
}

Remove-DomainName -DomainName "test.com" -FilePath $Filepath