[![Build status](https://ci.appveyor.com/api/projects/status/e56ra8c3q1jtc19o?svg=true)](https://ci.appveyor.com/project/nicholasdille/powershell-statistics)

# Introduction

Statistical analysis

# Usage

```powershell
PS C:\> $Processes = Get-Process
PS C:\> $Histogram = $Processes | Get-Histogram -Property WorkingSet64 -BucketWidth 50mb -BucketCount 10
PS C:\> $Histogram

Index Count
----- -----
    1    75
    2    15
    3     9
    4     2
    5     0
    6     2
    7     1
    8     1
    9     1
   10     2


PS C:\> $Histogram | Add-Bar

Index Count Bar
----- ----- ---
    1    75 ####################################################################################################
    2    15 ####################
    3     9 ############
    4     2 ###
    5     0
    6     2 ###
    7     1 #
    8     1 #
    9     1 #
   10     2 ###


PS C:\> $Processes | Measure-Object -Property WorkingSet64


Median            : 24731648
Variance          : 1,86476251813904E+16
StandardDeviation : 136556307,731977
Percentile10      : 6496256
Percentile25      : 12095488
Percentile75      : 92958720
Percentile90      : 190754816
Confidence95      : 25519460,826598
Count             : 110
Average           : 76195169,7454546
Sum               : 8381468672
Maximum           : 875040768
Minimum           : 4096
Property          : WorkingSet64



PS C:\> $Processes | Measure-Object -Property WorkingSet64 | Show-Measurement
---------|---------|---------|---------|---------|---------|---------|---------|---------|---------|
P10
P25
        A
     c----C
  M
          P75
                     P90
---------|---------|---------|---------|---------|---------|---------|---------|---------|---------|
PS C:\>
```

# TODO

None
