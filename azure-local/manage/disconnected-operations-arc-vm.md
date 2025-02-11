---
title: Arc VMs for Azure Local with disconnected operations (preview)
description: Learn how to manage Azure Arc VMs with disconnected operations for Azure Local (preview).
ms.topic: concept-article
author: ronmiab
ms.author: robess
ms.date: 2/11/2025
---

# Arc VMs for Azure Local with disconnected operations (preview)

[!INCLUDE [applies-to:](../includes/release-2411-1-later.md)]

This article gives you a brief overview of the Azure Arc Virtual Machine (VM) management features for disconnected operations on Azure Local, including the benefits, components, and high-level workflow.

This feature closely mirrors the Arc VM capabilities on Azure Local, and there are many references to Azure Local Arc VM articles. Key differences or limitations associated with disconnected operations are highlighted in this article.

[!INCLUDE [IMPORTANT](../includes/disconnected-operations-preview.md)]

## Overview

Azure Arc VM management lets you set up and manage VMs in your on-premises Azure Local environment. IT admins can use Azure management tools to enable self-service VM management and automate deployment.

For more information, see [What is Azure Arc VM management for Azure Local](../manage/azure-arc-vm-management-overview.md).

## Supported OS versions

Here's a list of supported OS versions for this preview:

- Windows Server 2022
- Windows Server 2025
- Windows 10 Enterprise
- Ubuntu 22.04

## Limitations

Arc VMs for Azure Local with disconnected operations have the following limitations:

### VM images

- Can only be created from a local share.
- Marketplace, Azure storage account, and images from an existing Arc VM aren't supported.
- Can only be created using Azure Command Line (CLI); the portal isn't supported.

### Network interfaces

Can only be created in CLI; the portal isn't supported.

### Storage paths

- Can only be created in CLI; the portal isn't supported.
- Can't be deleted using CLI or the portal if connected to an Arc VM or VM image. First, delete the Arc VM and image using that storage path.

### Logical networks

- Can only be created in CLI; the portal isn't supported.
- Won't be fully loaded in the portal, but you can see and use them.
- Deleting a logical network used by a network interface doesn't fail as expected; it deletes the network and results in a **Failed** state. To recover, recreate the logical network.

### Proxy servers

Not supported for connecting to outbound internet.

### Machine creation

- Create a machine through the portal via **Machines** > **Azure Arc** > **Add/Create** > C**reate a machine in a connected host environment**.
- The **Create** button in the Virtual Machines section of the Azure Local resource on the portal can't be used to create a machine.

## Create Arc VMs

Follow these steps to create Arc VMs for disconnected operations on Azure Local.

1. [Review prerequisites](../manage/azure-arc-vm-management-prerequisites.md).

    - Install Azure CLI version AzCLI 2.60.0.
    - Install the Azure Local extension **stack-hci-vm** version v1.3.0.

2. [Assign role-based access control (RBAC) roles](../manage/assign-vm-rbac-roles.md).

    - Use the built-in RBAC roles to control access to VMs and VM resources.

