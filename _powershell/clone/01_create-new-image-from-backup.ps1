# Modified from: https://documentation.red-gate.com/clone4/automation/powershell-worked-examples/create-an-image-for-the-latest-backup

##########################################################################################
# Create an image for the latest backup.ps1 - version 0.1
# Purpose: One key use case for SQL Clone is to have the latest possible copy of a
#          production database available for quick mounting in another environment. For a
#          backup file matching a database name, this script obtains the latest then uses
#          it to create a SQL Clone image.
# Warning: You need to provide a SQL Clone Agent to perform the operation, but you only 
#          need the disk space for the database to be available in the final destination
#         (the operation uses a virtual mount point into that location).
##########################################################################################

$ServerUrl = 'http://derp:14145' # Set to your Clone server URL
$MachineName = 'DERP' # The machine name of the SQL Server instance to create the clones on
$InstanceName = '' # The instance name of the SQL Server instance to create the clones on
$ImageLocation = '\\DERP\CloneImages' # Point to the file share we want to use to store the image
$DatabaseName = 'DontTypeInADemo' # The name of the database
$BackupFolder = '\\DERP\bak\' # The path to the database backup folder
$DataImageName = 'NorthwindNew'  # Prepare a name for the data image, with a timestamp this would use + (Get-Date -Format "yyyyMMdd")


# You may not need to change these
$BackupPath = "{0}\{1}.bak" -f $BackupFolder, $DatabaseName  # The path to the database backup folder

##########################################################################################

Write-Host 'Connecting to clone.'
Connect-SqlClone -ServerUrl $ServerUrl


$Image = Get-SqlCloneImage -Name "$DataImageName" -ErrorAction:SilentlyContinue
if ( $Image )
{
  Write-Host "Image $DataImageName already exists, not creating a new one"
}
else {
  Write-Host "Taking a fresh backup of $DatabaseName"

  Backup-SqlDatabase -ServerInstance "DERP" -Database $DatabaseName -BackupFile "$BackupPath" -Initialize

  $TemporaryServer = Get-SqlCloneSqlServerInstance -MachineName $MachineName -InstanceName $InstanceName # You can omit the instance parameter if there is only one instance

  if (!(Test-Path ($BackupFolder)))
    {
      Write-Host "Backup folder not found. Exiting."
      break
    }


  #Start a timer
  $elapsed = [System.Diagnostics.Stopwatch]::StartNew()



  $ImageDestination = Get-SqlCloneImageLocation -Path $ImageLocation

  New-SqlCloneImage -Name $DataImageName -SqlServerInstance $TemporaryServer -BackupFileName $BackupPath -Destination $ImageDestination | Wait-SqlCloneOperation # Create the data image and wait for completion

  Write-Host "Total Elapsed Time: $($elapsed.Elapsed.ToString())" 

  Write-Host "Created image $DataImageName"

}