---
title: Diagnostic log collection in Azure Stack Hub
description: Learn about diagnostic log collection in Azure Stack Hub Help + support.
author: justinha
ms.topic: article
ms.date: 08/24/2020
ms.author: justinha
ms.reviewer: shisab
ms.lastreviewed: 08/24/2020

# Intent: As an Azure Stack Hub operator, I want to learn about diagnostic log collection so I can share them with Microsoft Support when I need help addressing an issue.
# Keyword: diagnostic log collection azure stack hub
---
# Diagnostic log collection in Azure Stack Hub


Azure Stack Hub is a large collection of both Windows components and on-premise Azure services interacting with each other. All these components and services generate their own set of logs. To enable Microsoft Support to diagnose issues efficiently, we've provided a seamless experience for diagnostic log collection.

Diagnostic log collection in **Help + support** helps operators quickly collect and share diagnostic logs with Microsoft Support in an easy user interface, which doesn't require PowerShell. Logs get collected even if other infrastructure services are down.  

Diagnostic log collection in Help and Support helps operators quickly collect and share diagnostic logs with Microsoft Customer Support Services (CSS), an easy user interface, which does not require PowerShell. Logs get collected even if other infrastructure services are down.  

::: moniker range=">= azs-2002"

It is recommended to use this approach of log collection and only resort to [using the privileged endpoint (PEP)](azure-stack-get-azurestacklog.md) if the Administrator portal or Help and Support blade is unavailable. 

>[!NOTE]
>Azure Stack Hub must be registered to use diagnostic log collection. If Azure Stack Hub is not registered, use [Get-AzureStackLog](azure-stack-get-azurestacklog.md) to share logs. 

![Diagnostic log collection options in Azure Stack Hub](media/azure-stack-help-and-support/banner-enable-automatic-log-collection.png)

## Collection options and data handling

::: moniker-end
::: moniker range=">= azs-2005"

Depending on connectivity to Azure, Azure Stack Hub has suitable ways to collect, save, and send diagnostic logs to CSS. If Azure Stack Hub can connect to Azure, the recommended way is to enable **Proactive log collection**, which will automatically upload diagnostic logs to a Microsoft-controlled storage blob in Azure when a critical alert gets raised. You can alternatively collect logs on-demand by using **Send logs now**, or you can save logs locally if Azure Stack Hub is disconnected from Azure. 

The following sections explain each option and how your data is handled in each case. 

::: moniker-end

::: moniker range="= azs-2002"
Diagnostic log collection feature offers two options to send logs. The following sections explain each option and how your data is handled in each case. 
::: moniker-end

::: moniker range=">= azs-2002"

## Send logs proactively

