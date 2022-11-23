# Define license path as literal string
$licensepath = "\\server\share$\nomachine\Licenses"

Function assignlicense
{
# Get a list of all file objects in that file path and select the name parameter. Assign the names to Array
$Array = @(Get-ChildItem -Path $licensepath -Force | Select-Object Name)
# Define an empty array to store the full file paths
$fileList = @()
foreach ($item in $Array) {
    # Cut uneccessary characters
    $item = $item -replace '@{Name='
    $item = $item -replace '}'
    # Concatiante the file path and file name
    $fullFilename = $licensepath + "\" + $item.ToString()
    # Append the file path array
    if ([string]$fullFilename -Like "*node-*") {
        $fileList += $fullFilename 
    }
    }
# Identify Node and Server License
$nodelicense = $filelist[0]
$nodelicensenumber = $nodelicense.Split("-")[1]
$serverlicense = $licensepath + "\server-" + $nodelicensenumber

# Create directory and move licenses
New-Item -ItemType Directory -Path $licensepath -Name $env:COMPUTERNAME-server
Move-Item -Path $nodelicense -Destination $licensepath\$env:COMPUTERNAME-server
Move-Item -Path $serverlicense -Destination $licensepath\$env:COMPUTERNAME-server
}

Function copyNXLicense
{
Copy-Item -Recurse "$licensepath\$env:COMPUTERNAME-server" -Destination C:\Temp\NXLicenses\
}

Function activatelicense
{
$value = Get-Childitem "$licensepath\$env:COMPUTERNAME-server" -filter "node*" | select-object -ExpandProperty Name
$value = $value.Split("-")[1]
cmd.exe /c "`"C:\Program Files (x86)\NoMachine\bin\nxserver.exe`" --activate C:\Temp\NXLicenses\node-$value"
cmd.exe /c "`"C:\Program Files (x86)\NoMachine\bin\nxserver.exe`" --activate C:\Temp\NXLicenses\server-$value"
}

#Check for existing license assignement
if (Test-Path -LiteralPath "$licensepath\$env:COMPUTERNAME-server") 
{ 
    Write-Host "Machine has an existing license assigned, Using those..."
copyNXLicense
activatelicense
}

else
{
    Write-Host "Assigning New licenses"
assignlicense
copyNXLicense
activatelicense
}


