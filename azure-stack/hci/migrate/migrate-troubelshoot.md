---
title: Troubleshoot issues when migrating Hyper V VMs to Azure Stack HCI using Azure Migrate (preview)
description: Learn about how to troubleshoot issues when migrating Windows and Linux VMs to your Azure Stack HCI cluster using Azure Migrate (preview).
author: alkohli
ms.topic: how-to
ms.date: 08/14/2023
ms.author: alkohli
ms.reviewer: alkohli
ms.subservice: azure-stack-hci
---

# Troubleshoot issues migrating Hyper-V VMs to Azure Stack HCI via Azure Migrate (preview)

[!INCLUDE [applies-to](../../includes/hci-applies-to-23h2.md)]

This article describes how to troubleshoot any potential issues that you may experience when migrating Hyper-V VMs to your Azure Stack HCI using Azure Migrate.

[!INCLUDE [important](../../includes/hci-preview.md)]

## Collect logs and information

- If you experience any issues during the migration, collect the logs from the Azure Migrate appliance and share them with the Azure Migrate team for analysis. To collect the logs, run the following command on the Azure Migrate appliance:

    ```powershell
    Get-AzureMigrateLog -Path C:\AzureMigrateLogs
    ```
- If you experience any issues, collect the following information about your issues before you open a Support ticket.
    - Subscription ID 
    - Tenant ID 
    - Region
    - Azure Migrate project name
    - VM name for issues in replication and migration 
    - Description of the issue or feedback

The following sections describe how to gather this information based on the operation or the issue type.
 
## For user triggered operations from Azure portal

To troubleshoot user triggered operations, correlation ID for a deployment or a job ID are needed.

### Get correlation ID for a deployment

Failures in operations like creating or deleting a migrate project, creation of appliance artifacts, entities and storage accounts, errors are shown as failures in **Deployments** section of the migrate project resource group. Each deployment operation also has a **Correlation ID** that is useful for troubleshooting.

Additionally failed operations in the session are shown as notifications or in activity logs from older history.

Follow these steps to identify the correlation ID for your deployment in Azure portal:

1. Go to the resource group for your Azure Migrate project and then go to **Overview**. In the right-pane, select the hyperlink that shows failed and successful deployments.

    :::image type="content" source="./media/get-correlation-id-1.png" alt-text="Screenshot Azure Migrate project resource group > Overview in Azure portal.":::
  
1. Identify the deployment that you want the correlation ID for and select the deployment name.

    :::image type="content" source="./media/get-correlation-id-2.png" alt-text="Screenshot Azure Migrate project resource group > Deployments in Azure portal.":::
 
1. Find the correlation ID.

    :::image type="content" source="./media/get-correlation-id-3.png" alt-text="Screenshot Azure Migrate project resource group > Deployments > Your deployment > Overview in Azure portal.":::
 

### Get job ID for replication or migration

Operations such as creating and deleting a protected item (also known as creating and deleting a replication) and planned failover (also known as migration) are also listed as **Jobs** in the Azure Stack HCI migration section of the portal.

In these cases, the Job ID needs to be sent in the email as well.

Follow these steps to get the job ID:

1. In your Azure Migrate project in the Azure portal, go to **Overview** under **Migration tools**.

    :::image type="content" source="./media/get-job-id-1.png" alt-text="Screenshot Azure Migrate project > Migration tools > Overview in Azure portal.":::

1. In the left-pane, go to **Azure Stack HCI migration > Jobs**.

1. Identify the job that you want the job ID for and select the job name.

    :::image type="content" source="./media/get-job-id-2.png" alt-text="Screenshot Azure Migrate project > Migration tools > Overview > Azure Stack HCI migration > Jobs > Your job in Azure portal.":::

1. Find the **Job Id**.

    :::image type="content" source="./media/get-job-id-3.png" alt-text="Screenshot Azure Migrate project > Migration tools > Overview > Azure Stack HCI migration > Jobs >  Your job > Create or update protected item in Azure portal.":::

## For scheduled replication operations  

Failures in scheduled operations like hourly replication cycle failures are listed as **Events** under Azure Stack HCI migration section of the portal.

To troubleshoot replication issues, email the following information:

- Error details shown in the events which include Time, Error ID, Error message, VM ID.
- Screenshots of Azure portal if possible.  
   
## For UX issues in portal  

To troubleshoot UX issues in portal, email the following information:

- Screenshots from Azure portal.
- Record the operations in browser developer mode. Export the HAR file and share it.

## For appliance registration issues

To troubleshoot appliance registration issues, email the following information:

- All the available logs on the appliance at *C:\ProgramData\MicrosoftAzure\Logs\*.

## For discovery issues

Email needs to include the logs available on the source appliance at *C:\ProgramData\MicrosoftAzure\Logs\HyperV\Discovery*.

- [Troubleshoot Discovery](/azure/migrate/troubleshoot-discovery)

## For special issues

Where product team might need component event viewer logs or system event logs like Hyper-V logs, SMB logs, product team will make a request (if needed).


## Next steps

Depending upon the phase of migration you are in, you may need to review one of the following articles to troubleshoot issues:

- [Troubleshoot Azure Migrate projects](/azure/migrate/troubleshoot-general).
- [Troubleshoot Azure Migrate appliance issues](/azure/migrate/troubleshoot-appliance-issues).
- [Troubleshoot with appliance diagnostics](/azure/migrate/troubleshoot-appliance-diagnostic).
