---
title: Troubleshoot Azure Local Virtual Machines enabled by Azure Arc
description: Learn how to troubleshoot issues you experience with Azure Local Virtual Machines (VMs).
author: alkohli
ms.topic: how-to
ms.date: 07/21/2025
ms.author: alkohli
ms.reviewer: vlakshmanan
ms.service: azure-local
---

# Troubleshoot Azure Local Virtual Machines enabled by Azure Arc

[!INCLUDE [hci-applies-to-23h2](../includes/hci-applies-to-23h2.md)]

This article describes how to collect logs and troubleshoot issues with Azure Local Virtual Machines (VMs) enabled by Azure Arc. It also lists the current limitations and known issues with Azure Local VM management, along with recommended resolutions.

## Property isn't supported for this operation

**Error:**

`Property '<Property Name>' isn't supported for this operation on your Azure Local cluster version. Please update your cluster if you want to set this property for this operation. Please view aka.ms/hciproperties.`

**Cause:**

This error occurs when the feature you're trying to use isn't available for the software version running on your Azure Local instance. This can happen if the software version on your cluster is outdated or the feature was introduced in a later version.

**Resolution:**

To resolve this issue, update your Azure Local instance to the latest version. For more information, see [Update via PowerShell](../update/update-via-powershell-23h2.md) or [Update via Azure portal](../update/azure-update-manager-23h2.md).


## Cluster extension doesn't support resource type

**Error:**

`The cluster extension '<Cluster Extension Azure Resource Manager ID>' doesn't support resource type 'Microsoft.AzureStackHCI/<Resource Type>'. The currently enabled resource types are '<Supported Resource Type Names>'. Please ensure the 'Microsoft.AzureStackHCI' cluster extension version metadata file supports the resource type. [ClusterExtensionVersion='<Cluster Extension Version>'] [CorrelationId='<Correlation ID>'].`

**Cause:**

This error occurs when the feature you're trying to use isn't available for the software version running on your Azure Local instance. This can happen if the software version on your cluster is outdated or the feature was introduced in a later version.

**Resolution:**

To resolve this issue, update your Azure Local instance to the latest version. For more information, see [Update via PowerShell](../update/update-via-powershell-23h2.md) or [Update via Azure portal](../update/azure-update-manager-23h2.md).

## Unable to select an image for Trusted launch VMs

