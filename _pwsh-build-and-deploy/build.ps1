# https://documentation.red-gate.com/sca/getting-started/system-requirements/powershell-component-requirements
# https://documentation.red-gate.com/sca/getting-started/installation/installing-and-updating-powershell-components

param
(
      [string]$project = (get-item $PSScriptRoot ).parent.FullName + '\DontTypeInADemo.sqlproj',
      [string]$packageVersion = '0.0.001',
      [string]$packageID = 'DTD',
      [string]$buildArtifactPath = 'C:\DBAutomation\BuildArtifacts',
      [string]$buildSQLServer  = '.',   
      #https://documentation.red-gate.com/sc13/using-the-command-line/options-used-in-the-command-line
      [string]$sqlCompareOptions = ''
)

$errorActionPreference = "stop"


# Invoke the build
$validatedProject = $project | Invoke-DatabaseBuild -TemporaryDatabaseServer "Data Source =$buildSQLServer"

# Create a database build artifact
$buildArtifact = $validatedProject | New-DatabaseBuildArtifact -PackageId $packageID -PackageVersion $packageVersion

# Export the build artifact
$buildArtifact | Export-DatabaseBuildArtifact -Path "$buildArtifactPath"
