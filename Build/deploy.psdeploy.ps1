# Publish to gallery with a few restrictions
if (
    $env:BHModulePath -and
    $env:BHBuildSystem -ne 'Unknown' -and
    $env:BHBranchName -eq "master" -and
    $env:BHCommitMessage -match '!deploy'
)
{
    Deploy Module {
        By PSGalleryModule {
            FromSource $env:BHModulePath
            To PSGallery
            WithOptions @{
                ApiKey = $env:NugetApiKey
            }
        }
    }
}
else
{
    "Skipping deployment to PSGallery: To deploy, ensure that...`n" +
    "`t* You are in a known build system (Current: $env:BHBuildSystem)`n" +
    "`t* You are committing to the master branch (Current: $env:BHBranchName) `n" +
    "`t* Your commit message includes !deploy (Current: $env:BHCommitMessage)" |
        Write-Host
}

# Create GitHub release
if (
    $env:BHModulePath -and
    $env:BHBuildSystem -eq 'AppVeyor' -and
    $env:APPVEYOR_REPO_PROVIDER -eq 'gitHub' -and
    $env:BHCommitMessage -match '!release'
)
{
    $AssetName = "$env:ModuleName-$env:ModuleVersion.zip"
    $AssetPath = "$env:BHProjectPath\$AssetName"
    Compress-Archive -Path $env:BHModulePath -DestinationPath $AssetPath
    if (-Not (Test-Path -Path $AssetPath)) {
        Write-Error 'Failed to create archive for release'
    }
    "Created release asset $AssetPath" |
        Write-Host

    $ReleaseNotes = 'PLEASE FILL MANUALLY'
    if (Test-Path -Path $env:BHProjectPath\RELEASENOTES.md) {
        "Parsing release notes for version $env:ModuleVersion" |
            Write-Host
        $ReleaseNotesSection = Get-Content -Path $env:BHProjectPath\RELEASENOTES.md | ForEach-Object {
            if ($_ -like "# $env:ModuleVersion") {
                $output = $true

            } elseif ($_ -like '# *') {
                $output = $false
            }
            
            if ($output) {
                $_
            }
        }
        $ReleaseNotesSection += @(
            ' '
            "Install module from [PowerShell Gallery](https://www.powershellgallery.com/packages/$env:ModuleName/$env:ModuleVersion)"
            ' '
            "See build output at [AppVeyor](https://ci.appveyor.com/project/$env:GitHubOwner/$env:GitHubRepo/build/$env:APPVEYOR_BUILD_NUMBER="
            ' '
            "See test coverage at [Coveralls](https://coveralls.io/github/$env:GitHubOwner/$env:GitHubRepo)"
        )
        $ReleaseNotesSection = $ReleaseNotesSection | Where-Object { $_ -notlike '# *' -and $_ -ne '' }
        if ($ReleaseNotesSection -is [array]) {
            $ReleaseNotes = $ReleaseNotesSection -join "`n"
            "Added $($ReleaseNotesSection.Length) lines of release notes" |
                Write-Host

        } else {
            $ReleaseNotes = $ReleaseNotesSection
            "Added $($ReleaseNotesSection.Length) bytes in one line of release notes" |
                Write-Host
        }

    } else {
        "Unable to locate release notes in $env:BHProjectPath\RELEASENOTES.md." |
            Write-Host
    }

    "Creating release in GitHub repository" |
        Write-Host
    $GitHubReleaseId = New-GitHubRelease -Owner $env:GitHubOwner -Repository $env:GitHubRepo -Token $env:GitHubToken -Name $env:ModuleVersion -Branch $env:BHBranchName -Body $ReleaseNotes

    "Uploading asset to GitHub release" |
        Write-Host
    $GitHubAssetId = New-GitHubReleaseAsset -Owner $env:GitHubOwner -Repository $env:GitHubRepo -Token $env:GitHubToken -Release $GitHubReleaseId -Path $AssetPath
}
else
{
    "Skipping deployment on GitHub: To deploy, ensure that...`n" +
    "`t* Your build system is AppVeyor (Current: $env:BHBuildSystem)`n" +
    "`t* Your repo resides on GitHub (Current: $env:APPVEYOR_REPO_PROVIDER)`n" +
    "`t* Your commit message includes !release (Current: $ENV:BHCommitMessage)" |
        Write-Host
}

# Publish to AppVeyor if we're in AppVeyor
if (
    $env:BHModulePath -and
    $env:BHBuildSystem -eq 'AppVeyor'
   )
{
    Deploy DeveloperBuild {
        By AppVeyorModule {
            FromSource $ENV:BHModulePath
            To AppVeyor
            WithOptions @{
                Version = $env:APPVEYOR_BUILD_VERSION
            }
        }
    }
}

if (
    $env:BHModulePath -and
    $env:BHBuildSystem -eq 'Unknown'
)
{
    Deploy LocalModule {
        By FileSystem {
            FromSource $env:BHModulePath
            To $env:userprofile\Documents\WindowsPowerShell\Modules\$env:BHProjectName
        }
    }
}