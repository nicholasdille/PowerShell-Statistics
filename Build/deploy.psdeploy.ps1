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
    Compress-Archive -Path $env:BHModulePath -DestinationPath $env:BHProjectPath\$env:BHProjectName-$env:ModuleVersion.zip
    if (-Not (Test-Path -Path $env:BHProjectPath\$env:BHProjectName-$env:ModuleVersion.zip)) {
        Write-Error 'Failed to create archive for release'
    }
    "Created release asset $env:BHProjectPath\$env:BHProjectName-$env:ModuleVersion.zip" |
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
    $RequestBody = ConvertTo-Json -InputObject @{
        "tag_name"         = "$env:ModuleVersion"
        "target_commitish" = "$env:BHBranchName"
        "name"             = "Version $env:ModuleVersion"
        "body"             = "$ReleaseNotes"
        "draft"            = $false
        "prerelease"       = $false
    }
    $Result = Invoke-WebRequest -Method Post -Uri "https://api.github.com/repos/$ENV:APPVEYOR_REPO_NAME/releases" -Headers @{Authorization = "token $ENV:GitHubToken"} -Body $RequestBody
    if ($Result.StatusCode -ne 201) {
        Write-Error "Failed to create release. Code $($Result.StatusCode): $($Result.Content)"
    }
    $GitHubReleaseId = ($Result.Content | ConvertFrom-Json).id

    "Uploading asset to GitHub release" |
        Write-Host
    $RequestBody = Get-Content -Path $env:BHProjectPath\$env:BHProjectName-$env:ModuleVersion.zip -Raw
    $Result = Invoke-WebRequest -Method Post -Uri "https://uploads.github.com/repos/$ENV:APPVEYOR_REPO_NAME/releases/$GitHubReleaseId/assets?name=$env:BHProjectName-$env:ModuleVersion.zip" -Headers @{Authorization = "token $ENV:GitHubToken"} -ContentType 'application/zip' -Body $RequestBody
    if ($Result.StatusCode -ne 201) {
        Write-Error "Failed to upload release asset. Code $($Result.StatusCode): $($Result.Content)"
    }
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