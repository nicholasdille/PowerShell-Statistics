function Get-ExampleTimeSeries {
    [CmdletBinding()]
    param(
        [int]
        $Count = 100
        ,
        [datetime]
        $Start
        ,
        [datetime]
        $End = (Get-Date)
        ,
        [int]
        $IntervalDays = 7
    )

    if (-Not $Start) {
        $Start = $End.AddDays(-1 * $IntervalDays)
    }

    $StartTicks = $Start.Ticks
    $EndTicks = $End.Ticks

    1..$Count | ForEach-Object {
        Get-Random -Minimum $StartTicks -Maximum $EndTicks
    } | Sort-Object | ForEach-Object {
        [pscustomobject]@{
            Timestamp = Get-Date -Date $_
            Value     = Get-Random -Minimum 0 -Maximum 100
        }
    }
}