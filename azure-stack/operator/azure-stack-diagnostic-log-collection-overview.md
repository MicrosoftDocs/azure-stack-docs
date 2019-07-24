---
title: Azure Stack diagnostic log collection overview | Microsoft Docs
description: Explains diagnostic log collection in Azure Stack Help + Support, including on-demand and automatic log collection.
services: azure-stack
documentationcenter: ''
author: justinha
manager: femila
editor: ''

ms.assetid: a20bea32-3705-45e8-9168-f198cfac51af
ms.service: azure-stack
ms.workload: na
ms.tgt_pltfrm: na
ms.devlang: na
ms.topic: article
ms.date: 07/24/2019
ms.author: justinha
ms.reviewer: prchint
ms.lastreviewed: 07/24/2019

---
# Overview of Azure Stack diagnostic log collection 

*Applies to: Azure Stack integrated systems*

Azure Stack is a large collection of components working together and interacting with each other. All these components generate their own unique logs. This can make diagnosing issues a challenging task, especially for errors coming from multiple, interacting Azure Stack components.

Our diagnostics tools help make log collection easy and efficient. For example, operators can use [the privileged endpoint (PEP)](azure-stack-configure-on-demand-diagnostic-log-collection.md#using-pep) to collect logs from all the components in an Azure Stack environment, and [the Azure Stack validation tool (Test-AzureStack)](azure-stack-diagnostic-test.md) can run a series of tests on your system to identify failures. 

Beginning with the 1907 release, Azure Stack adds a simpler way to collect logs by using the **Diagnostic log collection** in Help and Support. 
**Diagnostic log collection** is part of an ongoing investment to make it easier for Azure Stack operators to troubleshoot problems. 
Operators can quickly share diagnostic logs with Microsoft Customer Support Services (CSS). 
The logs can be stored in a blob container in Azure and access can be restricted to only CSS.   
   
**Diagnostic log collection** can collect diagnostic logs in two different ways:

- **Automatic collection**: If enabled, log collection is triggered by specific health alerts 
- **Collect logs now**: You choose a 1-4 hour sliding window from the last seven days

![Screenshot of diagnostic log collection options](media/azure-stack-automatic-log-collection/azure-stack-log-collection-overview.png)

**Diagnostic log collection** has a simple user interface and doesn't require any PowerShell experience. 
Logs are reliably collected even when some of the infrastructure services are down.
If your policy allows sharing diagnostic logs with CSS, **Diagnostic log collection** is the recommended collection method beginning with the 1907 release. 
You should only need to [use PEP](azure-stack-configure-on-demand-diagnostic-log-collection.md#using-pep) if **Diagnostic log collection** in Help and Support is unavailable.

## Automatic diagnostic log collection 

Automatic diagnostic log collection proactively uploads diagnostic logs from Azure Stack to a storage blob in Azure when certain critical alerts are raised, significantly reducing the time required to share diagnostic logs with CSS.

For more information about automatic log collection, see [Configure automatic Azure Stack diagnostic log collection](azure-stack-configure-automatic-diagnostic-log-collection.md).

## On-demand diagnostic log collection

With on-demand collection, diagnostic logs are uploaded from Azure Stack to a storage blob in Azure when an Azure Stack operator manually triggers the collection.
CSS will provide shared access signature (SAS) URL to a CSS-owned storage blob. 
An Azure Stack operator can click **Collect logs now** to enter the SAS URL. 
Diagnostic logs get uploaded directly to the CSS blob without needing an intermediate share. 

For more information about collecting logs on demand, see [Collect Azure Stack diagnostic logs now](azure-stack-configure-on-demand-diagnostic-log-collection.md).

## Bandwidth considerations

The average size of diagnostic log collection varies based on whether log collection is on-demand or automatic. 
Automatic log collection size is around 2 GB on average. 
For on-demand log collection, the size of the logs collection depends on how many hours are being collected. 

>[!CAUTION]
>Don't enable automatic log collection if you are using a low-bandwidth, high-latency link. In this case, only use on-demand log collection. 

For more information, see [Best practices for automatic Azure Stack log collection](azure-stack-best-practices-automatic-diagnostic-log-collection.md).

## See also

[Azure Stack log and customer data handling](https://docs.microsoft.com/azure-stack/operator/azure-stack-data-collection)

[Using shared access signatures (SAS)](https://docs.microsoft.com/azure/storage/common/storage-dotnet-shared-access-signature-part-1)

