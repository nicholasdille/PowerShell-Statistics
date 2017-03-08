@{
    RootModule = 'Statistics.psm1'
    ModuleVersion = '1.0'
    GUID = 'd5add589-39c5-4f5a-a200-ba8258085bc9'
    Author = 'Nicholas Dille'
    # CompanyName = ''
    Copyright = '(c) 2017 Nicholas Dille. All rights reserved.'
    Description = 'Statistical analysis'
    PowerShellVersion = '5.0'
    FunctionsToExport = '*'
    CmdletsToExport = '*'
    VariablesToExport = ''
    AliasesToExport = '*'
    FormatsToProcess = @(
        'HistogramBucket.Format.ps1xml'
        'HistogramBar.Format.ps1xml'
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
            # IconUri = ''
            # ReleaseNotes = ''
        }
    }
    # HelpInfoURI = ''
    # DefaultCommandPrefix = ''
}
