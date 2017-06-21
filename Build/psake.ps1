Properties {
    $Timestamp = Get-Date -UFormat "%Y%m%d-%H%M%S"
    $PSVersion = $PSVersionTable.PSVersion.Major
    $lines = '----------------------------------------------------------------------'

    $PSModule = Get-ChildItem -Path $env:BHProjectPath -File -Recurse -Filter '*.psd1' | Where-Object { $_.Directory.Name -eq $_.BaseName }
    if ($PSModule -is [array]) {
        Write-Error 'Found more than one module manifest'
    }
    if (-Not $PSModule) {
        Write-Error 'Did not find any module manifest'
    }
    $ModuleName = $PSModule.Directory.BaseName
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

    # Gather test results. Store them in a variable and file
    if ($env:PSModulePath -notlike "$env:BHProjectPath;*") {
        $env:PSModulePath = "$env:BHProjectPath;$env:PSModulePath"
    }
    $TestResults = Invoke-Pester -Path "$env:BHProjectPath\Tests" -PassThru -OutputFormat NUnitXml -OutputFile "$env:BHProjectPath\$TestFile" -CodeCoverage "$env:BHModulePath\$ModuleName.psm1"

    # In Appveyor?  Upload our tests! #Abstract this into a function?
    if ($env:BHBuildSystem -eq 'AppVeyor') {
        (New-Object 'System.Net.WebClient').UploadFile(
            "https://ci.appveyor.com/api/testresults/nunit/$env:APPVEYOR_JOB_ID",
            "$env:BHProjectPath\$TestFile" )
    }
    #Remove-Item "$env:BHProjectPath\$TestFile" -Force -ErrorAction SilentlyContinue

    # Failed tests?
    # Need to tell psake or it will proceed to the deployment. Danger!
    if ($TestResults.FailedCount -gt 0) {
        Write-Error "Failed '$($TestResults.FailedCount)' tests, build failed"
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