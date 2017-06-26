Import-Module -Name Statistics -Force

Describe 'Get-SlidingAverage' {
    It 'Produces output' {
        switch ([CultureInfo]::InstalledUICulture) {
            'de-DE' {
                $Counter = '\Prozessor(_Total)\Prozessorzeit (%)'
            }
            'en-US' {
                $Counter = '\Processor(_Total)\% Processor Time'
            }
        }
        $data = @(Get-Counter -Counter $Counter -SampleInterval 1 -MaxSamples 6 | ConvertFrom-PerformanceCounter -Instance _total | Get-SlidingAverage -Property Value -Size 5)
        $data -is [array] | Should Be $true
        $data.Length | Should Be 2
    }
}