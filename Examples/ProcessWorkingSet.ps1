#region Source functions
Import-Module Statistics
#endregion

#region Data
$values = Get-Process | select Name,Id,WorkingSet
#endregion

#region Histogram
$bucket = Get-Histogram -InputObject $values -Property WorkingSet -BucketWidth 5mb -Minimum 0 -Maximum 50mb
$histogram = $bucket | Add-Bar -Property Count
$histogram
#endregion

#region Measurements
$stats = Measure-Object -InputObject $values -Property WorkingSet
$stats | Show-Measurement
#endregion
