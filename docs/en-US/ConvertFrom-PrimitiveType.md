---
external help file: Statistics-help.xml
online version: 
schema: 2.0.0
---

# ConvertFrom-PrimitiveType

## SYNOPSIS
Wraps values in objects

## SYNTAX

```
ConvertFrom-PrimitiveType [-InputObject] <Object>
```

## DESCRIPTION
The cmdlet accepts values in primitive types and wraps them in a new object

## EXAMPLES

### Example 1
```
1..10 | ConvertFrom-PrimitiveType

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

## PARAMETERS

### -InputObject
Input objects containing the relevant data

```yaml
Type: Object
Parameter Sets: (All)
Aliases: 

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