[Proactive log collection](./azure-stack-configure-automatic-diagnostic-log-collection.md?view=azs-2002) streamlines and simplifies diagnostic log collection so customers can send logs to Microsoft before opening a support case. Diagnostic logs are proactively uploaded from Azure Stack Hub for analysis. These logs are only collected when a [system health alert](./azure-stack-configure-automatic-diagnostic-log-collection.md?view=azs-2002#proactive-diagnostic-log-collection-alerts) is raised and are only accessed by Microsoft Support in the context of a support case.


### How the data is handled

You agree to periodic automatic log collections by Microsoft based only on Azure Stack Hub system health alerts. You also acknowledge and consent to the upload and retention of those logs in an Azure storage account managed and controlled by Microsoft.

The data will be used only troubleshooting system health alerts and won't be used for marketing, advertising, or any other commercial purposes without your consent. The data can be retained for up to 90 days and any data Microsoft collects will be handled following our [standard privacy practices](https://privacy.microsoft.com/).

Any data previously collected with your consent won't be affected by the revocation of your permission.

Logs collected using **Proactive log collection** are uploaded to an Azure storage account managed and controlled by Microsoft. These logs may be accessed by Microsoft in the context of a support case and to improve the health of Azure Stack Hub.

## Send logs now

[Send logs now](./azure-stack-configure-on-demand-diagnostic-log-collection-portal.md?view=azs-2002) is a manual option where diagnostic logs are uploaded from Azure Stack Hub only when you (as the customer) initiate the collection, usually before opening a support case.

Azure Stack operators can send diagnostics logs on-demand to Microsoft Support by using the administrator portal or PowerShell. If Azure Stack Hub is connected to the Azure, using [Send logs now in the administrator portal](./azure-stack-configure-on-demand-diagnostic-log-collection-portal.md?view=azs-2002) is recommended because it's the simplest way to send the logs directly to Microsoft. If the portal is unavailable, operators should instead [send logs now using PowerShell](./azure-stack-configure-on-demand-diagnostic-log-collection-powershell.md?view=azs-2002).

::: moniker-end
::: moniker range="= azs-2002"
If you are disconnected from the internet or want to only save logs locally, use [Get-AzureStackLog](azure-stack-get-azurestacklog.md) method to send logs. The following flowchart shows which option to use for sending diagnostic logs in each case. 
::: moniker-end

::: moniker range=">= azs-2002"

![Flowchart shows how to send logs now to Microsoft](media/azure-stack-help-and-support/send-logs-now-flowchart.png)

### How the data is handled

By initiating diagnostic log collection from Azure Stack Hub, you acknowledge and consent to uploading those logs and retaining them in an Azure storage account managed and controlled by Microsoft. Microsoft Support can access these logs right away with the support case without having to engage with the customer for log collection.

::: moniker-end

::: moniker range=">= azs-2005"

## Save logs locally

You can save logs to a local SMB share when Azure Stack Hub is disconnected from Azure. In the **Settings** blade, enter the path and a username and password with permission to write to the share. During a support case, Microsoft Support will provide detailed steps on how to get these local logs transferred. If the Administrator portal is unavailable, you can use [Get-AzureStackLog](azure-stack-get-azurestacklog.md) to save logs locally.

![Screenshot of diagnostic log collection options](media/azure-stack-help-and-support/save-logs-locally.png)

::: moniker-end

::: moniker range=">= azs-2002"

## Bandwidth considerations

The average size of diagnostic log collection varies based on whether it runs proactively or manually. The average size for **Proactive log collection** is around 2 GB. The  collection size for **Send logs now** depends on how many hours are being collected.

The following table lists considerations for environments with limited or metered connections to Azure.

| Network connection | Impact |
|----|---|
| Low-bandwidth/high-latency connection | Log upload will take an extended amount of time to complete. |
| Shared connection | The upload may also impact other apps/users sharing the network connection. |
| Metered connection | There may be an additional charge from your ISP for the extra network usage. |

::: moniker-end
::: moniker range="<= azs-1910"

## Collecting logs from multiple Azure Stack Hub systems

Set up one blob container for every Azure Stack Hub scale unit you want to collect logs from. For more information about how to configure the blob container, see [Configure automatic Azure Stack Hub diagnostic log collection](./azure-stack-configure-automatic-diagnostic-log-collection.md?view=azs-2002). As a best practice, only save diagnostic logs from the same Azure Stack Hub scale unit within a single blob container.

## Retention policy

Create an Azure Blob storage [lifecycle management rule](/azure/storage/blobs/storage-lifecycle-management-concepts) to manage the log retention policy. We suggest retaining diagnostic logs for 30 days. To create a lifecycle management rule in Azure storage, sign in to the Azure portal, select **Storage accounts**, select the blob container, and under **Blob service**, select **Lifecycle Management**.

![Lifecycle Management in the Azure portal](media/azure-stack-automatic-log-collection/blob-storage-lifecycle-management.png)

## SAS token expiration

Set the SAS URL expiry to two years. If you ever renew your storage account keys, make sure to regenerate the SAS URL. You should manage the SAS token according to best practices. For more information, see [Best practices when using SAS](/azure/storage/common/storage-dotnet-shared-access-signature-part-1#best-practices-when-using-sas).

## Bandwidth consumption

The average size of diagnostic log collection varies based on whether log collection is on-demand or automatic.

For on-demand log collection, the size of the logs collection depends on how many hours are being collected. You can choose any 1-4 hour sliding window from the last seven days.

When automatic diagnostic log collection is enabled, the service monitors for critical alerts. After a critical alert gets raised and persists for around 30 minutes, the service collects and uploads appropriate logs. This log collection size is around 2 GB on average. If there's a patch and update failure, automatic log collection will start only if a critical alert is raised and persists for around 30 minutes. We recommend you follow [guidance on monitoring the patch and update](azure-stack-updates.md). Alert monitoring, log collection, and upload are transparent to the user.

In a healthy system, logs won't be collected at all. In an unhealthy system, log collection may run two or three times in a day, but typically only once. At most, it could potentially run up to 10 times in a day in a worst-case scenario.  

The following table can help environments with limited or metered connections to Azure consider the impact of enabling automatic log collection.

| Network connection | Impact |
|---|---|
| Low-bandwidth/high-latency connection | Log upload will take an extended amount of time to complete. | 
| Shared connection | The upload may also impact other apps/users sharing the network connection. |
| Metered connection | There may be an additional charge from your ISP for the extra network usage. |

## Managing costs

Azure [blob storage charges](https://azure.microsoft.com/pricing/details/storage/blobs/) depend on how much data is saved each month and other factors like data redundancy. If you don't have an existing storage account, you can sign in to the Azure portal, select **Storage accounts**, and follow the steps to [create an Azure blob container SAS URL](./azure-stack-configure-automatic-diagnostic-log-collection.md?view=azs-2002).

As a best practice, create an Azure Blob storage [lifecycle management policy](/azure/storage/blobs/storage-lifecycle-management-concepts) to minimize ongoing storage costs. For more information about how to set up the storage account, see [Configure automatic Azure Stack Hub diagnostic log collection](./azure-stack-configure-automatic-diagnostic-log-collection.md?view=azs-2002)

::: moniker-end

## See also

[Azure Stack Hub log and customer data handling](./azure-stack-data-collection.md)
