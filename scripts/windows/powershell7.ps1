$ErrorActionPreference = "Stop"
 
$webserver = "s-be-ki-packer.brisk-it.net"
$url = "http://" + $webserver
$installer = "PowerShell-7.2.6-win-x64.msi"
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
   Write-Error "Failed to install Powershell 7"
   Write-Error $_.Exception
   Exit -1 
}

# Cleanup on aisle 4...
Remove-Item C:\temp\$installer -Confirm:$false