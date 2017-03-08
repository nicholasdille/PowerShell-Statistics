$scriptBody = "using module '$env:BHPSModulePath\HistogramBucket.psm1'"
$script = [ScriptBlock]::Create($scriptBody)
. $script

$scriptBody = "using module '$env:BHPSModulePath\HistogramBar.psm1'"
$script = [ScriptBlock]::Create($scriptBody)
. $script

Get-ChildItem -Path "$PSScriptRoot" -Filter '*.ps1' | ForEach-Object {
    . "$($_.FullName)"
}