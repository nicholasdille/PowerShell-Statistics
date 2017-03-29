Import-Module -Name Statistics -Force

Describe 'Expand-DateTime' {
    It 'Works on property implicitly' {
        { Get-Counter -Counter '\Processor(_Total)\% Processor Time' | Expand-DateTime } | Should Not Throw
    }
    It 'Works on property explicitly' {
        { Get-Counter -Counter '\Processor(_Total)\% Processor Time' | Expand-DateTime -Property Timestamp } | Should Not Throw
    }
    It 'Produces the correct members' {
        $data = Get-Counter -Counter '\Processor(_Total)\% Processor Time' | Expand-DateTime
        { $data | Select-Object -ExpandProperty Timestamp -ErrorAction SilentlyContinue } | Should Not Throw
        { $data | Select-Object -ExpandProperty Value     -ErrorAction SilentlyContinue } | Should Not Throw
        { $data | Select-Object -ExpandProperty DayOfWeek -ErrorAction SilentlyContinue } | Should Not Throw
        { $data | Select-Object -ExpandProperty Year      -ErrorAction SilentlyContinue } | Should Not Throw
        { $data | Select-Object -ExpandProperty Month     -ErrorAction SilentlyContinue } | Should Not Throw
        { $data | Select-Object -ExpandProperty Hour      -ErrorAction SilentlyContinue } | Should Not Throw
    }
}