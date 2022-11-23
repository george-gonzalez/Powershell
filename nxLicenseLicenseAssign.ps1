# Script to select a NoMachine license file and assign to a machine developed by George G.
# 2020
# Version 20200806.1

$licensePath = "\\server\share$\nomachine\Licenses"
$licenseLocalDestination = "C:\Temp\NXLicenses\"
function Assign-NXLicense

{
New-Item -ItemType Directory -Path $licensePath -Name $env:COMPUTERNAME-server

$getNodeLicense= Get-ChildItem -Path $licensePath -Filter "node-*.lic" | Sort-Object { [regex]::Replace($_.Name, '\d+', { $args[0].Value.PadLeft(20) }) } | Select-Object -First 1
$getServerLicense= Get-ChildItem -Path $licensePath -Filter "server-*.lic" | Sort-Object { [regex]::Replace($_.Name, '\d+', { $args[0].Value.PadLeft(20) }) } | Select-Object -First 1

Write-Host $getNodeLicense

Move-Item -Path $licensePath\$getNodeLicense -Destination $licensePath\$env:COMPUTERNAME-server
Move-Item -Path $licensePath\$getServerLicense -Destination $licensePath\$env:COMPUTERNAME-server

}

# Destination should be changed based on what is planned. 

function Copy-NXLicense
{

Copy-Item -Recurse "$licensePath\$env:COMPUTERNAME-server" -Destination $licenseLocalDestination

}

#Check for existing license assignment

if (Test-Path -LiteralPath "$licensePath\$env:COMPUTERNAME-server") { Write-Host "Machine has an existing license assigned, Using those..."
Copy-NXLicense
}

else {Write-Host "Assigning New licenses"
Assign-NXLicense
Copy-NXLicense
}
