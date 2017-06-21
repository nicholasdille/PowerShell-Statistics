---
external help file: Statistics-help.xml
online version: 
schema: 2.0.0
---

# ConvertFrom-PerformanceCounter

## SYNOPSIS
{{Fill in the Synopsis}}

## SYNTAX

```
ConvertFrom-PerformanceCounter [-InputObject] <Array> [-Instance] <String>
```

## DESCRIPTION
{{Fill in the Description}}

## EXAMPLES

### Example 1
```
Get-counter -Counter "\Processor(_Total)\% Processor Time" -SampleInterval 2 -MaxSamples 100 | ConvertFrom-PerformanceCounter
```

{{ Add example description here }}

## PARAMETERS

### -InputObject
{{Fill InputObject Description}}

```yaml
Type: Array
Parameter Sets: (All)
Aliases: 

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Instance
{{Fill Instance Description}}

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

### System.Array

## OUTPUTS

### System.Object

## NOTES

## RELATED LINKS

