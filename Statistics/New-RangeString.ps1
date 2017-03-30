function New-RangeString {
    param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [int]
        $Width
        ,
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [int]
        $LeftIndex
        ,
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [int]
        $RightIndex
        ,
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]
        $LeftIndicator = '|'
        ,
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]
        $RightIndicator = '|'
    )

    Write-Debug ('[{0}] Width={1} LeftIndex={2} RightIndex={3}' -f $MyInvocation.MyCommand, $Width, $LeftIndex, $RightIndex)
    if ($LeftIndex -lt 0) {
        $LeftIndex = 1
        $LeftIndicator = '<'
    }
    Write-Debug ('[{0}] Width={1} LeftIndex={2} RightIndex={3}' -f $MyInvocation.MyCommand, $Width, $LeftIndex, $RightIndex)
    $line = ' ' * ($LeftIndex - 1) + $LeftIndicator
    if ($RightIndex -gt $Width) {
        $RightIndex = $Width
        $RightIndicator = '>'
    }
    Write-Debug ('[{0}] Width={1} LeftIndex={2} RightIndex={3}' -f $MyInvocation.MyCommand, $Width, $LeftIndex, $RightIndex)
    if ($RightIndex -gt $LeftIndex) {
        $line += '-' * ($RightIndex - $LeftIndex - 1)
    }
    $line += $RightIndicator

    $line
}