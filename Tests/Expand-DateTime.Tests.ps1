Import-Module -Name Statistics -Force

Describe 'Expand-DateTime' {
    switch ([CultureInfo]::InstalledUICulture) {
        'de-DE' {
            $Counter = '\Prozessor(_Total)\Prozessorzeit (%)'
        }
        'en-US' {
            $Counter = '\Processor(_Total)\% Processor Time'
        }
    }
    It 'Works on property implicitly' {
        { Get-Counter -Counter $Counter | Expand-DateTime } | Should Not Throw
    }
    It 'Works on property explicitly' {
        { Get-Counter -Counter $Counter | Expand-DateTime -Property Timestamp } | Should Not Throw
    }
    It 'Produces the correct members' {
        $data = Get-Counter -Counter $Counter | Expand-DateTime
        { $data | Select-Object -ExpandProperty Timestamp -ErrorAction SilentlyContinue } | Should Not Throw
        { $data | Select-Object -ExpandProperty Value     -ErrorAction SilentlyContinue } | Should Not Throw
        { $data | Select-Object -ExpandProperty DayOfWeek -ErrorAction SilentlyContinue } | Should Not Throw
        { $data | Select-Object -ExpandProperty Year      -ErrorAction SilentlyContinue } | Should Not Throw
        { $data | Select-Object -ExpandProperty Month     -ErrorAction SilentlyContinue } | Should Not Throw
        { $data | Select-Object -ExpandProperty Hour      -ErrorAction SilentlyContinue } | Should Not Throw
    }
}