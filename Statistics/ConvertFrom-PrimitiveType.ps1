function ConvertFrom-PrimitiveType {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory,ValueFromPipeline)]
        [ValidateNotNullOrEmpty()]
        $InputObject
    )

    Process {
        Write-Debug ('[{0}] Entered process block' -f $MyInvocation.MyCommand)

        $InputObject | ForEach-Object {
            if (-Not $_.GetType().IsPrimitive) {
                throw ('[{0}] Value is not a primitive type' -f $MyInvocation.MyCommand)
            }

            [pscustomobject]@{
                Value = $_
            }
        }
    }
}

New-Alias -Name cfpt -Value ConvertFrom-PrimitiveType -Force