#Get-ChildItem -Path "$env:BHModulePath" -Filter '*.ps1' -File | ForEach-Object {
#    . "$($_.FullName)"
#}

if ($env:PSModulePath -notlike '*Statistics*') {
    $env:PSModulePath = "$((Get-Item -Path "$PSScriptRoot\..").FullName);$env:PSModulePath"
}

Import-Module -Name Statistics -Force -ErrorAction 'Stop'

Describe 'Measure-Object' {
    It 'Produces output from parameter' {
        $data = 0..10 | ConvertFrom-PrimitiveType
        $Stats = Measure-Object -Data $data -Property Value
        $Stats | Select-Object -ExpandProperty Property | Should Be 'Value'
    }
    It 'Produces correct Median for an odd number of values' {
        $data = 0..10 | ConvertFrom-PrimitiveType
        $Stats = Measure-Object -Data $data -Property Value
        $Stats.Median | Should Be 5
    }
    It 'Produces correct Median for an even number of values' {
        $data = 1..10 | ConvertFrom-PrimitiveType
        $Stats = Measure-Object -Data $data -Property Value
        $Stats.Median | Should Be 5.5
    }
}