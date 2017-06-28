Get-ChildItem -Path "$env:BHModulePath" -Filter '*.ps1' -File | ForEach-Object {
    . "$($_.FullName)"
}

Describe 'Show-Measurement' {
    $data = 0..10 | ConvertFrom-PrimitiveType
    $stats = Measure-Object -Data $data -Property Value
    It 'Produces output' {
        Mock Write-Host {}
        Show-Measurement -InputObject $stats
        Assert-MockCalled Write-Host -Scope It -Times 1 -Exactly
    }
    It 'Produces input object' {
        Mock Write-Host {}
        $input = Show-Measurement -InputObject $stats -PassThru
        $input | Should Be $stats
    }
}