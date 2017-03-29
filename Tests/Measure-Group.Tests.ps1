Import-Module -Name Statistics -Force

Describe 'Measure-Group' {
    It 'Produces correct members' {
        $now = Get-Date
        $data = 1..10 | ForEach-Object {
            [pscustomobject]@{
                Timestamp = Get-Random -Minimum $now.AddDays(-1).Ticks -Maximum $now.Ticks
                Value     = Get-Random -Minimum 0 -Maximum 100
            }
        } | Sort-Object -Property Timestamp
        $group = $data | Expand-DateTime | Group-Object -Property Hour | Measure-Group -Property Value
        { $group.Average } | Should Not Throw
    }
}