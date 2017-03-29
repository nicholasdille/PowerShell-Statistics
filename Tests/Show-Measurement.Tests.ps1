Import-Module -Name Statistics -Force

Describe 'Show-Measurement' {
    $stats = 0..10 | ConvertFrom-PrimitiveType | Measure-Object -Property Value
    It 'Produces a string' {
        $graph = $stats | Show-Measurement
        $graph -is [string] | Should Be $true
    }
}