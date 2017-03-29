Import-Module -Name Statistics -Force

Describe 'Get-SlidingAverage' {
    It 'Produces output' {
        $data = @(Get-Counter -Counter '\Processor(_Total)\% Processor Time' -SampleInterval 1 -MaxSamples 6 | ConvertFrom-PerformanceCounter -Instance _total | Get-SlidingAverage -Property Value -Size 5)
        $data -is [array] | Should Be $true
        $data.Length | Should Be 2
    }
}