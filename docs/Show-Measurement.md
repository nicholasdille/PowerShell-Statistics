---
external help file: Statistics-help.xml
online version: http://go.microsoft.com/fwlink/?LinkId=821829
schema: 2.0.0
---

# Show-Measurement

## SYNOPSIS
Visualizes statistical data about input values

## SYNTAX

```
Show-Measurement [-InputObject] <Object> [[-Width] <Int32>] [-PassThru]
```

## DESCRIPTION
Show-Measurement relies on the overload of Measure-Object provided by this module.
It visualizes the data calculated by Measure-Object on the console.

## EXAMPLES

### Example 1
```
PS C:\> Get-Process | Measure-Object -Property WorkingSet | Show-Measurement
---------|---------|---------|---------|---------|---------|---------|---------|---------|---------|
P10
 P25
         A
      c-----C
   M
            P75
                        P90
---------|---------|---------|---------|---------|---------|---------|---------|---------|---------|
```

## PARAMETERS

### -InputObject
Single object produced by Measure-Object included in this module

```yaml
Type: Object
Parameter Sets: (All)
Aliases: 

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Width
Maximum number of characters to display per line

```yaml
Type: Int32
Parameter Sets: (All)
Aliases: 

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PassThru
{{Fill PassThru Description}}

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

### System.Object

## OUTPUTS

### System.Object

## NOTES

## RELATED LINKS

[Median](https://en.m.wikipedia.org/wiki/Median)

[Variance](https://en.m.wikipedia.org/wiki/Variance)

[Standard deviation](https://en.m.wikipedia.org/wiki/Standard_deviation)

[Percentile](https://en.m.wikipedia.org/wiki/Percentile)

[Confidence interval](https://en.m.wikipedia.org/wiki/Confidence_interval)
