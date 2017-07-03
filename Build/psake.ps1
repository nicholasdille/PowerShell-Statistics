Properties {
    $Timestamp = Get-Date -UFormat "%Y%m%d-%H%M%S"
    $PSVersion = $PSVersionTable.PSVersion.Major
    $lines = '----------------------------------------------------------------------'

    $PSModule = Get-ChildItem -Path $env:BHProjectPath -File -Recurse -Filter '*.psd1' | Where-Object { $_.Directory.Name -eq $_.BaseName }
    if ($PSModule -is [array]) {
        Write-Error ('Found more than one module manifest: {0}' -f ($PSModule -join ', '))
    }
    if (-Not $PSModule) {
        Write-Error 'Did not find any module manifest'
    }
    $env:ModuleName = $PSModule.Directory.BaseName
    $env:BHModulePath = $PSModule.Directory.FullName
    $TestFile = "TestResults_PS$PSVersion`_$TimeStamp.xml"
    Import-LocalizedData -BindingVariable Manifest -BaseDirectory $PSModule.Directory.FullName -FileName $PSModule.Name
    $env:ModuleVersion = $Manifest.ModuleVersion
}

Task Default -Depends Test

Task Init {
    $lines

    Set-Location -Path $env:BHProjectPath
    "Build System Details:"
    Get-Item ENV:BH*

    "`n"
}

Task Analysis -Depends Init {
    $lines

    $Files = Get-ChildItem -Path .\Statistics\*.ps1 -File
    $results = $Files | ForEach-Object { Invoke-ScriptAnalyzer -Path $_ -Severity Warning }
    if ($results) {
        $results
        Write-Error 'Failed script analysis. Build failed.'
    }
    $results = $Files | ForEach-Object { Invoke-ScriptAnalyzer -Path $_ -SuppressedOnly }
    if ($results) {
        $results
        Write-Warning 'Some issues are suppressed from script analysis.'
    }

    "`n"
}

Task Test -Depends Init,Analysis  {
    $lines
    "`n`tSTATUS: Testing with PowerShell $PSVersion"

    Remove-Module -Name pester -ErrorAction SilentlyContinue
    Import-Module -Name pester -MinimumVersion '4.0.0'

    # Gather test results. Store them in a variable and file
    if ($env:PSModulePath -notlike "$env:BHProjectPath;*") {
        $env:PSModulePath = "$env:BHProjectPath;$env:PSModulePath"
    }
    $TestResults = Invoke-Pester -Path "$env:BHProjectPath\Tests" -OutputFormat NUnitXml -OutputFile "$env:BHProjectPath\$TestFile" -CodeCoverage "$env:BHModulePath\*.ps1" -PassThru

    # In Appveyor?  Upload our tests! #Abstract this into a function?
    if ($env:BHBuildSystem -eq 'AppVeyor') {
        (New-Object 'System.Net.WebClient').UploadFile(
            "https://ci.appveyor.com/api/testresults/nunit/$env:APPVEYOR_JOB_ID",
            "$env:BHProjectPath\$TestFile" )
    }
    #Remove-Item "$env:BHProjectPath\$TestFile" -Force -ErrorAction SilentlyContinue

    $CodeCoverage = Get-CodeCoverageMetrics -CodeCoverage $TestResults.CodeCoverage
 
    "Statement coverage: $($CodeCoverage.Statement.Analyzed) analyzed, $($CodeCoverage.Statement.Executed) executed, $($CodeCoverage.Statement.Missed) missed, $($CodeCoverage.Statement.Coverage)%."
    "Function coverage: $($CodeCoverage.Function.Analyzed) analyzed, $($CodeCoverage.Function.Executed) executed, $($CodeCoverage.Function.Missed) missed, $($CodeCoverage.Function.Coverage)%."

    if ($TestResults.FailedCount -gt 0) {
        Write-Error "Failed '$($TestResults.FailedCount)' tests. Build failed!"
    }
    if ($CodeCoverage.Statement.Coverage -lt $env:StatementCoverageThreshold) {
        Write-Error "Failed statement coverage below 80% ($($CodeCoverage.Statement.Coverage)%). Build failed!"
    }
    if ($CodeCoverage.Function.Coverage -lt $env:FunctionCoverageThreshold) {
        Write-Error "Failed function coverage is not 100% ($($CodeCoverage.Function.Coverage)%). Build failed!"
    }

    "`n"
}

Task Docs {
    $lines

    $TestResults = Invoke-Pester -Path $env:BHProjectPath\docs\docs.Tests.ps1 -PassThru

    if ($TestResults.FailedCount -gt 0) {
        Write-Error "Failed '$($TestResults.FailedCount)' documentation tests. Failed!"
    }

    Get-ChildItem -Path $env:BHProjectPath\docs -Directory | Select-Object -ExpandProperty Name | ForEach-Object {
        New-ExternalHelp -Path $env:BHProjectPath\docs\$_ -OutputPath $env:BHModulePath\$_ -Force | Out-Null
    }

    "`n"
}

Task Build -Depends Analysis,Test,Docs {
    $lines

    if ($env:BHBuildSystem -eq 'AppVeyor') {
        Update-Metadata -Path $PSModule.FullName -PropertyName ModuleVersion -Value "$($Manifest.ModuleVersion).$env:APPVEYOR_BUILD_NUMBER" -ErrorAction stop
        $env:ModuleVersion = "$($Manifest.ModuleVersion).$env:APPVEYOR_BUILD_NUMBER"
    }

    "`n"
}

Task Deploy -Depends Build {
    $lines

    $Params = @{
        Path = "$env:BHProjectPath\Build"
        Force = $true
        Recurse = $false # We keep psdeploy artifacts, avoid deploying those : )
    }
    Invoke-PSDeploy @Params

    "`n"
}