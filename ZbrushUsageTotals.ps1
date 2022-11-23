# Script to monitor license usage from Zbrush developed by George G.
# 2020
# Version 20200213.1

#Set variable for binary, license server, port and hard coded total licenses

$currentLicenses = 30
$licServer = "licenseserver" 
$licServerPort ="2376"
$rlmutil = C:\Temp\rlmutil.exe rlmstat -c $licServerPort@$licServer -i pixologic -p zbrush -avail

#This was meant to add influx compatible timestamps - decided to let the db add it at time of POST - kept for reference.
filter timestamp {"$(Get-Date -Format o), $_"} 

#Data manipulation, removing extra data

$outputData = ($rlmutil | Select-String -Pattern "v4" | ForEach-Object {
    $_ -replace 'v4 available: ',"" `
       -replace 'v4.0 available: ', "" `
   })

#Extracting the total available licenses

$totalAvail = Write-Output $outputData | Measure-Object -Sum | Select-Object -ExpandProperty Sum

#Extracting the total licenses in use
$inUse = ($currentLicenses - $totalAvail)

#Post Data to the Telegraf database for Graphing purposes.

Invoke-WebRequest 'http://influx.domain.com:8086/write?db=telegraf' -Method POST -Body "zbrush_usage,host=win-lic01 Zbrush_inUse=$inUse"

Invoke-WebRequest 'http://influx.domain.com:8086/write?db=telegraf' -Method POST -Body "zbrush_usage,host=win-lic01 Zbrush_free=$totalAvail"

