Get-ChildItem -Path "$env:BHModulePath" -Filter '*.ps1' -File | ForEach-Object {
    . "$($_.FullName)"
}

Describe 'Get-ExampleTimeSeries' {
    $end = (Get-Date)
    $start = $end.AddDays(-3)
    $count = 25
    $data = Get-ExampleTimeSeries -Start $start -End $end -Count $count
    It 'Produces data of correct length' {
        $data -is [array] | Should Be $true
        $data.Length | Should Be $count
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
    It 'Calculated the time range correctly' {
        $data = Get-ExampleTimeSeries -Interval 3 -Count $count
        $stats = $data | Microsoft.PowerShell.Utility\Measure-Object -Property Timestamp -Minimum -Maximum
        $stats.Minimum | Should BeGreaterThan $start
        $stats.Maximum | Should BeLessThan $end
    }
}