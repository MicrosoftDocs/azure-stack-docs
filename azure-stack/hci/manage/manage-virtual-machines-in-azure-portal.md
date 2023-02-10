---
title: Create Arc virtual machines on Azure Stack HCI (preview)
description: Learn how to view your cluster in the Azure portal and create Arc virtual machines on your Azure Stack HCI (preview).
author: ksurjan
ms.author: ksurjan
ms.topic: how-to
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 02/10/2023
---

# Use VM images to create Arc virtual machines on Azure Stack HCI (preview)

[!INCLUDE [hci-applies-to-22h2-21h2](../../includes/hci-applies-to-22h2-21h2.md)]

This article describes how to create an Arc VM starting with the VM images that you've created on your Azure Stack HCI cluster. You can create Arc VMs using the Azure portal.

[!INCLUDE [hci-preview](../../includes/hci-preview.md)]

## About Azure Stack HCI cluster resource

You can use the [Azure Stack HCI cluster resource page](https://portal.azure.com/#blade/HubsExtension/BrowseResource/resourceType/Microsoft.AzureStackHCI%2Fclusters) for the following operations:

- You can create and manage Arc VM resources such as VM images, disks, network interfaces.
- You can use this page to view and access Azure Arc Resource Bridge and Custom Location associated with the Azure Stack HCI cluster.
- You can also use this page to provision and manage Arc VMs.

The procedure to create Arc VMs is described in the next section.

## Prerequisites

Before you create an Azure Arc-enabled VM, make sure that the following prerequisites are completed.

# [Azure CLI](#tab/azurecli)

[!INCLUDE [hci-vm-prerequisites](../../includes/hci-vm-prerequisites.md)]

- Access to a virtual network that you have created on your Azure Stack HCI cluster. For more information, see [Create virtual network]().
- Access to a client that can connect to your Azure Stack HCI cluster. This client should be:

    - Running PowerShell 5.0 or later.
    - Running the latest version of `az` CLI.
        - [Download the latest version of `az` CLI](/cli/azure/install-azure-cli-windows?tabs=azure-cli). Once you have installed `az` CLI, make sure to restart the system.
        -  If you have an older version of `az` CLI running, make sure to uninstall the older version first.

# [Azure portal](#tab/azureportal)

[!INCLUDE [hci-vm-prerequisites](../../includes/hci-vm-prerequisites.md)]

## Create Arc VMs

Follow these steps to create an Arc VM on your Azure Stack HCI cluster.

# [Azure CLI](#tab/azurecli)

Follow these steps on the client running az CLI and is connected to your Azure Stack HCI cluster.

### Set some parameters

1. Run PowerShell as an administrator.


1. Sign in. Type:

    ```azurecli
    az login
    ```

1. Set your subscription.

    ```azurecli
    az account set --subscription <Subscription ID>
    ```

1. Set parameters for your subscription, resource group, location, OS type for the image. Replace the parameters in `< >` with the appropriate values.

    ```azurecli
    $Subscription = "<Subscription ID>"
    $Resource_Group = "<Resource group>"
    $Location = "<Location for Azure Stack HCI cluster resource>"
    $CustomLoc_Name = "<Custom location for Azure Stack HCI cluster>"
    $VNet = "<Virtual network for VMs deployed on Azure Stack HCI cluster>"
    $VNic = "<Virtual network interface associated with the VM>"
    $galleryImageName = "<Name of the VM image you'll use to create VM>" 
    ```
    
    The parameters are described in the following table:
    
    | Parameter      | Description                                                                                |
    |----------------|--------------------------------------------------------------------------------------------|
    | `Subscription`   | Subscription associated with your Azure Stack HCI cluster.        |
    | `Resource_Group` | Resource group for Azure Stack HCI cluster that will contain all the Arc VM resources.        |
    | `Location`       | Location for your Azure Stack HCI cluster. For example, this could be `eastus`, `eastus2euap`. |
    | `CustomLocation` | Custom location associated with your Azure Stack HCI cluster. For more information, see how to create a custom location when you [Deploy an Arc Resource Bridge via the command line](../manage/deploy-arc-resource-bridge-using-command-line.md#set-up-arc-vm-management).     |

### Create virtual network interface

To create a VM, you'll first need to create a virtual network interface.

1. Create a network interface. Run the following command:

    ```azurecli
    az azurestackhci networkinterface create --subscription $subscription --resource-group $resource_group --extended-location name="/subscriptions/$subscription/resourceGroups/$resource_group/providers/Microsoft.ExtendedLocation/customLocations/$customloc_name" type="CustomLocation" --location $Location --subnet-id $VNet --name $VNic
    ```
1. Here is a sample output:

    ```azurecli
    {
      "extendedLocation": {
        "name": "/subscriptions/0709bd7a-8383-4e1d-98c8-f81d1b3443fc/resourceGroups/hybridaksresgrp-491206666/providers/Microsoft.ExtendedLocation/customLocations/hci-hybridaks-cl",
        "type": "CustomLocation"
      },
      "id": "/subscriptions/0709bd7a-8383-4e1d-98c8-f81d1b3443fc/resourceGroups/hybridaksresgrp-491206666/providers/Microsoft.AzureStackHCI/networkinterfaces/testnic001",
      "location": "eastus",
      "name": "testnic001",
      "properties": {
        "ipConfigurations": [
          {
            "name": null,
            "properties": {
              "gateway": null,
              "prefixLength": null,
              "privateIpAddress": null,
              "privateIpAllocationMethod": null,
              "subnet": {
                "id": "internalNAT"
              }
            }
          }
        ],
        "macAddress": null,
        "provisioningState": "Succeeded",
        "resourceName": "testnic001",
        "status": {}
      },
      "resourceGroup": "hybridaksresgrp-491206666",
      "systemData": {
        "createdAt": "2023-02-08T23:25:10.984508+00:00",
        "createdBy": "vlakshmanan@microsoft.com",
        "createdByType": "User",
        "lastModifiedAt": "2023-02-08T23:26:03.262252+00:00",
        "lastModifiedBy": "319f651f-7ddb-4fc6-9857-7aef9250bd05",
        "lastModifiedByType": "Application"
      },
      "tags": null,
      "type": "microsoft.azurestackhci/networkinterfaces"
    }
    PS C:\windows\system32> 
    ```


### Create VM

To create a VM with guest management enabled, you'll use the network interface that you created in the previous step. You can create a Windows VM or a Linux VM.

#### Create a Windows VM

To create a Windows VM, run the following command:

```azurecli
az azurestackhci virtualmachine create --name $vm_name --subscription $subscription --resource-group $resource_group --extended-location name="/subscriptions/$subscription/resourceGroups/$resource_group/providers/Microsoft.ExtendedLocation/customLocations/$customloc_name" type="CustomLocation" --location $Location --hardware-profile vm-size="Default" --computer-name "testvm0001" --admin-username "<VM administrator username>" --admin-password "<VM administrator password>" --image-reference $galleryImageName --nic-id $VNic --provision-vm-agent true --debug
```

Make sure to provide VM computer name, VM administrator username and VM administrator password.

In the above cmdlet, the parameter `--provision-vm-agent` when set to `true` enables guest management in the VM that is created. To disable guest management, you can omit the parameter or set it to `false'.


Here is a sample output:

```
PS C:\windows\system32> az azurestackhci virtualmachine create --name $vm_name --subscription $subscription --resource-group $resource_group --extended-location name="/subscriptions/$subscription/resourceGroups/$resource_group/providers/Microsoft.ExtendedLocation/customLocations/$customloc_name" type="CustomLocation" --location $Location --hardware-profile vm-size="Default" --computer-name "testvm0001" --admin-username "admin" --admin-password "pass" --image-reference $galleryImageName --nic-id $VNic --provision-vm-agent true --debug
Guest Management for Azure Stack HCI VMs is currently in Preview. This command enables password-based authentication for the created VM. Would you like to proceed? (y/N): y

********************************************************************************
{
  "extendedLocation": {
    "name": "/subscriptions/0709bd7a-8383-4e1d-98c8-f81d1b3443fc/resourceGroups/hybridaksresgrp-491206666/providers/Microsoft.ExtendedLocation/customLocations/hci-hybridaks-cl",
    "type": "CustomLocation"
  },
  "id": "/subscriptions/0709bd7a-8383-4e1d-98c8-f81d1b3443fc/resourceGroups/hybridaksresgrp-491206666/providers/Microsoft.AzureStackHCI/virtualmachines/testvm001",
  "identity": {
    "principalId": "9ab8c590-8f6e-4657-89f4-54af762153d4",
    "tenantId": "72f988bf-86f1-41af-91ab-2d7cd011db47",
    "type": "SystemAssigned"
  },
  "location": "eastus",
  "name": "testvm001",
  "properties": {
    "guestAgentProfile": {
      "agentVersion": "1.25.02203.713",
      "errorDetails": [],
      "lastStatusChange": "2023-02-08T23:46:26.6921034Z",
      "status": "Connected",
      "vmuuid": "31B7B385-1502-467C-BCB0-A815CAB0C5F7"
    },
    "hardwareProfile": {
      "dynamicMemoryConfig": null,
      "memoryGb": 4,
      "processors": 4,
      "vmSize": "Custom"
    },
    "networkProfile": {
      "networkInterfaces": [
        {
          "id": "testnic001"
        }
      ]
    },
    "osProfile": {
      "adminPassword": null,
      "adminUsername": "admin",
      "computerName": "testvm0001",
      "linuxConfiguration": {
        "disablePasswordAuthentication": false,
        "provisionVmAgent": true,
        "ssh": null
      },
      "osType": null,
      "windowsConfiguration": {
        "enableAutomaticUpdates": null,
        "provisionVmAgent": true,
        "ssh": null,
        "timeZone": null
      }
    },
    "provisioningState": "Succeeded",
    "resourceName": "testvm001",
    "securityProfile": {
      "enableTpm": null,
      "uefiSettings": {
        "secureBootEnabled": true
      }
    },
    "status": {
      "powerState": "Running"
    },
    "storageProfile": {
      "dataDisks": [],
      "imageReference": {
        "name": "windos"
      },
      "osDisk": {
        "id": null
      },
      "storagepathId": null
    },
    "vmId": "85679cec-a80a-11ed-bfb6-22ee2f11ced4"
  },
  "resourceGroup": "hybridaksresgrp-491206666",
  "systemData": {
    "createdAt": "2023-02-08T23:43:59.974877+00:00",
    "createdBy": "hciuser@contoso.com",
    "createdByType": "User",
    "lastModifiedAt": "2023-02-08T23:46:35.803537+00:00",
    "lastModifiedBy": "319f651f-7ddb-4fc6-9857-7aef9250bd05",
    "lastModifiedByType": "Application"
  },
  "tags": null,
  "type": "microsoft.azurestackhci/virtualmachines"
}

```
The VM is successfully created when the `provisioningState` shows as `succeeded`in the output.

<!--#### Create a Linux VM

To create a Linux VM, run the following command:

```azurecli

```
Here is a sample output:

```

```
-->
# [Azure portal](#tab/azureportal)

Follow these steps in Azure portal of your Azure Stack HCI cluster.

1. Go to **Resources (Preview) > Virtual machines**.
1. From the top command bar, select **+ Create VM**.

   :::image type="content" source="./media/manage-vm-resources/select-create-vm.png" alt-text="Screenshot of select + Create VM." lightbox="./media/manage-vm-resources/select-create-vm.png":::

1. In the **Create an Azure Arc virtual machine** wizard, on the **Basics** tab, input the following parameters:

    1. **Subscription** – The subscription is tied to the billing. Choose the subscription that you want to use to deploy this VM.

    1. **Resource group** – Create new or choose an existing resource group where you'll deploy all the resources associated with your VM.

    1. **Virtual machine name** – Enter a name for your VM. The name should follow all the naming conventions for Azure virtual machines.  
    
        > [!IMPORTANT]
        > VM names should be in lowercase letters and may use hyphens and numbers.

    1. **Custom location** – Select the custom location for your VM. The custom locations are filtered to only show those locations that are enabled for your Azure Stack HCI.

    1. **Image** – Select the Marketplace or customer managed image to create the VM image. If you selected a Windows image, provide a username and password for the administrator account. For Linux VMs, provide SSH keys.

    1. **Virtual processor count** – Specify the number of vCPUs you would like to use to create the VM.

    1. **Memory** – Specify the memory in GB for the VM you intend to create.

    1. **Memory type** – Specify the memory type as static or dynamic.

       :::image type="content" source="./media/manage-vm-resources/create-arc-vm.png" alt-text="Screenshot showing how to Create a VM." lightbox="./media/manage-vm-resources/create-arc-vm.png":::
    
    1. **Administrator account**: Specify the username and the password for the administrator account on the VM. 
    
    1. **Enable guest management** - Select the checkbox to enable guest management. You can install extensions on VMs where the guest management is enabled.
    
        > [!NOTE]
        > - You can't enable guest management via Azure portal if the Arc VM is already created.
        > - Add atleast one network interface through the **Networking** tab to complete guest management setup.

       :::image type="content" source="./media/manage-vm-resources/create-arc-vm-1.png" alt-text="Screenshot guest management enabled during Create a VM." lightbox="./media/manage-vm-resources/create-arc-vm.png":::

1. **(Optional)** Create new or add more disks to the VM by providing a name and size. You can also choose the disk type to be static or dynamic.

1. **(Optional)** Create or add network interface (NIC) cards for the VM by providing a name for the network interface. Then select the network and choose static or dynamic IP addresses.

    > [!NOTE]
    > If you enabled guest management, you must add at least one network interface.

   :::image type="content" source="./media/manage-vm-resources/create-arc-vm-2.png" alt-text="Screenshot of network interface added during Create a VM." lightbox="./media/manage-vm-resources/create-arc-vm-2.png":::


1. **(Optional)** Add tags to the VM resource if necessary.

1. Review all the properties, and then select **Create**. It should take a few minutes to provision the VM.


## Next steps

- [Install and manage VM extensions](./virtual-machine-manage-extension.md)
- [Troubleshoot](troubleshoot-arc-enabled-vms.md)
- [FAQs](faqs-arc-enabled-vms.md)