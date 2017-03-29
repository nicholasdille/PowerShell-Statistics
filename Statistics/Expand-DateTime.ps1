function Expand-DateTime {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory,ValueFromPipeline)]
        [ValidateNotNullOrEmpty()]
        [array]
        $InputObject
        ,
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]
        $Property = 'Timestamp'
    )

    Process {
        Write-Debug ('[{0}] Entering process block' -f $MyInvocation.MyCommand)
        $InputObject | ForEach-Object {
            Write-Debug 'inside foreach'
            if (($_ | Select-Object -ExpandProperty $Property -ErrorAction 'SilentlyContinue') -eq $null) {
                throw ('[{0}] Unable to find property <{1}> in input object' -f $MyInvocation.MyCommand, $Property)
            }

            $DateTimeExpanded = $_.$Property
            if ($DateTimeExpanded -isnot [System.DateTime]) {
                Write-Debug 'inside if'
                $DateTimeExpanded = Get-Date -Date $_.$Property
            }

            foreach ($DateTimeProperty in @('DayOfWeek', 'Year', 'Month', 'Hour')) {
                Add-Member -InputObject $_ -MemberType NoteProperty -Name $DateTimeProperty -Value $DateTimeExpanded.$DateTimeProperty
            }
            Add-Member -InputObject $_ -MemberType NoteProperty -Name WeekOfYear -Value (Get-Date -Date $_.$Property -UFormat '%V')

            $_
        }
    }
}

New-Alias -Name edt -Value Expand-DateTime -Force