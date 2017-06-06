---
external help file: Statistics-help.xml
online version: 
schema: 2.0.0
---

# Expand-DateTime

## SYNOPSIS
{{Fill in the Synopsis}}

## SYNTAX

```
Expand-DateTime [-InputObject] <Array> [[-Property] <String>]
```

## DESCRIPTION
{{Fill in the Description}}

## EXAMPLES

### Example 1
```
1..10 | ForEach-Object {
    Get-Counter -Counter '\Processor(_Total)\% Processor Time'
} | ConvertFrom-PerformanceCounter | ForEach-Object {
    [pscustomobject]@{
        Timestamp = $_.Timestamp.DateTime
        Value     = $_.Value
    }
} | Expand-DateTime -Property Timestamp
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

Required: False
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

