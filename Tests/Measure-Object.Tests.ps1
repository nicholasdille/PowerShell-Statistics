Import-Module -Name Statistics -Force

Describe 'Measure-Object' {
    It 'Produces output from parameter' {
        $data = 0..10 | ConvertFrom-PrimitiveType
        $Stats = Measure-Object -InputObject $data -Property Value
        $Stats | Select-Object -ExpandProperty Property | Should Be 'Value'
    }
    It 'Produces output from pipeline' {
        $data = 0..10 | ConvertFrom-PrimitiveType
        $Stats = $data | Measure-Object -Property Value
        $Stats | Select-Object -ExpandProperty Property | Should Be 'Value'
    }
    It 'Produces correct Median for an odd number of values' {
        $data = 0..10 | ConvertFrom-PrimitiveType
        $Stats = Measure-Object -InputObject $data -Property Value
        $Stats.Median | Should Be 5
    }
    It 'Produces correct Median for an even number of values' {
        $data = 1..10 | ConvertFrom-PrimitiveType
        $Stats = Measure-Object -InputObject $data -Property Value
        $Stats.Median | Should Be 5.5
    }
    It 'Dies on missing property' {
        $data = 1..10
        { Measure-Object -InputObject $data -Property -Value } | Should Throw
    }
}