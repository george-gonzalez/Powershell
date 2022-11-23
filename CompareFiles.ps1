# Script to take two files and and extract the differences developed by George G.
# 2019
# Version 20190628.1


## Set Variables for Lists by ingesting text files with the list.

$list1= Get-Content -Path (Read-Host -Prompt 'Type the path and filename for list 1')

$list2= Get-Content -Path (Read-Host -Prompt 'Type the path and filename for list 2')


## Used for Debugging - Output the content of the variables
#Write-Host $list1
#Write-Host $list2


# Write out the results
Write-Host "The following items are not in list #2"

#Compare and add to variable for later export

$result = $list1 | ?{$list2 -notcontains $_}


$result