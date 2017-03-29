Import-Module -Name Statistics -Force

Describe 'Get-Histogram' {
    $data = 1..10 | ConvertFrom-PrimitiveType
    It 'Produces output from parameter' {
        $histogram = Get-Histogram -InputObject $data -Property Value
        $histogram -is [array] | Should Be $true
        $histogram.Length | Should Be 9
    }
    It 'Produces output from pipeline' {
        $histogram = $data | Get-Histogram -Property Value
        $histogram -is [array] | Should Be $true
        $histogram.Length | Should Be 9
    }
    It 'Produces output type [HistogramBucket]' {
        $item = $data | Get-Histogram -Property Value | Select-Object -First 1
        $item.PSTypeNames -contains 'HistogramBucket' | Should Be $true
    }
    It 'Honors minimum and maximum values' {
        $histogram = Get-Histogram -InputObject $data -Property Value -Minimum 2 -Maximum 5
        $histogram | Select-Object -First 1 -ExpandProperty lowerBound | Should Be 2
        $histogram | Select-Object -Last  1 -ExpandProperty upperBound | Should Be 5
    }
    It 'Dies on missing property' {
        $data = 1..10
        { Get-Histogram -InputObject $data -Property Value } | Should Throw
    }
}