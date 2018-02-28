#Get-ChildItem -Path "$env:BHModulePath" -Filter '*.ps1' -File | ForEach-Object {
#    . "$($_.FullName)"
#}

if ($env:PSModulePath -notlike '*Statistics*') {
    $env:PSModulePath = "$((Get-Item -Path "$PSScriptRoot\..").FullName);$env:PSModulePath"
}

Import-Module -Name Statistics -Force -ErrorAction 'Stop'

Describe 'Get-Histogram' {
    $data = 1..10 | ConvertFrom-PrimitiveType
    It 'Produces output from parameter' {
        $histogram = Get-Histogram -Data $data -Property Value
        $histogram -is [array] | Should Be $true
        $histogram.Length | Should Be 9
    }
    It 'Produces output type [HistogramBucket]' {
        $item = Get-Histogram -Data $data -Property Value | Select-Object -First 1
        $item.PSTypeNames -contains 'HistogramBucket' | Should Be $true
    }
    It 'Honors minimum and maximum values' {
        $histogram = Get-Histogram -Data $data -Property Value -Minimum 2 -Maximum 5
        $histogram | Select-Object -First 1 -ExpandProperty lowerBound | Should Be 2
        $histogram | Select-Object -Last  1 -ExpandProperty upperBound | Should Be 5
    }
    It 'Warns for large number of buckets' {
        $data = 1..110 | ConvertFrom-PrimitiveType
        Mock Write-Warning {}
        Get-Histogram -Data $data -Property Value
        Assert-MockCalled -CommandName Write-Warning -Times 1 -Exactly
    }
    It 'Produces empty histogram' {
        $data = 1..10 + 20..30 | ConvertFrom-PrimitiveType
        $histogram = Get-Histogram -Data $data -Property Value -Minimum 11 -Maximum 19
        $histogram
    }
}