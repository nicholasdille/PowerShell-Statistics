function Get-InterarrivalTime {
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
        [ValidateSet('Ticks', 'TotalSecond', 'Minutes', 'Hours', 'Days')]
        [string]
        $Unit = 'Ticks'
    )

    Begin {
        Write-Debug ('[{0}] Entering begin block' -f $MyInvocation.MyCommand)
        $PreviousArrival = $null
    }

    Process {
        Write-Debug ('[{0}] Entering process block' -f $MyInvocation.MyCommand)
        $InputObject | ForEach-Object {
            Write-Debug ('[{0}] Processing value' -f $MyInvocation.MyCommand)
            if ($PreviousArrival) {
                Write-Debug ('[{0}] Calculating interarrival time' -f $MyInvocation.MyCommand)
                Add-Member -InputObject $_ -MemberType NoteProperty -Name "Interarrival$Unit" -Value (New-TimeSpan -Start $PreviousArrival.$Property -End $_.$Property | Select-Object -ExpandProperty $Unit) -PassThru
            }
            $PreviousArrival = $_
        }
    }
}

New-Alias -Name giat -Value Get-InterarrivalTime -Force