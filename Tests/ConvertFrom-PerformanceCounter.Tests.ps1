Import-Module -Name Statistics -Force

Describe 'ConvertFrom-PerformanceCounter' {
    It 'Produces the correct properties' {
        switch ([CultureInfo]::InstalledUICulture) {
            'de-DE' {
                $Counter = '\Prozessor(_Total)\Prozessorzeit (%)'
            }
            'en-US' {
                $Counter = '\Processor(_Total)\% Processor Time'
            }
        }
        $data = Get-Counter -Counter $Counter | ConvertFrom-PerformanceCounter -Instance _total
        { $data | Select-Object -ExpandProperty Timestamp -ErrorAction SilentlyContinue } | Should Not Throw
        { $data | Select-Object -ExpandProperty Value     -ErrorAction SilentlyContinue } | Should Not Throw
    }
}