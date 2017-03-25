function Get-Histogram {
    [CmdletBinding(DefaultParameterSetName='BucketCount')]
    Param(
        [Parameter(Mandatory, ValueFromPipeline, Position=1)]
        [ValidateNotNullOrEmpty()]
        [array]
        $InputObject
        ,
        [Parameter(Mandatory, Position=2)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Property
        ,
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [float]
        $Minimum
        ,
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [float]
        $Maximum
        ,
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [Alias('Width')]
        [float]
        $BucketWidth = 1
        ,
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [Alias('Count')]
        [float]
        $BucketCount
    )

    Begin {
        Write-Verbose ('[{0}] Initializing' -f $MyInvocation.MyCommand)

        $Buckets = @{}
        $Data = @()
    }

    Process {
        Write-Verbose ('[{0}] Processing {1} items' -f $MyInvocation.MyCommand, $InputObject.Length)

        $InputObject | ForEach-Object {
            if (-Not ($_ | Select-Object -ExpandProperty $Property -ErrorAction SilentlyContinue)) {
                throw ('Input object does not contain a property called <{0}>.' -f $Property)
            }
            $Data += $_
        }
    }

    End {
        Write-Verbose ('[{0}] Building histogram' -f $MyInvocation.MyCommand)

        Write-Debug ('[{0}] Retrieving measurements from upstream cmdlet.' -f $MyInvocation.MyCommand)
        $Stats = $Data | Microsoft.PowerShell.Utility\Measure-Object -Minimum -Maximum -Property $Property

        if (-Not $PSBoundParameters.ContainsKey('Minimum')) {
            $Minimum = $Stats.Minimum
            Write-Debug ('[{0}] Minimum value not specified. Using smallest value ({1}) from input data.' -f $MyInvocation.MyCommand, $Minimum)
        }
        if (-Not $PSBoundParameters.ContainsKey('Maximum')) {
            $Maximum = $Stats.Maximum
            Write-Debug ('[{0}] Maximum value not specified. Using largest value ({1}) from input data.' -f $MyInvocation.MyCommand, $Maximum)
        }
        if (-Not $PSBoundParameters.ContainsKey('BucketCount')) {
            $BucketCount = [math]::Ceiling(($Maximum - $Minimum) / $BucketWidth)
            Write-Debug ('[{0}] Bucket count not specified. Calculated {1} buckets from width of {2}.' -f $MyInvocation.MyCommand, $BucketCount, $BucketWidth)
        }
        if ($BucketCount -gt 100) {
            Write-Warning ('[{0}] Generating {1} buckets' -f $MyInvocation.MyCommand, $BucketCount)
        }

        Write-Debug ('[{0}] Building buckets using: Minimum=<{1}> Maximum=<{2}> BucketWidth=<{3}> BucketCount=<{4}>' -f $MyInvocation.MyCommand, $Minimum, $Maximum, $BucketWidth, $BucketCount)
        $OverallCount = 0
        $Buckets = 1..$BucketCount | ForEach-Object {
            [pscustomobject]@{
                Index         = $_
                lowerBound    = $Minimum + ($_ - 1) * $BucketWidth
                upperBound    = $Minimum +  $_      * $BucketWidth
                Count         = 0
                RelativeCount = 0
                Group         = @()
                PSTypeName    = 'HistogramBucket'
            }
        }

        Write-Debug ('[{0}] Building histogram' -f $MyInvocation.MyCommand)
        $Data | ForEach-Object {
            $Value = $_.$Property
            
            if ($Value -ge $Minimum -and $Value -le $Maximum) {
                $BucketIndex = [math]::Floor(($Value - $Minimum) / $BucketWidth)
                if ($BucketIndex -lt $Buckets.Length) {
                    $Buckets[$BucketIndex].Count += 1
                    $Buckets[$BucketIndex].Group += $_
                    $OverallCount += 1
                }
            }
        }

        Write-Debug ('[{0}] Adding relative count' -f $MyInvocation.MyCommand)
        $Buckets | ForEach-Object {
            $_.RelativeCount = $_.Count / $OverallCount
        }

        Write-Debug ('[{0}] Returning histogram' -f $MyInvocation.MyCommand)
        $Buckets
    }
}

New-Alias -Name gh -Value Get-Histogram -Force