Trusted launch for Azure Local VMs currently supports only a select set of Azure Marketplace images. For a list of supported images, see [Guest operating system images](./trusted-launch-vm-overview.md#guest-operating-system-images). When you create a Trusted launch VM in the Azure portal, the Image dropdown list shows only the images supported by Trusted launch. The Image dropdown appears blank if you select an unsupported image, including a custom image. The list also appears blank if none of the images available on your Azure Local system are supported by Trusted launch.

## Failure when trying to enable guest management

When trying to run the command to enable guest management, you see the following error:

**Error:** `Deployment failed. Correlation ID: aaaa0000-bb11-2222-33cc-444444dddddd. VM Spec validation failed for guest agent provisioning: Invalid managed identity. A system-assigned managed identity must be enabled in parent resource: Invalid Configuration`

This failure is because the managed identity wasn't created for this VM. System-assigned Managed Identity is required to enable guest management.

**Resolution:**  

Follow these steps to verify that the Managed Identity isn't created for this VM and then enable System-assigned Managed Identity.

1. In the Azure portal, go to the VM. Browse to the **Overview** page. On the **Properties** tab, under **Configuration**, the **Guest management** should show as **Disabled**. Select the **JSON View** from the top right corner.

    :::image type="content" source="./media/troubleshoot-arc-enabled-vms/managed-identity-missing-1.png" alt-text="Screenshot of how to get to JSON view." lightbox="./media/troubleshoot-arc-enabled-vms/managed-identity-missing-1.png":::

1. Under `Identity` parameter, the `type` should show as `None`.

    :::image type="content" source="./media/troubleshoot-arc-enabled-vms/managed-identity-missing-2.png" alt-text="Screenshot of JSON view indicating the Managed Identity is absent." lightbox="./media/troubleshoot-arc-enabled-vms/managed-identity-missing-2.png":::

1. To create managed identity, connect to the Azure Local machine via Remote Desktop Protocol (RDP). Run the following command:
    
    ```azurecli
    az extension add --name connectedmachine
    ```

1. Verify that the connected machine CLI extension is installed on the system. Here's a sample output with the extension successfully installed. The `connectedmachine` indicates that version 0.7.0 is installed.
    
    ```output
    [v-hostl]: PS C:\Clusterstorage\lnfrastructure_l\ArcHci> az version
    {
    "azure-cli": "2.53.0",
    "azure-cli-core": "2.53.0",
    "azure-cli-telemetry": "1.1.0",
    "extensions": {
        "akshybrid": "0.1.1",
        "arcappliance"^ "1.0.2",
        "connectedk8s": "1.5.4",
        "connectedmachine": "0.7.0",
        "customlocation": "0.1.3",
        "hybridaks": "0.2.4",
        "k8s-extension": "1.4.5",
        "stack-hci-vm": "0.1.8"
        }
    }
    [v-hostl]: PS C:\ClusterStorage\Infrastructure_l\ArcHci>
        ```
1. Run the following command to assign a system managed identity to the VM.

    ```azurecli
    az connectedmachine update --ids "<Resource Manager ID for the VM>" --set identity.type="SystemAssigned"
    ```

1. Go to the Azure portal and browse to the **Overview** page. The **JSON View** should indicate that the system managed identity is now assigned to the VM.

    :::image type="content" source="./media/troubleshoot-arc-enabled-vms/managed-identity-missing-3.png" alt-text="Screenshot of JSON view when Managed Identity is enabled." lightbox="./media/troubleshoot-arc-enabled-vms/managed-identity-missing-3.png":::  

## Failure deploying a VM image from a storage account

You see the following error when trying to deploy a VM image from a storage account on your Azure Local:

**Error:** `{"code":"moc-operator galleryimage serviceClient returned an error while reconciling: rpc error: code = Unknown desc = ===== RESPONSE ERROR (ErrorCode=AuthorizationPermissionMismatch) =====\nDescription=, Details: (none)\n","message":"moc-operator galleryimage serviceClient returned an error while reconciling: rpc error: code = Unknown desc = ===== RESPONSE ERROR (ErrorCode=AuthorizationPermissionMismatch) =====\nDescription=, Details: (none)\n"}`

Or, you see this error:

**Error:** `{"code":"moc-operator galleryimage serviceClient returned an error while reconciling: rpc error: code = Unknown desc = ===== RESPONSE ERROR (ErrorCode=NoAuthenticationInformation) =====\nDescription=, Details: (none)\n","message":"moc-operator galleryimage serviceClient returned an error while reconciling: rpc error: code = Unknown desc = ===== RESPONSE ERROR (ErrorCode=NoAuthenticationInformation) =====\nDescription=, Details: (none)\n"}`

The failure occurs because the user creating the image doesn't have the right permissions to access the image from the storage account. The user must have the **Storage Blob Data Contributor** role on the storage account that you use for the image. For more information, see [Assign Azure roles](/azure/role-based-access-control/role-assignments-portal?tabs=current) for access to blob data.

**Resolution:**

Add the **Storage Blob Data Contributor** role to the user that needs to create an image from this storage account. Once role is added, retry deploying the image.

You might also see the following error when trying to deploy a VM image from a storage account:

**Error:** `{"code":"moc-operator galleryimage serviceClient returned an error while reconciling: rpc error: code = Unknown desc = ===== RESPONSE ERROR (ErrorCode=InvalidBlobType) =====\nDescription=The blob type is invalid for this operation.\nRequestId:5e74055f-e01e-0033-66eb-ff9734000000\nTime:2024-09-05T23:32:56.3001852Z, Details: (none)\n","message":"moc-operator galleryimage serviceClient returned an error while reconciling: rpc error: code = Unknown desc = ===== RESPONSE ERROR (ErrorCode=InvalidBlobType) =====\nDescription=The blob type is invalid for this operation.\nRequestId:5e74055f-e01e-0033-66eb-ff9734000000\nTime:2024-09-05T23:32:56.3001852Z, Details: (none)\n","additionalInfo":[{"type":"ErrorInfo","info":{"category":"Uncategorized","recommendedAction":"","troubleshootingURL":""}}]}`

This failure is because the blob type isn't correct within the storage account. The image must be of `page blob` type.

**Resolution:**

Upload the image into your storage account in `page blob format` and retry deploying the image.

Ensure that the user has the right permissions, and the blob is in the correct format. For more information, see [Add VM image from Azure Storage account](virtual-machine-image-storage-account.md?tabs=azurecli#prerequisites).


## Failure to deploy an Azure Local VM

You see the following error when trying to deploy an Azure Local VM:

**Error:** `{"code":"ConflictingOperation","message":"Unable to process request 'Microsoft.AzureStackHCI/virtualMachineInstances'. There is already a previous running operation for resource '/subscriptions/<subscription ID>/resourceGroups/<Resource group name>/providers/Microsoft.HybridCompute/machines/<VM name>/providers/Microsoft.AzureStackHCI/virtualMachineInstances/default'. Please wait for the previous operation to complete."}`

This failure is because the `SystemAssigned` managed identity object isn't under the `Microsoft.HybridCompute/machines` resource type.

**Resolution:**  

Verify in your deployment template that:

The `SystemAssigned` managed identity object is under `Microsoft.HybridCompute/machines` resource type and not under `Microsoft.AzureStackHCI/VirtualMachineInstances` resource type.

The deployment template should match the provided sample template. For more information, see the sample template in [Create Azure Local virtual machines enabled by Azure Arc](./create-arc-virtual-machines.md).

## Azure CLI installation isn't recognized

If your environment fails to recognize Azure CLI after installing it, run the following code block to add the Azure CLI installation path to the environment path.

```PowerShell
        if ( -not( $env:PATH -like '*C:\Program Files (x86)\Microsoft SDKs\Azure\CLI2\wbin*') ) {
            $env:PATH += "C:\Program Files (x86)\Microsoft SDKs\Azure\CLI2\wbin;"
            Write-Host "Updated path $env:PATH"
        }
```

## "Windows created a temporary paging file" message appears at startup

**Error:**

When you deploy an Azure Local VM using the SQL Server 2022 on Windows Server 2022 Azure marketplace images (Standard or Enterprise), you might see the following warning at startup:

*Windows created a temporary paging file...*

**Resolution:**

To resolve this issue, follow these steps:

1. Select **OK** on the warning popup. Or, go to **System Properties** > **Advanced** > **Performance** > **Settings** to open the **Performance Options** window.
1. In the **Performance Options** window, select **Change** under the **Virtual memory** section.

    :::image type="content" source="./media/troubleshoot-arc-enabled-vms/temporary-paging-file-1.png" alt-text="Screenshot of the Performance Options window highlighting the Change button." lightbox="./media/troubleshoot-arc-enabled-vms/temporary-paging-file-1.png":::

1. In the **Virtual Memory** window, select **System managed size**.  Also ensure that the **Automatically manage paging file size for all drives** checkbox is cleared.

    :::image type="content" source="./media/troubleshoot-arc-enabled-vms/temporary-paging-file-2.png" alt-text="Screenshot of the Virtual Memory window showing options to configure the paging file size for each drive." lightbox="./media/troubleshoot-arc-enabled-vms/temporary-paging-file-2.png":::

1. Select **Set**, then select **OK** to apply the changes.

1. Restart the VM. After the restart, the warning message should no longer appear.

## Resource deployment failure due to insufficient disk space on the first storage path

**Error:**

`The system failed to create <Azure resource name>: There is not enough space on the disk.`

**Cause:**

If no storage path is specified during deployment, resources are automatically placed on the first storage path, even when additional storage paths are available on the cluster. This can lead to insufficient disk space on the first storage path, even when other storage paths still have available capacity.

**Resolution:**

When creating a VM, data disk, or image, choose a storage path manually.

# [Azure portal](#tab/azure-portal)

When creating an image, select the **Choose manually** option for storage path and then select a storage path from the available list.

# [CLI](#tab/cli)

To specify a storage path when creating a VM, data disk, or image, use the `--storage-path-id` parameter with the `az stack-hci-vm create`, `az stack-hci-vm disk create`, or `az stack-hci-vm image create` command.

# [ARM template](#tab/arm-template)

To define a storage path for a VM configuration, add `vmConfigStoragePathId` to the `storageProfile` section of the VM resource:

```json
"storageProfile": {
 "vmConfigStoragePathId": "Insert ARM ID of specified storage path"
}
```

If using an ARM template that creates multiple VMs in one deployment:

1. Define a parameter for the storage path IDs:

    ```json
    "parameters": {
     "storagePathIds": {
       "type": "array",
       "metadata": {
         "description": "List of storage path resource IDs to cycle through for VM placement."
       }
     }
    }
    ```

1. Add `vmConfigStoragePathId` to the `storageProfile`section of the VM resource:

    ```json
    "storageProfile": {
     "vmConfigStoragePathId": "[parameters('storagePathIds')[mod(copyIndex(), length(parameters('storagePathIds')))]]"
    }
    ```

---

## Next steps

- [Azure Local VM management FAQs](./azure-arc-vms-faq.yml)