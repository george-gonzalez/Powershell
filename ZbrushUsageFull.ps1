# Script to monitor license usage from Zbrush developed by George G.
# 2020
# Version 20200206.1

#Set variable for binary license server and port location

$licServer = "license1" 
$licServerPort ="2376"
$rlmutil = C:\Temp\rlmutil.exe rlmstat -c $licServerPort@$licServer -i pixologic -p zbrush
$i++
filter timestamp {"$(Get-Date -Format o),$i, $_"}

#Set output file

$outputFile = "C:\Temp\zbrushlicenseStats.txt"

#Data manipulation

$outputData = ($rlmutil | Select-String -Pattern "zbrush" | ForEach-Object {
    $_ -replace '1/0 at ',"" `
       -replace 'zbrush v4.0: ', "" `
       -replace 'zbrush v4: ', "" `
       -replace '\(handle:.*',"" `
       -replace "@", "," `
       -replace "`t", "" `
       -replace " ", "," `
        | timestamp 
    })
    
#Outputting file as CSV
  
$outputData | Out-File -FilePath $outputFile

#Adding header information to CSV and re-saving file

$csvData = import-csv $outputFile -Header currenttime, usedcount, username, computer, checkoutdate, checkouttime

#Total Count of licenses used

$totalUsed = $outputData | Measure-Object -Line

$totalUsed

$csvData | export-csv $outputFile -NoTypeInformation

Write-Output $csvData

# As an alternative this converts the data to JSON and saves out a file
   
# $outputData | ConvertTo-Json | Out-File -FilePath $outputFile

#Post Data to the Telegraf database for Graphing purposes.

#Invoke-WebRequest 'http://influx.domain.com:8086/write?db=telegraf' -Method POST -Body "zbrush_usage,host=win-lic01 Zbrush_inUse=$inUse"

#Invoke-WebRequest 'http://influx.domain.com:8086/write?db=telegraf' -Method POST -Body "zbrush_usage,host=win-lic01 Zbrush_free=$totalAvail"

# Note to self - to be able to post this data I will most likely have to do a query + manipulation + post of each of the data or query the data once and then use
# the file that is generated to compose the POST.

https://docs.influxdata.com/influxdb/v0.9/guides/writing_data/

