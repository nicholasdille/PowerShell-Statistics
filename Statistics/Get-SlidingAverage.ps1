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
            $q.Enqueue($_)
            Write-Debug ('[{0}] Size of queue is <{1}>' -f $MyInvocation.MyCommand, $q.Count)
            if ($q.Count -gt $Size) {
                $q.Dequeue() | Out-Null
            }
            if ($q.Count -eq $Size) {
                $q | Measure-Object -Property $Property -Average | Select-Object -ExpandProperty Average
            }
        }
    }
}

New-Alias -Name gsa -Value Get-SlidingAverage -Force