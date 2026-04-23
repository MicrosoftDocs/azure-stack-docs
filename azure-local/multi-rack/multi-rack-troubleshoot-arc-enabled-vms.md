---
title: Troubleshoot Azure Local Multi-rack Virtual Machines Enabled by Azure Arc (preview)
description: Learn how to troubleshoot issues you experience with Azure Local multi-rack Virtual Machines (VMs) enabled by Azure Arc.
author: dramasamy
ms.topic: how-to
ms.date: 04/15/2026
ms.author: dramasamy
ms.reviewer: vlakshmanan
ms.service: azure-local
ms.custom: sfi-image-nochange
ms.subservice: multi-rack
---

# Troubleshoot Azure Local multi-rack virtual machines enabled by Azure Arc (preview)

[!INCLUDE [multi-rack-applies-to-preview](../includes/multi-rack-applies-to-preview.md)]

This article describes how to troubleshoot problems with Azure Local Virtual Machines enabled by Azure Arc on multi-rack deployments. It also lists the current limitations and known problems with Azure Local VM management, along with recommended resolutions.

[!INCLUDE [hci-preview](../includes/hci-preview.md)]

## Cluster extension doesn't support resource type

**Error:**

`The cluster extension '<Cluster Extension Azure Resource Manager ID>' doesn't support resource type 'Microsoft.AzureStackHCI/<Resource Type>'. The currently enabled resource types are '<Supported Resource Type Names>'. Please ensure the 'Microsoft.AzureStackHCI' cluster extension version metadata file supports the resource type. [ClusterExtensionVersion='<Cluster Extension Version>'] [CorrelationId='<Correlation ID>'].`

**Cause:**

This error occurs when the feature you're trying to use isn't available for the software version running on your Azure Local instance. This problem can happen if the software version on your cluster is outdated or the feature was introduced in a later version.

**Resolution:**

To resolve this problem, update your Azure Local instance to the latest version.

## Failure when trying to enable guest management

When trying to run the command to enable guest management, you see the following error:

**Error:** `Deployment failed. Correlation ID: aaaa0000-bb11-2222-33cc-444444dddddd. VM Spec validation failed for guest agent provisioning: Invalid managed identity. A system-assigned managed identity must be enabled in parent resource: Invalid Configuration`

This failure happens because the managed identity doesn't exist for this VM. You need a system-assigned managed identity to enable guest management.

**Resolution:**  

Follow these steps to verify that the managed identity doesn't exist for this VM and then enable system-assigned managed identity.

1. In the Azure portal, go to the VM. Browse to the **Overview** page. On the **Properties** tab, under **Configuration**, the **Guest management** shows as **Disabled**. Select the **JSON View** from the top right corner.

    :::image type="content" source="../manage/media/troubleshoot-arc-enabled-vms/managed-identity-missing-1.png" alt-text="Screenshot of how to get to JSON view." lightbox="../manage/media/troubleshoot-arc-enabled-vms/managed-identity-missing-1.png":::

1. Under the `Identity` parameter, the `type` shows as `None`.

    :::image type="content" source="../manage/media/troubleshoot-arc-enabled-vms/managed-identity-missing-2.png" alt-text="Screenshot of JSON view indicating the Managed Identity is absent." lightbox="../manage/media/troubleshoot-arc-enabled-vms/managed-identity-missing-2.png":::

1. To create a managed identity, ensure the `connectedmachine` Azure CLI extension is installed. Run the following command:
    
    ```azurecli
    az extension add --name connectedmachine
    ```

1. Run the following command to assign a system managed identity to the VM.

    ```azurecli
    az connectedmachine update --ids "<Resource Manager ID for the VM>" --set identity.type="SystemAssigned"
    ```

1. Go to the Azure portal and browse to the **Overview** page. The **JSON View** indicates that the system managed identity is now assigned to the VM.

    :::image type="content" source="../manage/media/troubleshoot-arc-enabled-vms/managed-identity-missing-3.png" alt-text="Screenshot of JSON view when Managed Identity is enabled." lightbox="../manage/media/troubleshoot-arc-enabled-vms/managed-identity-missing-3.png":::  

## Failure to deploy an Azure Local VM

You see the following error when trying to deploy an Azure Local VM:

**Error:** `{"code":"ConflictingOperation","message":"Unable to process request 'Microsoft.AzureStackHCI/virtualMachineInstances'. There is already a previous running operation for resource '/subscriptions/<subscription ID>/resourceGroups/<Resource group name>/providers/Microsoft.HybridCompute/machines/<VM name>/providers/Microsoft.AzureStackHCI/virtualMachineInstances/default'. Please wait for the previous operation to complete."}`

This failure happens because the `SystemAssigned` managed identity object isn't under the `Microsoft.HybridCompute/machines` resource type.

**Resolution:**  

Verify in your deployment template that:

- The `SystemAssigned` managed identity object is under `Microsoft.HybridCompute/machines` resource type and not under `Microsoft.AzureStackHCI/VirtualMachineInstances` resource type.

- The deployment template matches the provided sample template. For more information, see the sample template in [Create Azure Local virtual machines enabled by Azure Arc](multi-rack-create-arc-virtual-machines.md).

## Related content

- [Azure Local multi-rack VM management overview](multi-rack-azure-arc-vm-management-overview.md)
