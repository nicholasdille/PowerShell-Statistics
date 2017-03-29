function Get-WeightedValue {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory,ValueFromPipeline)]
        [ValidateNotNullOrEmpty()]
        [array]
        $InputObject
        ,
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Property
        ,
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]
        $WeightProperty
    )

    Process {
        $InputObject | ForEach-Object {
            if (($_ | Select-Object -ExpandProperty $Property -ErrorAction 'SilentlyContinue') -eq $null) {
                throw ('[{0}] Unable to find property <{1}> in input object' -f $MyInvocation.MyCommand, $Property)
            }
            if (($_ | Select-Object -ExpandProperty $WeightProperty -ErrorAction 'SilentlyContinue') -eq $null) {
                throw ('[{0}] Unable to find weight property <{1}> in input object' -f $MyInvocation.MyCommand, $WeightProperty)
            }

            [pscustomobject]@{
                Value = $_.$WeightProperty * $_.$Property
            }
        }
    }
}

New-Alias -Name gwv -Value Get-WeightedValue -Force