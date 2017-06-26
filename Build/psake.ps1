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

Task Test -Depends Init  {
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

    $CodeCoverage = @{
        Functions = @{}
        Line = @{
            Analyzed = $TestResults.CodeCoverage.NumberOfCommandsAnalyzed
            Executed = $TestResults.CodeCoverage.NumberOfCommandsExecuted
            Missed   = $TestResults.CodeCoverage.NumberOfCommandsMissed
            Coverage = 0
        }
        Function = @{}
    }
    $CodeCoverage.Line.Coverage = [math]::Round($CodeCoverage.Line.Executed / $CodeCoverage.Line.Analyzed * 100, 2)
    $TestResults.CodeCoverage.HitCommands | Group-Object -Property Function | ForEach-Object {
        if (-Not $CodeCoverage.Functions.ContainsKey($_.Name)) {
            $CodeCoverage.Functions.Add($_.Name, @{
                Name     = $_.Name
                Analyzed = 0
                Executed = 0
                Missed   = 0
                Coverage = 0
            })
        }

        $CodeCoverage.Functions[$_.Name].Analyzed += $_.Count
        $CodeCoverage.Functions[$_.Name].Executed += $_.Count
    }
    $TestResults.CodeCoverage.MissedCommands | Group-Object -Property Function | ForEach-Object {
        if (-Not $CodeCoverage.Functions.ContainsKey($_.Name)) {
            $CodeCoverage.Functions.Add($_.Name, @{
                Name     = $_.Name
                Analyzed = 0
                Executed = 0
                Missed   = 0
                Coverage = 0
            })
        }

        $CodeCoverage.Functions[$_.Name].Analyzed += $_.Count
        $CodeCoverage.Functions[$_.Name].Missed   += $_.Count
    }
    foreach ($function in $CodeCoverage.Functions.Values) {
        $function.Coverage = [math]::Round($function.Executed / $function.Analyzed * 100)
    }
    $CodeCoverage.Function = @{
        Analyzed = $CodeCoverage.Functions.Count
        Executed = ($CodeCoverage.Functions.Values | Where-Object { $_.Executed -gt 0 }).Length
        Missed   = ($CodeCoverage.Functions.Values | Where-Object { $_.Executed -eq 0 }).Length
    }
    $CodeCoverage.Function.Coverage = [math]::Round($CodeCoverage.Function.Executed / $CodeCoverage.Function.Analyzed * 100, 2)
 
    "Line coverage: $($CodeCoverage.Line.Analyzed) analyzed, $($CodeCoverage.Line.Executed) executed, $($CodeCoverage.Line.Missed) missed, $($CodeCoverage.Line.Coverage)%."
    "Function coverage: $($CodeCoverage.Function.Analyzed) analyzed, $($CodeCoverage.Function.Executed) executed, $($CodeCoverage.Function.Missed) missed, $($CodeCoverage.Function.Coverage)%."

    if ($TestResults.FailedCount -gt 0) {
        Write-Error "Failed '$($TestResults.FailedCount)' tests, build failed"
    }
    if ($CodeCoverage.Line.Coverage -lt 80) {
        Write-Error "Failed line coverage below 80% ($($CodeCoverage.Line.Coverage)%)"
    }
    if ($CodeCoverage.Function.Coverage -lt 100) {
        Write-Error "Failed function coverage is not 100% ($($CodeCoverage.Function.Coverage)%)"
    }

    "`n"
}

Task Docs {
    $lines

    Get-ChildItem -Path $env:BHProjectPath\docs -Directory | Select-Object -ExpandProperty Name | ForEach-Object {
        New-ExternalHelp -Path $env:BHProjectPath\docs\$_ -OutputPath $env:BHProjectPath\$_ -Force
    }

    "`n"
}

Task Build -Depends Test,Docs {
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