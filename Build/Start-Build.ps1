param(
    $Task = 'Default'
)

# Install dependencies
Get-PackageProvider -Name NuGet -ForceBootstrap | Out-Null
@('psake', 'PSDeploy', 'BuildHelpers', 'Pester', 'platyps') | ForEach-Object {
    if (-Not (Get-Module -ListAvailable -Name $_)) {
        Install-Module -Name $_ -Scope CurrentUser -Force
    }
}

# Prepare build environment
$BHVariables = Get-BuildVariables
$env:BHBuildSystem   = $BHVariables.BuildSystem
$env:BHProjectPath   = $BHVariables.ProjectPath
$env:BHBranchName    = $BHVariables.BranchName
$env:BHCommitMessage = $BHVariables.CommitMessage
$env:BHBuildNumber   = $BHVariables.BuildNumber

# Invoke psake and handle return value
Invoke-psake $PSScriptRoot\psake.ps1 -taskList $Task -nologo
exit ( [int]( -not $psake.build_success ) )