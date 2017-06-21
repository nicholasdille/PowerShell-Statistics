function Get-SlidingAverage {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory,ValueFromPipeline)]
        [ValidateNotNullOrEmpty()]
        [array]
        $InputObject
        ,
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Property
        ,
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [int]
        $Size = 5
    )

    Begin {
        Write-Debug ('[{0}] Size of queue is <{1}>' -f $MyInvocation.MyCommand, $q.Count)
        $q = New-Object -TypeName System.Collections.Queue -ArgumentList $Size
    }

    Process {
        $InputObject | ForEach-Object {
            if (Get-Member -InputObject $_ -MemberType Properties -Name $Property) {
                throw ('[{0}] Unable to find property <{1}> in input object' -f $MyInvocation.MyCommand, $Property)
            }

            #region Enqueue new item and trim to specified size
            $q.Enqueue($_)
            Write-Debug ('[{0}] Size of queue is <{1}>' -f $MyInvocation.MyCommand, $q.Count)
            if ($q.Count -gt $Size) {
                $q.Dequeue() | Out-Null
            }
            #endregion

            #region Calculate average if the specified number of items is present
            if ($q.Count -eq $Size) {
                $q | Microsoft.PowerShell.Utility\Measure-Object -Property $Property -Average | Select-Object -ExpandProperty Average
            }
            #endregion
        }
    }
}

New-Alias -Name gsa -Value Get-SlidingAverage -Force