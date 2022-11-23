# Script to check if a list of Machines is in AD developed by George G.
# 2019
# Version 20190614.1

#Get List of machines

$Computers = Get-Content C:\Temp\HOSTNAMES.txt

Write-Host $Computers

#Check AD and Return Boolean

$ADCheck = ([bool](Get-ADComputer -Identity $Computer))

#Check each name on the list against AD

foreach ($Computer in $Computers) {$ADCheck}

Function CheckAD
{
   if (Get-ADComputer -Identity $_) {
      return 0
   }else{
      return 1
   }
}

