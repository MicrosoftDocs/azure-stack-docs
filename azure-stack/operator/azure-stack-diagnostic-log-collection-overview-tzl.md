---
title: Azure Stack Hub diagnostic log collection overview 
description: Explains diagnostic log collection in Azure Stack Hub Help + Support, including on-demand and proactive log collection.
author: justinha

ms.topic: article
ms.date: 02/20/2020
ms.author: justinha
ms.reviewer: shisab
ms.lastreviewed: 02/20/2020

---
# Overview of Azure Stack Hub diagnostic log collection 

Azure Stack Hub is a large collection of both Windows components and on-premise Azure services interacting with each other. All these components and services generate their own set of logs. To enable Microsoft Customer Support Services (CSS) to diagnose issues efficiently, we have provided a seamless experience for diagnostic log collection. 

Diagnostic log collection in Help and Support helps operators quickly collect and share diagnostic logs with Microsoft Customer Support Services (CSS), an easy user interface, which does not require PowerShell. Logs get collected even if other infrastructure services are down.  
 
It is recommended to use this approach of log collection and only resort to [using the privileged endpoint (PEP)](azure-stack-get-azurestacklog.md) if the Administrator portal or Help and Support blade is unavailable. 

>[!NOTE]
>Azure Stack Hub must be registered and have internet connectivity to use diagnostic log collection. If Azure Stack Hub is not registered, then [use the privileged endpoint (PEP)](azure-stack-get-azurestacklog.md) to share logs. 

![Screenshot of diagnostic log collection options](media/azure-stack-help-and-support/banner-enable-automatic-log-collection.png)

## Collection options and data handling

Diagnostic log collection feature offers two options to send logs. The following table explains each option and how your data is handled in each case. 

### Send logs proactively

[Proactive log collection](azure-stack-configure-automatic-diagnostic-log-collection-tzl.md) streamlines and simplifies diagnostic log collection so customers can send logs to Microsoft before opening a support case. Diagnostic logs are proactively uploaded from Azure Stack Hub for analysis. These logs are only collected when a [system health alert](azure-stack-configure-automatic-diagnostic-log-collection-tzl.md#proactive-diagnostic-log-collection-alerts) is raised and are only accessed by the CSS in the context of a support case.

You agree to periodic automatic log collections by Microsoft based only on Azure Stack Hub system health alerts. You also acknowledge and consent to the upload and retention of those logs in an Azure storage account managed and controlled by Microsoft. 

#### How the data is handled

The data will be used only for the purpose of troubleshooting system health alerts and will not be used for marketing, advertising, or any other commercial purposes without your consent. The data can be retained for up to 90 days and any data Microsoft collects will be handled in accordance with our [standard privacy practices](https://privacy.microsoft.com/).

Any data previously collected with your consent will not be affected by the revocation of your permission.

Logs collected using Proactive log collection are uploaded to an Azure storage account managed and controlled by Microsoft. These logs may be accessed by Microsoft in the context of a support case and to improve the health of Azure Stack Hub.|

### Send logs now

[Send logs now](azure-stack-configure-on-demand-diagnostic-log-collection-tzl.md) is a manual option where diagnostic logs are uploaded from Azure Stack Hub only when you (as the customer) initiate the collection, usually before opening a support case. 

By initiating diagnostic log collection from Azure Stack Hub, you acknowledge and consent to uploading those logs and retaining them in an Azure storage account managed and controlled by Microsoft. Microsoft CSS can access these logs right away with the support case without having to engage with the customer for log collection. 

#### How the data is handled

The data will be used only for the purpose of troubleshooting system health alerts and will not be used for marketing, advertising, or any other commercial purposes without your consent. The data can be retained for up to 90 days and any data Microsoft  collects will be handled in accordance with our [standard privacy practices](https://privacy.microsoft.com/). 

Logs collected using Send logs now are uploaded to a Microsoft managed and controlled storage. These logs are accessed by Microsoft in the context of a support case and to improve the health of Azure Stack Hub. 

## Bandwidth considerations

The average size of diagnostic log collection varies based on whether it runs proactively or manually. The average size for **Proactive log collection** is around 2 GB. The  collection size for **Send logs now** depends on how many hours are being collected.

The following table lists considerations for environments with limited or metered connections to Azure.


| Network connection | Impact |
|--------------------|--------|
| Low-bandwidth/high-latency connection | Log upload will take an extended amount of time to complete | 
| Shared connection | The upload may also impact other applications/users sharing the network connection |
| Metered connection | There may be an additional charge from your ISP for the additional network usage | 

## See also

[Azure Stack Hub log and customer data handling](https://docs.microsoft.com/azure-stack/operator/azure-stack-data-collection)

