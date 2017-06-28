Get-ChildItem -Path "$env:BHModulePath" -Filter '*.ps1' -File | ForEach-Object {
    . "$($_.FullName)"
}

Describe 'Get-WeightedValue' {
    It 'Throws on missing property' {
        $data = [pscustomobject]@{
            Vaule = 5
            Weight = 2
        }
        { $data | Get-WeightedValue -Property Value -WeightProperty Weight } | Should Throw
    }
    It 'Throws on missing weight property' {
        $data = [pscustomobject]@{
            Value = 5
            Weigth = 2
        }
        { $data | Get-WeightedValue -Property Value -WeightProperty Weight } | Should Throw
    }
    It 'Produces the correct members' {
        $data = [pscustomobject]@{
            Value = 5
            Weight = 2
        }
        $result = @($data | Get-WeightedValue -Property Value -WeightProperty Weight)
        $result -is [array] | Should Be $true
        $result.Length | Should Be 1
        { $result[0] | Select-Object -ExpandProperty Value -ErrorAction SilentlyContinue } | Should Not Throw
    }
}