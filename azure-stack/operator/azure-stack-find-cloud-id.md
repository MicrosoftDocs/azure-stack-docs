---
title: Find your cloud ID  
description: How to find your Cloud ID in Azure Stack Hub Help + Support.
author: justinha

ms.topic: article
ms.date: 10/08/2019
ms.author: justinha
ms.reviewer: shisab
ms.lastreviewed: 10/08/2019

---
# Find your Cloud ID

This topic covers hot to get you Cloud ID. 

## Use the administrator portal

Properties > Properties > Region > Registration status > Stamp Cloud ID





##  Use the privileged endpoint



```powershell
$ipAddress = "<IP ADDRESS OF THE PEP VM>" # You can also use the machine name instead of IP here.

$password = ConvertTo-SecureString "<CLOUD ADMIN PASSWORD>" -AsPlainText -Force
$cred = New-Object -TypeName System.Management.Automation.PSCredential ("<DOMAIN NAME>\CloudAdmin", $password)
$session = New-PSSession -ComputerName $ipAddress -ConfigurationName PrivilegedEndpoint -Credential $cred

$stampInfo = Invoke-Command -Session $session { Get-AzureStackStampInformation }
if ($session) {
    Remove-PSSession -Session $session
}

$stampInfo.CloudID
```

## Next steps



