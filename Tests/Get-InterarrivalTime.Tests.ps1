Import-Module -Name Statistics -Force

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
        { $data.InterarrivalTicks } | Should Not Throw
    }
}