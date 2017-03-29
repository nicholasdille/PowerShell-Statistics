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
        { $data.Timestamp } | Should Not Throw
        { $data.Value } | Should Not Throw
        { $data.DayOfWeek } | Should Not Throw
        { $data.Year } | Should Not Throw
        { $data.Month } | Should Not Throw
        { $data.Hour } | Should Not Throw
    }
}