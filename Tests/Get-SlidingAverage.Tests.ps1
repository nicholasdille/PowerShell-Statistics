#Get-ChildItem -Path "$env:BHModulePath" -Filter '*.ps1' -File | ForEach-Object {
#    . "$($_.FullName)"
#}

if ($env:PSModulePath -notlike '*Statistics*') {
    $env:PSModulePath = "$((Get-Item -Path "$PSScriptRoot\..").FullName);$env:PSModulePath"
}

Import-Module -Name Statistics -Force -ErrorAction 'Stop'

Describe 'Get-SlidingAverage' {
    switch ([CultureInfo]::InstalledUICulture) {
        'de-DE' {
            $Counter = '\Prozessor(_Total)\Prozessorzeit (%)'
        }
        'en-US' {
            $Counter = '\Processor(_Total)\% Processor Time'
        }
    }
    It 'Produces output' {
        $data = @(Get-Counter -Counter $Counter -SampleInterval 1 -MaxSamples 6 | ConvertFrom-PerformanceCounter -Instance _total | Get-SlidingAverage -Property Value -Size 5)
        $data -is [array] | Should Be $true
        $data.Length | Should Be 2
    }
    It 'Throws on missing property' {
        { Get-Counter -Counter $Counter -SampleInterval 1 -MaxSamples 6 | ConvertFrom-PerformanceCounter -Instance _total | Get-SlidingAverage -Property Value2 -Size 5 } | Should Throw
    }
}