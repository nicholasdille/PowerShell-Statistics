---
external help file: Statistics-help.xml
online version: https://en.wikipedia.org/wiki/Histogram
schema: 2.0.0
---

# Get-Histogram

## SYNOPSIS
Visualizes values using bars

## SYNTAX

```
Get-Histogram -InputObject <Array> -Property <String> [-Minimum <Single>] [-Maximum <Single>]
 [-BucketWidth <Single>] [-BucketCount <Single>]
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
2    5242880   10485760    31 ##################################################     3   10485760   15728640    24 #######################################
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

### -BucketCount
{{Fill BucketCount Description}}

```yaml
Type: Single
Parameter Sets: (All)
Aliases: Count

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -BucketWidth
{{Fill BucketWidth Description}}

```yaml
Type: Single
Parameter Sets: (All)
Aliases: Width

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -InputObject
{{Fill InputObject Description}}

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

### -Maximum
{{Fill Maximum Description}}

```yaml
Type: Single
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Minimum
{{Fill Minimum Description}}

```yaml
Type: Single
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Property
{{Fill Property Description}}

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

## OUTPUTS

### HistogramBar[]

## NOTES

## RELATED LINKS

[Histogram](https://en.wikipedia.org/wiki/Histogram)

