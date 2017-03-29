Import-Module -Name Statistics -Force

Describe 'ConvertFrom-PerformanceCounter' {
    It 'Produces the correct properties' {
        $data = Get-Counter -Counter '\processor(_total)\% processor time' | ConvertFrom-PerformanceCounter -Instance _total
        { $data | Select-Object -ExpandProperty Timestamp -ErrorAction SilentlyContinue } | Should Not Throw
        { $data | Select-Object -ExpandProperty Value     -ErrorAction SilentlyContinue } | Should Not Throw
    }
}