3. [Create a storage path](../manage/create-storage-path.md). For this preview also refer to the [limitations](#limitations) section.

    Here's an example script.

    ```azurecli
    # Install Azcli extension
    az extension add -n stack-hci-vm --version 1.3.0
    
    # Az log in
    az cloud set -n azure.local
    az config set core.instance_discovery=false --only-show-errors
    az login --user "admin@demo.asz" --password $(New-Guid).Guid

    # Check and update variables according to your environment
    $subscriptionId  = "3d926709-1015-a8cc-3003-08439e143d37"  # The starter subscription Id
    $resource_group = "disconnected-test-rg"
    $customloc_name = "s-cluster-customlocation"
    $customLocationID="/subscriptions/$SubscriptionId/resourceGroups/$resource_group/providers/Microsoft.ExtendedLocation/customLocations/$customloc_name"
    $location = "autonomous"

    # Create resource group
    az group create -n $resource_group -l $location

    # Create storage path
    az stack-hci-vm storagepath create `
        --resource-group $resource_group `
        --custom-location $customLocationID `
        --location $location `
        --path "C:\\ClusterStorage\\UserStorage_1\\VMPath" `
        --name "New_StoragePath"    
    $storagePathID=(az stack-hci-vm storagepath show --name "New_StoragePath" --resource-group $resource_group --query id -o tsv)
    ```

4. [Create a VM image](../manage/virtual-machine-image-local-share.md) on Azure Local machines with access to the ClusterStorage. For this preview also refer to the [limitations](#limitations) section.

    Here's an example script.

    ```azurecli
    curl.exe -o "C:\\ClusterStorage\\UserStorage_1\\testimage.vhdx" "https://ostempfolder.z13.web.core.windows.net/17763.30320.amd64fre.rs5_release_svc_asdb_2303b.230128-1700_client_enterprise_en-us_vl.vhdx"
    az stack-hci-vm image create `
    --resource-group $resource_group `
    --custom-location $customLocationID `
    --location $location `
    --storage-path-id $storagePathID `
    --image-path "C:\\ClusterStorage\\UserStorage_1\\testimage.vhdx" `
    --name "test-gallery-image" `
    --os-type "Windows"
    ```

    For an Ubuntu image, see [Prepare an Ubuntu image for Azure Local virtual machines](../manage/virtual-machine-image-linux-sysprep.md).


5. [Create logical networks](../manage/create-logical-networks.md). For this preview also refer to the [limitations](#limitations) section.

    Here's an example script:

    ```azurecli
    # Create network for VM
    # Update vm-switch-name and IP addresses in address-prefixes/ip-pool-start/ip-pool-end/gate according to your environment.

    # You can find them in: C:\CloudDeployment\FullEnvironment.json

    # Find the “HostNetwork”, “Intents”, “Name” for the vm-switch-name 
    # Find the “"InfrastructureNetwork": section under “DeploymentData” to find the IP address details

    az stack-hci-vm network lnet create `
        --resource-group $resource_group `
        --custom-location $customLocationID `
        --location $location `
        --name "arcvm-lnet-static" `
        --vm-switch-name '"ConvergedSwitch(managementcomputestorage)"' `
        --ip-allocation-method "Static" `
        --address-prefixes "192.168.200.0/24" `
        --ip-pool-start "192.168.200.180" `
        --ip-pool-end "192.168.200.190" `
        --gateway "192.168.200.1" `
        --dns-servers "192.168.200.222"
    ```

6. [Create network interfaces](../manage/create-network-interfaces.md). For this preview also refer to the [limitations](#limitations) section.

    ```azurecli
    # Create network interface
    # Pick an ip-address between ip-pool-start and ip-pool-end from LNET
    az stack-hci-vm network nic create `
        --resource-group $resource_group `
        --custom-location $customLocationID `
        --location $location `
        --name "arcvm-vnic" `
        --subnet-id "arcvm-lnet-static" `
        --ip-address "192.168.200.185"        
    ```

7. [Create Arc VMs](../manage/create-arc-virtual-machines.md). For this preview also refer to the [limitations](#limitations) section.

    ```azurecli
    # Create VM
    az stack-hci-vm create `
        --resource-group $resource_group `
        --custom-location $customLocationID `
        --location $location `
        --hardware-profile processors="4" memory-mb="8192" vm-size="Custom" `
        --nics "arcvm-vnic" `
        --storage-path-id $storagePathID `
        --computer-name "test-machine" `
        --admin-username "admin" `
        --admin-password "example" `
        --image "test-gallery-image" `
        --name "test-vm" `
        --enable-agent true
    ```
    
    :::image type="content" source="./media/disconnected-operations/arc-vms/create-arc-vms.png" alt-text="Screenshot showing how create a container registry from the Portal." lightbox=" ./media/disconnected-operations/arc-vms/create-arc-vms.png":::

## Manage Arc VMs and VM resources

To manage Arc VMs using CLI, see [Arc VMs using the Azure CLI](/azure/azure-local/manage/manage-arc-virtual-machines?view=azloc-24112&tabs=windows&preserve-view=true). To verify the status of the VM, see [Status of the VM](../manage/manage-arc-virtual-machines.md#status-displayed-as-connecting).

For Arc VM resources:

- If you remove a data disk interface used by a VM, the command doesn't fail as expected. Instead, it deletes the data disk interface and results in an incorrect provisioning state as **Failed**.

- To restore the provisioning state to **Succeeded**, you need to recreate the data disk interface.

## Manage VM extensions

The supported VM extensions are *Azure Monitor Agent* and *Custom Script*.

To manage VM extensions, see [manage VM extensions](../manage/virtual-machine-manage-extension.md) on Arc-enabled VMs for Azure Local.

## Extra resources

Here are some extra resources to help you manage Azure Arc VMs on Azure Local:

- [Collect log files for Azure Arc VMs on Azure Local](../manage/collect-log-files-arc-enabled-vms.md).

- [Troubleshoot Azure Arc VM management for Azure Local](../manage/troubleshoot-arc-enabled-vms.md).

- [Azure Arc VM management FAQ](../manage/azure-arc-vms-faq.yml).

<!--## Next steps-->