
<#
.Synopsis
   Deletes all files in a specific directory with "(n)" in their name (where 'n' indicates a number).  Useful for cleaning up downloads
.DESCRIPTION
   Deletes all files in a specific directory with "(n)" in their name (where 'n' indicates a number).  Useful for cleaning up duplicate downloads
.EXAMPLE
   Remove-DuplicateDownloads -TargetPath C:\Users\User1\Downloads
#>
function Remove-DuplicateDownloads
{
    [CmdletBinding()]
    Param
    (
        # The directory you would like to use to search for the duplicate downloads
        [Parameter(ValueFromPipeline=$true)]
        $TargetPath = "$env:USERPROFILE\Downloads"
        )
        
    Begin {
        $Date = Get-Date -Format yyyyMMdd
        $FileName = "$Date" + "_Remove-DuplicateDownloads_Results.csv"
    }
    Process {
        $ChildItems = Get-ChildItem -LiteralPath $TargetPath -Recurse | Where {$_.Name -like "*([0-9]?)*"} |
        Select Name,
        Directory,
        @{Label="Created";Expression={$_.CreationTime}},
        @{Label="File Size";Expression={$_.Length}},
        @{Label="Full Path";Expression={$_.FullName}}
        $MeasureObject = $ChildItems | Select -ExpandProperty "File Size" | Measure -Sum
        if ($MeasureObject.Count -gt 0) {
            $Count = $MeasureObject.Count
            $Sum = $MeasureObject.Sum
            $AddtoCSV = "`n Total Count = $Count `n Total Size = $Sum"
            Try {
                $ChildItems | Export-CSV -Path $env:TEMP\$FileName
                $AddToCSV | Out-File $env:TEMP\$FileName -Append -Force
            }
            Catch {
                Write-Error "You may not have access to write to $env:TEMP.  Make sure you have proper permissions and that the file is not open."
            }
            Remove-Item -LiteralPath $ChildItems.'Full Path' -WhatIf
        }
        else {
            Write-Output "No Items Found!"
        }
    }
    End {

    }
}