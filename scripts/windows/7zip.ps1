$ErrorActionPreference = "Stop"
 
$webserver = "s-bi-adobuild1.brisk-it.be"
$url = "http://" + $webserver
$installer = "7z2201-x64.msi"
$listConfig = "/i ""C:\temp\$installer"" /qn REBOOT=ReallySuppress"
 
# Verify connectivity
Test-Connection $webserver -Count 1
 
# Get AppVolumes Agent
Invoke-WebRequest -Uri ($url +"/" +$installer) -OutFile C:\temp\$installer
 
# Unblock installer
Unblock-File C:\temp\$installer -Confirm:$false
 
# Install AppVolumes Agent
Try 
{
   Start-Process msiexec.exe -ArgumentList $listConfig -PassThru -Wait
}
Catch
{
   Write-Error "Failed to install 7zip"
   Write-Error $_.Exception
   Exit -1 
}

# Cleanup on aisle 4...
Remove-Item C:\temp\$installer -Confirm:$false