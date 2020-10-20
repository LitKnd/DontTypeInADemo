##########################################################################################
# https://documentation.red-gate.com/clone4/automation/powershell-cmdlet-reference/rename-sqlcloneimage


$ServerUrl = 'http://derp:14145' # Set to your Clone server URL
$CurrentImageName = 'Northwind' #This will be renamed to $CurrentImageNameOld
$ReplacementImageName = 'NorthwindNew' #This will be renamed to $CurrentImageName

$ErrorActionPreference = "Stop"

##########################################################################################

Write-Host 'Connecting to clone.'
Connect-SqlClone -ServerUrl $ServerUrl


$current = Get-SqlCloneImage -Name "$CurrentImageName" -ErrorAction:Continue
$new = Get-SqlCloneImage -Name "$ReplacementImageName" -ErrorAction:Continue

Write-Host "Check: Do both images exist?"
if ( $current -and $new)

{
    Write-Host "Take the current baseline image and rename it to $CurrentImageNameOld"
    $ImageToRename = Get-SqlCloneImage -Name "$CurrentImageName"
    $NewName = "{0}Old" -f $CurrentImageName
    Rename-SqlCloneImage -Image $ImageToRename -NewName $NewName

    Write-Host "Take the new image and rename it to $CurrentImageName"
    $ImageToRename = Get-SqlCloneImage -Name "$ReplacementImageName"
    Rename-SqlCloneImage -Image $ImageToRename -NewName "$CurrentImageName"

}
else {

    Write-Host "Did not find BOTH images $CurrentImageName and $ReplacementImageName, no action taken"
}