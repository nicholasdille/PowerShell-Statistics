function Add-Bar {
    [CmdletBinding()]
    #[OutputType([HistogramBar[]])]
    Param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [ValidateNotNullOrEmpty()]
        [array]
        $InputObject
        ,
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]
        $Property = 'Count'
        ,
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [int]
        $Width = $( if ($Host -and $Host.UI) { $Host.UI.RawUI.MaxWindowSize.Width - 20 } )
    )

    Begin {
        $Data = @()
    }

    Process {
        $InputObject | ForEach-Object {
            if (-Not ($_ | Select-Object -ExpandProperty $Property -ErrorAction SilentlyContinue)) {
                throw ('Input object does not contain a property called <{0}>.' -f $Property)
            }
            $Data += $_
        }
    }

    End {
        $Count = $Data | Microsoft.PowerShell.Utility\Measure-Object -Maximum -Property $Property | Select-Object -ExpandProperty Maximum
        $Bars = $Data | ForEach-Object {
            $RelativeCount = [math]::Round($_.$Property / $Count * $Width, 0)
            #Add-Member -InputObject $_ -MemberType NoteProperty -Name Bar -Value ('#' * $RelativeCount)
            $_ | Select-Object -Property Index,Count | Add-Member -MemberType NoteProperty -Name Bar -Value ('#' * $RelativeCount) -PassThru
        }
        [HistogramBar[]]$Bars
    }
}

New-Alias -Name ab -Value Add-Bar -Force