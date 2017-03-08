function Get-Histogram {
    [CmdletBinding(DefaultParameterSetName='BucketCount')]
    [OutputType([HistogramBucket])]
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
        $Buckets = @{}
        $Data = @()
    }

    Process {
        $InputObject | ForEach-Object {
            if (-Not ($_ | Select-Object -ExpandProperty $Property -ErrorAction SilentlyContinue)) {
                throw ('Input object does not contain a property called <{0}>.' -f $Property)
            }
            $Data += $_
        }
    }

    End {
        $Stats = $Data | Microsoft.PowerShell.Utility\Measure-Object -Minimum -Maximum -Property $Property
        if (-Not $PSBoundParameters.ContainsKey('Minimum')) {
            $Minimum = $Stats.Minimum
        }
        if (-Not $PSBoundParameters.ContainsKey('Maximum')) {
            $Maximum = $Stats.Maximum
        }
        if (-Not $PSBoundParameters.ContainsKey('BucketCount')) {
            $BucketCount = [math]::Ceiling(($Maximum - $Minimum) / $BucketWidth)
        }
        if ($BucketCount -gt 100) {
            Write-Warning ('[{0}] Generating {1} buckets' -f $MyInvocation.MyCommand, $BucketCount)
        }
        Write-Verbose ('Minimum=<{0}> Maximum=<{1}> BucketWidth=<{2}> BucketCount=<{3}>' -f $Minimum, $Maximum, $BucketWidth, $BucketCount)

        $OverallCount = 0
        $Buckets = 1..$BucketCount | ForEach-Object {
            [HistogramBucket]@{
                Index         = $_
                lowerBound    = $Minimum + ($_ - 1) * $BucketWidth
                upperBound    = $Minimum +  $_      * $BucketWidth
                Count         = 0
                RelativeCount = 0
                Group         = @()
            }
        }
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
        $Buckets | ForEach-Object {
            $_.RelativeCount = $_.Count / $OverallCount
        }

        $Buckets
    }
}

New-Alias -Name gh -Value Get-Histogram -Force