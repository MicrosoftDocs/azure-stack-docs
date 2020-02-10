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

This topic covers how to get you Cloud ID. 

## Use the administrator portal

Properties > Properties > Region > Registration status > Stamp Cloud ID

1. Open the Administrator portal. 
1. Click **Region management**.

   ![Screenshot of the Dashboard](./media/azure-stack-automatic-log-collection/dashboard.png)

1. Click **Properties** > **Properties**.

   ![Screenshot of the the Region blade](media/azure-stack-automatic-log-collection/region-blade.png)

1. Copy the **Stamp Cloud ID**.

   ![Screenshot of Region properties with Stamp Cloud ID](media/azure-stack-automatic-log-collection/region-properties-blade-with-stamp-cloud-id.png)


## Use the privileged endpoint



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



