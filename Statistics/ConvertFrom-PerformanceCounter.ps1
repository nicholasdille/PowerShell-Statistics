function ConvertFrom-PerformanceCounter {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory,ValueFromPipeline)]
        [ValidateNotNullOrEmpty()]
        [array]
        $InputObject
        ,
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Instance
    )

    Process {
        $InputObject | ForEach-Object {
            [pscustomobject]@{
                Timestamp = $_.Timestamp
                Value     = $_.CounterSamples | Where-Object { $_.InstanceName -ieq $Instance } | Select-Object -ExpandProperty CookedValue
            }
        }
    }
}

New-Alias -Name cfpc -Value ConvertFrom-PerformanceCounter -Force