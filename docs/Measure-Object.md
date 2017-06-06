---
external help file: Statistics-help.xml
online version: http://go.microsoft.com/fwlink/?LinkId=821829
schema: 2.0.0
---

# Measure-Object

## SYNOPSIS
Overload of the official cmdlet to provide statistical insights Calculates the numeric properties of objects, and the characters, words, and lines in string objects, such as files of text.

## SYNTAX

```
Measure-Object -InputObject <Array> [-Property] <String>
```

## DESCRIPTION
This cmdlet overloads the official implementation and adds several statistical value to the resulting object.
This includes the median, several percentiles as well as the 95% confidence interval.

The Measure-Object cmdlet calculates the property values of certain types of object.
Measure-Object performs three types of measurements, depending on the parameters in the command.

The Measure-Object cmdlet performs calculations on the property values of objects.
It can count objects and calculate the minimum, maximum, sum, and average of the numeric values.
For text objects, it can count and calculate the number of lines, words, and characters.

## EXAMPLES

### Example 1: Display memory usage of processes
```
PS C:\>Get-Process | Measure-Object -Property WorkingSet
```

This command visualizes the memory usage of processes currently running on the local machine.

### Example 1: Count the files and folders in a directory
```
PS C:\>Get-ChildItem | Measure-Object
```

This command counts the files and folders in the current directory.

### Example 2: Measure the files in a directory
```
PS C:\>Get-ChildItem | Measure-Object -Property length -Minimum -Maximum -Average
```

This command displays the minimum, maximum, and sum of the sizes of all files in the current directory, and the average size of a file in the directory.

### Example 3: Measure text in a text file
```
PS C:\>Get-Content C:\test.txt | Measure-Object -Character -Line -Word
```

This command displays the number of characters, words, and lines in the Text.txt file.

### Example 4: Measure computer processes
```
PS C:\>Get-Process | Measure-Object -Property workingset -Minimum -Maximum -Average
```

This command displays the minimum, maximum, and average sizes of the working sets of the processes on the computer.

### Example 5: Measure the contents of a CSV file
```
PS C:\>Import-Csv d:\test\serviceyrs.csv | Measure-Object -Property years -Minimum -Maximum -Average
```

This command calculates the average years of service of the employees of a company.

The ServiceYrs.csv file is a CSV file that contains the employee number and years of service of each employee.
The first row in the table is a header row of EmpNo, Years.

When you use Import-Csv to import the file, the result is a PSCustomObject with note properties of EmpNo and Years.
You can use Measure-Object to calculate the values of these properties, just like any other property of an object.

### Example 6: Measure Boolean values
```
PS C:\>Get-ChildItem | Measure-Object -Property psiscontainer -Max -Sum -Min -Average
Count    : 126
Average  : 0.0634920634920635
Sum      : 8
Maximum  : 1
Minimum  : 0
Property : PSIsContainer
```

This example demonstrates how the Measure-Object can measure Boolean values.
In this case, it uses the PSIsContainer Boolean property to measure the incidence of folders (vs.
files) in the current directory.

## PARAMETERS

### -InputObject
Specifies the objects to be measured.

Specifies the objects to be measured.
Enter a variable that contains the objects, or type a command or expression that gets the objects.

When you use the InputObject parameter with Measure-Object , instead of piping command results to Measure-Object , the InputObject value-even if the value is a collection that is the result of a command, such as \`-InputObject (Get-Process)\`-is treated as a single object.
Because InputObject cannot return individual properties from an array or collection of objects, it is recommended that if you use Measure-Object to measure a collection of objects for those objects that have specific values in defined properties, you use Measure-Object in the pipeline, as shown in the examples in this topic.

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

Specifies one or more numeric properties to measure.
The default is the Count property of the object.

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

### System.Management.Automation.PSObject
You can pipe objects to Measure-Object .

## OUTPUTS

### System.Object

### Microsoft.PowerShell.Commands.GenericMeasureInfo, Microsoft.PowerShell.Commands.TextMeasureInfo, Microsoft.PowerShell.Commands.GenericObjectMeasureInfo
If you use the Word parameter, Measure-Object returns a TextMeasureInfo object.
Otherwise, it returns a GenericMeasureInfo object.

## NOTES
## RELATED LINKS

[Median](https://en.m.wikipedia.org/wiki/Median)

[Variance](https://en.m.wikipedia.org/wiki/Variance)

[Standard deviation](https://en.m.wikipedia.org/wiki/Standard_deviation)

[Percentile](https://en.m.wikipedia.org/wiki/Percentile)

[Confidence interval](https://en.m.wikipedia.org/wiki/Confidence_interval)
