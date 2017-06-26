Import-Module -Name Statistics -Force

Describe 'Show-Measurement' {
    $data = 0..10 | ConvertFrom-PrimitiveType
    $stats = Measure-Object -Data $data -Property Value
    It 'Produces output' {
        #Mock Write-Output {}
        $output = Show-Measurement -InputObject $stats
        #Assert-MockCalled Write-Output -Scope It -Times 1 -Exactly
        $output.Length -gt 0 | Should Be $true
    }
}