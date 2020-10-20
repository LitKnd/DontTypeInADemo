# https://documentation.red-gate.com/sca/getting-started/system-requirements/powershell-component-requirements
# https://documentation.red-gate.com/sca/getting-started/installation/installing-and-updating-powershell-components


param
(
    [string]$project = (get-item $PSScriptRoot ).parent.FullName + '\DontTypeInADemo.sqlproj',
    [string]$packageVersion = '0.0.001',
    [string]$packageID = 'DTD',
    [string]$artifactPath = 'C:\DBAutomation\BuildArtifacts',
    [string]$releaseArtifactPath = 'C:\DBAutomation\ReleaseArtifacts',
    [string]$targetSQLServer  = '.',
    [string]$targetDatabase = 'DontTypeInADemoDeploy1'
)

$buildArtifact = "$artifactPath\$packageID.$packageVersion.nupkg"

# Connect to the database we plan to deploy to 
$targetConnection = New-DatabaseConnection -ServerInstance $targetSQLServer -Database $targetDatabase

# Create the release artifact
$releaseArtifact = New-DatabaseReleaseArtifact -Source $buildArtifact -Target $targetConnection -SQLCompareOptions $sqlCompareOptions 

# Export release artifact to the file system 
$releaseArtifact | Export-DatabaseReleaseArtifact -Path "$releaseArtifactPath\$targetDatabase.$packageID.$packageVersion\"

# One might have a review step in the pipeline here and then chose to import the release artifact like this and deploy it
# Import-DatabaseReleaseArtifact -Path "$artifactPath\$targetDatabase\$packageID.$packageVersion\" | Use-DatabaseReleaseArtifact -DeployTo $targetConnection

# We are not pausing for review so we deploy from $releaseArtifact
Use-DatabaseReleaseArtifact $releaseArtifact -DeployTo $targetConnection