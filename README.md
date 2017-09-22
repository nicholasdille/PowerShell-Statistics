| AppVeyor | Coveralls | Download |
| :------: | :-------: | :------: |
| [![Build status](https://ci.appveyor.com/api/projects/status/e56ra8c3q1jtc19o?svg=true)](https://ci.appveyor.com/project/nicholasdille/powershell-statistics) | [![Coverage Status](https://coveralls.io/repos/github/nicholasdille/PowerShell-Statistics/badge.svg?branch=master)](https://coveralls.io/github/nicholasdille/PowerShell-Statistics?branch=master) | [![Download](https://img.shields.io/badge/powershellgallery-Statistics-blue.svg)](https://www.powershellgallery.com/packages/Statistics/) 

# Introduction

Statistical analysis

# TODO

- Use `Update-TypeData`
- Display values in `Show-Measurement`... include minimum and maximum
- Limit displayed range in `Show-Measurement`
- Check handling of negative values
- More tests
- Get-SlidingAverage
  - Output data similar to `Group-Object` by adding properties `Property`, `Group` and `Average`
- Filter performance counters from `(Get-Counter).CounterSamples`
- Progress bar
  - Implement in all cmdlets
  - Support for child bars
- Performance improvements by using ArrayList instead of `+=`
- Provide predefined buckets to `Get-Histogram`

# Warning

**Many cmdlets contained in this modules operate directly on the input objects and add new properties to them. This is a design decision to prevent excessive memory usage caused by copying the input data.**

# Histograms

Create a histogram from the currently running processes using `Get-Histogram`. The WorkingSet will be used to express the amount of memory used by the processes. It makes sense to specify the bucket size (`-BucketWidth`) as well as the number of buckets (`-BucketCount`).

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
```

The histogram is visualized using `Add-Bar`. It adds a new property to the input objects containing the bar. Note that the width is predefined to match the current console window.

```powershell
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
```

# Statistical analysis

In addition to value distribution, statistics has a lot more to offer. This module overloads the cmdlet `Measure-Object` and adds many properties like the median and the standard deviation.

```powershell
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
```

Although those values are very interesting, visualizing them using `Show-Measurement` helps understanding your data set.

```powershell
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

# Simple data

In case you have input data as primitive type (e.g. [int]), use can use `ConvertFrom-PrimitiveType` to construct a complex (yet still simple) type containing the values. The output can be used for any cmdlet described above.

```powershell
PS C:\> 1..10 | ConvertFrom-PrimitiveType

Value
-----
    1
    2
    3
    4
    5
    6
    7
    8
    9
   10
```

# Analyzing performance counters

Performance counters are retrieved using the builtin cmdlet `Get-Counter`. Unfortunately, this cmdlet wraps the samples in a separate property. `ConvertFrom-PerformanceCounter` changes the structure of the input data to make it easier to process. The cmdlet can be used for stream processing in a pipeline.

```powershell
PS C:\> Get-Counter -Counter '\Processor(_Total)\% Processor Time' -SampleInterval 1 -MaxSamples 10 | ConvertFrom-PerformanceCounter -Instance _total

Timestamp                      Value
---------                      -----
29.03.2017 14:29:46 2,97703720584355
29.03.2017 14:29:47 3,06092596747546
29.03.2017 14:29:48 6,49145039193071
29.03.2017 14:29:49  7,9961263543842
29.03.2017 14:29:50 5,11584502920018
29.03.2017 14:29:51 4,63986180903145
29.03.2017 14:29:52 4,53201559488423
29.03.2017 14:29:53 1,77517662636473
29.03.2017 14:29:54 10,1188887197758
29.03.2017 14:29:55  4,1137771992306
```

The individual values do not tell you enough because they may be peaking once in a while. `Get-SlidingAverage` calculates an average over a window of the specified size:

```powershell
PS C:\> Get-Counter -Counter '\Processor(_Total)\% Processor Time' -SampleInterval 1 -MaxSamples 10 | ConvertFrom-PerformanceCounter -Instance _total | Get-SlidingAverage -Property Value -Size 5
0,999077477590933
0,954436964202299
0,572272227101394
0,572272227101394
0,417360277344085
0,797367872038486
```

# Time series

In contrast to reading samples at regular intervals (as seen above for performance counters), you sometime obtain values at irregular intervals. Analyzing the timestamps will tell you as much as the data values. For the sake of this example, let's generate sample data. The timestamp is generated randomly over the last 24 hours:

```powershell
$now = Get-Date
$data = 1..10 | ForEach-Object {
    [pscustomobject]@{
        Timestamp = Get-Random -Minimum $now.AddDays(-1).Ticks -Maximum $now.Ticks
        Value     = Get-Random -Minimum 0 -Maximum 100
    }
} | Sort-Object -Property Timestamp
```

Let's take a closer look at the distance (interarrival time) between samples. By default, the distance is expessed in ticks but you can choose from several units using `-Unit`.

```powershell
PS C:\> $data | Get-InterarrivalTime -Property Timestamp

         Timestamp Value InterarrivalTicks
         --------- ----- -----------------
636263194123056256    30        2285541632
636263376363844864    49      182240788608
636263469245163392    21       92881318528
636263553811059072     9       84565895680
636263622795032960    42       68983973888
636263691231611392    87       68436578432
636263800435401856    28      109203790464
636263902248199552    27      101812797696
636263932075540992    69       29827341440

PS C:\> $data | Get-InterarrivalTime -Property Timestamp -Unit Minutes

         Timestamp Value InterarrivalMinutes
         --------- ----- -------------------
636263260120122752    49                  21
636263337519778304    14                   8
636263366516410368    49                  48
636263500972027904    15                  44
636263620709248256    95                  19
636263635450691840    97                  24
636263747658795264    44                   7
636263773550362368    98                  43
636263853541291392    88                  13
```

The ticks-based timestamp in the examples above it impossibel to read without any conversion. This module also offers a cmdlet called `Expand-DateTime` to convert timestamps:

```powershell
PS C:\> $data | Expand-DateTime -Property Timestamp

Timestamp           Value DayOfWeek Year Month Hour WeekOfYear
---------           ----- --------- ---- ----- ---- ----------
28.03.2017 18:34:18    23   Tuesday 2017     3   18 13
28.03.2017 19:13:38    43   Tuesday 2017     3   19 13
28.03.2017 20:42:08    53   Tuesday 2017     3   20 13
28.03.2017 21:41:23    73   Tuesday 2017     3   21 13
28.03.2017 22:28:16     9   Tuesday 2017     3   22 13
28.03.2017 22:46:47    20   Tuesday 2017     3   22 13
28.03.2017 22:50:01    75   Tuesday 2017     3   22 13
29.03.2017 01:01:26    40 Wednesday 2017     3    1 13
29.03.2017 05:11:43    55 Wednesday 2017     3    5 13
29.03.2017 09:10:39    77 Wednesday 2017     3    9 13
```

# Credits

Build scripts based on [PSDeploy](https://github.com/RamblingCookieMonster/PSDeploy) by [Warren Frame](http://ramblingcookiemonster.github.io/)