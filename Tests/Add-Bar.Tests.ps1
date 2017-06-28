Get-ChildItem -Path "$env:BHModulePath" -Filter '*.ps1' -File | ForEach-Object {
    . "$($_.FullName)"
}

Describe 'Add-Bar' {
    It 'Produces bars from parameter' {
        $data = Get-Process | Select-Object -Property Name,Id,WorkingSet64
        $bars = Add-Bar -InputObject $data -Property WorkingSet64 -Width 50
        $bars | ForEach-Object {
            $_.PSObject.Properties | Where-Object Name -eq 'Bar' | Select-Object -ExpandProperty Name | Should Be 'Bar'
        }
    }
    It 'Produces bars from pipeline' {
        $data = Get-Process | Select-Object -Property Name,Id,WorkingSet64
        $bars = $data | Add-Bar -Property WorkingSet64 -Width 50
        $bars | ForEach-Object {
            $_.PSObject.Properties | Where-Object Name -eq 'Bar' | Select-Object -ExpandProperty Name | Should Be 'Bar'
        }
    }
    It 'Produces correct output type' {
        $item = Get-Process | Add-Bar -Property WorkingSet64 -Width 50 | Select-Object -First 1
        $item.PSTypeNames -contains 'HistogramBar' | Should Be $true
    }
    It 'Has one bar of maximum width' {
        $data = Get-Process | Select-Object -Property Name,Id,WorkingSet64
        $bars = Add-Bar -InputObject $data -Property WorkingSet64 -Width 50
        $bars | Where-Object { $_.Bar.Length -eq 50 } | Should Not Be $null
    }
    It 'Dies on missing property' {
        $data = 1..10
        { Add-Bar -InputObject $data -Property Value } | Should Throw
        $data = 11..20
        { $data | Add-Bar -Property Value } | Should Throw
    }
}