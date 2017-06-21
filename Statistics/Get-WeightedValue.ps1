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
            if (-Not (Get-Member -InputObject $_ -MemberType Properties -Name $Property)) {
                throw ('[{0}] Unable to find property <{1}> in input object' -f $MyInvocation.MyCommand, $Property)
            }
            if (-Not (Get-Member -InputObject $_ -MemberType Properties -Name $WeightProperty)) {
                throw ('[{0}] Unable to find weight property <{1}> in input object' -f $MyInvocation.MyCommand, $WeightProperty)
            }

            [pscustomobject]@{
                Value = $_.$WeightProperty * $_.$Property
            }
        }
    }
}

New-Alias -Name gwv -Value Get-WeightedValue -Force