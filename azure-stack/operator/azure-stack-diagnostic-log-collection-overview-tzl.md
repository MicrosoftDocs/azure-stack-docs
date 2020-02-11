---
title: Azure Stack Hub diagnostic log collection overview 
description: Explains diagnostic log collection in Azure Stack Hub Help + Support, including on-demand and proactive log collection.
author: justinha

ms.topic: article
ms.date: 12/26/2019
ms.author: justinha
ms.reviewer: shisab
ms.lastreviewed: 12/26/2019

---
# Overview of Azure Stack Hub diagnostic log collection 

Azure Stack Hub is a large collection of both Windows components and on-premise Azure services interacting with each other. All these components and services generate their own set of logs. 

To help Microsoft Customer Support Services (CSS) diagnose issues as efficiently as possible, we have provided a seamless experience to diagnostic log collection.
Diagnostic log collection in **Help and Support** helps operators quickly collect and share diagnostic logs with Microsoft Customer Support Services (CSS). 

Diagnostic log collection works in two different ways:

- **Proactive log collection**: If enabled (recommended), logs are proactively sent to CSS based on specific health alerts
- **Send logs now**: This is a manual, on-demand option to send logs to CSS

![Screenshot of diagnostic log collection options](media/azure-stack-help-and-support/banner-enable-automatic-log-collection.png)

**Diagnostic log collection** has an easy user interface and doesn't require PowerShell. 
Logs get collected reliably even if infrastructure services are down.
It is recommended to enable proactive log collection and only use the [privileged endpoint (PEP) method](azure-stack-configure-on-demand-diagnostic-log-collection.md#use-the-privileged-endpoint-pep-to-collect-diagnostic-logs) to collect logs if the administrator portal or the **Help and Support** blade are unavailable.

>[!NOTE]
>Azure Stack must be registered and have internet connectivity to use **Diagnostic log collection**. If this is not the case, use the [Get-AzureStackLog PEP method](azure-stack-configure-on-demand-diagnostic-log-collection.md#use-the-privileged-endpoint-pep-to-collect-diagnostic-logs) to share logs.

## Proactive diagnostic log collection 

When a [specific health alert](azure-stack-configure-automatic-diagnostic-log-collection.md#proactive-diagnostic-log-collection-alerts) is active, log collection proactively uploads diagnostic logs from Azure Stack Hub to Microsoft managed storage, significantly reducing the time required to share diagnostic logs with CSS. Diagnostic logs are only collected when an alert is raised.  

For more information, see [Configure proactive Azure Stack Hub diagnostic log collection](azure-stack-configure-automatic-diagnostic-log-collection.md).

## On-demand diagnostic log collection


With on-demand collection, diagnostic logs are uploaded from Azure Stack Hub only when initiated by the customer, usually before opening a support case (recommended). 
This helps CSS access the logs quickly without having to engage with the customer.

For more information about collecting logs on demand, see [Send logs now](azure-stack-configure-on-demand-diagnostic-log-collection.md).

## Bandwidth considerations

The average size of diagnostic log collection varies based on whether it runs on-demand or proactively. 
The average size for proactive log collection is around 2 GB, whereas on-demand log collection size depends on how many hours are being collected. 

The following table lists considerations for environments with limited or metered connections to Azure.

| Network connection | Impact |
|--------------------|--------|
| Low-bandwidth/high-latency connection | Log upload will take an extended amount of time to complete | 
| Shared connection | The upload may also impact other applications/users sharing the network connection |

## See also

[Azure Stack Hub log and customer data handling](https://docs.microsoft.com/azure-stack/operator/azure-stack-data-collection)

