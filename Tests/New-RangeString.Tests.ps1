Import-Module -Name Statistics -Force

Describe 'New-RangeString' {
    InModuleScope Statistics {
        It 'Works with both indexes in bounds' {
            New-RangeString -Width 10 -LeftIndex  2 -RightIndex  8 | Should Be ' |-----|'
        }
        It 'Works with left index out of bounds' {
            New-RangeString -Width 10 -LeftIndex -2 -RightIndex  8 | Should Be '<------|'
        }
        It 'Works with both right index out of bounds' {
            New-RangeString -Width 10 -LeftIndex  2 -RightIndex 12 | Should Be ' |------->'
        }
        It 'Works with both indexes out of bounds' {
            New-RangeString -Width 10 -LeftIndex -2 -RightIndex 12 | Should Be '<-------->'
        }
        It 'Works with identical indexes' {
            New-RangeString -Width 10 -LeftIndex  2 -RightIndex  2 | Should Be ' ||'
        }
        It 'Works with zero indexes' {
            New-RangeString -Width 10 -LeftIndex  0 -RightIndex  0 | Should Be '||'
        }
    }
}