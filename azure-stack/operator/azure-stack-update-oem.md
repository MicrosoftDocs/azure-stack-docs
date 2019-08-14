---
title: Apply an OEM update to Azure Stack | Microsoft Docs
description: Learn to apply an OEM update to Azure Stack.
services: azure-stack
documentationcenter: ''
author: mattbriggs
manager: femila
editor: ''

ms.service: azure-stack
ms.workload: na
ms.tgt_pltfrm: na
ms.devlang: na
ms.topic: article
ms.date: 08/14/2019
ms.author: mabrigg
ms.lastreviewed: 08/14/2019
ms.reviewer: ppacent 

---

# Apply Azure Stack original equipment manufacturer (OEM) updates

*Applies to: Azure Stack integrated systems*

You can apply original equipment manufacturer (OEM) updates to your Azure Stack hardware components to receive driver and firmware improvements as well as security patches while minimizing the impact on your users. In this article, you can learn about OEM updates, OEM contact information, and how to apply an OEM update.

## Overview of OEM updates


In addition to Microsoft Azure Stack updates, many OEM will also release updates for your Azure Stack hardware, such as driver and firmware updates. These are referred to as **OEM Package Updates**. To understand whether your OEM releases OEM Package Updates, check your *OEM’s Azure Stack documentation*(link to OEM documentation page).

Starting with Azure Stack update 1905 these OEM package updates are uploaded into the **updateadminaccount** storage account and applied via the Azure Stack Administrator portal. For more information, see Applying OEM Updates (link to subsection)

Ask your original equipment manufacturer (OEM) about their specific notification process to ensure OEM package update notifications reach your organization.

Some hardware vendors may require a *proxy VM* that handles the internal firmware update process. For more information, see [Configure hardware vendor proxy VM](#configure-hardware-vendor-proxy-vm) \[Link to Configure hardware vendor Proxy VM section\]

## OEM contact information 
| Hardware Partner | Region | URL |
|------------------|--------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Cisco | All | [Cisco Integrated System for Microsoft Azure Stack Operations Guide](https://www.cisco.com/c/en/us/td/docs/unified_computing/ucs/azure-stack/b_Azure_Stack_Operations_Guide_4-0/b_Azure_Stack_Operations_Guide_4-0_chapter_00.html#concept_wks_t1q_wbb)<br><br>[Release Notes for Cisco Integrated System for Microsoft Azure Stack](https://www.cisco.com/c/en/us/support/servers-unified-computing/ucs-c-series-rack-mount-ucs-managed-server-software/products-release-notes-list.html) |
| Dell EMC | All | [Cloud for Microsoft Azure Stack 14G (account and login required)](https://support.emc.com/downloads/44615_Cloud-for-Microsoft-Azure-Stack-14G)<br><br>[Cloud for Microsoft Azure Stack 13G (account and login required)](https://support.emc.com/downloads/42238_Cloud-for-Microsoft-Azure-Stack-13G) |
| Fujitsu | JAPAN | [Fujitsu managed service support desk (account and login required)](https://eservice.fujitsu.com/supportdesk-web/) |
|  | EMEA | [Fujitsu support IT products and systems](https://support.ts.fujitsu.com/IndexContact.asp?lng=COM&ln=no&LC=del) |
|  | EU | [Fujitsu MySupport (account and login required)](https://support.ts.fujitsu.com/IndexMySupport.asp) |
| HPE | All | [HPE ProLiant for Microsoft Azure Stack](http://www.hpe.com/info/MASupdates) |
| Lenovo | All | [ThinkAgile SXM Best Recipes](https://datacentersupport.lenovo.com/us/en/solutions/ht505122)
| Wortmann |  | [OEM/firmware package](https://drive.terracloud.de/dl/fiTdTb66mwDAJWgUXUW8KNsd/OEM)<br>[terra Azure Stack documentation (including FRU)](https://drive.terracloud.de/dl/fiWGZwCySZSQyNdykXCFiVCR/TerraAzSDokumentation)

## Apply OEM updates

Apply the OEM packages with the following steps:

1. Contact your OEM about the best method to download your OEM package.
2. Prepare your OEM package with the steps outlined in "Prepare an Azure Stack update package."
3. Apply the updates with the steps outlined in "Apply updates in Azure Stack."

## Configure hardware vendor proxy VM

Some hardware vendor require a proxy VM. The proxy VM handles the data from the source to the target in the internal firmware update process. You can configure the proxy VM with the following steps:

1.  Access the privileged endpoint

    ```powershell  
      $cred = Get-Credential
      
      Enter-PSSession -ComputerName &lt;IP_address_of_ERCS&gt; -ConfigurationName PrivilegedEndpoint -Credential $cred
    ```

2.  Configure the hardware vendor proxy VM.

## Next steps

[Azure Stack updates](azure-stack-updates.md)
