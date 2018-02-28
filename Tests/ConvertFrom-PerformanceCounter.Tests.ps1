#Get-ChildItem -Path "$env:BHModulePath" -Filter '*.ps1' -File | ForEach-Object {
#    . "$($_.FullName)"
#}

if ($env:PSModulePath -notlike '*Statistics*') {
    $env:PSModulePath = "$((Get-Item -Path "$PSScriptRoot\..").FullName);$env:PSModulePath"
}

Import-Module -Name Statistics -Force -ErrorAction 'Stop'

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