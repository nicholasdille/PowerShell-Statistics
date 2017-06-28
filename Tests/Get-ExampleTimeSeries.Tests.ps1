#Import-Module -Name Statistics -Force
. "$PSScriptRoot\..\Statistics\Get-ExampleTimeSeries.ps1"

Describe 'Get-ExampleTimeSeries' {
    $end = (Get-Date)
    $start = $end.AddDays(-3)
    $count = 25
    $data = Get-ExampleTimeSeries -Start $start -End $end
    It 'Produces data of correct length' {
        $data -is [array] | Should Be $true
        $data.Length | Should Be 100
    }
    It 'Honours the defined time range' {
        $stats = $data | Microsoft.PowerShell.Utility\Measure-Object -Property Timestamp -Minimum -Maximum
        $stats.Minimum | Should BeGreaterThan $start
        $stats.Maximum | Should BeLessThan $end
    }
    It 'Produces the correct range of values' {
        $stats = $data | Microsoft.PowerShell.Utility\Measure-Object -Property Value -Minimum -Maximum
        $stats.Minimum -ge 0 | Should Be $true
        $stats.Maximum | Should BeLessThan 100
    }
}