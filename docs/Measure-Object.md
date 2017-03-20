---
external help file: Statistics-help.xml
online version: http://go.microsoft.com/fwlink/?LinkId=821829
schema: 2.0.0
---

# Measure-Object

## SYNOPSIS
Overload of the official cmdlet to provide statistical insights

## SYNTAX

```
Measure-Object -InputObject <Array> [-Property] <String>
```

## DESCRIPTION
This cmdlet overloads the official implementation and adds several statistical value to the resulting object. This includes the median, several percentiles as well as the 95% confidence interval.

## EXAMPLES

### Example 1: Display memory usage of processes
```
PS C:\>Get-Process | Measure-Object -Property WorkingSet
```

This command visualizes the memory usage of processes currently running on the local machine.

## PARAMETERS

### -InputObject
Specifies the objects to be measured.

```yaml
Type: Array
Parameter Sets: (All)
Aliases: 

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Property
Specifies the numeric property to measure

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: True
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

### System.Array


### System.Management.Automation.PSObject
You can pipe objects to Measure-Object.

## OUTPUTS

### System.Object

## NOTES

## RELATED LINKS

[Median](https://en.m.wikipedia.org/wiki/Median)

[Variance](https://en.m.wikipedia.org/wiki/Variance)

[Standard deviation](https://en.m.wikipedia.org/wiki/Standard_deviation)

[Percentile](https://en.m.wikipedia.org/wiki/Percentile)

[Confidence interval](https://en.m.wikipedia.org/wiki/Confidence_interval)
