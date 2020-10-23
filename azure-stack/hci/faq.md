---
title: Azure Stack HCI FAQ
description: Azure Stack HCI FAQ.
ms.topic: conceptual
author: JohnCobb1
ms.author: v-johcob
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 10/23/2020
---

# Azure Stack HCI FAQ
<!---Group into H2 subject area buckets. Add Cosmos FAQ buckets after these sections.--->

<!---Example note format.--->
   >[!NOTE]
   > TBD.



### How does Azure Stack HCI relate to Windows Server?

Windows Server is the foundation of nearly every Azure product, and all the features you value continue to ship and be supported in Windows Server. The initial offering of Azure Stack HCI was based on Windows Server 2019 and used the traditional Windows Server licensing model. Today, Azure Stack HCI has its own operating system and subscription-based licensing model. Azure Stack HCI is the recommended way to deploy HCI on-premises, using Microsoft-validated hardware from our partners.

### Does Azure Stack HCI need to connect to Azure?

Yes, the cluster must connect to Azure at least once every 30 days in order for the number of cores to be assessed for billing purposes. You can also take advantage of integration with Azure for hybrid scenarios like off-site backup and disaster recovery, and cloud-based monitoring and update management, but they're optional. It's no problem to run disconnected from the internet for extended periods.

### Can I upgrade from Windows Server 2019 to Azure Stack HCI?

There is no in-place upgrade from Windows Server to Azure Stack HCI at this time. Stay tuned for specific migration guidance for customers running hyperconverged clusters based on Windows Server 2019 and 2016.

### What do Azure Stack Hub and Azure Stack HCI solutions have in common?

Azure Stack HCI features the same Hyper-V-based software-defined compute, storage, and networking technologies as Azure Stack Hub. Both offerings meet rigorous testing and validation criteria to ensure reliability and compatibility with the underlying hardware platform.

### How are they different?

With Azure Stack Hub, you run cloud services on-premises. You can run Azure IaaS and PaaS services on-premises to consistently build and run cloud apps anywhere, managed with the Azure portal on-premises.

With Azure Stack HCI, you run virtualized workloads on-premises, managed with Windows Admin Center and familiar Windows Server tools. You can also connect to Azure for hybrid scenarios like cloud-based Site Recovery, monitoring, and others.

### Why is Microsoft bringing its HCI offering to the Azure Stack family?

Microsoft's hyperconverged technology is already the foundation of Azure Stack Hub.

Many Microsoft customers have complex IT environments and our goal is to provide solutions that meet them where they are with the right technology for the right business need. Azure Stack HCI is an evolution of the Windows Server Software-Defined (WSSD) solutions previously available from our hardware partners. We brought it into the Azure Stack family because we've started to offer new options to connect seamlessly with Azure for infrastructure management services.

### Can I upgrade from Azure Stack HCI to Azure Stack Hub?

No, but customers can migrate their workloads from Azure Stack HCI to Azure Stack Hub or Azure.

### What Azure services can I connect to Azure Stack HCI?

For an updated list of Azure services that you can connect Azure Stack HCI to, see [Connecting Windows Server to Azure hybrid services](/windows-server/manage/windows-admin-center/azure/index).

### Does Azure Stack HCI collect any data from my system?

Yes - a very limited set of data is collected. This data is used to keep HCI up to date, performing properly, provide information to the Azure portal, and to assess the number of processor cores in the cluster for billing purposes.

### To which endpoints is the data transmitted?  

Azure Stack HCI uses the following endpoint to transmit billing data: *-azurestackhci-usage.azurewebsites.net

### How do I identify an Azure Stack HCI server?

Windows Admin Center lists the operating system in the All Connections list and various other places, or you can use the following PowerShell command to query for the operating system name and version.

```PowerShell
Get-ComputerInfo -Property 'osName', 'osDisplayVersion'
```

Here’s some example output:

```
OsName                    OSDisplayVersion
------                    ----------------
Microsoft Azure Stack HCI 20H2
```

## Next steps
<!---Do we need this section?--->

- [Download Azure Stack HCI](https://azure.microsoft.com/products/azure-stack/hci/hci-download/)
- [Use Azure Stack HCI with Windows Admin Center](get-started.md)
