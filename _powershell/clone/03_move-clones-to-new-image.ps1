# Modified from https://documentation.red-gate.com/clone4/automation/powershell-worked-examples/refresh-all-clone-databases-to-use-an-updated-image

##########################################################################################
# Refresh all clone databases to use an updated image.ps1 EXCEPT delete shadow DBs
# Purpose: If you are regularly creating images so that you have a latest possible copy 
#          of a database available, you may want to migrate clones to that new image. This
#          script will remove existing clone databases for a named image, then create 
#          new clone databases in the same location for an updated image.
# Warning: The clone databases will be removed immediately by this script, and any changes
#          made to them will be lost. 
#          Clones with "SHADOW" in the name will be deleted (they'll be recreated on demand)
#          The old image will also be removed.
##########################################################################################

$ServerUrl = 'http://derp:14145' # Set to your Clone server URL
$OldImageName = 'NorthwindOld' # The name of the image to move clones from
$NewImageName = 'Northwind'  # The name of the image to move clones to

$ErrorActionPreference = "Stop"

##########################################################################################

Write-Host 'Connecting to clone.'
Connect-SqlClone -ServerUrl $ServerUrl

$oldImage = Get-SqlCloneImage -Name $OldImageName
$newImage = Get-SqlCloneImage -Name $NewImageName

Write-Host "Get clones"
$oldClones = Get-SqlClone | Where-Object {$_.ParentImageId -eq $oldImage.Id}

Write-Host "Move clones"
foreach ($clone in $oldClones)
{
    $thisDestination = Get-SqlCloneSqlServerInstance | Where-Object {$_.Id -eq $clone.LocationId}

    Remove-SqlClone $clone | Wait-SqlCloneOperation

    "Removed clone ""{0}"" from instance ""{1}"" " -f $clone.Name , $thisDestination.Server + '\' + $thisDestination.Instance;

    # Recreate if the clone name isn't like "*SHADOW"
    if ($clone.Name -like "*SHADOW" )
    {
        Write-Host "Not moving as this is a shadow"
    }
    else
        {
            $newImage | New-SqlClone -Name $clone.Name -Location $thisDestination  | Wait-SqlCloneOperation

            "Added clone ""{0}"" to instance ""{1}"" " -f $clone.Name , $thisDestination.Server + '\' + $thisDestination.Instance;
        }
}

Write-Host "Remove the old image"
Remove-SqlCloneImage -Image $oldImage;