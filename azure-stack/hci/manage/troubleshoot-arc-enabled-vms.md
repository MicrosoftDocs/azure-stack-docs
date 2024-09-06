---
title: Troubleshoot Azure Arc VM management
description: Learn how to troubleshoot Azure Arc VM management
author: alkohli
ms.topic: how-to
ms.date: 09/06/2024
ms.author: alkohli
ms.reviewer: vlakshmanan
---

# Troubleshoot Azure Arc VM management

[!INCLUDE [hci-applies-to-23h2](../../includes/hci-applies-to-23h2.md)]

This article provides guidance on how to collect logs and troubleshoot issues with Azure Arc virtual machines (VMs) in your Azure Stack HCI cluster. It also lists the limitations and known issues that currently exist with Azure Arc VM management.

## Troubleshoot Azure Arc VMs

This section describes the errors related to Azure Arc VM management and their recommended resolutions.

## Failure when trying to enable guest management

When trying to run the command to enable guest management, you see the following error:

**Error:** `Deployment failed. Correlation ID: 5d0c4921-78e0-4493-af16-dffee5cbf9d8. VM Spec validation failed for guest agent provisioning: Invalid managed identity. A system-assigned managed identity must be enabled in parent resource: Invalid Configuration`

This failure is because the managed identity wasn't created for this VM. System-assigned Managed Identity is required to enable guest management.

**Resolution:**  

Follow these steps to verify that the Managed Identity isn't created for this VM and then enable System-assigned Managed Identity.

1. In the Azure portal, go to the VM. Browse to the **Overview** page. On the **Properties** tab, under **Configuration**, the **Guest management** should show as **Disabled**. Select the **JSON View** from the top right corner.

    :::image type="content" source="./media/troubleshoot-arc-enabled-vms/managed-identity-missing-1.png" alt-text="Screenshot of how to get to JSON view." lightbox="./media/troubleshoot-arc-enabled-vms/managed-identity-missing-1.png":::

1. Under `Identity` parameter, the `type` should show as `None`.

    :::image type="content" source="./media/troubleshoot-arc-enabled-vms/managed-identity-missing-2.png" alt-text="Screenshot of JSON view indicating the Managed Identity is absent." lightbox="./media/troubleshoot-arc-enabled-vms/managed-identity-missing-2.png":::

1. To create managed identity, connect to the Azure Stack HCI server via RDP. Run the following command:
    
    ```azurecli
    az extension add --name connectedmachine
    ```

1. Verify that the connected machine CLI extension is installed on the cluster. Here's a sample output with the extension successfully installed. The `connectedmachine` indicates that version 0.7.0 is installed.
    
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

You see the following error when trying to deploy a VM image from a storage account on your Azure Stack HCI cluster:

**Error:** `{"code":"moc-operator galleryimage serviceClient returned an error while reconciling: rpc error: code = Unknown desc = ===== RESPONSE ERROR (ErrorCode=AuthorizationPermissionMismatch) =====\nDescription=, Details: (none)\n","message":"moc-operator galleryimage serviceClient returned an error while reconciling: rpc error: code = Unknown desc = ===== RESPONSE ERROR (ErrorCode=AuthorizationPermissionMismatch) =====\nDescription=, Details: (none)\n"}`

Or, you see this error:

**Error:** `{"code":"moc-operator galleryimage serviceClient returned an error while reconciling: rpc error: code = Unknown desc = ===== RESPONSE ERROR (ErrorCode=NoAuthenticationInformation) =====\nDescription=, Details: (none)\n","message":"moc-operator galleryimage serviceClient returned an error while reconciling: rpc error: code = Unknown desc = ===== RESPONSE ERROR (ErrorCode=NoAuthenticationInformation) =====\nDescription=, Details: (none)\n"}`

The failure occurs because the user creating the image does not have the right permissions to access the image from the storage account. The user must have the **Storage Blob Data Contributor** role on the storage account that you use for the image. For more information, see [Assign Azure roles](/azure/role-based-access-control/role-assignments-portal?tabs=current) for access to blob data.

**Resolution:**

Add the **Storage Blob Data Contributor** role to the user that needs to create an image from this storage account. Once role has been added, retry deploying the image.

You may also see the following error when trying to deploy a VM image from a storage account:

**Error:** `{"code":"moc-operator galleryimage serviceClient returned an error while reconciling: rpc error: code = Unknown desc = ===== RESPONSE ERROR (ErrorCode=InvalidBlobType) =====\nDescription=The blob type is invalid for this operation.\nRequestId:5e74055f-e01e-0033-66eb-ff9734000000\nTime:2024-09-05T23:32:56.3001852Z, Details: (none)\n","message":"moc-operator galleryimage serviceClient returned an error while reconciling: rpc error: code = Unknown desc = ===== RESPONSE ERROR (ErrorCode=InvalidBlobType) =====\nDescription=The blob type is invalid for this operation.\nRequestId:5e74055f-e01e-0033-66eb-ff9734000000\nTime:2024-09-05T23:32:56.3001852Z, Details: (none)\n","additionalInfo":[{"type":"ErrorInfo","info":{"category":"Uncategorized","recommendedAction":"","troubleshootingURL":""}}]}`

