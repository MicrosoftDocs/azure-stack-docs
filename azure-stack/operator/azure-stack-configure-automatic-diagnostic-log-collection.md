---
title: Proactive diagnostic log collection in Azure Stack Hub 
description: Learn how to configure proactive diagnostic log collection in Azure Stack Hub Help + support.
author: justinha
ms.topic: article
ms.date: 06/16/2020
ms.author: justinha
ms.reviewer: shisab
ms.lastreviewed: 06/16/2020

# Intent: As an Azure Stack Hub operator, I want to proactively collect diagnostic logs when an alert gets raised so logs are uploaded automatically for analysis before opening a case with Microsoft Support.
# Keyword: proactive diagnostic log collection azure stack hub

---
# Proactive diagnostic log collection in Azure Stack Hub

::: moniker range=">= azs-2002"

Save time with customer support by proactively collecting diagnostic logs when an alert gets raised on Azure Stack Hub.

If system health conditions need to be investigated, the logs can be uploaded automatically for analysis before opening a support case with Microsoft Support.

>[!NOTE]
>If you are disconnected from the internet or want to only save logs locally, use [Get-AzureStackLog](azure-stack-get-azurestacklog.md) method to send logs. 

## Steps to configure proactive log collection

Follow these steps to configure proactive log collection. Proactive log collection can be disabled and re-enabled anytime.  

1. Sign in to the Azure Stack Hub administrator portal.
1. Open **Help + support Overview**.
1. If the banner appears, select **Enable proactive log collection**. =

   :::image type="content" source="media/azure-stack-help-and-support/banner-enable-automatic-log-collection.png" alt-text="Screenshot of a support page titled Overview - Log Collection. A purple banner contains a button labeled Enable proactive log collection." border="false":::

   Or you can select **Settings** and set **Proactive log collection** to **Enable**, then select **Save**.

   :::image type="content" source="media/azure-stack-help-and-support/settings-enable-automatic-log-collection.png" alt-text="Screenshot of the Settings page. Under Proactive log collection, the toggle is set to Enable." border="false":::

::: moniker-end
::: moniker range="<= azs-1910"

We recommend configuring the automatic diagnostic log collection feature to streamline your log collection and customer support experience.

If system health conditions need to be investigated, the logs can be uploaded automatically for analysis by Microsoft Support.

## Create an Azure blob container SAS URL

Before you can configure automatic log collection, you need to get a shared access signature (SAS) for a blob container. A SAS lets you grant access to resources in your storage account without sharing your account keys.

You can save Azure Stack Hub log files to a blob container in Azure, and then provide the SAS URL where Microsoft Support can collect the logs.

### Prerequisites

You can use a new or existing blob container in Azure. To create a blob container in Azure, you need at least the [storage blob contributor role](/azure/role-based-access-control/built-in-roles#storage-blob-data-contributor) or the [specific permission](/rest/api/storageservices/authenticate-with-azure-active-directory#permissions-for-calling-blob-and-queue-data-operations). Global admins also have the necessary permission.

For best practices on choosing parameters for the automatic log collection storage account, see [Best practices for automatic Azure Stack Hub log collection](./azure-stack-overview.md?view=azs-2002). For more information about types of storage accounts, see [Azure storage account overview](/azure/storage/common/storage-account-overview).

### Create a blob storage account

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

   ![Blob container properties](media/azure-stack-automatic-log-collection/azure-stack-log-collection-create-storage-account.png)

1. Select **Review + create** and then select **Create**.  

### Create a blob container

1. After the deployment succeeds, select **Go to resource**. You can also pin the storage account to the dashboard for easy access.
1. Select **Storage Explorer (preview)**, right-click **Blob containers**, and select **Create blob container**.
1. Enter a name for the new container and select **OK**.

## Create a SAS URL

1. Right-click the container, then select **Get Shared Access Signature**.
   
   ![How to get the shared access signature of a blob container](media/azure-stack-automatic-log-collection/get-sas.png)

1. Choose these properties:

   - Start time: You can optionally move the start time back
   - Expiry time: Two years
   - Time zone: UTC
   - Permissions: Read, Write, and List

   ![Shared access signature properties](media/azure-stack-automatic-log-collection/sas-properties.png) 

1. Select **Create**.  

Copy the URL and enter it when you [configure automatic log collection](?view=azs-2002). For more information about SAS URLs, see [Using shared access signatures (SAS)](/azure/storage/common/storage-dotnet-shared-access-signature-part-1).

## Steps to configure automatic log collection

Follow these steps to add the SAS URL to the log collection UI:

1. Sign in to the Azure Stack Hub administrator portal.
1. Open **Help + support Overview**.
1. Click **Automatic collection settings**.

   ![Where to enable log collection in Help + support](media/azure-stack-automatic-log-collection/azure-stack-automatic-log-collection.png)

1. Set automatic log collection to **Enabled**.
1. Enter the shared access signature (SAS) URL of the storage account blob container.

   ![Blob SAS URL](media/azure-stack-automatic-log-collection/azure-stack-enable-automatic-log-collection.png)

>[!NOTE]
>Automatic log collection can be disabled and re-enabled anytime. The SAS URL configuration won't change. If automatic log collection is re-enabled, the previously entered SAS URL will undergo the same validation checks, and an expired SAS URL will be rejected.

::: moniker-end

>[!NOTE]
>If log location settings are configured for a local file share, make sure lifecycle management policies will prevent share storage from reaching its size quota. Azure Stack Hub does not monitor local file share or enforce any retention policies.

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

## See also

[Azure Stack Hub log and customer data handling](azure-stack-data-collection.md)
