# Script to find and rename computer based on dns lookup developed by George G.
# 2019
# Version 20190315.1

#Set up credentials

$LocalCreds = New-Object System.Management.Automation.PsCredential(".\Administrator", (ConvertTo-SecureString "PASSGOESHERE" -AsPlainText -Force))

# Get local IP

$ipv4 = Test-Connection -ComputerName $env:COMPUTERNAME -Count 1

$resultIP = ($ipv4.IPV4Address).IPAddressToString

# Perform DNS Lookup on IP

$newName= nslookup $resultIP | Select-String  -Pattern "Name:"

# Srip out extraneous details.

$newname = ($newname -replace ".domain.com", "")
$newName = ($newName -replace "Name:    ", "")

echo $newName

Rename-Computer -NewName $newName -LocalCredential $LocalCreds -Restart