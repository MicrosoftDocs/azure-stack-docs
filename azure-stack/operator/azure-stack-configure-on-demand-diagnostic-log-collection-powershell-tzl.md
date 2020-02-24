---
title: Send Azure Stack Hub diagnostic logs to Azure using the privileged endpoint (PEP)
description: Learn how to send Azure Stack Hub diagnostic logs to Azure using the privileged endpoint (PEP).
author: justinha

ms.topic: article
ms.date: 02/22/2020
ms.author: justinha
ms.reviewer: shisab
ms.lastreviewed: 02/22/2020

---
# Send Azure Stack Hub diagnostic logs to Azure using the privileged endpoint (PEP)

You do not have to provide any target storage location when using this method. If **fromDate** and **toDate** parameters are not provided, then it defaults to last 4 hours from the time of execution. 

You can optionally specify **FilterByRole** or **FilterByResourceProvider** parameter to include only specific role or value-add RP logs. 

Here's an example script you can run using the PEP to collect logs on an integrated system. 


```powershell
$ipAddress = "<IP ADDRESS OF THE PEP VM>" # You can also use the machine name instead of IP address. 
 
$password = ConvertTo-SecureString "<CLOUD ADMIN PASSWORD>" -AsPlainText -Force 
$cred = New-Object -TypeName System.Management.Automation.PSCredential ("<DOMAIN NAME>\CloudAdmin", $password) 
 
$session = New-PSSession -ComputerName $ipAddress -ConfigurationName PrivilegedEndpoint -Credential $cred 
 
$fromDate = (Get-Date).AddHours(-8) # Optional. 
$toDate = (Get-Date).AddHours(-2) # Optional. Provide the time that includes the period for your issue 
 
Invoke-Command -Session $session {Send-AzureStackDiagnosticLog -FromDate $using:fromDate -ToDate $using:toDate} 
 
if ($session) { 
    Remove-PSSession -Session $session 
} 
```

## Next steps

[Use the privileged endpoint (PEP) to send Azure Stack Hub diagnostic logs](azure-stack-get-azurestacklog.md)
