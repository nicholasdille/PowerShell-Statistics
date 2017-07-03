@{
    RootModule = 'Statistics.psm1'
    ModuleVersion = '1.1'
    GUID = 'd5add589-39c5-4f5a-a200-ba8258085bc9'
    Author = 'Nicholas Dille'
    # CompanyName = ''
    Copyright = '(c) 2017 Nicholas Dille. All rights reserved.'
    Description = 'Statistical analysis of data in the console window. For example this module can generate a histogram (Get-Histogram) and visualize it (Add-Bar). It also provides several statistical properties of the input data (Measure-Object and Show-Measurement). Using Get-SlidingAverage, data can be analyzed in a pipeline in real-time.'
    PowerShellVersion = '5.0'
    FunctionsToExport = @('Add-Bar','ConvertFrom-PerformanceCounter','ConvertFrom-PrimitiveType','Expand-DateTime','Get-Histogram','Get-InterarrivalTime','Get-SlidingAverage','Get-WeightedValue','Measure-Group','Measure-Object','Show-Measurement')
    CmdletsToExport = ''
    VariablesToExport = ''
    AliasesToExport = @('ab','cfpc','cfpt','edt','gh','giat','gsa','gwv','mg','mo','sm')
    FormatsToProcess = @(
        'HistogramBucket.Format.ps1xml'
        'HistogramBar.Format.ps1xml'
    )
    RequiredModules = @(
        @{
            ModuleName = 'CICD'
            ModuleVersion = '0.1.22'
        },
        @{
            ModuleName = 'PSCoverage'
            ModuleVersion = '0.1.39'
        },
        @{
            ModuleName = 'PSGitHub'
            ModuleVersion = '0.13.9'
        }
    )
    PrivateData = @{
        PSData = @{
            Tags = @(
                'Math'
                'Mathematics'
                'Statistics'
                'Histogram'
            )
            LicenseUri = 'https://github.com/nicholasdille/PowerShell-Statistics/blob/master/LICENSE'
            ProjectUri = 'https://github.com/nicholasdille/PowerShell-Statistics'
            ReleaseNotes = 'https://github.com/nicholasdille/PowerShell-Statistics/releases'
        }
    }
}
