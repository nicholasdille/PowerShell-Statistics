Import-Module -Name Statistics -Force

Describe 'ConvertFrom-PerformanceCounter' {
    It 'Produces the correct properties' {
        $data = Get-Counter -Counter '\processor(_total)\% processor time' | ConvertFrom-PerformanceCounter -Instance _total
        { $data.Timestamp } | Should Not Throw
        { $data.Value } | Should Not Throw
    }
}