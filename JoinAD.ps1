# Script to join Computer objects to Active Directory developed by George G.
# 2019
# Version 20190313.1

$JoinADPW = New-Object System.Management.Automation.PsCredential("DOMAINNAME\svc_joinad", (ConvertTo-SecureString "insert-password-here" -AsPlainText -Force))

## This adds the machine it runs on and adds to the OU listed in OUPath it will also restart the machine when done

Add-Computer -DomainName domain.com -OUPath "OU=MSProjectVM,OU=Clients,OU=Computers,DC=domain,DC=com" -Credential $JoinADPW -Force -Restart
