#Get-ChildItem -Path "$env:BHModulePath" -Filter '*.ps1' -File | ForEach-Object {
#    . "$($_.FullName)"
#}

if ($env:PSModulePath -notlike '*Statistics*') {
    $env:PSModulePath = "$((Get-Item -Path "$PSScriptRoot\..").FullName);$env:PSModulePath"
}

Import-Module -Name Statistics -Force -ErrorAction 'Stop'

Describe 'ConvertFrom-PrimitiveType' {
    $array = @(1, 2, 3)
    It 'Produces output from parameter' {
        $data = ConvertFrom-PrimitiveType -InputObject $array
        $data -is [array] | Should Be $true
        $data.Length | Should Be $array.Length
    }
    It 'Produces output from pipeline' {
        $data = $array | ConvertFrom-PrimitiveType
        $data -is [array] | Should Be $true
        $data.Length | Should Be $array.Length
    }
    It 'Throws on piped complex type' {
        { Get-Process | Select-Object -First 1 | ConvertFrom-PrimitiveType } | Should Throw
    }
}