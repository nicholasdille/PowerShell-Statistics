function Show-Measurement {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [ValidateNotNullOrEmpty()]
        [object]
        $InputObject
        ,
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [int]
        $Width = 100
    )

    Process {
        #region Generate visualization of measurements
        $AvgSubDevIndex  = [math]::Round(($InputObject.Average - $InputObject.StandardDeviation) / $InputObject.Maximum * $Width, 0) - 1
        $AvgIndex        = [math]::Round( $InputObject.Average                                   / $InputObject.Maximum * $Width, 0) - 1
        $Dev2AvgIndex    = $AvgIndex - $AvgSubDevIndex  - 1
        $AvgAddDevIndex  = [math]::Round(($InputObject.Average + $InputObject.StandardDeviation) / $InputObject.Maximum * $Width, 0) - 1
        $Avg2DevIndex    = $AvgAddDevIndex  - $AvgIndex - 1
        $AvgSubConfIndex = [math]::Round(($InputObject.Average - $InputObject.Confidence95)      / $InputObject.Maximum * $Width, 0) - 1
        $Conf2AvgIndex   = $AvgIndex - $AvgSubConfIndex - 1
        $AvgAddConfIndex = [math]::Round(($InputObject.Average + $InputObject.Confidence95)      / $InputObject.Maximum * $Width, 0) - 1
        $Avg2ConfIndex   = $AvgAddConfIndex - $AvgIndex - 1
        $MedIndex        = [math]::Round( $InputObject.Median                                    / $InputObject.Maximum * $Width, 0) - 1
        $P10Index        = [math]::Round( $InputObject.Percentile10                              / $InputObject.Maximum * $Width, 0) - 1
        $P25Index        = [math]::Round( $InputObject.Percentile25                              / $InputObject.Maximum * $Width, 0) - 1
        $P75Index        = [math]::Round( $InputObject.Percentile75                              / $InputObject.Maximum * $Width, 0) - 1
        $P90Index        = [math]::Round( $InputObject.Percentile90                              / $InputObject.Maximum * $Width, 0) - 1

        Write-Debug ('P10Index=<{0}>' -f $P10Index)

        $graph = @()
        $graph += '---------|' * ($Width / 10)
        $graph += ' '          *  $P10Index + 'P10'
        $graph += ' '          *  $P25Index + 'P25'
        $graph += ' '          *  $AvgIndex + 'A'
        if ($AvgSubDevIndex  -ge 1 -and $Dev2AvgIndex  -ge 1 -and $Avg2DevIndex  -ge 1) {
            $graph += ' ' * $AvgSubDevIndex  + 's' + ('-' * ($Dev2AvgIndex  + $Avg2DevIndex))  + 'S'
        }
        if ($AvgSubConfIndex -ge 1 -and $Conf2AvgIndex -ge 1 -and $Avg2ConfIndex -ge 1) {
            $graph += ' ' * $AvgSubConfIndex + 'c' + ('-' * ($Conf2AvgIndex + $Avg2ConfIndex)) + 'C'
        }
        $graph += ' '          * $MedIndex + 'M'
        $graph += ' '          * $P75Index + 'P75'
        $graph += ' '          * $P90Index + 'P90'
        $graph += '---------|' * ($Width / 10)
        #endregion

        #region Return graph
        $graph -join "`n"
        #endregion
    }
}

New-Alias -Name sm -Value Show-Measurement -Force