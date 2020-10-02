---
title: Diagnostic log collection in Azure Stack Hub
description: Learn about diagnostic log collection in Azure Stack Hub Help + support.
author: myoungerman
ms.topic: article
ms.date: 08/24/2020
ms.author: v-myoung
ms.reviewer: shisab
ms.lastreviewed: 08/24/2020

# Intent: As an Azure Stack Hub operator, I want to learn about diagnostic log collection so I can share them with Microsoft Support when I need help addressing an issue.
# Keyword: diagnostic log collection azure stack hub
---
# Diagnostic log collection in Azure Stack Hub

Azure Stack Hub is a collection of both Windows components and on-premise Azure services interacting with each other. All these components and services generate their own set of logs. Since Microsoft Support uses these logs to efficiently identify and fix your issues, we offer diagnostic log collection. Diagnostic log collection in Help and Support helps you quickly collect and share diagnostic logs with Microsoft Support in an easy user interface, which doesn't require PowerShell. Logs get collected even if other infrastructure services are down.  

::: moniker range=">= azs-2002"

We recommend you use this approach for log collection and only resort to [using the privileged endpoint (PEP)](azure-stack-get-azurestacklog.md) if the Administrator portal or Help and Support blade is unavailable. 

>[!NOTE]
>Azure Stack Hub must be registered to use diagnostic log collection. If Azure Stack Hub is not registered, use [Get-AzureStackLog](azure-stack-get-azurestacklog.md) to share logs. 
::: moniker-end

![Diagnostic log collection options in Azure Stack Hub](media/azure-stack-help-and-support/banner-enable-automatic-log-collection.png)

## Collection options and data handling

::: moniker range=">= azs-2005"

Depending on connectivity to Azure, Azure Stack Hub has suitable ways to collect, save, and send diagnostic logs to CSS. If Azure Stack Hub can connect to Azure, the recommended way is to enable **Proactive log collection**, which will automatically upload diagnostic logs to a Microsoft-controlled storage blob in Azure when a critical alert gets raised. You can alternatively collect logs on-demand by using **Send logs now**, or you can save logs locally if Azure Stack Hub is disconnected from Azure. 

The following sections explain each option and how your data is handled in each case. 

::: moniker-end

::: moniker range=">= azs-2002"
Diagnostic log collection feature offers two options to send logs:
* Send logs proactively
* Send logs now

The following sections explain each option and how your data is handled in each case. 
::: moniker-end

### Send logs proactively

