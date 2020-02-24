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

This topic covers how to get you Cloud ID by using the Administrator portal or the privileged endpoint (PEP). 

## Use the administrator portal

1. Open the Administrator portal. 
1. Click **Region management**.

   ![Screenshot of the Dashboard](./media/azure-stack-automatic-log-collection/dashboard.png)

1. Click **Properties** > **Properties**.

   ![Screenshot of the the Region blade](media/azure-stack-automatic-log-collection/region-blade.png)

1. Copy the **Stamp Cloud ID**.

   ![Screenshot of Region properties with Stamp Cloud ID](media/azure-stack-automatic-log-collection/region-properties-blade-with-stamp-cloud-id.png)


## Use the privileged endpoint

1. Open an elevated PowerShell session and run the following script. Replace the IP address of the PEP VM and  Cloud Admin credentials as needed for your environment. 

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

* [Send logs proactively](azure-stack-configure-automatic-diagnostic-log-collection-tzl.md)
* [Send logs now](azure-stack-configure-on-demand-diagnostic-log-collection-portal-tzl.md)






