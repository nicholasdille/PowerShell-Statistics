# workaround for loading class
$scriptBody = "using module '$PSScriptRoot\HistogramBucket.psm1'"
$script = [ScriptBlock]::Create($scriptBody)
. $script

# workaround for loading class
$scriptBody = "using module '$PSScriptRoot\HistogramBar.psm1'"
$script = [ScriptBlock]::Create($scriptBody)
. $script

. "$PSScriptRoot\Get-Histogram.ps1"
. "$PSScriptRoot\Add-Bar.ps1"
. "$PSScriptRoot\Measure-Object.ps1"
. "$PSScriptRoot\Show-Measurement.ps1"