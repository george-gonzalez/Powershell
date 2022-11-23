# Script to remove Computer objects from Active Directory developed by George G.
# 2018
# Version 20190115.1

#Get Date
$Date = Get-Date

# Ask for Computer name the query Active Directory for that name
# If the name doesn't match, loop until it does

Write-Host "Windows AD Decomissioning"`n

do
{

$ComputerName = Read-Host -Prompt 'Input Computer Name or press enter to delete multiple computers based on a file'
$ComputerName = $ComputerName.Trim().ToLower()

$ValidNames = Get-ADComputer -Identity $ComputerName | Select-Object Name

if ($ValidNames -like "*$ComputerName*") 

{ Write-Host "Machine Name $ComputerName is Valid"} elseif ($ValidNames -notlike "*$ComputerName*")

 { Write-Host "Machine Name $ComputerName is Not Valid, Please enter a valid computer name."
   pause
}
}
until ($ValidNames -like "*$ComputerName*")

#Remove Blank lines and whitespaces from the computernames file

function Clean-Names
{
$CleanNames = Get-Content C:\Temp\COMPUTERS2DELETE.txt
$CleanNames = $ListOfNames.Trim().ToLower() | where {$_ -ne ""} | Set-Content C:\Temp\COMPUTERS2DELETE.txt
}

#Notification

function Notify-Changelog
{
Send-MailMessage -From WindowsDecomScript@domain.com -To it@domain.com -Subject "$ComputerName has been removed from AD" -Body "User: $env:USERNAME has removed Computer(s): $ComputerName from Active Directory on $Date." -SmtpServer smtp.domain.com -Verbose
}

function Notify-ChangeLogList
{

$ListOfNames = Get-Content C:\Temp\COMPUTERS2DELETE.txt

Send-MailMessage -From WindowsDecomScript@domain.com -To it@domain.com -Subject "Several Computers have been removed from AD" -Body "User: $env:USERNAME has removed Computer(s): $ListOfNames from Active Directory on $Date." -SmtpServer smtp.domain.com -Verbose
}

# Display a user menu

function Show-Menu
{
     param (
           [string]$Title = 'Windows Decomissioning'
     )
     cls
     Write-Host "================ $Title ================`n"
    
     Write-Host "Actions will be performed on '$ComputerName'`n"
    
     Write-Host "1: Press '1' Delete Computer from Active Directory."
     Write-Host "2: Press '2' Delete Multiple Computers from Text File in C:\TEMP\COMPUTERS2DELETE.txt"
     Write-Host "3: Press '3' Delete from all services."
     Write-Host "Q: Press 'Q' to quit."
}


# Loop until a selection is made, when made execute the code.
# Option 1 will also allow user to enter a different name or quit.

do
{
     Show-Menu
     $input = Read-Host "Please make a selection"
     switch ($input)
     {
           '1' {
                Remove-ADComputer -Identity $ComputerName
                Notify-Changelog
                $ComputerName = Read-Host -Prompt 'Input another computer name or press enter to go back to the main menu'
                cls
           } '2' {
                Clean-Names        
                Write-Host "The following computers will be deleted from Active Directory." -ForegroundColor White -BackgroundColor Red        
                Get-Content C:\Temp\COMPUTERS2DELETE.txt | % { Get-ADComputer -Filter { Name -eq $_ } } | Write-Host 
                pause
                Get-Content C:\Temp\COMPUTERS2DELETE.txt | % { Get-ADComputer -Filter { Name -eq $_ } } | Remove-ADComputer 
                Notify-ChangeLogList
                Clear-Content C:\Temp\COMPUTERS2DELETE.txt

                'You chose option #2'
           } '3' {
                cls
                'You chose option #3'
           } 'q' {
                return
           }
     }
     #pause
}
until ($input -eq 'q')