Proactive log collection simplifies diagnostic log collection so you can send logs to Microsoft before opening a support case. Diagnostic logs are proactively uploaded from Azure Stack Hub for analysis. These logs are only collected when a [system health alert](#proactive-diagnostic-log-collection-alerts) is raised and are only accessed by Microsoft Support in the context of a support case.

Follow these steps to configure proactive log collection. Proactive log collection can be disabled and re-enabled anytime.  

1. Sign in to the Azure Stack Hub administrator portal.
1. Open **Help + support Overview**.
1. If the banner appears, select **Enable proactive log collection**.

   :::image type="content" source="media/azure-stack-help-and-support/banner-enable-automatic-log-collection.png" alt-text="Screenshot of a support page titled Overview - Log Collection. A purple banner contains a button labeled Enable proactive log collection." border="false":::

   Or you can select **Settings** and set **Proactive log collection** to **Enable**, then select **Save**.

   :::image type="content" source="media/azure-stack-help-and-support/settings-enable-automatic-log-collection.png" alt-text="Screenshot of the Settings page. Under Proactive log collection, the toggle is set to Enable." border="false":::

::: moniker range="<= azs-1910"

We recommend configuring the automatic diagnostic log collection feature to streamline your log collection and customer support experience.

If system health conditions need to be investigated, the logs can be uploaded automatically for analysis by Microsoft Support.

::: moniker-end

### Send logs now

Send logs now is a manual option where diagnostic logs are uploaded from Azure Stack Hub only when you (as the customer) initiate the collection, usually before opening a support case.

Azure Stack operators can send diagnostics logs on-demand to Microsoft Support by using the administrator portal or PowerShell. If Azure Stack Hub is connected to the Azure, **Send logs now** in the administrator portal is recommended because it's the simplest way to send the logs directly to Microsoft. If the portal is unavailable, you should instead send logs using PowerShell.

::: moniker range="= azs-2002"
If you are disconnected from the internet or want to only save logs locally, use [Get-AzureStackLog](azure-stack-get-azurestacklog.md) method to send logs. The following flowchart shows which option to use for sending diagnostic logs in each case. 
::: moniker-end

::: moniker range=">= azs-2002"

![Flowchart shows how to send logs now to Microsoft](media/azure-stack-help-and-support/send-logs-now-flowchart.png)

::: moniker-end

::: moniker range=">= azs-2005"

## Save logs locally

You can save logs to a local SMB share when Azure Stack Hub is disconnected from Azure. In the **Settings** blade, enter the path and a username and password with permission to write to the share. During a support case, Microsoft Support will provide detailed steps on how to get these local logs transferred. If the Administrator portal is unavailable, you can use [Get-AzureStackLog](azure-stack-get-azurestacklog.md) to save logs locally.

![Screenshot of diagnostic log collection options](media/azure-stack-help-and-support/save-logs-locally.png)

::: moniker-end

::: moniker range=">= azs-2002"

## Bandwidth considerations

The average size of diagnostic log collection varies based on whether it runs proactively or manually. The average size for **Proactive log collection** is around 2 GB. The collection size for **Send logs now** depends on how many hours are being collected.

The following table lists considerations for environments with limited or metered connections to Azure.

| Network connection | Impact |
|----|---|
| Low-bandwidth/high-latency connection | Log upload will take an extended amount of time to complete. |
| Shared connection | The upload may also impact other apps/users sharing the network connection. |
| Metered connection | There may be an additional charge from your ISP for the extra network usage. |

::: moniker-end
::: moniker range="<= azs-1910"

## Collect logs automatically for one or more Azure Stack Hub systems

Before you can configure automatic log collection, you need to:
* [create a blob storage account](#create-a-blob-storage-account) or use an existing one
* [create a blob storage container](#create-a-blob-container) or use an existing one
* [create a shared access signature (SAS) URL](#create-a-sas-url)

Follow these steps to add the shared access signature (SAS) URL to the log collection UI:

1. Sign in to the Azure Stack Hub administrator portal.
1. Open **Help + support Overview**.
1. Click **Automatic collection settings**.

   ![Where to enable log collection in Help + support](media/azure-stack-automatic-log-collection/azure-stack-automatic-log-collection.png)

1. Set automatic log collection to **Enabled**.
1. Enter the SAS URL of the storage account blob container.

   ![Blob SAS URL](media/azure-stack-automatic-log-collection/azure-stack-enable-automatic-log-collection.png)

>[!NOTE]
>Automatic log collection can be disabled and re-enabled anytime. The SAS URL configuration won't change. If automatic log collection is re-enabled, the previously entered SAS URL will undergo the same validation checks, and an expired SAS URL will be rejected.

::: moniker-end

>[!NOTE]
>If log location settings are configured for a local file share, make sure lifecycle management policies will prevent share storage from reaching its size quota. Azure Stack Hub does not monitor local file share or enforce any retention policies.

## Retention policy

Create an Azure Blob storage [lifecycle management rule](/azure/storage/blobs/storage-lifecycle-management-concepts) to manage the log retention policy. We suggest retaining diagnostic logs for 30 days. To create a lifecycle management rule in Azure storage, sign in to the Azure portal, select **Storage accounts**, select the blob container, and under **Blob service**, select **Lifecycle Management**.

![Lifecycle Management in the Azure portal](media/azure-stack-automatic-log-collection/blob-storage-lifecycle-management.png)

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

Azure [blob storage charges](https://azure.microsoft.com/pricing/details/storage/blobs/) depend on how much data is saved each month and other factors like data redundancy. If you don't have an existing storage account, you can sign in to the Azure portal, select **Storage accounts**, and follow the steps to [create an Azure blob container SAS URL](#create-a-sas-url).

As a best practice, create an Azure Blob storage [lifecycle management policy](/azure/storage/blobs/storage-lifecycle-management-concepts) to minimize ongoing storage costs. For more information about how to set up the storage account, see [Configure automatic Azure Stack Hub diagnostic log collection](#collect-logs-automatically-from multiple-Azure-Stack-Hub-systems).

::: moniker range=">= azs-2002"

Azure Stack operators can send diagnostics logs on-demand to Microsoft Support, before requesting support, by using the Administrator portal or PowerShell. If Azure Stack Hub is connected to the Azure, the **Send logs now** option in the Administrator portal is recommended because it's the simplest way to send the logs directly to Microsoft. If the portal is unavailable, operators should instead [send logs now using Send-AzureStackDiagnosticLog](#send-logs-now). 

If you are disconnected from the internet or want to only save logs locally, use [Get-AzureStackLog](azure-stack-get-azurestacklog.md) method to send logs. The following flowchart shows which option to use for sending diagnostic logs in each case. 

![Flowchart shows how to send logs now to Microsoft](media/azure-stack-help-and-support/send-logs-now-flowchart.png)

>[!NOTE]
>As an alternative to collecting logs on demand, you can streamline the troubleshooting process by [proactively collecting diagnostic logs](#send-logs-proactively). If system health conditions need to be investigated, the logs are uploaded automatically for analysis before opening a case with Microsoft Support. If proactive log collection is enabled, **Help and Support** shows when log collection is in progress. If you click **Send logs now** to collect logs from a specific time while proactive log collection is in progress, on-demand collection begins after proactive log collection is complete.

Specify the start time and end time for log collection and click **Collect and Upload**. 

![Screenshot of option to Send logs now](media/azure-stack-help-and-support/send-logs-now.png)


::: moniker-end
::: moniker range=">= azs-2005"

## Collect diagnostic logs on demand

To troubleshoot a problem, Microsoft Support might request an Azure Stack Hub operator to collect diagnostic logs on demand for a specific time window from the previous week. In that case, Microsoft Support will provide you with a SAS URL for uploading the collection. 
Use the following steps to configure on-demand log collection using the SAS URL from Microsoft Support:

1. Open **Help + support > Log Collection > Collect logs now**. 
1. Choose a 1-4 hour sliding window from the last seven days. 
1. Choose the local time zone.
1. Enter the SAS URL that Microsoft Support provided.

   ![Screenshot of on-demand log collection](media/azure-stack-automatic-log-collection/collect-logs-now.png)

>[!NOTE]
>If automatic diagnostic log collection is enabled, **Help and Support** shows when log collection is in progress. If you click **Collect logs now** to collect logs from a specific time while automatic log collection is in progress, on-demand collection begins after automatic log collection is complete. 


::: moniker-end

## Parameter considerations 

* The **FromDate** and **ToDate** parameters can be used to collect logs for a particular time period. If these parameters aren't specified, logs are collected for the past four hours by default.

* Use the **FilterByNode** parameter to filter logs by computer name. For example:

  ```powershell
  Send-AzureStackDiagnosticLog -FilterByNode azs-xrp01
  ```

* Use the **FilterByLogType** parameter to filter logs by type. You can choose to filter by File, Share, or WindowsEvent. For example:

  ```powershell
  Send-AzureStackDiagnosticLog -FilterByLogType File
  ```

* Use the **FilterByResourceProvider** parameter to send diagnostic logs for value-add Resource Providers (RPs). The general syntax is:
 
  ```powershell
  Send-AzureStackDiagnosticLog -FilterByResourceProvider <<value-add RP name>>
  ```
 
  To send diagnostic logs for IoT Hub: 

  ```powershell
  Send-AzureStackDiagnosticLog -FilterByResourceProvider IotHub
  ```
 
  To send diagnostic logs for Event Hubs:

  ```powershell
  Send-AzureStackDiagnosticLog -FilterByResourceProvider eventhub
  ```
 
  To send diagnostic logs for Azure Stack Edge:

  ```powershell
  Send-AzureStackDiagnosticLog -FilterByResourceProvide databoxedge
  ```

* Use the **FilterByRole** parameter to send diagnostic logs from VirtualMachines and BareMetal roles:

  ```powershell
  Send-AzureStackDiagnosticLog -FilterByRole VirtualMachines,BareMetal
  ```

* To send diagnostic logs from VirtualMachines and BareMetal roles, with date filtering for log files for the past 8 hours:

  ```powershell
  Send-AzureStackDiagnosticLog -FilterByRole VirtualMachines,BareMetal -FromDate (Get-Date).AddHours(-8)
  ```

* To send diagnostic logs from VirtualMachines and BareMetal roles, with date filtering for log files for the time period between 8 hours ago and 2 hours ago:

  ```powershell
  Send-AzureStackDiagnosticLog -FilterByRole VirtualMachines,BareMetal -FromDate (Get-Date).AddHours(-8) -ToDate (Get-Date).AddHours(-2)
  ```

Save time with customer support by proactively collecting diagnostic logs when an alert gets raised on Azure Stack Hub.

If system health conditions need to be investigated, the logs can be uploaded automatically for analysis before opening a support case with Microsoft Support.

>[!NOTE]
>If you are disconnected from the internet or want to only save logs locally, use [Get-AzureStackLog](azure-stack-get-azurestacklog.md) method to send logs. 

## Create a blob storage account

For more information about types of storage accounts, see [Azure storage account overview](/azure/storage/common/storage-account-overview).

1. Sign in to the [Azure portal](https://portal.azure.com).
1. Select **Storage accounts** > **Add**.
1. Create a blob container with these settings:

   - **Subscription**: Choose your Azure subscription.
   - **Resource group**: Specify a resource group.
   - **Storage account name**: Specify a unique storage account name.
   - **Location**: Choose a datacenter in accordance with your company policy.
   - **Performance**: Standard.
   - **Account kind** StorageV2 (general purpose v2).
   - **Replication**: Locally redundant storage (LRS).
   - **Access tier**: Cool.

1. Select **Review + create** and then select **Create**.  

## Create a blob container

To create a blob container in Azure, you need at least the [storage blob contributor role](/azure/role-based-access-control/built-in-roles#storage-blob-data-contributor) or the [specific permission](/rest/api/storageservices/authenticate-with-azure-active-directory#permissions-for-calling-blob-and-queue-data-operations). Global admins also have the necessary permission.
Set up one blob container for every Azure Stack Hub scale unit you want to collect logs from. As a best practice, only save diagnostic logs from the same Azure Stack Hub scale unit within a single blob container.

1. After the deployment succeeds, select **Go to resource**. You can also pin the storage account to the dashboard for easy access.
1. Select **Storage Explorer (preview)**, right-click **Blob containers**, and select **Create blob container**.
1. Enter a name for the new container and select **OK**.

## Create a SAS URL

A shared access signature (SAS) lets you grant Microsoft Support access to resources in your storage account without sharing your account keys.

1. Right-click your blob container, then select **Get Shared Access Signature**.
   
   ![How to get the shared access signature of a blob container](media/azure-stack-automatic-log-collection/get-sas.png)

1. Choose these properties:

   - Start time: You can optionally move the start time back
   - Expiry time: Two years
   - Time zone: UTC
   - Permissions: Read, Write, and List

1. Select **Create**.  

Copy the URL and enter it when you [configure automatic log collection](?view=azs-2002). For more information about SAS URLs, see [Using shared access signatures (SAS)](/azure/storage/common/storage-dotnet-shared-access-signature-part-1).

## SAS token expiration

Set the SAS URL expiration to two years. If you ever renew your storage account keys, make sure to regenerate the SAS URL. You should manage the SAS token according to best practices. For more information, see [Best practices when using SAS](/azure/storage/common/storage-dotnet-shared-access-signature-part-1#best-practices-when-using-sas).

## View log collection

The history of logs collected from Azure Stack Hub appears on the **Log collection** page in **Help + support**, with the following dates and times:

- **Time Collected**: When the log collection operation began.
- **Status**: Either in progress or complete.
- **Logs start**: Start of the time period for which you want to collect.
- **Logs end**: End of the time period.
- **Type**: If it's a manual or proactive log collection.

![Log collections in Help + support](media/azure-stack-help-and-support/azure-stack-log-collection.png)

## Proactive diagnostic log collection alerts

If enabled, proactive log collection uploads logs only when one of the following events is raised.

For example, **Update failed** is an alert that triggers proactive diagnostic log collection. If it's enabled, diagnostic logs are proactively captured during an update failure to help Microsoft Support troubleshoot the problem. The diagnostic logs are only collected when the alert for **Update failed** is raised.

| Alert Title | FaultIdType |
|---|---|
|Unable to connect to the remote service | UsageBridge.NetworkError|
|Update failed | Urp.UpdateFailure |
|Storage Resource Provider infrastructure/dependencies not available |    StorageResourceProviderDependencyUnavailable |
|Node not connected to controller| ServerHostNotConnectedToController |  
|Route publication failure | SlbMuxRoutePublicationFailure |
|Storage Resource Provider internal data store unavailable |    StorageResourceProvider. DataStoreConnectionFail |
|Storage device failure | Microsoft.Health.FaultType.VirtualDisks.Detached |
|Health controller can't access storage account | Microsoft.Health.FaultType.StorageError |
|Connectivity to a physical disk has been lost | Microsoft.Health.FaultType.PhysicalDisk.LostCommunication |
|The blob service isn't running on a node | StorageService.The.blob.service.is.not.running.on.a.node-Critical |
|Infrastructure role unhealthy | Microsoft.Health.FaultType.GenericExceptionFault |
|Table service errors | StorageService.Table.service.errors-Critical |
|A file share is over 80% utilized | Microsoft.Health.FaultType.FileShare.Capacity.Warning.Infra |
|Scale unit node is offline | FRP.Heartbeat.PhysicalNode |
|Infrastructure role instance unavailable | FRP.Heartbeat.InfraVM |
|Infrastructure role instance unavailable  | FRP.Heartbeat.NonHaVm |
|The infrastructure role, Directory Management, has reported time synchronization errors | DirectoryServiceTimeSynchronizationError |
|Pending external certificate expiration | CertificateExpiration.ExternalCert.Warning |
|Pending external certificate expiration | CertificateExpiration.ExternalCert.Critical |
|Unable to provision virtual machines for specific class and size due to low memory capacity | AzureStack.ComputeController.VmCreationFailure.LowMemory |
|Node inaccessible for virtual machine placement | AzureStack.ComputeController.HostUnresponsive |
|Backup failed  | AzureStack.BackupController.BackupFailedGeneralFault |
|The scheduled backup was skipped due to a conflict with failed operations    | AzureStack.BackupController.BackupSkippedWithFailedOperationFault |

## How the data is handled

You agree to periodic automatic log collections by Microsoft based only on Azure Stack Hub system health alerts. You also acknowledge and consent to the upload and retention of those logs in an Azure storage account managed and controlled by Microsoft.

The data will be used only troubleshooting system health alerts and won't be used for marketing, advertising, or any other commercial purposes without your consent. The data can be retained for up to 90 days and any data Microsoft collects will be handled following our [standard privacy practices](https://privacy.microsoft.com/).

Any data previously collected with your consent won't be affected by the revocation of your permission.

Logs collected using **Proactive log collection** are uploaded to an Azure storage account managed and controlled by Microsoft. These logs may be accessed by Microsoft in the context of a support case and to improve the health of Azure Stack Hub.

## See also

[Azure Stack Hub log and customer data handling](./azure-stack-data-collection.md)
