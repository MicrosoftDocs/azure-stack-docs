---
title: Find your cloud ID  
description: How to find your Cloud ID in Azure Stack Hub Help + Support.
author: myoungerman

ms.topic: article
ms.date: 10/08/2019
ms.author: v-myoung
ms.reviewer: shisab
ms.lastreviewed: 10/08/2019

# Intent: As an Azure Stack Hub user, I want to find my Cloud ID.
# Keywords: find cloud id

---
# Find your Cloud ID

This topic covers how to get your Cloud ID by using the Administrator portal or the privileged endpoint (PEP). The Cloud ID is the unique ID for tracking support data uploaded from a specific scale unit. When diagnostic logs are uploaded for support analysis, the Cloud ID is how the logs are associated with that scale unit.

## Use the administrator portal

1. Open the Administrator portal. 
1. Select **Region management**.

   ![Screenshot of the Dashboard](./media/azure-stack-automatic-log-collection/dashboard.png)

1. Select **Properties** and copy the **Stamp Cloud ID**.

   ![Screenshot of Region properties with Stamp Cloud ID](media/azure-stack-automatic-log-collection/region-properties-blade-with-stamp-cloud-id.png)


## Use the privileged endpoint

1. Open an elevated PowerShell session and run the following script. Replace the IP address of the PEP VM and Cloud Admin credentials as needed for your environment. 

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

* [Send logs proactively](./azure-stack-diagnostic-log-collection-overview.md###send-logs-proactively)
* [Send logs now](./azure-stack-configure-on-demand-diagnostic-log-collection-portal.md?view=azs-2002###send-logs-now)
