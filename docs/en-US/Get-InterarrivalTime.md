---
external help file: Statistics-help.xml
online version: 
schema: 2.0.0
---

# Get-InterarrivalTime

## SYNOPSIS
{{Fill in the Synopsis}}

## SYNTAX

```
Get-InterarrivalTime [-InputObject] <Array> [-Property] <String> [[-Unit] <String>]
```

## DESCRIPTION
{{Fill in the Description}}

## EXAMPLES

### Example 1
```
1..10 | ForEach-Object {
    Get-Counter -Counter '\Processor(_Total)\% Processor Time'
    Start-Sleep -Seconds (Get-Random -Minimum 1 -Maximum 5)
} | ConvertFrom-PerformanceCounter | Get-InterarrivalTime -Property Timestamp
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

### -Property
{{Fill Property Description}}

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

### -Unit
{{Fill Unit Description}}

```yaml
Type: String
Parameter Sets: (All)
Aliases: 
Accepted values: Ticks, TotalSecond, Minutes, Hours, Days

Required: False
Position: 2
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

