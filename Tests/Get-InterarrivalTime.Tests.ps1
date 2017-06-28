Get-ChildItem -Path "$env:BHModulePath" -Filter '*.ps1' -File | ForEach-Object {
    . "$($_.FullName)"
}

Describe 'Get-InterarrivalTime' {
    $now = Get-Date
    $data = 1..10 | ForEach-Object {
        [pscustomobject]@{
            Timestamp = Get-Random -Minimum $now.AddDays(-1).Ticks -Maximum $now.Ticks
            Value     = Get-Random -Minimum 0 -Maximum 100
        }
    } | Sort-Object -Property Timestamp
    It 'Produces the correct members' {
        $data = $data | Get-InterarrivalTime -Property Timestamp
        { $data | Select-Object -ExpandProperty InterarrivalTicks -ErrorAction SilentlyContinue } | Should Not Throw
    }
}