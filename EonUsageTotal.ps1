# Script to monitor license usage from eon-Vue and PlantFactory developed by George G.
# 2020
# Version 20200819.1

#Set variable for binary license server and port location

$licServer = "licenseserver" 
$licServerPort ="5053"
$rlmutil = C:\Temp\rlmutil.exe rlmstat -c $licServerPort@$licServer -i eonsoftw -avail

#Set output file

$outputFile = "C:\Temp\eonlicenseStats.txt"

#Data manipulation

$Array = @($rlmutil)

ForEach ($line in $Array) {

$line = $line -replace 'vuee v1.0 available:', "Vue: "`
              -replace 'tpfe v1.0 available:', "Plant Factory: "`
              -replace 'suitee v1.0 available:', "Suite: "`
              -replace 'rndx v1.0 available:', "Render Node: "

echo $line
}

$Array




$outputDataVue = ($rlmutil | Select-String -Pattern "vuee" | ForEach-Object {
    $_ -replace '1/0 at ',"" `
       -replace 'vuee v1.0: ', "vuee," `
       -replace '\(handle:.*',"" `
       -replace "@", "," `
       -replace "`t", "" `
           
    })

$outputDataRnd = ($rlmutil | Select-String -Pattern "rndx" | ForEach-Object {
    $_ -replace '1/0 at ',"" `
       -replace 'rndx v1.0: ', "rndx," `
       -replace '\(handle:.*',"" `
       -replace "@", "," `
       -replace "`t", "" `
           
    })


$outputDataVue
$outputDataRnd


$outputDataVue.Count
$outputDataRnd.Count





    
