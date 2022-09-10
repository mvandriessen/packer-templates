#Set VM Version file
$date = (Get-Date).ToShortDateString().Replace("/","-")
new-item "c:\template_$($date).txt" -ItemType "file"

#clearing Eventlogs
Get-EventLog -LogName * | ForEach { Clear-EventLog -LogName $_.Log }