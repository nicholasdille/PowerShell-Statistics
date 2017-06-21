---
external help file: Statistics-help.xml
online version: 
schema: 2.0.0
---

# Add-Bar

## SYNOPSIS
Visualizes values using bars

## SYNTAX

```
Add-Bar [-InputObject] <Array> [[-Property] <String>] [[-Width] <Int32>]
```

## DESCRIPTION
A graphical representation help understanding data.
Add-Bar adds a new member to the input objects which contain bars to visualize the size of the value relative to the maximum value

## EXAMPLES

### -------------------------- EXAMPLE 1 --------------------------
```
Add-Bar -InputObject $Files -Property Length
```

Index lowerBound upperBound Count Bar
----- ---------- ---------- ----- ---
1          0    5242880    13 #####################
2    5242880   10485760    31 ##################################################
3   10485760   15728640    24 #######################################
4   15728640   20971520    14 #######################
5   20971520   26214400     5 ########
6   26214400   31457280     5 ########
7   31457280   36700160     3 #####
8   36700160   41943040     2 ###
9   41943040   47185920     3 #####
10   47185920   52428800     1 ##

### -------------------------- EXAMPLE 2 --------------------------
```
$Files | Add-Bar -Property Length
```

## PARAMETERS

### -InputObject
Input objects containing the relevant data

```yaml
Type: Array
Parameter Sets: (All)
Aliases: 

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Property
Property of the input objects containing the relevant data

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Width
Length of the bar for the maximum value (width of the graph)

```yaml
Type: Int32
Parameter Sets: (All)
Aliases: 

Required: False
Position: 3
Default value: 50
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

## OUTPUTS

### HistogramBar[]

## NOTES

## RELATED LINKS

