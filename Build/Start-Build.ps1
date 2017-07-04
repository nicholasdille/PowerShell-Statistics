param(
    $Task = 'Default'
)

# Check connectivity
if (Get-NetAdapter | Where-Object Status -ieq 'Up') {
    # Install dependencies
    Get-PackageProvider -Name NuGet -ForceBootstrap | Out-Null
    @('psake', 'PSDeploy', 'BuildHelpers', 'Pester', 'platyps', 'PSScriptAnalyzer', 'PSCoverage', 'CICD', 'PSGitHub') | ForEach-Object {
        if (-Not (Get-Module -ListAvailable -Name $_)) {
            Install-Module -Name $_ -Scope CurrentUser -Force
        }
    }

} else {
    Write-Warning 'No network connectivity. Unable to install/update module dependencies.'
}

# Prepare build environment
$BHVariables = Get-BuildVariables
$env:BHBuildSystem   = $BHVariables.BuildSystem
$env:BHProjectPath   = Get-Item -Path "$PSScriptRoot\.." | Select-Object -ExpandProperty FullName
$env:BHBranchName    = $BHVariables.BranchName
$env:BHCommitMessage = $BHVariables.CommitMessage
$env:BHBuildNumber   = $BHVariables.BuildNumber

$env:GitHubOwner = git config -l | Where-Object { $_ -like 'remote.origin.url=*' } | ForEach-Object {
    if ( $_ -match '^https://github.com/([^/]+)/([^/]+)(.git)?$' ) {
        $env:GitHubOwner = $Matches[1]
        $env:GitHubRepo = $Matches[2]
    }
}

# Invoke psake and handle return value
Invoke-psake $PSScriptRoot\psake.ps1 -taskList $Task -nologo
exit ( [int]( -not $psake.build_success ) )