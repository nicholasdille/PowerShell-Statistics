$scriptBody = "using module '$PSScriptRoot\HistogramBucket.psm1'"
$script = [ScriptBlock]::Create($scriptBody)
. $script

$scriptBody = "using module '$PSScriptRoot\HistogramBar.psm1'"
$script = [ScriptBlock]::Create($scriptBody)
. $script

Get-ChildItem -Path "$PSScriptRoot" -Filter '*.ps1' | ForEach-Object {
    . "$($_.FullName)"
}