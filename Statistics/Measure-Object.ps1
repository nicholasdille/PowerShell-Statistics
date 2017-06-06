function Measure-Object {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [array]
        $Data
        ,
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Property
    )

    Process {
        #region Percentiles require sorted data
        $Data = $Data | Sort-Object -Property $Property
        #endregion

        #region Grab basic measurements from upstream Measure-Object
        $Stats = $Data | Microsoft.PowerShell.Utility\Measure-Object -Property $Property -Minimum -Maximum -Sum -Average
        #endregion
        
        #region Calculate median
        Write-Debug ('[{0}] Number of data items is <{1}>' -f $MyInvocation.MyCommand.Name, $Data.Count)
        if ($Data.Count % 2 -eq 0) {
            Write-Debug ('[{0}] Even number of data items' -f $MyInvocation.MyCommand.Name)

            $MedianIndex = ($Data.Count / 2) - 1
            Write-Debug ('[{0}] Index of Median is <{1}>' -f $MyInvocation.MyCommand.Name, $MedianIndex)
            
            $LowerMedian = $Data[$MedianIndex] | Select-Object -ExpandProperty $Property
            $UpperMedian = $Data[$MedianIndex + 1] | Select-Object -ExpandProperty $Property
            Write-Debug ('[{0}] Lower Median is <{1}> and upper Median is <{2}>' -f $MyInvocation.MyCommand.Name, $LowerMedian, $UpperMedian)
            
            $Median = ([double]$LowerMedian + [double]$UpperMedian) / 2
            Write-Debug ('[{0}] Average of lower and upper Median is <{1}>' -f $MyInvocation.MyCommand.Name, $Median)

        } else {
            Write-Debug ('[{0}] Odd number of data items' -f $MyInvocation.MyCommand.Name)

            $MedianIndex = [math]::Ceiling(($Data.Count - 1) / 2)
            Write-Debug ('[{0}] Index of Median is <{1}>' -f $MyInvocation.MyCommand.Name, $MedianIndex)

            $Median = $Data[$MedianIndex] | Select-Object -ExpandProperty $Property
            Write-Debug ('[{0}] Median is <{1}>' -f $MyInvocation.MyCommand.Name, $Median)
        }
        Add-Member -InputObject $Stats -MemberType NoteProperty -Name 'Median' -Value $Median
        #endregion

        #region Calculate variance
        $Variance = 0
        foreach ($_ in $Data) {
            $Variance += [math]::Pow($_.$Property - $Stats.Average, 2) / $Stats.Count
        }
        $Variance /= $Stats.Count
        Add-Member -InputObject $Stats -MemberType NoteProperty -Name 'Variance' -Value $Variance
        #endregion

        #region Calculate standard deviation
        $StandardDeviation = [math]::Sqrt($Stats.Variance)
        Add-Member -InputObject $Stats -MemberType NoteProperty -Name 'StandardDeviation' -Value $StandardDeviation
        #endregion

        #region Calculate percentiles
        $Percentile10Index = [math]::Ceiling(10 / 100 * $Data.Count)
        $Percentile25Index = [math]::Ceiling(25 / 100 * $Data.Count)
        $Percentile75Index = [math]::Ceiling(75 / 100 * $Data.Count)
        $Percentile90Index = [math]::Ceiling(90 / 100 * $Data.Count)
        Add-Member -InputObject $Stats -MemberType NoteProperty -Name 'Percentile10' -Value $Data[$Percentile10Index].$Property
        Add-Member -InputObject $Stats -MemberType NoteProperty -Name 'Percentile25' -Value $Data[$Percentile25Index].$Property
        Add-Member -InputObject $Stats -MemberType NoteProperty -Name 'Percentile75' -Value $Data[$Percentile75Index].$Property
        Add-Member -InputObject $Stats -MemberType NoteProperty -Name 'Percentile90' -Value $Data[$Percentile90Index].$Property
        #endregion

        #region Calculate Tukey's range for outliers
        $TukeysOutlier = 1.5
        $TukeysRange = $TukeysOutlier * ($Stats.Percentile75 - $Stats.Percentile25)
        Add-Member -InputObject $Stats -MemberType NoteProperty -Name TukeysRange -Value $TukeysRange
        #endregion

        #region Calculate confidence intervals
        $z = @{
            '90' = 1.645
            '95' = 1.96
            '98' = 2.326
            '99' = 2.576
        }
        $Confidence95 = 1.96 * $Stats.StandardDeviation / [math]::Sqrt($Stats.Count)
        Add-Member -InputObject $Stats -MemberType NoteProperty -Name 'Confidence95' -Value $Confidence95
        #endregion

        #region Return measurements
        $Stats
        #endregion
    }
}

New-Alias -Name mo -Value Measure-Object -Force