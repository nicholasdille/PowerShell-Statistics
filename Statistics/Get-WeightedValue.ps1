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
            [pscustomobject]@{
                Value = $_.$WeightProperty * $_.$Property
            }
        }
    }
}

New-Alias -Name gwv -Value Get-WeightedValue -Force