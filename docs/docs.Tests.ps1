Get-ChildItem -Path $env:BHProjectPath\docs -Directory | Select-Object -ExpandProperty Name | ForEach-Object {
    "Compiling help for $_"

    Describe "Documentation for $_" {
        Get-Command -Module $env:ModuleName -CommandType Function | Select-Object -ExpandProperty Name | ForEach-Object {
            Context "Function $_" {
                $help = Get-Help -Name $_
                It 'Defines description' {
                    $help.description | Should Not Be ''
                }
                It 'Defines synopsis' {
                    $help.synopsis | Should Not Be ''
                }
            }
        }
    }
}