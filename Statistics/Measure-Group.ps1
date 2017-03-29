function Measure-Group {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory,ValueFromPipeline)]
        [ValidateNotNullOrEmpty()]
        [Microsoft.PowerShell.Commands.GroupInfo[]]
        $InputObject
        ,
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Property
    )

    Process {
        $InputObject | ForEach-Object {
            $Measurement = $_.Group | Measure-Object -Property $Property

            Add-Member -InputObject $Measurement -MemberType NoteProperty -Name Name -Value $_.Name -PassThru
        }
    }
}

New-Alias -Name mg -Value Measure-Group -Force