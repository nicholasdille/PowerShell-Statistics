# Generic module deployment.
#
# ASSUMPTIONS:
#
# * folder structure either like:
#
#   - RepoFolder
#     - This PSDeploy file
#     - ModuleName
#       - ModuleName.psd1
#
#   OR the less preferable:
#   - RepoFolder
#     - RepoFolder.psd1
#
# * Nuget key in $ENV:NugetApiKey
#
# * Set-BuildEnvironment from BuildHelpers module has populated ENV:BHModulePath and related variables

# Publish to gallery with a few restrictions
if(
    $env:BHModulePath -and
    $env:BHBuildSystem -ne 'Unknown' -and
    $env:BHBranchName -eq "master" -and
    $env:BHCommitMessage -match '!deploy'
)
{
    Deploy Module {
        By PSGalleryModule {
            FromSource $ENV:BHModulePath
            To PSGallery
            WithOptions @{
                ApiKey = $ENV:NugetApiKey
            }
        }
    }   
    
    $RequestBody = @{
        "tag_name"         = "$Version"
        "target_commitish" = "$Branch"
        "name"             = "Version $Version"
        "body"             = "$Description"
        "draft"            = -Not $NoDraft
        "prerelease"       = -Not $Release
    } | ConvertTo-Json
    $Result = Invoke-WebRequest -Method Post -Uri "https://api.github.com/repos/$Owner/$Repository/releases" -Headers @{Authorization = "token $ENV:GitHubToken"} -Body $RequestBody
}
else
{
    "Skipping deployment: To deploy, ensure that...`n" +
    "`t* You are in a known build system (Current: $ENV:BHBuildSystem)`n" +
    "`t* You are committing to the master branch (Current: $ENV:BHBranchName) `n" +
    "`t* Your commit message includes !deploy (Current: $ENV:BHCommitMessage)" |
        Write-Host
}

# Publish to AppVeyor if we're in AppVeyor
if(
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