This failure is because the blob type is not correct within the storage account. The image must be of `page blob` type.

**Resolution:**

Upload the image into your storage account in `page blob format` and retry deploying the image.

Ensure that the user has the right permissions, and the blob is in the correct format. For more information, see [Add VM image from Azure Storage account](virtual-machine-image-storage-account.md?tabs=azurecli#prerequisites).


## Failure deploying an Arc VM

You see the following error when trying to deploy an Arc VM on your Azure Stack HCI cluster:

**Error:** `{"code":"ConflictingOperation","message":"Unable to process request 'Microsoft.AzureStackHCI/virtualMachineInstances'. There is already a previous running operation for resource '/subscriptions/<subscription ID>/resourceGroups/<Resource group name>/providers/Microsoft.HybridCompute/machines/<VM name>/providers/Microsoft.AzureStackHCI/virtualMachineInstances/default'. Please wait for the previous operation to complete."}`

This failure is because the `SystemAssigned` managed identity object isn't under the `Microsoft.HybridCompute/machines` resource type.

**Resolution:**  

Verify in your deployment template that:

The `SystemAssigned` managed identity object is under `Microsoft.HybridCompute/machines` resource type and not under `Microsoft.AzureStackHCI/VirtualMachineInstances` resource type.

The deployment template should match the provided sample template. For more information, see the sample template in [Create Arc virtual machines on Azure Stack HCI](./create-arc-virtual-machines.md).

## Failure deleting storage path

When trying to delete a storage path on your Azure Stack HCI cluster, you might see an error similar to the following message. Resource numbers and versions may vary in your scenario.

**Error:** `"errorMessage" serviceClient returned an error during deletion: The storage container service returned an error during deletion: rpc error: code = Unknown desc = Container is in ACTIVE use by Resources [6:`  
`- linux-cblmariner-0.2.0.10503`  
`- windows-windows2019-0.2.0.10503`  
`- windows-windows2022-0.2.0.10503`  
`].`  
`Remove all the Resources from this container, before trying to delete: In Use: Failed,`

**Resolution:**  

The images listed in the error message differ from typical workloads, which are represented as Azure Resource Manager (ARM) objects on the Azure portal and CLI. This error occurs because these images are directly downloaded onto the file system, which Azure couldn't recognize.

Follow these steps before trying to remove a storage path:

1. Remove the associated workloads and the images present on the storage path you want to delete. Look for the following prefixes on the image names: `linux-cblmariner`, `windows-windows2019`, `windows-windows2022`, `windows_k8s`, `aks-image-merged`, `linux-K8s`.
1. File a [support ticket in the Azure portal](/azure/azure-portal/supportability/how-to-create-azure-support-request).

## Azure CLI installation isn't recognized

If your environment fails to recognize Azure CLI after installing it, run the following code block to add the Azure CLI installation path to the environment path.

```PowerShell
        if ( -not( $env:PATH -like '*C:\Program Files (x86)\Microsoft SDKs\Azure\CLI2\wbin*') ) {
            $env:PATH += "C:\Program Files (x86)\Microsoft SDKs\Azure\CLI2\wbin;"
            Write-Host "Updated path $env:PATH"
        }
```


<!--## Limitations and known issues

Here's a list of existing limitations and known issues with Azure Arc VM management:

- Resource name must be unique for an Azure Stack HCI cluster and must contain only alphabets, numbers, and hyphens.

- VMs provisioned from Windows Admin Center, PowerShell, or other Hyper-V management tools aren't visible in the Azure portal for management.

- You must update Arc VMs on Azure Stack HCI only from the Azure management plane. Any modifications to these VMs from other management tools aren't updated in the Azure portal.

- Arc VMs must be created in the same Azure subscription as the Custom location.

- An IT administrator can't view or manage VMs from cluster resource page in the Azure portal, if they are created in a subscription where the IT administrator doesn't have at least read-only access role.

- If the Arc for servers agents are installed on VMs provisioned through the Azure portal, there will be two projections of the VMs on the Azure portal.

- Arc VM management is currently not available for stretched cluster configurations on Azure Stack HCI.

- Support for Arc Resource Bridge and Arc VM Management is currently available only in English language.

- Azure Arc Linux VMs aren't supported behind a network proxy.

- Naming convention for Azure resources, such as logical networks, gallery images, custom location, Arc Resource Bridge must follow the guidelines listed in [Naming rules and restrictions for Azure resources](/azure/azure-resource-manager/management/resource-name-rules).-->

## Next steps

- [Azure Arc VM management FAQs](./azure-arc-vms-faq.yml)
