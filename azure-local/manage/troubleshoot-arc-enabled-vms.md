---
title: Troubleshoot Azure Local VMs enabled by Azure Arc
description: Learn how to troubleshoot Azure Local VMs.
author: alkohli
ms.topic: how-to
ms.date: 03/27/2025
ms.author: alkohli
ms.reviewer: vlakshmanan
ms.service: azure-local
---

# Troubleshoot Azure Local VMs enabled by Azure Arc

[!INCLUDE [hci-applies-to-23h2](../includes/hci-applies-to-23h2.md)]

This article describes how to collect logs and troubleshoot issues with Azure Local VMs enabled by Azure Arc. It also lists the current limitations and known issues with Azure Local VM management, along with recommended resolutions.

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

1. To create managed identity, connect to the Azure Local machine via RDP. Run the following command:
    
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

The failure occurs because the user creating the image does not have the right permissions to access the image from the storage account. The user must have the **Storage Blob Data Contributor** role on the storage account that you use for the image. For more information, see [Assign Azure roles](/azure/role-based-access-control/role-assignments-portal?tabs=current) for access to blob data.

**Resolution:**

Add the **Storage Blob Data Contributor** role to the user that needs to create an image from this storage account. Once role has been added, retry deploying the image.

You may also see the following error when trying to deploy a VM image from a storage account:

**Error:** `{"code":"moc-operator galleryimage serviceClient returned an error while reconciling: rpc error: code = Unknown desc = ===== RESPONSE ERROR (ErrorCode=InvalidBlobType) =====\nDescription=The blob type is invalid for this operation.\nRequestId:5e74055f-e01e-0033-66eb-ff9734000000\nTime:2024-09-05T23:32:56.3001852Z, Details: (none)\n","message":"moc-operator galleryimage serviceClient returned an error while reconciling: rpc error: code = Unknown desc = ===== RESPONSE ERROR (ErrorCode=InvalidBlobType) =====\nDescription=The blob type is invalid for this operation.\nRequestId:5e74055f-e01e-0033-66eb-ff9734000000\nTime:2024-09-05T23:32:56.3001852Z, Details: (none)\n","additionalInfo":[{"type":"ErrorInfo","info":{"category":"Uncategorized","recommendedAction":"","troubleshootingURL":""}}]}`

This failure is because the blob type is not correct within the storage account. The image must be of `page blob` type.

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

## Live migrations on Azure Local 2311.2 and later could fail without error

After you upgrade to Azure Local 2311.2 or on a new deployment of 2311.2 or later, you could see issues where the Azure Local VMs fail to live migrate in an Azure Local instance.

**Issue:** Live migration attempts may fail silently — no error messages are logged.

Cause: This problem is caused by a known issue in Azure Local, version 2311.2 or later. This problem manifests under specific system configurations.

**Resolution:**  

Run the following PowerShell script locally on one of the Azure Local machines. This script applies a registry fix on all the machines of your Azure Local instance.

After you have run the script, reboot each machine one at a time for the change to take effect.

```PowerShell
Get-ClusterNode | ForEach-Object {
    Invoke-Command -ComputerName $_.Name -ScriptBlock {
        $RegPath = "HKLM:\System\CurrentControlSet\Services\Vid\Parameters"
        $ValueName = "SkipSmallLocalAllocations"
        $ValueData = 0

        # Create the key if it doesn't exist
        if (-Not (Test-Path $RegPath)) {
            New-Item -Path $RegPath -Force | Out-Null
        }

        # Create or update the DWORD value
        New-ItemProperty -Path $RegPath -Name $ValueName -Value $ValueData -PropertyType DWord -Force
    }
}
```

## Next steps

- [Azure Local VM management FAQs](./azure-arc-vms-faq.yml)
