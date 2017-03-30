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
        $Width = $( if ($Host -and $Host.UI) { $Host.UI.RawUI.MaxWindowSize.Width - 10 } else { 90 } )
        ,
        [switch]
        $PassThru
    )

    Process {
        #region Generate visualization of measurements
        $AvgSubDevIndex  = [math]::Round(($InputObject.Average - $InputObject.StandardDeviation) / $InputObject.Maximum * $Width, 0)
        $AvgIndex        = [math]::Round( $InputObject.Average                                   / $InputObject.Maximum * $Width, 0)
        $AvgAddDevIndex  = [math]::Round(($InputObject.Average + $InputObject.StandardDeviation) / $InputObject.Maximum * $Width, 0)
        $AvgSubConfIndex = [math]::Round(($InputObject.Average - $InputObject.Confidence95)      / $InputObject.Maximum * $Width, 0)
        $AvgAddConfIndex = [math]::Round(($InputObject.Average + $InputObject.Confidence95)      / $InputObject.Maximum * $Width, 0)
        $MedIndex        = [math]::Round( $InputObject.Median                                    / $InputObject.Maximum * $Width, 0)
        $P10Index        = [math]::Round( $InputObject.Percentile10                              / $InputObject.Maximum * $Width, 0)
        $P25Index        = [math]::Round( $InputObject.Percentile25                              / $InputObject.Maximum * $Width, 0)
        $P75Index        = [math]::Round( $InputObject.Percentile75                              / $InputObject.Maximum * $Width, 0)
        $P90Index        = [math]::Round( $InputObject.Percentile90                              / $InputObject.Maximum * $Width, 0)
        $P25SubTukIndex  = [math]::Round(($InputObject.Percentile25 - $InputObject.TukeysRange)  / $InputObject.Maximum * $Width, 0)
        $P75AddTukIndex  = [math]::Round(($InputObject.Percentile75 + $InputObject.TukeysRange)  / $InputObject.Maximum * $Width, 0)

        Write-Debug "P10=$P10Index P25=$P25Index A=$AvgIndex M=$MedIndex sA=$AvgSubDevIndex As=$AvgAddDevIndex cA=$AvgSubConfIndex aC=$AvgAddConfIndex P75=$P75Index P90=$P90Index"

        $graph = @()
        $graph += 'Range             : ' + '---------|' * ($Width / 10)
        $graph += '10% Percentile    : ' + ' '          *  $P10Index + 'P10'
        $graph += '25% Percentile    : ' + ' '          *  $P25Index + 'P25'
        $graph += 'Average           : ' + ' '          *  $AvgIndex + 'A'
        $graph += 'Standard Deviation: ' + (New-RangeString -Width $Width -LeftIndex $AvgSubDevIndex  -RightIndex $AvgAddDevIndex  -LeftIndicator 's' -RightIndicator 'S')
        $graph += '95% Confidence    : ' + (New-RangeString -Width $Width -LeftIndex $AvgSubConfIndex -RightIndex $AvgAddConfIndex -LeftIndicator 'c' -RightIndicator 'C')
        $graph += 'Tukeys Range      : ' + (New-RangeString -Width $Width -LeftIndex $P25SubTukIndex  -RightIndex $P75AddTukIndex  -LeftIndicator 'o' -RightIndicator 'O')
        $graph += 'Median            : ' + ' '          * $MedIndex + 'M'
        $graph += '75% Percentile    : ' + ' '          * $P75Index + 'P75'
        $graph += '90% Percentile    : ' + ' '          * $P90Index + 'P90'
        $graph += 'Range             : ' + '---------|' * ($Width / 10)
        #endregion

        #region Return graph
        if ($PassThru) {
            $InputObject
        }
        Write-Host ($graph -join "`n")
        #endregion
    }
}

New-Alias -Name sm -Value Show-Measurement -Force